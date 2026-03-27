"""
DAVIS Bambu Auto-Discovery  —  zero-config printer detection

Strategy (in order, first hit wins):
  1. Load saved printer_config.json (from a previous successful discovery)
  2. Read Bambu Studio config — already has serial + access code, just needs IP
  3. Scan ARP table + local subnet for port 8883, match against known serials
  4. SSDP multicast (requires LAN mode on printer)

The result: no user input required if Bambu Studio is installed.
"""

from __future__ import annotations

import json
import os
import re
import socket
import struct
import subprocess
import threading
import time
from typing import Optional

_HERE        = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
_CONFIG_FILE = os.path.join(_HERE, "printer_config.json")

SSDP_ADDR    = "239.255.255.250"
SSDP_PORT    = 1990
BAMBU_NT     = "urn:bambulab-com:device:3dprinter:1"
BAMBU_MQTT   = 8883

_SERIAL_MODELS = {
    "00M": "Bambu X1C",
    "00W": "Bambu P1S",
    "01P": "Bambu P1S",
    "01A": "Bambu A1",
    "030": "Bambu A1",
    "039": "Bambu A1 Mini",
    "03A": "Bambu A1 Mini",
    "030": "Bambu A1",
}

def _model_from_serial(serial: str) -> str:
    for prefix, name in _SERIAL_MODELS.items():
        if serial.upper().startswith(prefix):
            return name
    return "Bambu Printer"


# ─── 1. Saved config ──────────────────────────────────────────────────────────

def load_saved() -> Optional[dict]:
    if not os.path.exists(_CONFIG_FILE):
        return None
    try:
        with open(_CONFIG_FILE) as f:
            data = json.load(f)
        if data.get("ip") and data.get("serial") and data.get("access_code"):
            return data
    except Exception:
        pass
    return None


def save_config(ip: str, serial: str, access_code: str, model: str = ""):
    data = {"ip": ip, "serial": serial, "access_code": access_code,
            "model": model or _model_from_serial(serial)}
    with open(_CONFIG_FILE, "w") as f:
        json.dump(data, f, indent=2)
    print(f"[discovery] Saved printer config -> {_CONFIG_FILE}")


def apply_to_config(data: dict):
    try:
        import config as cfg
        cfg.BAMBU_IP          = data["ip"]
        cfg.BAMBU_SERIAL      = data["serial"]
        cfg.BAMBU_ACCESS_CODE = data.get("access_code", "")
    except Exception:
        pass


# ─── 2. Read Bambu Studio config ──────────────────────────────────────────────

def _bambu_studio_conf_path() -> Optional[str]:
    candidates = [
        os.path.expandvars(r"%APPDATA%\BambuStudio\BambuStudio.conf"),
        os.path.expanduser("~/.config/BambuStudio/BambuStudio.conf"),
        os.path.expanduser("~/Library/Application Support/BambuStudio/BambuStudio.conf"),
    ]
    for p in candidates:
        if os.path.exists(p):
            return p
    return None


def read_bambu_studio_credentials() -> list[dict]:
    """
    Parse BambuStudio.conf and return list of {serial, access_code, model}.
    No IP yet — that comes from ARP/port scan.
    """
    path = _bambu_studio_conf_path()
    if not path:
        return []
    try:
        txt = open(path, encoding="utf-8", errors="ignore").read()
        # Find access_code or user_access_code block: {"serial": "code", ...}
        for key in ("user_access_code", "access_code"):
            m = re.search(rf'"{key}"\s*:\s*(\{{[^}}]+\}})', txt, re.DOTALL)
            if m:
                block = m.group(1)
                pairs = re.findall(r'"([0-9A-Za-z]{10,})"\s*:\s*"([^"]+)"', block)
                if pairs:
                    return [{"serial": s, "access_code": c,
                             "model": _model_from_serial(s)} for s, c in pairs]
    except Exception as exc:
        print(f"[discovery] Bambu Studio conf read failed: {exc}")
    return []


# ─── 3. ARP table + port scan ────────────────────────────────────────────────

def _arp_ips() -> list[str]:
    """Return IPs from the system ARP table."""
    ips = []
    try:
        out = subprocess.check_output("arp -a", shell=True,
                                      stderr=subprocess.DEVNULL).decode(errors="ignore")
        ips = re.findall(r"(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})", out)
        # Filter out broadcast/multicast
        ips = [ip for ip in ips
               if not ip.startswith(("224.", "239.", "255.", "127."))]
    except Exception:
        pass
    return list(dict.fromkeys(ips))   # deduplicate, preserve order


def _port_open(ip: str, port: int, timeout: float = 0.8) -> bool:
    try:
        with socket.create_connection((ip, port), timeout=timeout):
            return True
    except Exception:
        return False


def _find_printer_ips(serials: list[str]) -> list[str]:
    """
    Return IPs that have port 8883 open on the local network.
    Checks ARP table first (fast), then broader subnet scan.
    """
    arp_ips  = _arp_ips()
    candidate_ips = list(arp_ips)

    # Also try the local /24 subnet
    try:
        local_ip = socket.gethostbyname(socket.gethostname())
        prefix   = ".".join(local_ip.split(".")[:3])
        subnet   = [f"{prefix}.{i}" for i in range(1, 255)]
        # Add subnet IPs not already in ARP list
        candidate_ips += [ip for ip in subnet if ip not in candidate_ips]
    except Exception:
        pass

    # Probe in parallel
    results = []
    lock    = threading.Lock()

    def probe(ip):
        if _port_open(ip, BAMBU_MQTT):
            with lock:
                results.append(ip)

    threads = [threading.Thread(target=probe, args=(ip,), daemon=True)
               for ip in candidate_ips]
    # Run in batches of 50 to avoid overwhelming the OS
    batch = 50
    for i in range(0, len(threads), batch):
        for t in threads[i:i+batch]:
            t.start()
        for t in threads[i:i+batch]:
            t.join(timeout=1.5)

    return results


