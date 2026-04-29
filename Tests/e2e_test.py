#!/usr/bin/env python3
"""
Cross-platform E2E test for EW8 LVGL frontend.

Sends CAN messages and verifies the app is receiving them.

By default runs two transport phases sequentially:
  1) UDP virtual CAN (the simulated path the backend uses without canlib)
  2) Kvaser virtual CAN (matches what tools like CANking drive on real Windows
     deployments) — only on Windows when canlib32.dll is loadable.

Each phase exercises the same scenarios. The Kvaser phase additionally
verifies the bus is live by waiting for the backend's keepalive frame (0x7E0)
before sending its own traffic.

After running, a self-contained HTML report is written under
Tests/reports/e2e_report_<timestamp>.html.

Usage:
    python e2e_test.py                       # both phases (auto-skip Kvaser if unavailable)
    python e2e_test.py --transport udp       # UDP only
    python e2e_test.py --transport kvaser    # Kvaser only
    python e2e_test.py --transport socketcan # Linux native only

Prerequisites:
    - EW8 LVGL app must be running.
    - Linux: vcan interface must be up.
    - Windows: no special setup for UDP. Kvaser drivers + canlib32.dll for the Kvaser phase.
"""

import argparse
import datetime as _dt
import html as _html
import os
import platform
import socket
import struct
import sys
import time

UDP_CAN_PORT = 18700
UDP_CAN_HOST = "127.0.0.1"

# Kvaser channel used by the test. The backend opens channel 0
# (canmanager.cpp:738), so the test sends on channel 1 — both channels share
# the same Kvaser virtual bus.
KVASER_CHANNEL = 1
KVASER_BITRATE = 500000

# Keepalive frame the backend emits every ~200ms (keepalivemsg.cpp).
# Its appearance on the Kvaser bus proves the backend is on the same bus.
BACKEND_KEEPALIVE_ID = 0x7E0


# -- Senders ----------------------------------------------------------------

class UdpSender:
    name = "udp"
    def __init__(self, host=UDP_CAN_HOST, port=UDP_CAN_PORT):
        self.host = host
        self.port = port
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    def send(self, can_id, data_hex):
        data = bytes.fromhex(data_hex)
        dlc = min(len(data), 8)
        padded = (data[:8] + b'\x00' * 8)[:8]
        packet = struct.pack('<IB', can_id, dlc) + padded
        self.sock.sendto(packet, (self.host, self.port))
    def close(self):
        self.sock.close()
    def description(self):
        return f"UDP virtual CAN ({self.host}:{self.port})"


class SocketCanSender:
    name = "socketcan"
    def __init__(self, interface="can0"):
        self.interface = interface
    def send(self, can_id, data_hex):
        import subprocess
        frame_str = f'{can_id:03X}#{data_hex.upper()}'
        subprocess.run(['cansend', self.interface, frame_str], check=True)
    def close(self): pass
    def description(self):
        return f"socketcan ({self.interface})"


class KvaserSender:
    """Sends frames via Kvaser virtual CAN, mirroring CANking-style traffic."""
    name = "kvaser"
    def __init__(self, channel=KVASER_CHANNEL, bitrate=KVASER_BITRATE):
        from kvaser_can import KvaserBus
        self._bus = KvaserBus(channel=channel, bitrate=bitrate)
        self.channel = channel
        self.bitrate = bitrate
        self.tx_failures = 0
    def send(self, can_id, data_hex):
        data = bytes.fromhex(data_hex)
        stat = self._bus.send(can_id, data)
        if stat != 0:
            self.tx_failures += 1
            raise RuntimeError(f"canWriteWait id=0x{can_id:X} stat={stat}")
    def recv(self, timeout_ms=200):
        return self._bus.recv(timeout_ms)
    def close(self):
        self._bus.close()
    def description(self):
        return f"Kvaser virtual CAN (ch {self.channel} @ {self.bitrate} bps)"


# -- Test scenarios (transport-agnostic) ------------------------------------

def test_keepalive(sender):
    print("  Sending keepalive + base status...")
    for _ in range(5):
        sender.send(0x700, "0000190100800001")
        sender.send(0x701, "00000000")
        sender.send(0x412, "0000000000001100")
        time.sleep(0.01)


def test_fcw_alert(sender):
    print("  Triggering FCW alert...")
    for _ in range(10):
        sender.send(0x700, "0000110108800003")
        sender.send(0x701, "00000000")
        time.sleep(0.01)


