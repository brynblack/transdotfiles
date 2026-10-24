# Uploads an OpenRGB profile to the running SDK server and loads it, so the
# server's plugins (e.g. Effects) pick up the new settings without a restart.
#
# "#rrggbb" strings anywhere in the profile are converted to OpenRGB's packed
# 0x00BBGGRR integers first, as noctalia templates can only emit hex.
#
# Usage: openrgb-load-profile PROFILE.json [HOST[:PORT]]

import json
import re
import socket
import struct
import sys

PROTOCOL_VERSION = 6

PKT_ACK = 10
PKT_REQUEST_PROTOCOL_VERSION = 40
PKT_SET_CLIENT_NAME = 50
PKT_SET_CLIENT_FLAGS = 52
PKT_SET_SERVER_FLAGS = 53
PKT_PROFILEMANAGER_LOAD_PROFILE = 152
PKT_PROFILEMANAGER_UPLOAD_PROFILE = 154

# Uploading profiles is restricted to the "local client", which the server
# only grants on request, and only to loopback connections
FLAG_LOCAL_CLIENT = 1 << 16

STATUS = ["ok", "generic error", "unsupported", "not allowed", "invalid id", "invalid data"]

HEADER = struct.Struct("<4sIII")
HEX_COLOR = re.compile(r"#([0-9a-fA-F]{6})")


def to_bgr(value):
    if isinstance(value, dict):
        return {k: to_bgr(v) for k, v in value.items()}
    if isinstance(value, list):
        return [to_bgr(v) for v in value]
    if isinstance(value, str) and (m := HEX_COLOR.fullmatch(value)):
        r, g, b = bytes.fromhex(m[1])
        return b << 16 | g << 8 | r
    return value


class Client:
    def __init__(self, host, port):
        self.sock = socket.create_connection((host, port), timeout=10)

    def send(self, pkt_id, data=b""):
        self.sock.sendall(HEADER.pack(b"ORGB", 0, pkt_id, len(data)) + data)

    def recv_exact(self, size):
        buf = b""
        while len(buf) < size:
            chunk = self.sock.recv(size - len(buf))
            if not chunk:
                raise ConnectionError("server closed the connection")
            buf += chunk
        return buf

    # Waits for a packet, skipping any others (server name, ACKs for earlier
    # requests, device list notifications) that arrive first
    def recv(self, pkt_id, acked_pkt_id=None):
        while True:
            magic, _, rid, size = HEADER.unpack(self.recv_exact(HEADER.size))
            if magic != b"ORGB":
                raise ConnectionError("bad packet magic from server")
            data = self.recv_exact(size)
            if rid != pkt_id:
                continue
            if acked_pkt_id is None or struct.unpack_from("<I", data)[0] == acked_pkt_id:
                return data

    def request(self, pkt_id, data):
        self.send(pkt_id, data)
        status = struct.unpack("<II", self.recv(PKT_ACK, pkt_id))[1]
        if status != 0:
            name = STATUS[status] if status < len(STATUS) else status
            raise RuntimeError(f"server rejected packet {pkt_id}: {name}")


def main():
    if len(sys.argv) not in (2, 3):
        sys.exit("usage: openrgb-load-profile PROFILE.json [HOST[:PORT]]")

    host, _, port = (sys.argv[2] if len(sys.argv) == 3 else "127.0.0.1").partition(":")

    with open(sys.argv[1]) as f:
        profile = to_bgr(json.load(f))
    name = profile["profile_name"]

    client = Client(host, int(port or 6742))

    client.send(PKT_REQUEST_PROTOCOL_VERSION, struct.pack("<I", PROTOCOL_VERSION))
    version = struct.unpack("<I", client.recv(PKT_REQUEST_PROTOCOL_VERSION))[0]
    if version < PROTOCOL_VERSION:
        sys.exit(f"OpenRGB server speaks SDK protocol {version}, profile upload needs {PROTOCOL_VERSION} (OpenRGB 1.0+)")

    client.send(PKT_SET_CLIENT_NAME, b"noctalia\0")
    client.send(PKT_SET_CLIENT_FLAGS, struct.pack("<I", FLAG_LOCAL_CLIENT))
    flags = struct.unpack("<I", client.recv(PKT_SET_SERVER_FLAGS))[0]
    if not flags & FLAG_LOCAL_CLIENT:
        sys.exit("OpenRGB server refused local client access (not a loopback connection?)")

    # Saves the profile to the server's profiles dir, so it also survives
    # restarts if it's the startup profile, then applies it
    client.request(PKT_PROFILEMANAGER_UPLOAD_PROFILE, json.dumps(profile).encode() + b"\0")
    client.request(PKT_PROFILEMANAGER_LOAD_PROFILE, name.encode() + b"\0")


if __name__ == "__main__":
    main()
