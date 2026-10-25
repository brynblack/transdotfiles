# Uploads an OpenRGB profile to the running SDK server and loads it, so the
# server's plugins (e.g. Effects) pick up the new settings without a restart.
#
# "#rrggbb" strings anywhere in the profile are converted to LED colours (see
# to_led) and packed as OpenRGB's 0x00BBGGRR integers first, as noctalia
# templates can only emit hex.
#
# Usage: openrgb-load-profile PROFILE.json [HOST[:PORT]]

import json
import math
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

# How much to multiply a colour's OKLCH chroma by, as LED diffusers and
# bleed between neighbouring LEDs wash colours out compared to a screen
CHROMA_BOOST = 1.5
# OKLab lightness the colour is re-rendered at before being scaled to full
# brightness, low enough for most hues to reach their full chroma
LED_LIGHTNESS = 0.7


def srgb_to_linear(c):
    return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4


def linear_to_oklab(r, g, b):
    l_ = (0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b) ** (1 / 3)
    m = (0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b) ** (1 / 3)
    s = (0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b) ** (1 / 3)
    return (
        0.2104542553 * l_ + 0.7936177850 * m - 0.0040720468 * s,
        1.9779984951 * l_ - 2.4285922050 * m + 0.4505937099 * s,
        0.0259040371 * l_ + 0.7827717662 * m - 0.8086757660 * s,
    )


def oklab_to_linear(L, a, b):
    l_ = (L + 0.3963377774 * a + 0.2158037573 * b) ** 3
    m = (L - 0.1055613458 * a - 0.0638541728 * b) ** 3
    s = (L - 0.0894841775 * a - 1.2914855480 * b) ** 3
    return (
        4.0767416621 * l_ - 3.3077115913 * m + 0.2309699292 * s,
        -1.2684380046 * l_ + 2.6097574011 * m - 0.3413193965 * s,
        -0.0041960771 * l_ - 0.7034186147 * m + 1.7076127010 * s,
    )


# Maps a screen colour to the LED drive values that look most like it.
#
# Pastels are a hue plus white, so forcing them to full saturation throws
# the white away, and with it most of the hue's character (pink becomes
# red). Instead this keeps the OKLCH hue and (boosted) chroma, but drops the
# lightness, which LEDs can't show anyway, then scales it to full brightness.
#
# LEDs are also driven in linear light, whereas the hex is gamma encoded, so
# without linearising, every channel that isn't 0 or 255 comes out too bright,
# washing colours out towards white.
def to_led(r, g, b):
    _, a, b_ = linear_to_oklab(*(srgb_to_linear(c / 255) for c in (r, g, b)))
    chroma, hue = math.hypot(a, b_) * CHROMA_BOOST, math.atan2(b_, a)

    # Binary searches for the most chroma in gamut at that hue, so the
    # boost can't clip channels and shift the hue
    lo, hi = 0.0, chroma
    for _ in range(24):
        mid = (lo + hi) / 2
        rgb = oklab_to_linear(LED_LIGHTNESS, mid * math.cos(hue), mid * math.sin(hue))
        if min(rgb) >= 0 and max(rgb) <= 1:
            lo = mid
        else:
            hi = mid

    rgb = [max(c, 0) for c in oklab_to_linear(LED_LIGHTNESS, lo * math.cos(hue), lo * math.sin(hue))]
    peak = max(rgb)
    return tuple(round(c / peak * 255) for c in rgb)


def to_bgr(value):
    if isinstance(value, dict):
        return {k: to_bgr(v) for k, v in value.items()}
    if isinstance(value, list):
        return [to_bgr(v) for v in value]
    if isinstance(value, str) and (m := HEX_COLOR.fullmatch(value)):
        r, g, b = to_led(*bytes.fromhex(m[1]))
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
