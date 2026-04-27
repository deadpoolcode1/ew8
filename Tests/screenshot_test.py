#!/usr/bin/env python3
"""Run E2E tests with screenshots captured at each step."""

import subprocess
import time
import os
import sys
import struct
import socket
import ctypes
from ctypes import wintypes
from PIL import Image

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_DIR = os.path.dirname(SCRIPT_DIR)
EXE = os.path.join(PROJECT_DIR, "build_win", "ew8_lvgl.exe")
SCREENSHOT_DIR = os.path.join(PROJECT_DIR, "build_win", "screenshots")
UDP_PORT = 18700

os.makedirs(SCREENSHOT_DIR, exist_ok=True)

# Win32 constants
SRCCOPY = 0x00CC0020
PW_RENDERFULLCONTENT = 0x00000002
DIB_RGB_COLORS = 0
BI_RGB = 0


def find_sdl_window():
    """Find the SDL/EW8 window handle."""
    user32 = ctypes.windll.user32
    EnumWindows = user32.EnumWindows
    GetWindowTextW = user32.GetWindowTextW
    GetWindowTextLengthW = user32.GetWindowTextLengthW
    IsWindowVisible = user32.IsWindowVisible

    WNDENUMPROC = ctypes.WINFUNCTYPE(ctypes.c_bool, ctypes.c_void_p, ctypes.c_void_p)
    results = []

    def callback(hwnd, _):
        if IsWindowVisible(hwnd):
            length = GetWindowTextLengthW(hwnd)
            if length > 0:
                buff = ctypes.create_unicode_buffer(length + 1)
                GetWindowTextW(hwnd, buff, length + 1)
                title = buff.value.lower()
                if any(k in title for k in ['ew8', 'sdl', 'lvgl']):
                    results.append(hwnd)
        return True

    EnumWindows(WNDENUMPROC(callback), 0)
    return results[0] if results else None


def screenshot_hwnd(hwnd, output_path):
    """Capture a window using PrintWindow (works with HW-accelerated windows)."""
    user32 = ctypes.windll.user32
    gdi32 = ctypes.windll.gdi32

    # Get client rect (the SDL render area, no title bar)
    client_rect = wintypes.RECT()
    user32.GetClientRect(hwnd, ctypes.byref(client_rect))
    w = client_rect.right - client_rect.left
    h = client_rect.bottom - client_rect.top

    if w <= 0 or h <= 0:
        print(f"  Warning: client area {w}x{h}, falling back to window rect")
        rect = wintypes.RECT()
        user32.GetWindowRect(hwnd, ctypes.byref(rect))
        w = rect.right - rect.left
        h = rect.bottom - rect.top

    # Create compatible DC and bitmap
    hwnd_dc = user32.GetDC(hwnd)
    mem_dc = gdi32.CreateCompatibleDC(hwnd_dc)
    bitmap = gdi32.CreateCompatibleBitmap(hwnd_dc, w, h)
    gdi32.SelectObject(mem_dc, bitmap)

    # Try PrintWindow with PW_RENDERFULLCONTENT first (Windows 8.1+)
    result = user32.PrintWindow(hwnd, mem_dc, PW_RENDERFULLCONTENT)
    if not result:
        # Fallback: BitBlt from window DC
        gdi32.BitBlt(mem_dc, 0, 0, w, h, hwnd_dc, 0, 0, SRCCOPY)

    # Read bitmap data
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
    bmi.biHeight = -h  # Top-down
    bmi.biPlanes = 1
    bmi.biBitCount = 32
    bmi.biCompression = BI_RGB

    buf = ctypes.create_string_buffer(w * h * 4)
    gdi32.GetDIBits(mem_dc, bitmap, 0, h, buf, ctypes.byref(bmi), DIB_RGB_COLORS)

    # Convert BGRA -> RGBA
    img = Image.frombuffer('RGBA', (w, h), buf, 'raw', 'BGRA', 0, 1)
    img = img.convert('RGB')
    img.save(output_path)

    # Cleanup
    gdi32.DeleteObject(bitmap)
    gdi32.DeleteDC(mem_dc)
    user32.ReleaseDC(hwnd, hwnd_dc)

    print(f"  Screenshot saved: {output_path} ({w}x{h})")
    return output_path


