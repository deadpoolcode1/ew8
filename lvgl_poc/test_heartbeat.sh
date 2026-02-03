#!/bin/bash
# Test script for heartbeat/disconnection feature
# Tests the keep-alive mechanism and disconnected screen

CAN_IF=${1:-can0}

echo "Testing Heartbeat/Disconnection on $CAN_IF"
echo "Press Ctrl+C to stop"
echo ""

# Keep-alive message ID is 0x7e0
# Timeout is 500ms, so we need to send heartbeats faster than that

echo "=== Phase 1: Sending heartbeats (should hide disconnected screen) ==="
for i in {1..10}; do
    echo "Heartbeat $i"
    cansend $CAN_IF 7e0#0000000000000000
    sleep 0.2  # 200ms interval (faster than 500ms timeout)
done

echo ""
echo "=== Phase 2: Stopping heartbeats (disconnected screen should appear after 500ms) ==="
echo "Waiting 2 seconds..."
sleep 2

echo ""
echo "=== Phase 3: Resuming heartbeats (should hide disconnected screen) ==="
for i in {1..10}; do
    echo "Heartbeat $i"
    cansend $CAN_IF 7e0#0000000000000000
    sleep 0.2
done

echo ""
echo "=== Phase 4: Combined test - heartbeats with speed and FCW ==="
for i in {1..15}; do
    # Send heartbeat
    cansend $CAN_IF 7e0#0000000000000000

    # Send speed (cycling 0-100)
    speed=$((i * 7 % 100))
    speed_hex=$(printf "%02X" $speed)
    cansend $CAN_IF 760#0000${speed_hex}0000000000

    # Toggle FCW every 5 iterations
    if [ $((i % 5)) -eq 0 ]; then
        cansend $CAN_IF 700#0000000008000000  # FCW ON
    else
        cansend $CAN_IF 700#0000000000000000  # FCW OFF
    fi

    sleep 0.2
done

echo ""
echo "=== Phase 5: Final disconnect test ==="
echo "Stopping all messages..."
sleep 2

echo "Test complete!"
echo "The disconnected screen should now be visible."
