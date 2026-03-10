#!/usr/bin/env bash
set -euo pipefail

# Auto-generated replay script from HMW-Repeatable.txt
# Source log contains: Channel, Identifier, DLC, data bytes, timestamp (s).
# Usage: ./script.sh [can_if] [speedup]
#   can_if  : interface name (default: can0)
#   speedup : timing speed-up factor, e.g. 2.0 means twice as fast (default: 1.0)
# Env:
#   NO_TIMING=1  -> send frames without sleeps

CAN_IF="${1:-can0}"
SPEEDUP="${2:-1.0}"
NO_TIMING="${NO_TIMING:-0}"

echo "Replaying: HMW-Repeatable.txt on ${CAN_IF} (speedup=${SPEEDUP}, no_timing=${NO_TIMING})"

sleep_scaled() {
  local dt="$1"
  if [[ "$NO_TIMING" == "1" ]]; then return 0; fi
  # Avoid tiny sleeps that add overhead.
  # IMPORTANT: this helper must *always* return 0, otherwise `set -e` will
  # terminate the script when there is "no sleep" to perform.
  local v
  v="$(awk -v dt="$dt" -v s="$SPEEDUP" 'BEGIN{ if (s<=0) s=1; v=dt/s; if (v<0.00005) exit 0; printf "%.6f", v }')" || true
  if [[ -n "${v:-}" ]]; then
    sleep "$v" || true
  fi
  return 0
}