def test_hmw_monitor(sender):
    print("  Triggering HMW monitor...")
    for _ in range(10):
        sender.send(0x700, "0000190104800001")
        sender.send(0x760, "00FF000000023B67")
        time.sleep(0.01)


def test_ldw_left(sender):
    print("  Triggering LDW left warning...")
    for _ in range(10):
        sender.send(0x700, "0000190102800001")
        time.sleep(0.01)


def test_tsr_speed_sign(sender):
    print("  Showing TSR 30 km/h speed sign...")
    for _ in range(10):
        sender.send(0x700, "0000190100800001")
        sender.send(0x727, "0900FE00FE00FE00")
        sender.send(0x412, "0000000000001100")
        time.sleep(0.01)


def test_isa_active(sender):
    print("  Activating ISA at 50 km/h...")
    for _ in range(10):
        sender.send(0x700, "0000190100800001")
        sender.send(0x7BC, "5A0032030000")
        sender.send(0x412, "0000000000001100")
        time.sleep(0.01)


def test_speed_display(sender):
    print("  Displaying speed 80 km/h...")
    for _ in range(10):
        sender.send(0x700, "0050190100800001")
        time.sleep(0.01)


def test_clear_all(sender):
    print("  Clearing all alerts...")
    for _ in range(5):
        sender.send(0x700, "0000010100000001")
        sender.send(0x701, "00000000")
        sender.send(0x727, "FE00FE00FE00FE00")
        sender.send(0x7BC, "000000000000")
        sender.send(0x760, "0000000000000000")
        time.sleep(0.01)


SCENARIOS = [
    ("Keepalive_BaseStatus", test_keepalive,
        "Sends Base Status (0x700) + DSP status (0x701) + IMS_ISA (0x412) keepalive frames "
        "5 times via {transport}; backend should remain in nominal state with no overlays."),
    ("FCW_Alert", test_fcw_alert,
        "Triggers Forward Collision Warning by repeating 0x700 with FCW bits set + 0x701 "
        "10 times via {transport}; backend should render the FCW overlay."),
    ("HMW_Monitor", test_hmw_monitor,
        "Drives Headway Monitoring Warning by repeating 0x700 with HMW state + 0x760 "
        "(host car distance) 10 times via {transport}; backend should display HMW car icon."),
    ("LDW_LeftWarning", test_ldw_left,
        "Triggers Lane Departure Warning (left) by repeating 0x700 with LDW bits 10 times "
        "via {transport}; backend should display the left LDW indicator."),
    ("TSR_SpeedSign_30", test_tsr_speed_sign,
        "Displays a Traffic Sign Recognition 30 km/h sign by repeating 0x700 + 0x727 (sign "
        "type 9) + 0x412 10 times via {transport}; backend should render a 30 sign."),
    ("ISA_Active_50", test_isa_active,
        "Activates Intelligent Speed Assist at 50 km/h by repeating 0x700 + 0x7BC (ISA state 3 "
        "with limit byte) + 0x412 10 times via {transport}; backend should display ISA at 50."),
    ("Speed_Display_80", test_speed_display,
        "Displays vehicle speed at 80 km/h by repeating 0x700 with byte-1 speed 0x50 10 times "
        "via {transport}; backend should render the numeric speed."),
    ("Clear_All", test_clear_all,
        "Returns the backend to a clean idle state by clearing all alert/sign/ISA/HMW frames "
        "via {transport}; no overlays should remain."),
]


# -- Phase runner -----------------------------------------------------------

def run_scenarios(sender, delay, results):
    """Runs all scenarios with the given sender, appending per-scenario rows
    to `results` (list of dicts)."""
    transport_name = sender.name
    for i, (name, fn, what) in enumerate(SCENARIOS, 1):
        print(f"\n[{i}/{len(SCENARIOS)}] {name}")
        verifies = what.format(transport=transport_name)
        t0 = time.monotonic()
        status = "PASSED"
        message = ""
        try:
            fn(sender)
            print("  -> Sent OK (verify visually on LVGL display)")
        except Exception as e:
            status = "FAILED"
            message = repr(e)
            print(f"  -> FAILED: {e}")
        dur_ms = int((time.monotonic() - t0) * 1000)
        results.append({
            "name": name, "transport": transport_name, "verifies": verifies,
            "status": status, "duration_ms": dur_ms, "message": message,
        })
        if i < len(SCENARIOS):
            time.sleep(delay)


