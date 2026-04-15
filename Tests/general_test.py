#!/usr/bin/env python3
"""
Cross-platform interactive CAN test for EW8.
Works on both Linux (socketcan) and Windows (UDP virtual CAN).
"""

import os
import time
import platform
import socket
import struct
import sys

IS_WINDOWS = platform.system() == 'Windows'

# Import platform-specific keyboard module
if IS_WINDOWS:
    import msvcrt
else:
    import select

BASICSLEEP = 0.03
VERBOSE = True

# UDP virtual CAN settings
UDP_CAN_PORT = 18700
UDP_CAN_HOST = "127.0.0.1"

# CAN settings for python-can (Linux with Kvaser, or Linux socketcan)
BITRATE = 500000
CHANNEL = 1

# Global sender
_udp_sock = None
_can_bus = None


def _get_sender():
    global _udp_sock, _can_bus
    if IS_WINDOWS:
        if _udp_sock is None:
            _udp_sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        return 'udp'
    else:
        try:
            import can
            if _can_bus is None:
                can.rc['interface'] = "socketcan"
                can.rc['channel'] = "can0"
                _can_bus = can.interface.Bus()
            return 'can'
        except ImportError:
            if _udp_sock is None:
                _udp_sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            return 'udp'


def send_one(std_id, aData):
    mode = _get_sender()
    if mode == 'udp':
        dlc = min(len(aData), 8)
        padded = (bytes(aData)[:8] + b'\x00' * 8)[:8]
        packet = struct.pack('<IB', std_id, dlc) + padded
        _udp_sock.sendto(packet, (UDP_CAN_HOST, UDP_CAN_PORT))
    else:
        import can
        msg = can.Message(arbitration_id=std_id, data=aData, extended_id=False)
        try:
            _can_bus.send(msg)
        except can.CanError:
            print("CAN Error: Message NOT sent")


def write_to_can(msg_id, data):
    argumentstr = " ".join(hex(i) for i in data) + f" -i{hex(msg_id)}"
    starttime = time.time()
    send_one(msg_id, data)
    stoptime = time.time()
    if VERBOSE:
        print(f'{starttime} {stoptime} data: {argumentstr}')


# Send messages functions:

def msg0x700(B1BYTE=0x0, B2BYTE=0x0, B4BYTE=0x1, B5BYTE=0x0, B7BYTE=0x0):
    write_to_can(0x700, [0x0, B1BYTE, B2BYTE, 0x1, B4BYTE, B5BYTE, 0x0, B7BYTE])
    time.sleep(BASICSLEEP)


def msg0x727(SIGN0=0xFF, SUPP0=0x0, SIGN1=0xFF, SUPP1=0x0,
             SIGN2=0xFF, SUPP2=0x0, SIGN3=0xFF, SUPP3=0x0):
    write_to_can(0x727, [SIGN0, SUPP0, SIGN1, SUPP1, SIGN2, SUPP2, SIGN3, SUPP3])
    time.sleep(BASICSLEEP)


# Cross-platform keyboard check

def kbhit():
    """Check if a key has been pressed (non-blocking)."""
    if IS_WINDOWS:
        return msvcrt.kbhit()
    else:
        return select.select([sys.stdin], [], [], 0)[0] != []


def getch():
    """Read a single character."""
    if IS_WINDOWS:
        return msvcrt.getwch()
    else:
        sys.stdin.readline()
        return '\n'


# Tests:

def test_an_alert_b5(anAlert):
    iterfirst = True
    starttime = time.time()
    curtime = time.time()

    while iterfirst:
        msg0x700(B5BYTE=anAlert)
        curtime = time.time()
        if iterfirst:
            print("test with all seeqs alert " + hex(anAlert))
            iterfirst = False


def test_an_alert_b4(anAlert):
    iterfirst = True
    starttime = time.time()
    curtime = time.time()

    while iterfirst:
        msg0x700(B4BYTE=anAlert)
        curtime = time.time()
        if iterfirst:
            print("test with all seeqs alert " + hex(anAlert))
            iterfirst = False


def loop(msg_fn, **args):
    while not kbhit():
        msg_fn(**args)
    getch()


def main():
    time.sleep(3)

    while True:
        loop(msg0x700, B5BYTE=0x4)
        loop(msg0x700, B2BYTE=0x0, B7BYTE=0x1)

        print("Next is FCW alert")
        loop(msg0x700, B2BYTE=0x11, B5BYTE=0x4, B7BYTE=0x3)

        print("I am FCW alert")
        loop(msg0x700, B2BYTE=0x11, B4BYTE=0x8, B7BYTE=0x3)

        loop(msg0x700, B4BYTE=0x7)
        loop(msg0x700, B4BYTE=0x4)
        loop(msg0x700, B4BYTE=0x2)
        loop(msg0x700, B4BYTE=0x6)
        loop(msg0x700, B4BYTE=0x6, B5BYTE=0x4)
        loop(msg0x700, B1BYTE=0x80)
        loop(msg0x700, B1BYTE=0xC0)
        loop(msg0x700, B1BYTE=0x80)
        loop(msg0x700, B1BYTE=0x40)

        loop(msg0x727, SIGN1=0x9)
        loop(msg0x727)
        loop(msg0x727, SIGN1=0x6)
        loop(msg0x727, SIGN1=0xAF)
        loop(msg0x727, SIGN1=0xAB)
        loop(msg0x727, SIGN1=0x40)
        loop(msg0x727, SIGN1=0xC8)

    input("Press ENTER to close the window")


main()
