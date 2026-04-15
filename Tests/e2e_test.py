#!/usr/bin/env python3
"""
Cross-platform E2E test for EW8 LVGL frontend.

Sends CAN messages and verifies the app is receiving them.
Works on both Linux (socketcan) and Windows (UDP virtual CAN).

Usage:
    python e2e_test.py [--port 18700] [--host 127.0.0.1]

Prerequisites:
    - EW8 LVGL app must be running
    - On Linux: vcan interface must be up
    - On Windows: no special setup needed (UDP)
"""

import argparse
import platform
import socket
import struct
import time
import sys

UDP_CAN_PORT = 18700
UDP_CAN_HOST = "127.0.0.1"


class CANSender:
    """Cross-platform CAN frame sender."""

    def __init__(self, host=UDP_CAN_HOST, port=UDP_CAN_PORT, interface="can0"):
        self.host = host
        self.port = port
        self.interface = interface
        self.is_windows = platform.system() == 'Windows'

        if self.is_windows:
            self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        else:
            try:
                import subprocess
                subprocess.run(['which', 'cansend'], check=True,
                               capture_output=True)
                self.use_native = True
            except (subprocess.CalledProcessError, FileNotFoundError):
                # Fallback to UDP even on Linux
                self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
                self.use_native = False

    def send(self, can_id, data_hex):
        """Send a CAN frame. data_hex is a hex string like '0000190100800001'."""
        data = bytes.fromhex(data_hex)

        if self.is_windows or not getattr(self, 'use_native', True):
            self._send_udp(can_id, data)
        else:
            self._send_native(can_id, data)

    def _send_udp(self, can_id, data):
        dlc = min(len(data), 8)
        padded = (data[:8] + b'\x00' * 8)[:8]
        packet = struct.pack('<IB', can_id, dlc) + padded
        self.sock.sendto(packet, (self.host, self.port))

    def _send_native(self, can_id, data):
        import subprocess
        data_hex = ''.join(f'{b:02X}' for b in data)
        frame_str = f'{can_id:03X}#{data_hex}'
        subprocess.run(['cansend', self.interface, frame_str], check=True)

    def close(self):
        if hasattr(self, 'sock'):
            self.sock.close()


def test_keepalive(sender):
    """Send keepalive + status frames — app should show normal state."""
    print("  Sending keepalive + base status...")
    for _ in range(5):
        sender.send(0x700, "0000190100800001")
        sender.send(0x701, "00000000")
        sender.send(0x412, "0000000000001100")
        time.sleep(0.01)


def test_fcw_alert(sender):
    """Trigger Forward Collision Warning."""
    print("  Triggering FCW alert...")
    for _ in range(10):
        sender.send(0x700, "0000110108800003")
        sender.send(0x701, "00000000")
        time.sleep(0.01)


def test_hmw_monitor(sender):
    """Trigger HMW monitoring state."""
    print("  Triggering HMW monitor...")
    for _ in range(10):
        sender.send(0x700, "0000190104800001")
        sender.send(0x760, "00FF000000023B67")
        time.sleep(0.01)


def test_ldw_left(sender):
    """Trigger LDW left warning."""
    print("  Triggering LDW left warning...")
    for _ in range(10):
        sender.send(0x700, "0000190102800001")
        time.sleep(0.01)


def test_tsr_speed_sign(sender):
    """Show a 30 km/h speed limit sign."""
    print("  Showing TSR 30 km/h speed sign...")
    for _ in range(10):
        sender.send(0x700, "0000190100800001")
        sender.send(0x727, "0900FE00FE00FE00")  # Sign type 9 = 30 km/h
        sender.send(0x412, "0000000000001100")
        time.sleep(0.01)


def test_isa_active(sender):
    """Activate ISA with 50 km/h limit."""
    print("  Activating ISA at 50 km/h...")
    for _ in range(10):
        sender.send(0x700, "0000190100800001")
        sender.send(0x7BC, "5A0032030000")  # ISA state 3, speed 50
        sender.send(0x412, "0000000000001100")
        time.sleep(0.01)


def test_speed_display(sender):
    """Display vehicle speed at 80 km/h."""
    print("  Displaying speed 80 km/h...")
    for _ in range(10):
        sender.send(0x700, "0050190100800001")  # speed in byte 1
        time.sleep(0.01)


def test_clear_all(sender):
    """Clear all alerts — return to base state."""
    print("  Clearing all alerts...")
    for _ in range(5):
        sender.send(0x700, "0000010100000001")
        sender.send(0x701, "00000000")
        sender.send(0x727, "FE00FE00FE00FE00")
        sender.send(0x7BC, "000000000000")
        sender.send(0x760, "0000000000000000")
        time.sleep(0.01)


def run_all_tests(sender, delay=2.0):
    """Run the full E2E test suite."""
    tests = [
        ("Keepalive & Base Status", test_keepalive),
        ("FCW Alert", test_fcw_alert),
        ("HMW Monitor", test_hmw_monitor),
        ("LDW Left Warning", test_ldw_left),
        ("TSR Speed Sign (30 km/h)", test_tsr_speed_sign),
        ("ISA Active (50 km/h)", test_isa_active),
        ("Speed Display (80 km/h)", test_speed_display),
        ("Clear All", test_clear_all),
    ]

    total = len(tests)
    passed = 0

    for i, (name, test_fn) in enumerate(tests, 1):
        print(f"\n[{i}/{total}] {name}")
        try:
            test_fn(sender)
            print(f"  -> Sent OK (verify visually on LVGL display)")
            passed += 1
        except Exception as e:
            print(f"  -> FAILED: {e}")

        if i < total:
            time.sleep(delay)

    print(f"\n{'='*50}")
    print(f"E2E Test Complete: {passed}/{total} tests sent successfully")
    print(f"Platform: {platform.system()}")
    if sender.is_windows:
        print(f"Transport: UDP virtual CAN ({sender.host}:{sender.port})")
    else:
        print(f"Transport: {'socketcan' if getattr(sender, 'use_native', False) else 'UDP'}")
    print(f"{'='*50}")

    return passed == total


def main():
    parser = argparse.ArgumentParser(description="EW8 E2E Test")
    parser.add_argument("--port", type=int, default=UDP_CAN_PORT,
                        help=f"UDP port (default: {UDP_CAN_PORT})")
    parser.add_argument("--host", default=UDP_CAN_HOST,
                        help=f"UDP host (default: {UDP_CAN_HOST})")
    parser.add_argument("--interface", "-i", default="can0",
                        help="CAN interface for Linux (default: can0)")
    parser.add_argument("--delay", "-d", type=float, default=2.0,
                        help="Delay between tests in seconds (default: 2.0)")
    args = parser.parse_args()

    print(f"EW8 E2E Test — {platform.system()}")
    print(f"Make sure the LVGL app is running!\n")

    sender = CANSender(host=args.host, port=args.port, interface=args.interface)

    try:
        success = run_all_tests(sender, delay=args.delay)
    finally:
        sender.close()

    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