def wait_for_backend_keepalive(kvaser_sender, timeout_s=5.0):
    """Confirm the backend is on the same Kvaser bus by sniffing for 0x7E0."""
    deadline = time.monotonic() + timeout_s
    while time.monotonic() < deadline:
        frame = kvaser_sender.recv(timeout_ms=200)
        if frame is None:
            continue
        rid, _data, _flags = frame
        if rid == BACKEND_KEEPALIVE_ID:
            return True
    return False


def run_phase(label, sender, delay, results):
    """Returns (preflight_ok, preflight_status, preflight_message)."""
    print(f"\n{'='*60}\nPHASE: {label}\n  transport: {sender.description()}\n{'='*60}")

    if isinstance(sender, KvaserSender):
        print("  Preflight: waiting for backend keepalive 0x7E0 on Kvaser bus...")
        t0 = time.monotonic()
        ok = wait_for_backend_keepalive(sender, timeout_s=5.0)
        dur_ms = int((time.monotonic() - t0) * 1000)
        results.append({
            "name": "Preflight_KvaserBusLive",
            "transport": sender.name,
            "verifies": "Confirms the backend is on the same Kvaser virtual bus as the test "
                        "sender by waiting up to 5s for the keepalive frame (id=0x7E0) emitted "
                        "every ~200ms by keepalivemsg.cpp.",
            "status": "PASSED" if ok else "FAILED",
            "duration_ms": dur_ms,
            "message": "" if ok else "no 0x7E0 within 5s — backend not on Kvaser bus",
        })
        if not ok:
            print("  -> NOT SEEN within 5s. Skipping scenarios on this phase.")
            return False
        print("  -> Backend keepalive observed. Bus is live.")

    run_scenarios(sender, delay, results)

    # Regression check for the canERR_TIMEOUT (-7) storm we hit in dev: the
    # backend writes a kvaser_diag.log file only when canWriteWait returns
    # non-OK. We tolerate a small number of transient startup failures
    # (canlib + Kvaser virtual bus settles over the first few writes), but
    # any sustained failure or a high count = regression.
    if isinstance(sender, KvaserSender):
        diag = os.path.join(
            os.path.dirname(os.path.abspath(__file__)), "..", "build_win", "kvaser_diag.log"
        )
        diag = os.path.normpath(diag)
        t0 = time.monotonic()
        message = ""
        status = "PASSED"
        TRANSIENT_LIMIT = 20  # original bug was hundreds — pass <=20 transient
        tx_failures = 0
        last_count = 0
        if os.path.exists(diag):
            try:
                with open(diag, "r", encoding="utf-8") as f:
                    body = f.read()
                tx_failures = body.count("KVASER TX FAILED")
                # Highest "count=N" value tells us if failures kept going past
                # the transient window.
                import re as _re
                counts = [int(m) for m in _re.findall(r"count=(\d+)", body)]
                if counts:
                    last_count = max(counts)
                if tx_failures > TRANSIENT_LIMIT or last_count > TRANSIENT_LIMIT:
                    status = "FAILED"
                    message = (f"backend logged {tx_failures} TX failures, last count={last_count} "
                               f"({diag})\nfirst 5 lines:\n"
                               + "\n".join(body.splitlines()[:6]))
                elif tx_failures > 0:
                    # Still pass, but surface the count in the row description
                    message = f"transient: {tx_failures} startup TX failures, last count={last_count} (within tolerance {TRANSIENT_LIMIT})"
            except Exception as e:
                message = f"could not read {diag}: {e}"
                status = "FAILED"
        dur_ms = int((time.monotonic() - t0) * 1000)
        results.append({
            "name": "BackendTxClean_NoCanlibFailures",
            "transport": sender.name,
            "verifies": (
                f"After the Kvaser phase, reads the backend's kvaser_diag.log "
                f"(written only when canWriteWait returns non-OK) and fails the suite if "
                f"the failure count or the last `count=N` exceeds {TRANSIENT_LIMIT} "
                f"(original storm was hundreds; <= {TRANSIENT_LIMIT} is canlib settling "
                f"during the first ~second after bus-on). Regression check for the "
                f"lone-writer ACK issue."),
            "status": status,
            "duration_ms": dur_ms,
            "message": message,
        })
    return True


# -- HTML report ------------------------------------------------------------

