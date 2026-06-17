#!/bin/bash
# Visual-regression harness for the EW8 LVGL notice/overlay screens.
#
# Same boot sequence as lvgl_visual_harness.sh (Xvfb :99 + twm + app under
# software SDL) BUT does NOT run a built-in 0x412 keepalive loop. The scenario
# owns ALL CAN traffic so it can:
#   - capture the boot-time disconnect overlay (no keepalive yet),
#   - drive op-mode overlays by holding a specific RunningMode in the keepalive,
#   - clear/restore state between shots.
#
# Usage: notice_regression_harness.sh <scenario.sh> <outdir>
# Scenario receives $1=outdir and an exported `shoot <name>` function.

set -u
SCENARIO="${1:?scenario script}"
OUTDIR="${2:?output dir}"
BUILD=/home/ilan/work/mobileye/ew8/frontend/lvgl/build
DISP=:99

mkdir -p "$OUTDIR"
rm -f "$OUTDIR"/*.png 2>/dev/null

# Clear leftovers from any interrupted run.
pkill -9 -f "cansend can0" 2>/dev/null
pkill -9 -f "ew8_lvgl" 2>/dev/null
pkill -9 -f "bash /tmp/notice_scenario" 2>/dev/null
pkill -f "Xvfb $DISP" 2>/dev/null
pkill -f "twm -f" 2>/dev/null
sleep 0.3
rm -f /tmp/.X${DISP#:}-lock 2>/dev/null

Xvfb $DISP -screen 0 320x240x24 >/tmp/xvfb.log 2>&1 &
XVFB_PID=$!
sleep 1
export DISPLAY=$DISP

twm -f /dev/null >/tmp/twm.log 2>&1 &
TWM_PID=$!
sleep 0.5

# App (force DBC parsing so message ids resolve without a config.dat cache).
( cd "$BUILD" && SDL_RENDER_DRIVER=software SDL_VIDEODRIVER=x11 ./ew8_lvgl -f >/tmp/ew8.log 2>&1 ) &
sleep 4

shoot() { import -window root "$OUTDIR/$1.png" 2>/dev/null && echo "  shot: $1"; }
export -f shoot
export OUTDIR

echo "=== running scenario: $SCENARIO ==="
bash "$SCENARIO" "$OUTDIR"

# Cleanup — nuke every CAN sender (scenario's keepalive loop included).
pkill -9 -f "cansend can0" 2>/dev/null
pkill -9 -f "bash $SCENARIO" 2>/dev/null
pkill -9 -f "ew8_lvgl" 2>/dev/null
kill $TWM_PID 2>/dev/null; pkill -f "twm -f" 2>/dev/null
kill $XVFB_PID 2>/dev/null
echo "=== app log tail ==="
tail -5 /tmp/ew8.log
echo "=== done; screenshots in $OUTDIR ==="
ls -la "$OUTDIR"/*.png 2>/dev/null
