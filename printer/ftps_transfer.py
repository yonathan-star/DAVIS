"""
FTPS file transfer to Bambu Labs printer.

Bambu printers expose an implicit-TLS FTP server on port 990.
Authentication: username="bblp", password=<access_code>.
Files are uploaded to the /upload/ directory.
"""

import ftplib
import os
import ssl

import config
from utils.logger import get_logger

log = get_logger(__name__)


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


def _stl_to_3mf(stl_path: str) -> str:
    """Convert STL to 3MF (what Bambu printers accept). Returns path to .3mf file."""
    import trimesh
    mesh = trimesh.load(stl_path)
    out_path = stl_path.replace(".stl", ".3mf")
    mesh.export(out_path)
    return out_path


def upload_stl(stl_path: str) -> str:
    """
    Convert STL to 3MF and upload to the Bambu printer via FTPS.

    Returns:
        The remote filename (basename only, .3mf extension).

    Raises:
        RuntimeError on any failure.
    """
    # Bambu printers accept 3MF, not raw STL
    upload_path = _stl_to_3mf(stl_path) if stl_path.endswith(".stl") else stl_path
    remote_filename = os.path.basename(upload_path)
    remote_path     = f"/upload/{remote_filename}"

    log.info("FTPS connecting to %s:%d", config.BAMBU_IP, config.BAMBU_PORT_FTPS)

    for attempt in range(1, config.MAX_FTPS_RETRIES + 1):
        try:
            ftp = ImplicitFTP_TLS()
            ftp.connect(host=config.BAMBU_IP, port=config.BAMBU_PORT_FTPS, timeout=30)
            ftp.login(user="bblp", passwd=config.BAMBU_ACCESS_CODE)
            ftp.set_pasv(True)
            ftp.prot_p()

            file_size = os.path.getsize(upload_path)
            log.info("Uploading %s (%.1f KB) -> %s", remote_filename,
                     file_size / 1024, remote_path)

            with open(upload_path, "rb") as f:
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
