#!/bin/bash
# Launch the EW8 LVGL UI on your own display and drive a looping CAN demo so you
# can watch it live (normal driving -> signs -> SmartADAS -> FCW -> PLCA).
#
# Run this in YOUR OWN terminal (not via the agent sandbox):
#   bash Tests/run_ui_demo.sh
# Ctrl-C to stop. A small 320x240 window appears on your desktop.
set -u
BUILD="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/frontend/lvgl/build"
CAN=can0
: "${DISPLAY:=:0}"
export DISPLAY

# Bring up the virtual CAN bus if needed (needs sudo once).
if ! ip link show $CAN >/dev/null 2>&1; then
  echo "Bringing up vcan $CAN (sudo)..."
  sudo modprobe vcan
  sudo ip link add dev $CAN type vcan
  sudo ip link set up $CAN
fi

cleanup() { kill "${APP:-0}" "${DEMO:-0}" 2>/dev/null; pkill -f "cansend $CAN" 2>/dev/null; }
trap cleanup EXIT INT TERM

echo "Launching EW8 UI on DISPLAY=$DISPLAY ..."
( cd "$BUILD" && SDL_VIDEODRIVER=x11 SDL_RENDER_DRIVER=software ./ew8_lvgl -f ) &
APP=$!
sleep 4

echo "Driving demo CAN traffic (Ctrl-C to stop)..."
ka() { cansend $CAN 412#0000000000001100; }
phase() { local secs="$1"; shift; local end=$((SECONDS+secs));
  while [ $SECONDS -lt $end ]; do ka; for fr in "$@"; do cansend $CAN "$fr"; done; sleep 0.2; done; }
(
  while true; do
    phase 3 760#0080500000000000 700#0000010100000000                                  # normal: speed + green lanes
    phase 4 760#0080500000000000 700#0000190101800001 7BC#5A0032120000 727#0900000000000000  # SLI sign + HMW + ISA
    phase 4 760#0080500000000000 593#0904000000000000 700#0000010101000000              # SmartADAS tstm+road
    phase 3 700#0000010108000000                                                        # FCW
    phase 4 760#0080500000000000 300#0600000000000000 700#0000010101000000              # PLCA left-warn + right-info (NEW)
    phase 3 760#0080500000000000 300#0C00000000000000 700#0000010101000000              # PLCA both-warn (NEW)
    cansend $CAN 300#0000000000000000
  done
) &
DEMO=$!

wait $APP
