#!/usr/bin/env python3
"""E2E test: disconnect/no-message timeout warning sign.

Verifies that the LVGL frontend shows the yellow "Disconnected" warning
overlay after no keepalive (CAN id 0x412) arrives for the configured
keepAlive timeout (20s in EW8_Signals.json), and that the warning
clears once keepalives resume.
"""

import ctypes
import os
import socket
import struct
import subprocess
import sys
import time
from ctypes import wintypes
from PIL import Image

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_DIR = os.path.dirname(SCRIPT_DIR)
EXE = os.path.join(PROJECT_DIR, "build_win", "ew8_lvgl.exe")
SCREENSHOT_DIR = os.path.join(PROJECT_DIR, "build_win", "screenshots_disconnect")
UDP_PORT = 18700

# Keep-alive timeout from signals/EW8_Signals.json -> "timeout": 20000
KEEPALIVE_TIMEOUT_S = 20.0
WAIT_AFTER_TIMEOUT_S = 3.0  # buffer for timer + LVGL render

os.makedirs(SCREENSHOT_DIR, exist_ok=True)

SRCCOPY = 0x00CC0020
PW_RENDERFULLCONTENT = 0x00000002
DIB_RGB_COLORS = 0
BI_RGB = 0


def find_sdl_window():
    user32 = ctypes.windll.user32
    WNDENUMPROC = ctypes.WINFUNCTYPE(ctypes.c_bool, ctypes.c_void_p, ctypes.c_void_p)
    results = []

    def callback(hwnd, _):
        if user32.IsWindowVisible(hwnd):
            length = user32.GetWindowTextLengthW(hwnd)
            if length > 0:
                buff = ctypes.create_unicode_buffer(length + 1)
                user32.GetWindowTextW(hwnd, buff, length + 1)
                title = buff.value.lower()
                if any(k in title for k in ['ew8', 'sdl', 'lvgl']):
                    results.append(hwnd)
        return True

    user32.EnumWindows(WNDENUMPROC(callback), 0)
    return results[0] if results else None


def screenshot(name):
    """Capture the EW8/SDL window content via PrintWindow."""
    user32 = ctypes.windll.user32
    gdi32 = ctypes.windll.gdi32

    hwnd = find_sdl_window()
    path = os.path.join(SCREENSHOT_DIR, f"{name}.png")
    if not hwnd:
        print(f"  Window not found, skipping screenshot {name}")
        return None

    client = wintypes.RECT()
    user32.GetClientRect(hwnd, ctypes.byref(client))
    w = client.right - client.left
    h = client.bottom - client.top

    hwnd_dc = user32.GetDC(hwnd)
    mem_dc = gdi32.CreateCompatibleDC(hwnd_dc)
    bitmap = gdi32.CreateCompatibleBitmap(hwnd_dc, w, h)
    gdi32.SelectObject(mem_dc, bitmap)

    ok = user32.PrintWindow(hwnd, mem_dc, PW_RENDERFULLCONTENT)
    if not ok:
        gdi32.BitBlt(mem_dc, 0, 0, w, h, hwnd_dc, 0, 0, SRCCOPY)

    class BITMAPINFOHEADER(ctypes.Structure):
        _fields_ = [
            ('biSize', wintypes.DWORD),
            ('biWidth', ctypes.c_long),
            ('biHeight', ctypes.c_long),
            ('biPlanes', wintypes.WORD),
            ('biBitCount', wintypes.WORD),
            ('biCompression', wintypes.DWORD),
            ('biSizeImage', wintypes.DWORD),
            ('biXPelsPerMeter', ctypes.c_long),
            ('biYPelsPerMeter', ctypes.c_long),
            ('biClrUsed', wintypes.DWORD),
            ('biClrImportant', wintypes.DWORD),
        ]

    bmi = BITMAPINFOHEADER()
    bmi.biSize = ctypes.sizeof(BITMAPINFOHEADER)
    bmi.biWidth = w
    bmi.biHeight = -h
    bmi.biPlanes = 1
    bmi.biBitCount = 32
    bmi.biCompression = BI_RGB

    buf = ctypes.create_string_buffer(w * h * 4)
    gdi32.GetDIBits(mem_dc, bitmap, 0, h, buf, ctypes.byref(bmi), DIB_RGB_COLORS)

    img = Image.frombuffer('RGBA', (w, h), buf, 'raw', 'BGRA', 0, 1)
    img = img.convert('RGB')
    img.save(path)

    gdi32.DeleteObject(bitmap)
    gdi32.DeleteDC(mem_dc)
    user32.ReleaseDC(hwnd, hwnd_dc)

    print(f"  Screenshot saved: {path} ({w}x{h})")
    return path


