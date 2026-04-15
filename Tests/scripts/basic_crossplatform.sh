#!/bin/bash
# Cross-platform basic CAN test — works on both Linux and Windows.
# Uses cansend_wrapper.sh which auto-detects the platform.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CANSEND="$SCRIPT_DIR/../cansend_wrapper.sh"
CAN="${1:-can0}"

echo "Running basic CAN test on $CAN..."

for i in {1..10}; do
  "$CANSEND" "$CAN" 700#0000190100800001
  "$CANSEND" "$CAN" 701#00000000
  "$CANSEND" "$CAN" 7BC#5A0032120000
  "$CANSEND" "$CAN" 7BD#281606
  "$CANSEND" "$CAN" 412#0000000000001100
  "$CANSEND" "$CAN" 760#00FF000000023B67
  sleep 0.01
done

echo "Basic test complete."