sleep_scaled 0.000000
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFFD00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#7C6B09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027050
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3FFFD00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#996B09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.006820
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019290
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFE0002FFFC
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D3000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#B76B09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022620
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#D16B09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.002650
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.001280
cansend "$CAN_IF" 7E0#2579090083E50080
sleep_scaled 0.019880
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#EC6B09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.025090
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000940
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#086C09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026450
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#880003FFF6FFF1
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#266C09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.016890
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.006060
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2FFFD00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#406C09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023890
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1FFFD00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#5B6C09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.013740
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.012380
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D5FFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#776C09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026970
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88000800050003
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0FFF800
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#956C09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000940
cansend "$CAN_IF" 7E0#E779090083E50080
sleep_scaled 0.003920
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017240
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFF800
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#B06C09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024320
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D3FFF800
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#CB6C09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.002220
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.023720
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0FFF800
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#E66C09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023550
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002730
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFE00020005
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#046D09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022450
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#1E6D09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.018350
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.005370
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000180
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D3000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#3A6D09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026450
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#556D09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.008700
cansend "$CAN_IF" 7E0#AF7A090083E50080
sleep_scaled 0.004180
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.014680
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88000500000003
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0FFFB00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#746D09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022360
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3FFFB00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#8E6D09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.006490
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.016720
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2FFFB00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#A96D09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026200
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFFB00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#C46D09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.001700
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.025600
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#8800080002FFF9
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2FFF800
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#E36D09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.020560
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.001450
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFF800
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#FE6D09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023550
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFF800
sleep_scaled 0.000180
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#186E09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.016300
cansend "$CAN_IF" 7E0#787B090083E50080
sleep_scaled 0.003410
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.007430
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2FFF800
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#346E09006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027560
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88000100000002
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#536E09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.008370
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.012030
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#6C6E09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024740
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#886E09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.007940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.018680
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#A36E09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026790
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFAFFFD0006
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000600
sleep_scaled 0.000170
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#C16E09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022270
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#DC6E09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.019800
cansend "$CAN_IF" 7E0#407C090083E50080
sleep_scaled 0.003670
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#F76E09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026880
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#126F09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.016560
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.009890
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88000A0002FFFF
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2FFF600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#316F09006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022530
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3FFF600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#4B6F09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.011950
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.011520
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFF600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#666F09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027050
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0FFF600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#826F09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005210
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.021070
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFF8FFFB0001
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D3000800
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#A06F09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022010
cansend "$CAN_IF" 7E0#077D090083E50080
sleep_scaled 0.000260
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0000800
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#BA6F09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.001110
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.022700
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D4000800
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#D56F09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023640
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002900
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2000800
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F26F09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026290
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88000200000001
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFFE00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#0F7009006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.015270
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.007430
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0FFFE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#2A7009006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024070
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFFE00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#447009006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.012290
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.013320
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFFE00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#617009006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026620
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#880002FFFBFFFF
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFFE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#7E7009006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.004090
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000520
cansend "$CAN_IF" 7E0#D47D090083E50080
sleep_scaled 0.017830
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2FFFE00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#997009006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024490
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2FFFE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#B47009006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000940
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.024570
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1FFFE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#CF7009006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022690
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.004190
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88000200000001
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2FFFE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#EE7009006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022780
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D6FFFE00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#087109006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.016470
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.006740
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFFE00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#237109006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026800
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2FFFE00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#3F7109006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.007340
cansend "$CAN_IF" 7E0#987E090083E50080
sleep_scaled 0.003670
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.015700
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#8800020000FFFC
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2FFFE00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#5D7109006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023640
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2FFFE00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#787109006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.004190
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.018100
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFFE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#927109006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027140
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0FFFE00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#AE7109006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026110
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#880000FFFB0003
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D4000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#CC7109006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.019290
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002900
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E77109006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023550
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000180
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#017209006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.014080
cansend "$CAN_IF" 7E0#5F7F090083E50080
sleep_scaled 0.004100
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.009390
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D4000000
sleep_scaled 0.000180
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#1E7209006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026460
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88FFFB00020000
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000500
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#3C7209006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.007680
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013820
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D4000500
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#567209006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023890
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000500
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#717209006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.007000
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.020230
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D5000500
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#8D7209006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026200
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000420
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 703#8800010005FFF8
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#AB7209006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022870
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#C67209006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.018510
cansend "$CAN_IF" 7E0#2880090083E50080
sleep_scaled 0.003330
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.001710
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E07209006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027740
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#FD7209006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.014250
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.011090
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#880001FFFA0007
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D4FFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#1A7309006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022530
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#357309006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.010830
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013060
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D6FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000180
cansend "$CAN_IF" 412#4F7309006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027570
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#6C7309006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.003070
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001030
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.022360
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88FFF90000FFFB
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000700
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#8A7309006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021160
cansend "$CAN_IF" 7E0#F080090083E50080
sleep_scaled 0.001190
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D3000700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#A47309006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023640
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2000700
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#BF7309006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022010
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.004530
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1000700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#DB7309006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026280
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFBFFF30000
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D4000500
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000180
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F97309006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.013570
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.009470
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1000500
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#137409006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023640
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000500
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#2E7409006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.010590
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.015700
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000500
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#4A7409006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026020
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#8800000002000A
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000180
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#687409006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.002480
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.001540
cansend "$CAN_IF" 7E0#BD81090083E50080
sleep_scaled 0.018260
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D5000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#827409006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024660
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000180
cansend "$CAN_IF" 412#9D7409006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026450
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000180
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#B97409006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.020480
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.005720
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#880002FFF9FFFB
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFFE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#D77409006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022530
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2FFFE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#F17409006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.015190
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.008270
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3FFFE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#0D7509006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026880
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFFE00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#287509006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005810
cansend "$CAN_IF" 7E0#7F82090083E50080
sleep_scaled 0.003750
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019200
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#880005FFFE0002
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D4FFFB00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#477509006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021340
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFFB00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000180
cansend "$CAN_IF" 412#627509006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.002990
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019370
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFFB00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#7C7509006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027480
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFFB00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#987509006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026110
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#880018FFF9000F
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1FFE800
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000180
cansend "$CAN_IF" 412#B67509006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.017580
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001030
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.004090
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2FFE800
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#D07509006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023810
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2FFE800
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#EB7509006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.012630
cansend "$CAN_IF" 7E0#4783090083E50080
sleep_scaled 0.004090
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.010240
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2FFE800
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#077609006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026960
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88000B00030011
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFF500
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#257609006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.006230
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.015190
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D4FFF500
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#3F7609006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024060
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D3FFF500
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#5A7609006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005380
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.021670
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFF500
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#767609006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024740
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.001620
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFECFFFEFFFF
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2001400
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#947609006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022700
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3001400
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#AF7609006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.016900
cansend "$CAN_IF" 7E0#1084090083E50080
sleep_scaled 0.003330
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.003240
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3001400
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#C97609006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027300
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1001400
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#E67609006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.013220
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.012800
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88001D00030014
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2FFE300
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#047709006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022280
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFE300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#1E7709006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.009390
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.014510
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0FFE300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#397709006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027140
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D4FFE300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#557709006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.002140
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.024240
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFF60001FFEB
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2000A00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#737709006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.019110
cansend "$CAN_IF" 7E0#D884090083E50080
sleep_scaled 0.003500
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1000A00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#8E7709006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023130
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2000A00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#A87709006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.020570
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.005550
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0000A00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#C47709006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.028160
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#880005FFFE0002
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3FFFB00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E37709006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.010670
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.009900
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFFB00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#FC7709006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024920
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2FFFB00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#187809006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.008960
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.017070
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFFB00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#347809006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026030
cansend "$CAN_IF" 7E0#9F85090083E50080
sleep_scaled 0.000260
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#880000FFF9FFFF
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#517809006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000850
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.021930
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#6C7809006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024070
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#877809006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026290
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#A37809006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.019120
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.007680
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#880005FFF9FFFD
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0FFFB00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#C17809006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022270
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFFB00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#DB7809006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.013570
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.010070
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFFB00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#F67809006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027050
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2FFFB00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#127909006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.004350
cansend "$CAN_IF" 7E0#6886090083E50080
sleep_scaled 0.003250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.018680
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88FFFE0000FFFF
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#307909006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023630
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2000200
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#4B7909006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.001190
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.020910
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D4000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#657909006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026460
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000770
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1000200
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#817909006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027140
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#880003FFF9FFFD
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3FFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#A07909006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.015610
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.005460
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2FFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#BA7909006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024150
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3FFFD00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#D47909006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.011950
cansend "$CAN_IF" 7E0#3087090083E50080
sleep_scaled 0.003160
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.011520
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFFD00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F07909006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027220
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88FFFB0005FFF7
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2000500
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#0F7A09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.004770
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017070
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000500
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#297A09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023800
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3000500
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#447A09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.003840
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.022870
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000500
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#607A09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023560
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002730
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88FFFEFFFE0006
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#7E7A09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023120
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000180
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#997A09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.015100
cansend "$CAN_IF" 7E0#F887090083E50080
sleep_scaled 0.003500
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.004780
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3000200
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#B37A09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027310
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#CF7A09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.011520
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.014260
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88FFFE00050003
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000200
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#EE7A09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022520
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D3000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#087B09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.007680
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.016040
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#227B09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027650
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#3F7B09006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000510
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.025340
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000180
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#890009FFFEFFF7
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3FFF700
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#5D7B09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.018090
cansend "$CAN_IF" 7E0#BF88090083E50080
sleep_scaled 0.003670
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000930
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFF700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#777B09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024320
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2FFF700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#927B09006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.018520
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.007600
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D3FFF700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#AE7B09006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026020
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#890001FFFEFFFB
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3FFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#CC7B09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.010760
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.011690
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D3FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#E67B09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024320
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2FFFF00
sleep_scaled 0.000180
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#017C09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.007680
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.018770
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3FFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#1E7C09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024240
cansend "$CAN_IF" 7E0#8789090083E50080
sleep_scaled 0.001870
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#8900050009FFFF
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3FFFB00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#3B7C09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022190
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0FFFB00
sleep_scaled 0.000180
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#557C09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023210
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3FFFB00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#707C09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026800
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFFB00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#8C7C09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.017670
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.009210
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89FFF9FFFBFFFF
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3000700
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#AA7C09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022530
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#C47C09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.011770
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.011690
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3000700
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E07C09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026370
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2000700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#FB7C09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.003420
cansend "$CAN_IF" 7E0#508A090083E50080
sleep_scaled 0.003240
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.020560
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#8900050000FFFF
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFFB00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#1A7D09006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022870
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D3FFFB00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#347D09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000680
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.022450
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0FFFB00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#4F7D09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024920
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002050
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2FFFB00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#6B7D09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026540
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#89FFFB0002000B
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2000500
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#897D09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.014760
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.007590
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000500
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#A47D09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023380
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2000500
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#BE7D09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.010240
cansend "$CAN_IF" 7E0#188B090083E50080
sleep_scaled 0.003490
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013150
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2000500
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#DA7D09006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027390
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#8900030005FFF7
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CEFFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#F87D09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.002900
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.018940
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D5FFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#137E09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023380
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFD00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#2D7E09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.002380
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.024410
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3FFFD00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#497E09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022010
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.004350
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#8900030002FFFA
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFFD00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#687E09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022450
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFFD00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#827E09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.013740
cansend "$CAN_IF" 7E0#DF8B090083E50080
sleep_scaled 0.003930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.006310
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D6FFFD00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#9D7E09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027990
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFD00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#B97E09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.009380
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.015790
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89000000000004
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#D77E09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022700
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D3000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#F27E09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005980
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017570
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#0C7F09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027220
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#287F09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026030
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#8900050002FFFF
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFB00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#467F09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.017230
cansend "$CAN_IF" 7E0#A88C090083E50080
sleep_scaled 0.003250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002300
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D4FFFB00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#607F09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023890
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFFB00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#7B7F09006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.017490
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.009050
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFFB00
sleep_scaled 0.000180
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#987F09006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026290
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#890005FFFE0001
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2FFFB00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#B57F09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.009130
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013570
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFFB00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000180
cansend "$CAN_IF" 412#D07F09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024150
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2FFFB00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#EB7F09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005970
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.019540
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1FFFB00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#068009006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023980
cansend "$CAN_IF" 7E0#708D090083E50080
sleep_scaled 0.002640
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#890001FFFE0006
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3FFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#248009006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022190
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#3E8009006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022020
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.001790
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2FFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#5A8009006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027130
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2FFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000180
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#768009006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.015780
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.010410
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#8900050001FFFF
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2FFFB00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#948009006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023210
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D3FFFB00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#AF8009006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.009810
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013050
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0FFFB00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#C98009006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026370
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFFB00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E58009006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.001450
cansend "$CAN_IF" 7E0#378E090083E50080
sleep_scaled 0.003840
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.021680
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89000000050006
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#038109006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023300
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D3000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000170
cansend "$CAN_IF" 412#1E8109006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022870
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000180
cansend "$CAN_IF" 760#40FE5300D0000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#388109006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023290
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.003590
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D3000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#548109006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027220
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89FFFEFFFEFFFA
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D5000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#728109006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.012630
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.008790
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#8D8109006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023730
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D4000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#A78109006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.008020
cansend "$CAN_IF" 7E0#FF8E090083E50080
sleep_scaled 0.004190
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.015100
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#C48109006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027820
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#890000FFFB0000
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#E28109006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000600
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019970
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#FC8109006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023900
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#178209006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000860
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.026190
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D4000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#338209006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.020140
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.006230
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89FFFE0002FFF8
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D4000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#518209006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022530
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000200
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#6C8209006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.012110
cansend "$CAN_IF" 7E0#C88F090083E50080
sleep_scaled 0.003500
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.007770
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#868209006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027130
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D3000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#A28209006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.008710
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017230
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000180
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#89000300070007
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D4FFFD00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#C08209006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023120
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFFD00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#DB8209006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.004090
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019120
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F58209006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027050
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2FFFD00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#118309006A590100
sleep_scaled 0.000340
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026200
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#89FFF6FFFEFFF8
sleep_scaled 0.000180
cansend "$CAN_IF" 760#40FE5300D1000A00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#2F8309006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.015100
cansend "$CAN_IF" 7E0#8F90090083E50080
sleep_scaled 0.003840
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.004100
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000A00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#4A8309006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023640
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D5000A00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#658309006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.015960
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.010240
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000A00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#818309006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026540
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89FFFE00020002
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D5000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#9F8309006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.007680
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.014850
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000200
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#B98309006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024660
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#D48309006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.004270
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.021000
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D5000200
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#F08309006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021930
cansend "$CAN_IF" 7E0#5791090083E50080
sleep_scaled 0.004090
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000690
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89FFFE0002FFFB
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#0E8409006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023300
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#298409006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.019540
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.003240
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#438409006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026630
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#5F8409006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.014760
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.012210
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#89FFFAFFF6FFFC
sleep_scaled 0.000180
cansend "$CAN_IF" 760#40FE5300D4000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#7D8409006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022610
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#988409006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.008620
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.014510
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2000600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#B38409006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026460
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#CE8409006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000340
cansend "$CAN_IF" 7E0#2092090083E50080
sleep_scaled 0.003330
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.023380
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#89000100050007
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#ED8409006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022700
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000340
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#088509006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023220
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#228509006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021760
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.005550
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2FFFF00
sleep_scaled 0.000180
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#3E8509006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026970
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000180
cansend "$CAN_IF" 703#8900000002FFFE
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#5C8509006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.011010
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.010750
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#778509006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023470
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#918509006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.006830
cansend "$CAN_IF" 7E0#E792090083E50080
sleep_scaled 0.003580
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.016900
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D5000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#AD8509006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027990
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89000A0000FFFB
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2FFF600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000260
cansend "$CAN_IF" 412#CC8509006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.020820
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFF600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#E58509006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023800
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2FFF600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#008609006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027470
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3FFF600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#1D8609006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.017920
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.008270
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#89000000070000
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#3B8609006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021840
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#558609006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.010410
cansend "$CAN_IF" 7E0#AF93090083E50080
sleep_scaled 0.003920
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.009470
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#708609006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027990
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#8C8609006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.006320
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.018770
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89000700070005
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D4FFF900
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#AA8609006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021850
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFF900
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#C48609006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.003840
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.020570
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D5FFF900
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#DF8609006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.025860
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000680
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFF900
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000180
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#FB8609006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026450
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89FFFE0007000A
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#198709006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.014000
cansend "$CAN_IF" 7E0#7894090083E50080
sleep_scaled 0.003320
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.006060
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2000200
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#348709006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023720
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000200
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#4F8709006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.013910
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.012460
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2000200
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#6B8709006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000180
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026280
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89FFFE000A0005
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2000200
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#888709006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005720
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.016210
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#A28709006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024920
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#BE8709006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.002560
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.022870
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#DA8709006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.020820
cansend "$CAN_IF" 7E0#4095090083E50080
sleep_scaled 0.003410
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002220
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89000000020008
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#F78709006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023470
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#128809006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.017750
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.004860
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#2D8809006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026880
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#498809006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.012970
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013650
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#8900000002FFF9
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D4000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#678809006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022950
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#828809006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.006910
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.016120
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#9C8809006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026540
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#B88809006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.002050
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002130
cansend "$CAN_IF" 7E0#0D96090083E50080
sleep_scaled 0.024410
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#8900010000FFFD
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#D68809006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.019630
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000760
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F18809006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023640
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#0B8909006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.020310
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.006910
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#288909006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027310
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#890015FFFDFFFD
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2FFEB00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#458909006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.009220
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.012110
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFEB00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#608909006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023640
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D4FFEB00
sleep_scaled 0.000180
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#7A8909006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005810
cansend "$CAN_IF" 7E0#D096090083E50080
sleep_scaled 0.003150
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017840
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFEB00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#968909006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027730
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89000D00010009
sleep_scaled 0.000250
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2FFF300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#B58909006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022020
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFF300
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#D08909006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023210
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D4FFF300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#EA8909006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027130
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000180
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFF300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#068A09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.016720
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.009650
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89FFE900000004
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1001700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#248A09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021420
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D6001700
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#3E8A09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.009820
cansend "$CAN_IF" 7E0#9897090083E50080
sleep_scaled 0.003410
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.010920
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0001700
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#598A09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027140
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000180
cansend "$CAN_IF" 760#40FE5300D2001700
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#758A09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005550
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.020480
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#89000D00040004
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFF300
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#938A09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023210
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D3FFF300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#AE8A09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000680
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.022020
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2FFF300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#C88A09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024320
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.001800
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CEFFF300
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E48A09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027390
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89FFFBFFF5FFFD
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3000500
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#038B09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.011430
cansend "$CAN_IF" 7E0#5F98090083E50080
sleep_scaled 0.003840
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.007170
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000500
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#1D8B09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023470
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2000500
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#378B09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.013060
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013480
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000180
cansend "$CAN_IF" 760#40FE5300D2000500
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#548B09006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026710
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89000000000007
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#728B09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.004180
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.018350
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D4000000
sleep_scaled 0.000180
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#8C8B09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024070
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#A78B09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.001370
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.023810
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#C38B09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.020050
cansend "$CAN_IF" 7E0#2899090083E50080
sleep_scaled 0.003240
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.003670
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89FFFB00000001
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1000500
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#E18B09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022530
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2000500
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#FB8B09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.017320
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.006310
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000500
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000180
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#168C09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027300
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2000500
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#328C09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.011010
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.015110
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#89FFFE00010004
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2000200
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#508C09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023040
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D3000200
sleep_scaled 0.000180
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#6B8C09006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005290
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017670
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#868C09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026280
cansend "$CAN_IF" 7E0#F099090083E50080
sleep_scaled 0.000940
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#A28C09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026200
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#8900000004FFF8
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1000000
sleep_scaled 0.000180
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#C08C09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.019540
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002390
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#DA8C09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023630
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#F58C09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.018690
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.008020
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#118D09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027480
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#890001FFFD0000
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#2F8D09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.008020
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013570
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2FFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#498D09006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023640
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000180
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#648D09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.003670
cansend "$CAN_IF" 7E0#B79A090083E50080
sleep_scaled 0.003760
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019280
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#808D09006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027060
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000250
cansend "$CAN_IF" 700#03000301B1810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#89FFFAFFFD0002
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000180
cansend "$CAN_IF" 412#9E8D09006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C

echo "Done."