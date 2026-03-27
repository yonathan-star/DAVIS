"""
FTPS file transfer to Bambu Labs printer.

Bambu printers expose an implicit-TLS FTP server on port 990.
Authentication: username="bblp", password=<access_code>.
Files are uploaded to the /cache/ directory as sliced .3mf project files.
"""

import ftplib
import os
import ssl
import subprocess
import tempfile

import config
from utils.logger import get_logger

log = get_logger(__name__)

# BambuStudio CLI path and profile defaults for Bambu A1 0.4mm nozzle
_STUDIO_EXE   = "C:/Program Files/Bambu Studio/bambu-studio.exe"
_PROFILES_DIR = "C:/Program Files/Bambu Studio/resources/profiles/BBL"

_MACHINE_PROFILES = {
    "Bambu A1":      f"{_PROFILES_DIR}/machine/Bambu Lab A1 0.4 nozzle.json",
    "Bambu A1 Mini": f"{_PROFILES_DIR}/machine/Bambu Lab A1 mini 0.4 nozzle.json",
    "Bambu P1S":     f"{_PROFILES_DIR}/machine/Bambu Lab P1S 0.4 nozzle.json",
    "Bambu X1C":     f"{_PROFILES_DIR}/machine/Bambu Lab X1 Carbon 0.4 nozzle.json",
}
_PROCESS_PROFILES = {
    "0.08mm": f"{_PROFILES_DIR}/process/0.08mm High Quality @BBL A1.json",
    "0.12mm": f"{_PROFILES_DIR}/process/0.12mm Fine @BBL A1.json",
    "0.16mm": f"{_PROFILES_DIR}/process/0.16mm Optimal @BBL A1.json",
    "0.20mm": f"{_PROFILES_DIR}/process/0.20mm Standard @BBL A1.json",
    "0.24mm": f"{_PROFILES_DIR}/process/0.24mm Draft @BBL A1.json",
    "0.28mm": f"{_PROFILES_DIR}/process/0.28mm Draft @BBL A1.json",
}
_FILAMENT_PROFILES = {
    "PLA":      f"{_PROFILES_DIR}/filament/Generic PLA @BBL A1.json",
    "PETG":     f"{_PROFILES_DIR}/filament/Generic PETG @BBL A1.json",
    "ABS":      f"{_PROFILES_DIR}/filament/Generic ABS @BBL A1.json",
    "TPU":      f"{_PROFILES_DIR}/filament/Generic TPU @BBL A1.json",
    "PLA+":     f"{_PROFILES_DIR}/filament/Generic PLA @BBL A1.json",
    "SILK PLA": f"{_PROFILES_DIR}/filament/Generic PLA Silk @BBL A1.json",
    "ASA":      f"{_PROFILES_DIR}/filament/Generic ASA @BBL A1.json",
}


class ImplicitFTP_TLS(ftplib.FTP_TLS):
    """
    FTP over implicit TLS (port 990).

    Standard ftplib.FTP_TLS uses explicit TLS (STARTTLS / AUTH TLS).
    Bambu printers require implicit TLS — TLS negotiation starts immediately.
    This subclass wraps the socket in TLS before any FTP handshake.
    """

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._sock = None

    def connect(self, host: str = "", port: int = 0, timeout: float = 30, **kwargs):
        self.host = host or self.host
        self.port = port or self.port
        self.timeout = timeout

        import socket
        ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
        ctx.check_hostname = False
        ctx.verify_mode = ssl.CERT_NONE   # Bambu uses a self-signed cert

        raw_sock = socket.create_connection((self.host, self.port), timeout=timeout)
        self.sock = ctx.wrap_socket(raw_sock, server_hostname=self.host)
        self.af = self.sock.family
        self.file = self.sock.makefile("r", encoding="latin-1")
        self.welcome = self.getresp()
        return self.welcome

    def storbinary(self, cmd, fp, blocksize=8192, callback=None, rest=None):
        """Override to suppress TLS close_notify timeout.

        Bambu's FTPS server doesn't send a TLS close_notify on the data
        connection, causing ssl.SSLSocket.unwrap() to time out. The actual
        data transfer succeeds — we just ignore the teardown error.
        """
        self.voidcmd("TYPE I")
        with self.transfercmd(cmd, rest) as conn:
            while True:
                buf = fp.read(blocksize)
                if not buf:
                    break
                conn.sendall(buf)
                if callback:
                    callback(buf)
            try:
                conn.settimeout(3)   # short timeout for TLS teardown
                conn.unwrap()
            except (ssl.SSLError, OSError, TimeoutError, Exception):
                pass  # Bambu doesn't respond to TLS shutdown — safe to ignore
        return self.voidresp()