# ─── 4. SSDP (LAN mode) ───────────────────────────────────────────────────────

def _ssdp_discover(timeout: float = 5.0) -> list[dict]:
    found: dict[str, dict] = {}
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        sock.settimeout(1.0)
        sock.bind(("", SSDP_PORT))
        mreq = struct.pack("4sL", socket.inet_aton(SSDP_ADDR), socket.INADDR_ANY)
        sock.setsockopt(socket.IPPROTO_IP, socket.IP_ADD_MEMBERSHIP, mreq)

        # Send M-SEARCH
        msearch = (f"M-SEARCH * HTTP/1.1\r\nHOST: {SSDP_ADDR}:{SSDP_PORT}\r\n"
                   f"MAN: \"ssdp:discover\"\r\nMX: 3\r\nST: {BAMBU_NT}\r\n\r\n")
        try:
            sock.sendto(msearch.encode(), (SSDP_ADDR, SSDP_PORT))
        except Exception:
            pass

        deadline = time.time() + timeout
        while time.time() < deadline:
            try:
                data, addr = sock.recvfrom(4096)
                txt = data.decode(errors="ignore")
                if BAMBU_NT not in txt and "bambulab" not in txt.lower():
                    continue

                def hdr(name):
                    m = re.search(rf"^{re.escape(name)}:\s*(.+)$",
                                  txt, re.MULTILINE | re.IGNORECASE)
                    return m.group(1).strip() if m else ""

                serial = hdr("DevSerial.bambu.com")
                model  = hdr("DevModel.bambu.com")
                loc    = hdr("Location") or addr[0]
                ip_m   = re.search(r"(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})", loc)
                ip     = ip_m.group(1) if ip_m else addr[0]
                if serial and serial not in found:
                    found[serial] = {"ip": ip, "serial": serial,
                                     "model": model or _model_from_serial(serial)}
            except socket.timeout:
                continue
            except Exception:
                continue
        sock.close()
    except Exception:
        pass
    return list(found.values())


# ─── Main discovery entry point ───────────────────────────────────────────────

def discover_all(ssdp_timeout: float = 4.0) -> list[dict]:
    """
    Full auto-discovery pipeline. Returns list of printer dicts with
    keys: ip, serial, access_code, model.
    """
    # Try SSDP first (fast if LAN mode is on)
    ssdp = _ssdp_discover(ssdp_timeout)

    # Read Bambu Studio credentials
    studio_creds = read_bambu_studio_credentials()
    if not studio_creds:
        # No Studio config — return SSDP results only (may be empty)
        return [{**d, "access_code": ""} for d in ssdp]

    # Merge SSDP IPs into studio creds
    ssdp_by_serial = {d["serial"]: d["ip"] for d in ssdp}

    # Find IPs for serials we have creds for
    serials = [c["serial"] for c in studio_creds]
    printer_ips = _find_printer_ips(serials)

    results = []
    for cred in studio_creds:
        # Check SSDP first (authoritative — contains serial in packet)
        ip = ssdp_by_serial.get(cred["serial"])
        if not ip:
            # Try to authenticate against each port-8883 host to find the real printer
            ip = _verify_printer_ip(printer_ips, cred["serial"], cred["access_code"])
        if ip:
            results.append({
                "ip":          ip,
                "serial":      cred["serial"],
                "access_code": cred["access_code"],
                "model":       cred["model"],
            })
            print(f"[discovery] Found {cred['model']} ({cred['serial']}) at {ip}")

    return results


def _verify_printer_ip(candidate_ips: list[str], serial: str, access_code: str) -> Optional[str]:
    """
    Try to authenticate against each candidate IP via MQTT.
    Returns the first IP that accepts the credentials.
    """
    try:
        import paho.mqtt.client as mqtt
        import ssl
    except ImportError:
        return candidate_ips[0] if candidate_ips else None

    result = [None]
    found  = threading.Event()

    def try_ip(ip):
        if found.is_set():
            return
        try:
            connected = threading.Event()
            ok        = [False]

            def on_connect(client, userdata, flags, rc, *args):
                ok[0] = (rc == 0)
                connected.set()

            try:
                client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2,
                                     client_id="DAVIS_probe")
            except Exception:
                client = mqtt.Client(client_id="DAVIS_probe")

            client.on_connect = on_connect
            ctx = ssl.create_default_context()
            ctx.check_hostname = False
            ctx.verify_mode = ssl.CERT_NONE
            client.tls_set_context(ctx)
            client.username_pw_set("bblp", access_code)
            client.connect_async(ip, BAMBU_MQTT, keepalive=5)
            client.loop_start()
            connected.wait(timeout=3.0)
            client.loop_stop()
            try:
                client.disconnect()
            except Exception:
                pass

            if ok[0] and not found.is_set():
                found.set()
                result[0] = ip
        except Exception:
            pass

    threads = [threading.Thread(target=try_ip, args=(ip,), daemon=True)
               for ip in candidate_ips]
    for t in threads:
        t.start()
    for t in threads:
        t.join(timeout=4.0)

    return result[0]


def start_discovery(on_found: callable, ssdp_timeout: float = 6.0):
    """Run discovery in background thread, call on_found(list[dict]) when done."""
    def _run():
        results = discover_all(ssdp_timeout)
        on_found(results)
    threading.Thread(target=_run, daemon=True).start()