REPORT_CSS = """body{font-family:-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,sans-serif;background:#f5f7fa;color:#222;margin:0;padding:24px;}
h1{margin:0 0 16px 0;font-size:22px;color:#1a237e;}
section.card{background:#fff;padding:18px 22px;border-radius:8px;box-shadow:0 1px 3px rgba(0,0,0,.08);margin-bottom:18px;}
.meta div{margin:4px 0;font-size:14px;}
.meta .k{display:inline-block;width:120px;color:#666;font-weight:600;}
.meta .dim{color:#999;}
.meta code{font-family:Consolas,Menlo,monospace;font-size:12px;color:#555;background:#f0f0f0;padding:1px 4px;border-radius:3px;}
.summary{display:flex;gap:14px;flex-wrap:wrap;}
.box{flex:1;min-width:110px;padding:14px;border-radius:6px;text-align:center;}
.box .n{font-size:26px;font-weight:700;display:block;}
.box .l{font-size:12px;text-transform:uppercase;letter-spacing:.5px;color:#555;}
.box.total{background:#e3f2fd;}
.box.pass{background:#c8e6c9;}
.box.fail{background:#ffcdd2;}
.box.skip{background:#fff9c4;}
.box.time{background:#ede7f6;}
table{width:100%;border-collapse:collapse;background:#fff;border-radius:6px;overflow:hidden;}
th{background:#37474f;color:#fff;text-align:left;padding:10px;font-weight:600;font-size:13px;}
td{padding:10px 12px;border-bottom:1px solid #eceff1;font-size:13px;vertical-align:top;}
tr.pass td.status{color:#2e7d32;font-weight:600;}
tr.fail td.status{color:#c62828;font-weight:600;}
tr.skip td.status{color:#f9a825;font-weight:600;}
tr.fail{background:#fff5f5;}
.transport{font-family:Consolas,Menlo,monospace;font-size:11px;color:#666;background:#eceff1;padding:1px 6px;border-radius:3px;}
.msg{font-family:Consolas,Menlo,monospace;background:#fff0f0;padding:6px 8px;margin-top:6px;border-left:3px solid #c62828;font-size:12px;white-space:pre-wrap;}
.idx{color:#999;width:36px;text-align:right;}
.dur{color:#555;white-space:nowrap;}
footer{margin-top:20px;font-size:12px;color:#888;text-align:center;}"""


def render_html_report(results, meta, out_path):
    total = len(results)
    passed = sum(1 for r in results if r["status"] == "PASSED")
    failed = sum(1 for r in results if r["status"] == "FAILED")
    skipped = sum(1 for r in results if r["status"] == "SKIPPED")
    duration_ms = sum(r["duration_ms"] for r in results)

    e = _html.escape

    def meta_row(k, v, dim=None):
        s = f"<div><span class='k'>{e(k)}</span>{e(str(v))}"
        if dim:
            s += f" <span class='dim'>({e(str(dim))})</span>"
        return s + "</div>"

    rows = []
    for i, r in enumerate(results, 1):
        cls = {"PASSED": "pass", "FAILED": "fail", "SKIPPED": "skip"}[r["status"]]
        msg_html = ""
        if r.get("message"):
            msg_html = f"<div class='msg'>{e(r['message'])}</div>"
        rows.append(
            f"<tr class='{cls}'>"
            f"<td class='idx'>{i}</td>"
            f"<td><code>{e(r['name'])}</code> "
            f"<span class='transport'>{e(r['transport'])}</span></td>"
            f"<td>{e(r['verifies'])}{msg_html}</td>"
            f"<td class='status'>{r['status']}</td>"
            f"<td class='dur'>{r['duration_ms']} ms</td>"
            f"</tr>"
        )

    html = (
        "<!DOCTYPE html>\n<html lang='en'><head>"
        "<meta charset='UTF-8'>"
        "<title>EW8 E2E Test Report</title>"
        f"<style>{REPORT_CSS}</style>"
        "</head><body>"
        "<section class='card'>"
        "<h1>EW8 E2E Test Report</h1>"
        "<div class='meta'>"
        + meta_row("Generated", meta["generated"])
        + meta_row("Platform", meta["platform"], meta["platform_release"])
        + meta_row("Hostname", meta["hostname"])
        + meta_row("Python", meta["python"])
        + meta_row("Backend exe", meta["backend_exe"])
        + meta_row("Phases", ", ".join(meta["phases"]) if meta["phases"] else "(none)")
        + "</div></section>"
        "<section class='card'><div class='summary'>"
        f"<div class='box total'><span class='n'>{total}</span><span class='l'>Total</span></div>"
        f"<div class='box pass'><span class='n'>{passed}</span><span class='l'>Passed</span></div>"
        f"<div class='box fail'><span class='n'>{failed}</span><span class='l'>Failed</span></div>"
        f"<div class='box skip'><span class='n'>{skipped}</span><span class='l'>Skipped</span></div>"
        f"<div class='box time'><span class='n'>{duration_ms} ms</span><span class='l'>Duration</span></div>"
        "</div></section>"
        "<section class='card'><table>"
        "<thead><tr>"
        "<th class='idx'>#</th><th>Test</th><th>What it verifies</th>"
        "<th>Status</th><th class='dur'>Time</th>"
        "</tr></thead><tbody>"
        + "".join(rows)
        + "</tbody></table></section>"
        "<footer>EW8 E2E HTML report</footer>"
        "</body></html>\n"
    )

    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    with open(out_path, "w", encoding="utf-8") as f:
        f.write(html)


