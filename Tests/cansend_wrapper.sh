#!/bin/bash
# Cross-platform cansend wrapper.
# On Linux: calls the native cansend (can-utils).
# On Windows: calls cansend.py via Python (UDP virtual CAN).
#
# Usage: same as cansend
#   ./cansend_wrapper.sh <interface> <can_id>#<data>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if command -v cansend &>/dev/null; then
    # Native cansend available (Linux with can-utils)
    exec cansend "$@"
else
    # Fallback to Python UDP sender (Windows or Linux without can-utils)
    exec python "$SCRIPT_DIR/cansend.py" "$@"
fi
