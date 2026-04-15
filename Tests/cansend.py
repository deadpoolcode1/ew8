#!/usr/bin/env python3
"""
Cross-platform cansend replacement for EW8 testing.

On Linux:  uses the real `cansend` utility (can-utils) via socketcan
On Windows: sends CAN frames via UDP to the EW8 app (port 18700)

Usage (same as Linux cansend):
    python cansend.py <interface> <can_id>#<hex_data>

Examples:
    python cansend.py can0 700#0000190100800001
    python cansend.py can0 7BC#5A0032120000

The <interface> argument is accepted for compatibility but ignored on Windows
(UDP always targets localhost:18700).
"""

import sys
import struct
import platform

# UDP virtual CAN port — must match CanManager::UDP_CAN_PORT in canmanager.h
UDP_CAN_PORT = 18700
UDP_CAN_HOST = "127.0.0.1"


def parse_cansend_args(args):
    """Parse cansend-style arguments: <interface> <can_id>#<data_hex>"""
    if len(args) < 2:
        print(f"Usage: {args[0] if args else 'cansend.py'} <interface> <can_id>#<data>",
              file=sys.stderr)
        sys.exit(1)

    # Handle both "cansend can0 700#..." and "cansend 700#..." (no interface)
    if '#' in args[1]:
        frame_str = args[1]
    elif len(args) >= 3 and '#' in args[2]:
        frame_str = args[2]
    else:
        print(f"Error: expected <can_id>#<data>, got: {' '.join(args[1:])}",
              file=sys.stderr)
        sys.exit(1)

    can_id_str, data_hex = frame_str.split('#', 1)
    can_id = int(can_id_str, 16)

    # Parse data bytes (pairs of hex chars)
    data = bytes.fromhex(data_hex) if data_hex else b''

    return can_id, data


def send_udp(can_id, data):
    """Send CAN frame via UDP to the EW8 app."""
    import socket

    # Wire format: [4B can_id LE][1B dlc][8B data zero-padded]
    dlc = min(len(data), 8)
    padded_data = (data[:8] + b'\x00' * 8)[:8]

    packet = struct.pack('<IB', can_id, dlc) + padded_data

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        sock.sendto(packet, (UDP_CAN_HOST, UDP_CAN_PORT))
    finally:
        sock.close()


def send_socketcan(interface, can_id, data):
    """Send CAN frame via Linux socketcan using the cansend utility."""
    import subprocess
    data_hex = ''.join(f'{b:02X}' for b in data)
    frame_str = f'{can_id:03X}#{data_hex}'
    subprocess.run(['cansend', interface, frame_str], check=True)


def main():
    args = sys.argv

    # Determine interface name (for Linux compatibility)
    interface = "can0"
    if len(args) >= 3 and '#' in args[2]:
        interface = args[1]

    can_id, data = parse_cansend_args(args)

    if platform.system() == 'Windows':
        send_udp(can_id, data)
    else:
        send_socketcan(interface, can_id, data)


if __name__ == '__main__':
    main()
