#!/bin/bash
# Test script for LVGL POC
# Sends CAN messages with visible Speed and FCW values

CAN_IF=${1:-can0}

echo "Testing LVGL POC on $CAN_IF"
echo "Press Ctrl+C to stop"

# Speed is at byte 2 of CAN ID 0x760
# FCW is at byte 4, bit 3 of CAN ID 0x700

# Test sequence: increase speed, trigger FCW, then clear
for speed in 0 20 40 60 80 100 120; do
    # Convert speed to hex (byte 2)
    speed_hex=$(printf "%02X" $speed)

    echo "Setting speed to $speed km/h"
    cansend $CAN_IF 760#0000${speed_hex}0000000000
    sleep 0.5
done

echo "Activating FCW alert..."
# FCW_on is bit 35 = byte 4, bit 3 = 0x08
cansend $CAN_IF 700#0000000008000000
sleep 2

echo "Deactivating FCW alert..."
cansend $CAN_IF 700#0000000000000000
sleep 1

echo "Speed cycling with FCW..."
for i in {1..5}; do
    # Speed 80, FCW ON
    cansend $CAN_IF 760#0000500000000000
    cansend $CAN_IF 700#0000000008000000
    sleep 0.5

    # Speed 60, FCW OFF
    cansend $CAN_IF 760#00003C0000000000
    cansend $CAN_IF 700#0000000000000000
    sleep 0.5
done

echo "Test complete!"