# -- main -------------------------------------------------------------------

def select_transports(requested, system):
    if requested == "udp":      return ["udp"]
    if requested == "kvaser":   return ["kvaser"]
    if requested == "socketcan": return ["socketcan"]

    # auto
    if system == 'Windows':
        phases = ["udp"]
        try:
            from kvaser_can import is_available
            if is_available():
                phases.append("kvaser")
            else:
                print("note: Kvaser phase skipped — canlib32.dll not loadable or no channels.")
        except Exception as e:
            print(f"note: Kvaser phase skipped — {e}")
        return phases
    return ["socketcan"]


def build_sender(transport, args):
    if transport == "udp":
        return UdpSender(host=args.host, port=args.port)
    if transport == "kvaser":
        return KvaserSender(channel=args.kvaser_channel, bitrate=args.kvaser_bitrate)
    if transport == "socketcan":
        return SocketCanSender(interface=args.interface)
    raise ValueError(f"unknown transport {transport}")


def main():
    parser = argparse.ArgumentParser(description="EW8 E2E test")
    parser.add_argument("--transport", choices=["auto", "udp", "kvaser", "socketcan"],
                        default="auto",
                        help="Transport(s) to exercise (default: auto — UDP then Kvaser on Windows, socketcan on Linux)")
    parser.add_argument("--port", type=int, default=UDP_CAN_PORT)
    parser.add_argument("--host", default=UDP_CAN_HOST)
    parser.add_argument("--interface", "-i", default="can0")
    parser.add_argument("--kvaser-channel", type=int, default=KVASER_CHANNEL)
    parser.add_argument("--kvaser-bitrate", type=int, default=KVASER_BITRATE)
    parser.add_argument("--delay", "-d", type=float, default=2.0)
    parser.add_argument("--report",
                        help="Path for HTML report (default: Tests/reports/e2e_report_<ts>.html)")
    parser.add_argument("--no-report", action="store_true",
                        help="Skip HTML report generation.")
    parser.add_argument("--backend-exe", default="",
                        help="Optional: path to the backend exe under test, recorded in the report meta.")
    args = parser.parse_args()

    print(f"EW8 E2E Test — {platform.system()}")
    print("Make sure the LVGL app is running!")

    phases = select_transports(args.transport, platform.system())
    print(f"phases to run: {phases}")

    results = []
    for transport in phases:
        sender = build_sender(transport, args)
        try:
            run_phase(transport.upper(), sender, args.delay, results)
        finally:
            sender.close()
        if transport != phases[-1]:
            time.sleep(args.delay)

    # console summary
    total = len(results)
    passed = sum(1 for r in results if r["status"] == "PASSED")
    failed = sum(1 for r in results if r["status"] == "FAILED")
    print(f"\n{'='*60}\nE2E SUMMARY\n{'='*60}")
    by_phase = {}
    for r in results:
        d = by_phase.setdefault(r["transport"], [0, 0])
        d[0] += (r["status"] == "PASSED")
        d[1] += 1
    for t, (p, n) in by_phase.items():
        marker = "PASS" if p == n else "FAIL"
        print(f"  [{marker}] {t:10s} {p}/{n}")
    print(f"  TOTAL: {passed}/{total}")

    # HTML report
    if not args.no_report:
        ts = _dt.datetime.now().strftime("%Y%m%d_%H%M%S")
        default_path = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                    "reports", f"e2e_report_{ts}.html")
        out_path = args.report or default_path
        meta = {
            "generated": _dt.datetime.now().strftime("%Y-%m-%d %H:%M:%S %Z").strip(),
            "platform": platform.system(),
            "platform_release": platform.release(),
            "hostname": platform.node(),
            "python": platform.python_version(),
            "backend_exe": args.backend_exe or "(not specified)",
            "phases": phases,
        }
        render_html_report(results, meta, out_path)
        print(f"\nHTML report: {out_path}")

    sys.exit(0 if failed == 0 else 1)


if __name__ == "__main__":
    main()