def _find_profile(profile_map: dict, key: str, default_key: str) -> str:
    """Return the first matching profile path, falling back to default_key."""
    for k, path in profile_map.items():
        if k.lower() in key.lower() or key.lower() in k.lower():
            if os.path.exists(path):
                return path
    fallback = profile_map.get(default_key, "")
    if os.path.exists(fallback):
        return fallback
    # Return whichever exists
    for path in profile_map.values():
        if os.path.exists(path):
            return path
    return list(profile_map.values())[0]


def slice_stl(stl_path: str,
              printer_model: str = "Bambu A1",
              layer_height: str = "0.20mm",
              filament: str = "PLA") -> str:
    """
    Slice an STL using BambuStudio CLI.

    Returns:
        Path to the sliced .3mf project file (contains Metadata/plate_1.gcode).

    Raises:
        RuntimeError if BambuStudio is not found or slicing fails.
    """
    if not os.path.exists(_STUDIO_EXE):
        raise RuntimeError(
            f"BambuStudio not found at {_STUDIO_EXE}. "
            "Install Bambu Studio to enable printing."
        )

    machine_profile  = _find_profile(_MACHINE_PROFILES, printer_model, "Bambu A1")
    process_profile  = _find_profile(_PROCESS_PROFILES, layer_height,  "0.20mm")
    filament_profile = _find_profile(_FILAMENT_PROFILES, filament,      "PLA")

    log.info("Slicing %s  printer=%s  layer=%s  filament=%s",
             os.path.basename(stl_path), printer_model, layer_height, filament)
    log.debug("  machine:  %s", machine_profile)
    log.debug("  process:  %s", process_profile)
    log.debug("  filament: %s", filament_profile)

    out_dir  = tempfile.mkdtemp(prefix="davis_slice_")
    out_3mf  = os.path.join(out_dir, "sliced.3mf")

    cmd = [
        _STUDIO_EXE,
        "--slice", "0",
        "--export-3mf", out_3mf,
        "--load-settings", f"{machine_profile};{process_profile}",
        "--load-filaments", filament_profile,
        stl_path,
    ]

    result = subprocess.run(
        cmd,
        capture_output=True,
        text=True,
        timeout=300,
    )

    if not os.path.exists(out_3mf):
        err = (result.stderr or result.stdout or "no output")[-600:]
        raise RuntimeError(f"BambuStudio slicing failed: {err}")

    kb = os.path.getsize(out_3mf) / 1024
    log.info("Slicing complete: sliced.3mf (%.1f KB)", kb)
    return out_3mf


def upload_stl(stl_path: str,
               printer_model: str = "Bambu A1",
               layer_height: str = "0.20mm",
               filament: str = "PLA") -> str:
    """
    Slice the STL with BambuStudio and upload the resulting 3MF to the
    Bambu printer's /cache/ directory via FTPS.

    Returns:
        The remote filename (basename, .3mf extension).

    Raises:
        RuntimeError on any failure.
    """
    sliced_path     = slice_stl(stl_path, printer_model, layer_height, filament)
    remote_filename = "davis_print.3mf"
    remote_path     = f"/cache/{remote_filename}"

    log.info("FTPS connecting to %s:%d", config.BAMBU_IP, config.BAMBU_PORT_FTPS)

    for attempt in range(1, config.MAX_FTPS_RETRIES + 1):
        try:
            ftp = ImplicitFTP_TLS()
            ftp.connect(host=config.BAMBU_IP, port=config.BAMBU_PORT_FTPS, timeout=30)
            ftp.login(user="bblp", passwd=config.BAMBU_ACCESS_CODE)
            ftp.set_pasv(True)
            ftp.prot_p()

            file_size = os.path.getsize(sliced_path)
            log.info("Uploading %s (%.1f KB) -> %s", remote_filename,
                     file_size / 1024, remote_path)

            with open(sliced_path, "rb") as f:
                ftp.storbinary(f"STOR {remote_path}", f)

            ftp.quit()
            log.info("FTPS upload complete: %s", remote_filename)
            return remote_filename

        except Exception as exc:
            log.warning("FTPS attempt %d/%d failed: %s",
                        attempt, config.MAX_FTPS_RETRIES, exc)
            if attempt == config.MAX_FTPS_RETRIES:
                raise RuntimeError(
                    f"FTPS transfer failed after {config.MAX_FTPS_RETRIES} attempts: {exc}"
                ) from exc
