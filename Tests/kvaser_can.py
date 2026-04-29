"""
Zero-dependency Kvaser virtual CAN sender for Windows E2E tests.

Mirrors what tools like CANking do: opens a Kvaser channel via canlib32.dll
and writes/reads CAN frames on the bus the backend is also bound to.

The backend opens channel 0 (canmanager.cpp:738). Test sender opens channel 1
so the two share the Kvaser virtual bus without owning the same channel.

Usage:
    from kvaser_can import KvaserBus, is_available
    if is_available():
        with KvaserBus(channel=1, bitrate=500000) as bus:
            bus.send(0x700, b'\\x00\\x00\\x19\\x01\\x00\\x80\\x00\\x01')
"""
import ctypes
import platform
from ctypes import c_int, c_long, c_uint, c_ulong, c_void_p, byref

_IS_WINDOWS = platform.system() == 'Windows'

# canlib constants (from canlib.h)
canOK = 0
canOPEN_ACCEPT_VIRTUAL = 0x0020
canMSG_STD = 0x0002
canBITRATE_1M = -1
canBITRATE_500K = -2
canBITRATE_250K = -3
canBITRATE_125K = -4

_BITRATE_MAP = {
    1000000: canBITRATE_1M,
    500000:  canBITRATE_500K,
    250000:  canBITRATE_250K,
    125000:  canBITRATE_125K,
}

_dll = None


def _load_dll():
    global _dll
    if _dll is not None:
        return _dll
    if not _IS_WINDOWS:
        return None
    try:
        _dll = ctypes.WinDLL("canlib32.dll")
    except (OSError, FileNotFoundError):
        return None

    _dll.canInitializeLibrary.restype = None
    _dll.canGetNumberOfChannels.argtypes = [ctypes.POINTER(c_int)]
    _dll.canGetNumberOfChannels.restype = c_int
    _dll.canOpenChannel.argtypes = [c_int, c_int]
    _dll.canOpenChannel.restype = c_int
    _dll.canSetBusParams.argtypes = [c_int, c_long, c_uint, c_uint, c_uint, c_uint, c_uint]
    _dll.canSetBusParams.restype = c_int
    _dll.canBusOn.argtypes = [c_int]; _dll.canBusOn.restype = c_int
    _dll.canBusOff.argtypes = [c_int]; _dll.canBusOff.restype = c_int
    _dll.canClose.argtypes = [c_int]; _dll.canClose.restype = c_int
    _dll.canWriteWait.argtypes = [c_int, c_long, c_void_p, c_uint, c_uint, c_ulong]
    _dll.canWriteWait.restype = c_int
    _dll.canReadWait.argtypes = [c_int, ctypes.POINTER(c_long), c_void_p,
                                 ctypes.POINTER(c_uint), ctypes.POINTER(c_uint),
                                 ctypes.POINTER(c_ulong), c_ulong]
    _dll.canReadWait.restype = c_int
    _dll.canInitializeLibrary()
    return _dll


def is_available():
    """True if canlib32.dll is loadable and at least 1 channel exists."""
    dll = _load_dll()
    if dll is None:
        return False
    n = c_int(0)
    if dll.canGetNumberOfChannels(byref(n)) != canOK:
        return False
    return n.value >= 1


def channel_count():
    dll = _load_dll()
    if dll is None:
        return 0
    n = c_int(0)
    dll.canGetNumberOfChannels(byref(n))
    return n.value


class KvaserError(RuntimeError):
    def __init__(self, op, stat):
        super().__init__(f"{op} failed: canlib stat={stat}")
        self.stat = stat


class KvaserBus:
    """Open a Kvaser CAN channel for send/recv. Use as a context manager."""

    def __init__(self, channel=1, bitrate=500000):
        dll = _load_dll()
        if dll is None:
            raise RuntimeError("canlib32.dll not available — install Kvaser drivers")
        self._dll = dll
        self.channel = channel
        bit = _BITRATE_MAP.get(bitrate)
        if bit is None:
            raise ValueError(f"unsupported bitrate {bitrate}; use one of {list(_BITRATE_MAP)}")

        h = dll.canOpenChannel(channel, canOPEN_ACCEPT_VIRTUAL)
        if h < 0:
            raise KvaserError(f"canOpenChannel({channel})", h)
        self._h = h

        s = dll.canSetBusParams(h, bit, 0, 0, 0, 0, 0)
        if s != canOK:
            dll.canClose(h)
            raise KvaserError("canSetBusParams", s)

        s = dll.canBusOn(h)
        if s != canOK:
            dll.canClose(h)
            raise KvaserError("canBusOn", s)

    def send(self, can_id, data, timeout_ms=100):
        """Write one CAN frame. Returns canlib stat (0 = OK)."""
        if isinstance(data, (list, tuple)):
            data = bytes(data)
        dlc = len(data)
        if dlc > 8:
            raise ValueError("CAN classic frame data must be <=8 bytes")
        buf = (ctypes.c_ubyte * 8)(*data, *([0] * (8 - dlc)))
        return self._dll.canWriteWait(self._h, can_id, buf, dlc, canMSG_STD, timeout_ms)

    def recv(self, timeout_ms=200):
        """Read one frame. Returns (can_id, bytes, flags) or None on timeout."""
        rid = c_long(0); rdlc = c_uint(0); rflag = c_uint(0); rtime = c_ulong(0)
        buf = (ctypes.c_ubyte * 8)()
        s = self._dll.canReadWait(self._h, byref(rid), buf, byref(rdlc),
                                  byref(rflag), byref(rtime), timeout_ms)
        if s != canOK:
            return None
        return (rid.value, bytes(buf[:rdlc.value]), rflag.value)

    def close(self):
        if getattr(self, '_h', None) is not None:
            self._dll.canBusOff(self._h)
            self._dll.canClose(self._h)
            self._h = None

    def __enter__(self): return self
    def __exit__(self, *a): self.close()
    def __del__(self):
        try: self.close()
        except Exception: pass
