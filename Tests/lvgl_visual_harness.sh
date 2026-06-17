#!/bin/bash
# Headless visual test harness for the EW8 LVGL frontend (Linux).
#
# Boots the app under Xvfb with software rendering, keeps a background CAN
# keepalive (0x412) running so the disconnect overlay clears, then runs a
# user-supplied scenario script that injects CAN frames with `cansend can0`.
# Screenshots are captured to $OUTDIR.
#
# Usage:
#   lvgl_visual_harness.sh <scenario.sh> <outdir>
# The scenario script receives the output dir as $1 and a `shoot <name>`
# function (exported) that grabs the current screen.

set -u
SCENARIO="${1:?scenario script}"
OUTDIR="${2:?output dir}"
BUILD=/home/ilan/work/mobileye/ew8/frontend/lvgl/build
DISP=:99

mkdir -p "$OUTDIR"
rm -f "$OUTDIR"/*.png 2>/dev/null

# Defensive: clear any leftovers from a previously interrupted run. Orphaned
# `while true; cansend` loops from a killed scenario keep injecting frames and
# silently corrupt the next run's state, so nuke them before starting.
pkill -9 -f "cansend can0" 2>/dev/null
pkill -9 -f "ew8_lvgl" 2>/dev/null
# Also kill leftover scenario parents — a killed scenario keeps respawning its
# own cansend loops on each phase, so the loop-kill above is not enough.
# Match "bash /tmp/scenario_..." only, so this never matches THIS harness
# process (whose argv is "bash .../lvgl_visual_harness.sh /tmp/scenario_...").
pkill -9 -f "bash /tmp/scenario_" 2>/dev/null

# Fresh display
pkill -f "Xvfb $DISP" 2>/dev/null
pkill -f "twm -f" 2>/dev/null
sleep 0.3
rm -f /tmp/.X${DISP#:}-lock 2>/dev/null
Xvfb $DISP -screen 0 320x240x24 >/tmp/xvfb.log 2>&1 &
XVFB_PID=$!
sleep 1
export DISPLAY=$DISP

# Minimal window manager so the SDL window owns keyboard focus. On a bare Xvfb
# (no focus owner) xdotool key delivery to SDL is unreliable.
twm -f /dev/null >/tmp/twm.log 2>&1 &
TWM_PID=$!
sleep 0.5

# App (force DBC parsing so keepalive id resolves without a config.dat cache)
( cd "$BUILD" && SDL_RENDER_DRIVER=software SDL_VIDEODRIVER=x11 ./ew8_lvgl -f >/tmp/ew8.log 2>&1 ) &
APP_WRAP=$!
sleep 4

# Continuous keepalive so ALERT_NOCOM (disconnect logo) stays cleared.
# Only 0x412 (IMS_Status_Protocol_System) resets the disconnect timer; we must
# NOT touch 0x700 here or it would clobber the alert/HMW state the scenario sets.
( while true; do
    cansend can0 412#0000000000001100
    sleep 0.2
  done ) &
KA_PID=$!
sleep 1

shoot() { import -window root "$OUTDIR/$1.png" 2>/dev/null && echo "  shot: $1"; }
export -f shoot
export OUTDIR

echo "=== running scenario: $SCENARIO ==="
bash "$SCENARIO" "$OUTDIR"

# Cleanup. pkill the cansend loops by pattern — the scenario's own
# `while true; cansend` subshells outlive a plain `kill` of the scenario PID.
kill $KA_PID 2>/dev/null
pkill -9 -f "cansend can0" 2>/dev/null
# Also kill the scenario's own while-loop subshells (their argv is the scenario
# path, not "cansend can0", so the line above misses them).
pkill -9 -f "bash $SCENARIO" 2>/dev/null
pkill -9 -f "ew8_lvgl" 2>/dev/null
kill $TWM_PID 2>/dev/null
pkill -f "twm -f" 2>/dev/null
kill $XVFB_PID 2>/dev/null
echo "=== app log tail ==="
tail -5 /tmp/ew8.log
echo "=== done; screenshots in $OUTDIR ==="
ls -la "$OUTDIR"/*.png 2>/dev/null