def screenshot(name):
    """Capture the app window and save as PNG."""
    hwnd = find_sdl_window()
    path = os.path.join(SCREENSHOT_DIR, f"{name}.png")
    if hwnd:
        return screenshot_hwnd(hwnd, path)
    else:
        # Fallback: full desktop
        from PIL import ImageGrab
        img = ImageGrab.grab()
        img.save(path)
        print(f"  Screenshot saved (full desktop fallback): {path}")
        return path


def send_can(can_id, data_hex):
    data = bytes.fromhex(data_hex)
    dlc = min(len(data), 8)
    padded = (data[:8] + b'\x00' * 8)[:8]
    packet = struct.pack('<IB', can_id, dlc) + padded
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.sendto(packet, ("127.0.0.1", UDP_PORT))
    sock.close()


def send_repeated(frames, count=10, interval=0.01):
    for _ in range(count):
        for can_id, data_hex in frames:
            send_can(can_id, data_hex)
        time.sleep(interval)


def main():
    # Start the app
    print(f"Starting {EXE}...")
    env = os.environ.copy()
    env["PATH"] = r"C:\msys64\mingw64\bin" + ";" + env.get("PATH", "")
    # Force SDL2 software rendering so window content can be captured by GDI
    env["SDL_RENDER_DRIVER"] = "software"
    proc = subprocess.Popen(
        [EXE], cwd=os.path.join(PROJECT_DIR, "build_win"), env=env,
        stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
    )
    time.sleep(4)  # Wait for app to initialize

    if proc.poll() is not None:
        print("ERROR: App exited prematurely!")
        sys.exit(1)

    tests = [
        ("01_keepalive", "Keepalive & Base Status", [
            (0x700, "0000190100800001"),
            (0x701, "00000000"),
            (0x412, "0000000000001100"),
        ]),
        ("02_fcw_alert", "FCW Alert (Forward Collision Warning)", [
            (0x700, "0000110108800003"),
            (0x701, "00000000"),
        ]),
        ("03_hmw_monitor", "HMW Monitor (Headway Monitoring)", [
            (0x700, "0000190104800001"),
            (0x760, "00FF000000023B67"),
        ]),
        ("04_ldw_left", "LDW Left Warning (Lane Departure)", [
            (0x700, "0000190102800001"),
        ]),
        ("05_tsr_30kmh", "TSR Speed Sign (30 km/h)", [
            (0x700, "0000190100800001"),
            (0x727, "0900FE00FE00FE00"),
            (0x412, "0000000000001100"),
        ]),
        ("06_isa_50kmh", "ISA Active (50 km/h)", [
            (0x700, "0000190100800001"),
            (0x7BC, "5A0032030000"),
            (0x412, "0000000000001100"),
        ]),
        ("07_speed_80kmh", "Speed Display (80 km/h)", [
            (0x700, "0050190100800001"),
        ]),
        ("08_clear_all", "Clear All", [
            (0x700, "0000010100000001"),
            (0x701, "00000000"),
            (0x727, "FE00FE00FE00FE00"),
            (0x7BC, "000000000000"),
            (0x760, "0000000000000000"),
        ]),
    ]

    try:
        # Initial state screenshot
        screenshot("00_initial")

        for filename, name, frames in tests:
            print(f"\n[{filename}] {name}")
            send_repeated(frames)
            time.sleep(2.0)  # Let the display update fully
            screenshot(filename)

        print(f"\nAll {len(tests)} test screenshots saved to: {SCREENSHOT_DIR}")

    finally:
        proc.terminate()
        proc.wait(timeout=5)
        print("App terminated.")


if __name__ == "__main__":
    main()