def send_can(can_id, data_hex, sock):
    data = bytes.fromhex(data_hex)
    dlc = min(len(data), 8)
    padded = (data[:8] + b'\x00' * 8)[:8]
    packet = struct.pack('<IB', can_id, dlc) + padded
    sock.sendto(packet, ("127.0.0.1", UDP_PORT))


def send_normal_state(sock, count=1):
    """Send a normal-state burst: keepalive (0x412) + base status frames."""
    for _ in range(count):
        send_can(0x700, "0000190100800001", sock)
        send_can(0x701, "00000000", sock)
        send_can(0x412, "0000000000001100", sock)


def has_yellow_pixels(image_path, ratio_threshold=0.005):
    """Return True if the image contains a non-trivial number of saturated yellow pixels.

    Yellow warning sign uses RGB ~ (R high, G high, B low). This is a coarse but
    deterministic heuristic so the test does not depend on exact pixel layout.
    """
    img = Image.open(image_path).convert("RGB")
    px = img.load()
    w, h = img.size
    yellow = 0
    total = w * h
    for y in range(h):
        for x in range(w):
            r, g, b = px[x, y]
            if r >= 200 and g >= 180 and b <= 90 and abs(r - g) <= 60:
                yellow += 1
    ratio = yellow / total
    print(f"    yellow-pixel ratio = {ratio:.4f} (threshold {ratio_threshold})")
    return ratio >= ratio_threshold


def main():
    print(f"Starting {EXE}...")
    env = os.environ.copy()
    env["PATH"] = r"C:\msys64\mingw64\bin" + ";" + env.get("PATH", "")
    env["SDL_RENDER_DRIVER"] = "software"
    proc = subprocess.Popen(
        [EXE], cwd=os.path.join(PROJECT_DIR, "build_win"), env=env,
        stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
    )
    time.sleep(4)

    if proc.poll() is not None:
        print("ERROR: App exited prematurely!")
        sys.exit(1)

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    failures = []

    try:
        # 1) Push the app into a known-good state with keepalives.
        print("\n[1] Sending keepalives + base status for 5s...")
        deadline = time.time() + 5.0
        while time.time() < deadline:
            send_normal_state(sock)
            time.sleep(0.1)
        time.sleep(0.5)
        normal_path = screenshot("01_normal_state")

        if normal_path and has_yellow_pixels(normal_path):
            failures.append("Yellow warning visible during normal state (should be hidden)")

        # 2) Stop sending and wait long enough for the keepalive timeout to fire.
        wait = KEEPALIVE_TIMEOUT_S + WAIT_AFTER_TIMEOUT_S
        print(f"\n[2] Stopping CAN traffic, waiting {wait:.1f}s for disconnect timeout...")
        time.sleep(wait)
        disc_path = screenshot("02_after_timeout")

        if disc_path and not has_yellow_pixels(disc_path):
            failures.append("Yellow warning NOT visible after keepalive timeout (timeout did not trigger)")

        # 3) Resume keepalives, verify the warning clears.
        print("\n[3] Resuming keepalives, verifying warning clears...")
        for _ in range(20):
            send_normal_state(sock)
            time.sleep(0.1)
        time.sleep(1.0)
        recover_path = screenshot("03_after_recover")

        if recover_path and has_yellow_pixels(recover_path):
            failures.append("Yellow warning still visible after keepalive resumed (should clear)")

    finally:
        sock.close()
        proc.terminate()
        try:
            proc.wait(timeout=5)
        except subprocess.TimeoutExpired:
            proc.kill()
        print("App terminated.")

    print("\n" + "=" * 60)
    if failures:
        print("DISCONNECT TEST FAILED:")
        for f in failures:
            print(f"  - {f}")
        sys.exit(1)
    else:
        print("DISCONNECT TEST PASSED")
        sys.exit(0)


if __name__ == "__main__":
    main()
