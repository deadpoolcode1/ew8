import os
from time import sleep
import platform
import socket
import struct

import cantools

# Try importing python-can; not needed on Windows UDP mode
try:
    import can
    HAS_PYTHON_CAN = True
except ImportError:
    HAS_PYTHON_CAN = False

import time

BITRATE = 500000
CHANNEL = 0

# UDP virtual CAN settings (Windows)
UDP_CAN_PORT = 18700
UDP_CAN_HOST = "127.0.0.1"

IS_WINDOWS = platform.system() == 'Windows'

# Configure python-can for non-UDP modes
if HAS_PYTHON_CAN and not IS_WINDOWS:
    can.rc['interface'] = "socketcan"
    can.rc['channel'] = "can0"
elif HAS_PYTHON_CAN:
    # On Windows with python-can + Kvaser hardware, use kvaser interface
    # For UDP mode (default on Windows), python-can is not used
    can.rc['interface'] = "kvaser"
    can.rc['channel'] = CHANNEL


def send_one_udp(std_id, aData, udp_sock):
    """Send a CAN frame via UDP virtual CAN."""
    dlc = min(len(aData), 8)
    padded = (bytes(aData)[:8] + b'\x00' * 8)[:8]
    packet = struct.pack('<IB', std_id, dlc) + padded
    udp_sock.sendto(packet, (UDP_CAN_HOST, UDP_CAN_PORT))


def send_one(std_id, aData, bus):
    """Send a CAN frame via python-can bus."""
    msg = can.Message(arbitration_id=std_id,
                      data=aData, is_extended_id=False)
    try:
        bus.send(msg)
    except can.CanError:
        print("CAN Error: Message NOT sent")


class EW8test(object):
    dbset = dict()
    frames2send = []

    def __init__(self, use_udp=None):
        """
        Initialize the test library.

        Args:
            use_udp: Force UDP mode (True/False). Default: auto-detect
                     (UDP on Windows, socketcan on Linux).
        """
        if use_udp is None:
            self.use_udp = IS_WINDOWS
        else:
            self.use_udp = use_udp

        if self.use_udp:
            self._udp_sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

        homedir = os.path.expanduser('~')
        print(homedir)
        dbcdir = os.path.join(homedir, 'canquick', 'DBC')
        print(dbcdir)

        files = os.listdir(dbcdir)
        for file in files:
            print(file)
            db = cantools.db.load_file(os.path.join(dbcdir, file))

            for msg in db.messages:
                print(msg)
                self.dbset[msg.frame_id] = msg

    def constructMessage(self, id, dict_of_signals, fill=0):
        msg = self.dbset[id]
        can_frame = bytearray(len([0x00] * msg.length))
        can_dict = msg.decode(can_frame)
        can_dict.update(dict_of_signals)
        frame_data = msg.encode(can_dict)
        self.frames2send.append((id, frame_data))

    def deleteMessage(self, id):
        for frame in self.frames2send:
            if frame[0] == id:
                self.frames2send.remove(frame)

    def send(self, period=0.01, time2send=0):
        if self.use_udp:
            time2stop = time.time() + time2send
            while (time2send == 0 or time2stop > time.time()):
                for msg in self.frames2send:
                    (id, data) = msg
                    print(id)
                    send_one_udp(id, data, self._udp_sock)
                    sleep(period)
        else:
            with can.interface.Bus() as bus:
                time2stop = time.time() + time2send
                while (time2send == 0 or time2stop > time.time()):
                    for msg in self.frames2send:
                        (id, data) = msg
                        print(id)
                        send_one(id, data, bus)
                        sleep(period)

    def __del__(self):
        if hasattr(self, '_udp_sock'):
            self._udp_sock.close()


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    pass
