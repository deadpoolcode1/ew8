#!/usr/bin/env bash
set -euo pipefail

# Auto-generated replay script from FCW.txt
# Source log contains: Channel, Identifier, DLC, data bytes, timestamp (s).
# Usage: ./script.sh [can_if] [speedup]
#   can_if  : interface name (default: can0)
#   speedup : timing speed-up factor, e.g. 2.0 means twice as fast (default: 1.0)
# Env:
#   NO_TIMING=1  -> send frames without sleeps

CAN_IF="${1:-can0}"
SPEEDUP="${2:-1.0}"
NO_TIMING="${NO_TIMING:-0}"

echo "Replaying: FCW.txt on ${CAN_IF} (speedup=${SPEEDUP}, no_timing=${NO_TIMING})"

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
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.020820
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D0FFF900
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#23C303006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.025600
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.000430
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D7FFF900
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#3FC303006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026280
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000180
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#880003FFFEFFF1
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CDFFFD00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#5DC303006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.001190
cansend "$CAN_IF" 7E0#AFD0030083E50080
sleep_scaled 0.016210
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.004700
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D0FFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#77C303006A590100
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
sleep_scaled 0.025260
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D7FFFD00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#93C303006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.013820
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.011860
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800CFFFFD00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#AFC303006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026030
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#880002FFFC0005
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CEFFFE00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#CCC303006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.006480
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.015880
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D1FFFE00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E6C303006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.025170
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D5FFFE00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#02C403006A590100
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
sleep_scaled 0.002730
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.022700
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CFFFFE00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#1EC403006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.009130
cansend "$CAN_IF" 7E0#78D1030083E50080
sleep_scaled 0.015530
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002310
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88000500030005
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800CEFFFB00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#3CC403006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021930
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D3FFFB00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#55C403006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.019200
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.005120
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D5FFFB00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#71C403006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026620
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CEFFFB00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#8DC403006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.012980
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013220
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#8800000000000D
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CF000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#ABC403006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023210
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D3000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#C6C403006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
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
sleep_scaled 0.007080
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.015960
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D3000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E0C403006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.015450
cansend "$CAN_IF" 7E0#3FD2030083E50080
sleep_scaled 0.011090
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800CD000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#FCC403006A590100
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
sleep_scaled 0.002140
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.024490
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88000200000015
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D3FFFE00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#1AC503006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021590
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D3FFFE00
sleep_scaled 0.000180
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#35C503006A590100
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
sleep_scaled 0.024150
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CEFFFE00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#4FC503006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.020220
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.006830
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CEFFFE00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#6CC503006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026120
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFF8FFFCFFFE
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D0000800
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#89C503006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.010580
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.011260
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1000800
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#A4C503006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
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
sleep_scaled 0.019790
cansend "$CAN_IF" 7E0#07D3030083E50080
sleep_scaled 0.004950
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D0000800
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#BFC503006A590100
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
sleep_scaled 0.008700
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017920
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1000800
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#DBC503006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026710
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#8800050005FFF9
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D1FFFB00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#F9C503006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021670
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D2FFFB00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#13C603006A590100
sleep_scaled 0.000260
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
sleep_scaled 0.024750
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CFFFFB00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#2EC603006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026880
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2FFFB00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#4AC603006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.016900
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.009040
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFD0005FFFB
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1000300
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#68C603006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021940
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D1000300
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#82C603006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000260
cansend "$CAN_IF" 7E0#D0D3030083E50080
sleep_scaled 0.013220
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.011010
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D4000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000180
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#9DC603006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027470
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000180
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800CE000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#BAC603006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
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
sleep_scaled 0.005290
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019710
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88000000090004
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D0000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#D7C603006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022270
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D1000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F1C603006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.002470
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.022190
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800CF000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#0DC703006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
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
sleep_scaled 0.024150
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.002040
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#29C703006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
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
sleep_scaled 0.025770
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#880000FFFEFFF1
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D0000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#46C703006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000510
cansend "$CAN_IF" 7E0#98D4030083E50080
sleep_scaled 0.015870
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.007430
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#62C703006A590100
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
sleep_scaled 0.023980
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#7CC703006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.012290
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013480
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D0000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#98C703006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026120
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#880003FFFE0008
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2FFFD00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000180
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#B6C703006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.004780
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.018680
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2FFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#D1C703006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023980
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D0FFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#ECC703006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
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
sleep_scaled 0.000940
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.024490
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D0FFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#07C803006A590100
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
sleep_scaled 0.006570
cansend "$CAN_IF" 7E0#5FD5030083E50080
sleep_scaled 0.016210
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.003840
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFDFFF6FFF9
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#25C803006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022960
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800CF000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#40C803006A590100
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
sleep_scaled 0.016730
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.006910
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D0000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#5BC803006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026630
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D4000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#77C803006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.011090
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.015360
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFD00000002
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D1000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#95C803006A590100
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
sleep_scaled 0.023130
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#B0C803006A590100
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
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005040
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017830
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CE000300
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#CAC803006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.013990
cansend "$CAN_IF" 7E0#28D6030083E50080
sleep_scaled 0.012800
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D3000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000180
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#E6C803006A590100
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
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026370
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFF8FFFEFFF3
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D2000800
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#04C903006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.019630
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002810
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D0000800
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#1FC903006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023550
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2000800
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#39C903006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.018340
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.008880
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D3000800
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#56C903006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026710
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#880007FFFEFFF9
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D0FFF900
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#74C903006A590100
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
sleep_scaled 0.007940
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013910
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800CFFFF900
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#8EC903006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.017580
cansend "$CAN_IF" 7E0#EFD6030083E50080
sleep_scaled 0.006150
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D3FFF900
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000180
cansend "$CAN_IF" 412#A9C903006A590100
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
sleep_scaled 0.007080
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019970
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2FFF900
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#C5C903006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026450
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000510
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000180
cansend "$CAN_IF" 703#88FFFD000DFFFE
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D2000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E3C903006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022440
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D0000300
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#FDC903006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
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
sleep_scaled 0.022180
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.001710
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2000300
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#18CA03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027300
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D4000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#34CA03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.014600
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.010760
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#8800000000FFFE
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CD000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#52CA03006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.020220
cansend "$CAN_IF" 7E0#B7D7030083E50080
sleep_scaled 0.003160
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D3000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#6DCA03006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.010330
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013060
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D3000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#87CA03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027220
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D0000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#A4CA03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001060000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.003500
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.021680
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89FFFFFFFEFFF6
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800CF000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#C1CA03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022960
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D0000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000180
cansend "$CAN_IF" 412#DCCA03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023800
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D5000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#F6CA03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
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
sleep_scaled 0.022190
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.003760
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800CD000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#13CB03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026280
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89FFFB0005000C
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2000500
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#30CB03006A590100
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
sleep_scaled 0.003660
cansend "$CAN_IF" 7E0#85D8030083E50080
sleep_scaled 0.010500
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.008280
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2000500
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#4ACB03006A590100
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
sleep_scaled 0.025090
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1000500
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000180
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#66CB03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.010410
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.015360
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800CF000500
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#82CB03006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026110
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89000A0001000C
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800CFFFF600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#A0CB03006A590100
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
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019710
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D6FFF600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#BACB03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024750
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D2FFF600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#D5CB03006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026630
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800CCFFF600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F2CB03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.004520
cansend "$CAN_IF" 7E0#47D9030083E50080
sleep_scaled 0.015870
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.005290
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89FFFF0005000C
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1000100
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#0FCC03006A590100
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
sleep_scaled 0.023390
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D4000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000180
cansend "$CAN_IF" 412#29CC03006A590100
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
sleep_scaled 0.014850
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.008360
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CC000100
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#45CC03006A590100
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
sleep_scaled 0.026880
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D0000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#61CC03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.009470
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.016560
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#890009FFFE0003
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D3FFF700
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#7ECC03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022950
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D0FFF700
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#99CC03006A590100
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
sleep_scaled 0.003920
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001030
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019280
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D3FFF700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#B4CC03006A590100
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
sleep_scaled 0.011770
cansend "$CAN_IF" 7E0#0FDA030083E50080
sleep_scaled 0.015110
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CDFFF700
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#D0CC03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026450
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89000900030003
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1FFF700
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#EDCC03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.017920
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.004270
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D3FFF700
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#08CD03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023720
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CFFFF700
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#23CD03006A590100
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
sleep_scaled 0.016730
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.010410
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D6FFF700
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#3FCD03006A590100
sleep_scaled 0.000180
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
sleep_scaled 0.026880
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89FFFFFFF9FFF9
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D1000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#5DCD03006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.006150
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.014940
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D1000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#77CD03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.016810
cansend "$CAN_IF" 7E0#D8DA030083E50080
sleep_scaled 0.007430
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D2000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#92CD03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005550
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.021930
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CF000100
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#AFCD03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024490
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000940
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#890001FFFC000D
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D4FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#CCCD03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022450
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800CFFFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#E7CD03006A590100
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
sleep_scaled 0.021080
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.003070
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D1FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#01CE03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027220
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2FFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#1ECE03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.013490
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.012030
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#89FFFFFFFEFFFE
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#3CCE03006A590100
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
sleep_scaled 0.019110
cansend "$CAN_IF" 7E0#9FDB030083E50080
sleep_scaled 0.003760
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#56CE03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.009560
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.014340
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D0000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#71CE03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
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
sleep_scaled 0.027300
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#8DCE03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.001970
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.023040
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#89000000060000
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D0000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#AACE03006A590100
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
sleep_scaled 0.023290
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CF000000
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#C5CE03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023470
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D4000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#E0CE03006A590100
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
sleep_scaled 0.020650
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001030
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.005120
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CE000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#FCCE03006A590100
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
sleep_scaled 0.025600
cansend "$CAN_IF" 7E0#67DC030083E50080
sleep_scaled 0.000680
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89FFFE00060006
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D0000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#1ACF03006A590100
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
sleep_scaled 0.012800
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.009820
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D2000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#34CF03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.025170
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D1000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#50CF03006A590100
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
sleep_scaled 0.008700
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001030
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.016470
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D2000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#6BCF03006A590100
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
sleep_scaled 0.026540
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89FFFC00000000
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800CF000400
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#89CF03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.001370
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.021160
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1000400
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#A3CF03006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024740
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D4000400
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#BFCF03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026110
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D1000400
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#DBCF03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.003760
cansend "$CAN_IF" 7E0#30DD030083E50080
sleep_scaled 0.015700
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.007340
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#890001FFFB000C
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D4FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#F9CF03006A590100
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
sleep_scaled 0.023210
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#14D003006A590100
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
sleep_scaled 0.012970
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.009820
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D0FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#2ED003006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026540
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D0FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#4AD003006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.008280
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.018260
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#890001FFFF0000
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800CEFFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#68D003006A590100
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
sleep_scaled 0.023040
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D3FFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#82D003006A590100
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
sleep_scaled 0.002140
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.020910
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D0FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#9DD003006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.010580
cansend "$CAN_IF" 7E0#F7DD030083E50080
sleep_scaled 0.015870
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000850
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D3FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#BAD003006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026450
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89FFFC00000003
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800CE000400
sleep_scaled 0.000180
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#D7D003006A590100
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
sleep_scaled 0.016220
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.005810
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D3000400
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F2D003006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023550
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D0000400
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#0CD103006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.015360
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.011860
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D2000400
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#29D103006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026540
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89FFF9FFFC0000
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D1000700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#47D103006A590100
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
sleep_scaled 0.004950
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.016550
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CF000700
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#61D103006A590100
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
sleep_scaled 0.014590
cansend "$CAN_IF" 7E0#BFDE030083E50080
sleep_scaled 0.009550
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D3000700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#7CD103006A590100
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
sleep_scaled 0.004010
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.022700
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D0000700
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#98D103006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023550
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001030
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002300
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89FFF1FFFC0006
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D3000F00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#B6D103006A590100
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
sleep_scaled 0.023300
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D0000F00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#D1D103006A590100
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
sleep_scaled 0.018780
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.004600
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000180
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800CE000F00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#EBD103006A590100
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
sleep_scaled 0.027050
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D1000F00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#07D203006A590100
sleep_scaled 0.000170
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
sleep_scaled 0.012030
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013650
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#890000FFFCFFF4
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D0000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#25D203006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.018000
cansend "$CAN_IF" 7E0#88DF030083E50080
sleep_scaled 0.005040
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D1000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#40D203006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.007770
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.015950
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D0000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#5AD203006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027390
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D2000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#77D203006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000340
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.024580
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000180
cansend "$CAN_IF" 703#8900030005FFFE
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D2FFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#94D203006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022530
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.001020
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D2FFFD00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#AFD203006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023550
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000180
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D0FFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#C9D203006A590100
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
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.019030
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.007170
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D1FFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#E6D203006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
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
cansend "$CAN_IF" 7E0#4FE0030083E50080
sleep_scaled 0.001790
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89000000080008
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#03D303006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.011270
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.012710
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#1FD303006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023550
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#39D303006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.007500
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.018440
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D2000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000180
cansend "$CAN_IF" 412#55D303006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
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
sleep_scaled 0.026030
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89FFFCFFF60000
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2000400
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#72D303006A590100
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
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023300
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CE000400
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#8ED303006A590100
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
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022790
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2000400
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#A8D303006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
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
sleep_scaled 0.027050
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D2000400
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#C5D303006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.001200
cansend "$CAN_IF" 7E0#17E1030083E50080
sleep_scaled 0.016210
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.008450
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#8900030003FFFE
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1FFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E2D303006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023640
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D2FFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#FDD303006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.011350
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.011270
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CFFFFD00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#17D403006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
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
sleep_scaled 0.026710
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D3FFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#33D403006A590100
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
sleep_scaled 0.006740
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019710
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89FFFFFFFEFFFD
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CF000100
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#51D403006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022950
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000180
cansend "$CAN_IF" 412#6CD403006A590100
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
sleep_scaled 0.022440
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CF000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#87D403006A590100
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
sleep_scaled 0.009380
cansend "$CAN_IF" 7E0#E0E1030083E50080
sleep_scaled 0.015540
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002300
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#A3D403006A590100
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
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027400
cansend "$CAN_IF" 700#00000001B1810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#890002FFFA0004
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CFFFFE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#C2D403006A590100
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
sleep_scaled 0.013820
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.008280
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CEFFFE00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#DCD403006A590100
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
sleep_scaled 0.022700
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D3FFFE00
sleep_scaled 0.000180
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F6D403006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.013660
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013220
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800CFFFFE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#12D503006A590100
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
sleep_scaled 0.026710
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89FFFF0003FFFE
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D1000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000180
cansend "$CAN_IF" 412#30D503006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.003500
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.018600
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000180
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D2000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#4BD503006A590100
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
sleep_scaled 0.012720
cansend "$CAN_IF" 7E0#A7E2030083E50080
sleep_scaled 0.010840
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800CE000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#65D503006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.002390
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.024740
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#81D503006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021670
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.004010
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89FFF90000FFF4
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D0000700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#9FD503006A590100
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
sleep_scaled 0.023300
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D0000700
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#BAD503006A590100
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
sleep_scaled 0.017150
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.006140
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D1000700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#D4D503006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027220
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1000700
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F1D503006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.010410
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.015280
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#890000FFFCFFFE
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#0FD603006A590100
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
sleep_scaled 0.016470
cansend "$CAN_IF" 7E0#70E3030083E50080
sleep_scaled 0.006400
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D0000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#29D603006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.006320
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017410
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D2000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#44D603006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.027480
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CF000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#60D603006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.025680
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89FFFCFFFF0000
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D0000400
sleep_scaled 0.000180
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#7ED603006A590100
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
sleep_scaled 0.020740
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002130
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D2000400
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#98D603006A590100
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
sleep_scaled 0.023900
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D0000400
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#B3D603006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.017580
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.008540
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000180
cansend "$CAN_IF" 760#40FE4800D2000400
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#CFD603006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000340
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022870
cansend "$CAN_IF" 7E0#38E4030083E50080
sleep_scaled 0.003920
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89FFFFFFFFFFF3
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800CD000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#EDD603006A590100
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
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.008790
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013830
cansend "$CAN_IF" 700#0000000130800000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000180
cansend "$CAN_IF" 760#40FE4800D2000100
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#08D703006A590100
sleep_scaled 0.000340
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023890
cansend "$CAN_IF" 700#0000000130800000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D3000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#23D703006A590100
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
sleep_scaled 0.005970
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019880
cansend "$CAN_IF" 700#0000000130800000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CE000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#3ED703006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026620
cansend "$CAN_IF" 700#0000000130800000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89000100030008
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D1FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#5CD703006A590100
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
sleep_scaled 0.022270
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#77D703006A590100
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
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002050
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#92D703006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026710
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D3FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#AED703006A590100
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
sleep_scaled 0.000250
cansend "$CAN_IF" 7E0#FFE4030083E50080
sleep_scaled 0.015710
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.010410
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#890001FFFC0005
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D0FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#CCD703006A590100
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
sleep_scaled 0.023460
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D2FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E7D703006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.009640
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013140
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CFFFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#01D803006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026110
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800CFFFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#1DD803006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005380
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.021410
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#89FFFA00000000
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D3000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#3BD803006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023210
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D1000600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#55D803006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023130
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800CF000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#70D803006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.008110
cansend "$CAN_IF" 7E0#C8E5030083E50080
sleep_scaled 0.015360
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.003580
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#8CD803006A590100
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
sleep_scaled 0.026710
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#89000AFFFFFFF5
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CFFFF600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000180
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#AAD803006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.013220
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.009300
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1FFF600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#C5D803006A590100
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
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800CFFFF600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E0D803006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.011950
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.014760
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D4FFF600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#FBD803006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026800
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89FFFF0002FFF9
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D3000100
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#1AD903006A590100
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
sleep_scaled 0.001790
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019800
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CF000100
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#34D903006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.011770
cansend "$CAN_IF" 7E0#8FE6030083E50080
sleep_scaled 0.012200
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D1000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#4FD903006A590100
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
sleep_scaled 0.000850
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.026290
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D3000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000180
cansend "$CAN_IF" 412#6BD903006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
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
sleep_scaled 0.020140
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.005720
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89FFFC0000FFFB
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D2000400
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#89D903006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022960
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800CD000400
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#A4D903006A590100
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
sleep_scaled 0.015870
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.007600
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000180
cansend "$CAN_IF" 760#40FE4800D3000400
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#BED903006A590100
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
sleep_scaled 0.027390
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D0000400
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#DAD903006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.008620
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.016980
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89FFF7FFFF0008
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D2000900
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F8D903006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.014000
cansend "$CAN_IF" 7E0#57E7030083E50080
sleep_scaled 0.008700
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D1000900
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#12DA03006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.004690
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019030
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1000900
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#2DDA03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027390
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000510
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D2000900
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#4ADA03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.025340
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#890004FFFFFFFB
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CDFFFC00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#67DA03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.019200
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.003760
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D3FFFC00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#82DA03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023980
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1FFFC00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#9CDA03006A590100
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
sleep_scaled 0.015960
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.010410
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D0FFFC00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#B9DA03006A590100
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
sleep_scaled 0.021160
cansend "$CAN_IF" 7E0#20E8030083E50080
sleep_scaled 0.004700
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89FFFD00000000
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D2000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#D7DA03006A590100
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
sleep_scaled 0.007940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.015180
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800CF000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#F1DA03006A590100
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
sleep_scaled 0.024060
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D4000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#0CDB03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.004520
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.021500
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D0000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#28DB03006A590100
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
sleep_scaled 0.025860
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.001190
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89FFFD00000004
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D1000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#46DB03006A590100
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
sleep_scaled 0.022440
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D3000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#61DB03006A590100
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
sleep_scaled 0.019800
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.003160
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D0000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#7BDB03006A590100
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
sleep_scaled 0.026540
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#98DB03006A590100
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
sleep_scaled 0.003750
cansend "$CAN_IF" 7E0#ECE8030083E50080
sleep_scaled 0.011270
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.012030
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#890001FFFF0000
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D1FFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#B5DB03006A590100
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
sleep_scaled 0.023300
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D2FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#D0DB03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
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
sleep_scaled 0.008020
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.014330
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D3FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#EADB03006A590100
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
sleep_scaled 0.027050
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CDFFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#07DC03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.003240
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.026030
cansend "$CAN_IF" 700#0000000131810000
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89FFFF0003000A
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D3000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#25DC03006A590100
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
sleep_scaled 0.000510
cansend "$CAN_IF" 700#0600000139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D2000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#40DC03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023130
cansend "$CAN_IF" 700#0600000139810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D1000100
sleep_scaled 0.000180
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#5ADC03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.006320
cansend "$CAN_IF" 7E0#B0E9030083E50080
sleep_scaled 0.015440
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.005630
cansend "$CAN_IF" 700#0600000139810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D3000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#76DC03006A590100
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
sleep_scaled 0.027560
cansend "$CAN_IF" 700#0600000139810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#8900010008FFF5
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D0FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000180
cansend "$CAN_IF" 412#94DC03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.010330
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.010840
cansend "$CAN_IF" 700#0600090139810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D0FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#AFDC03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023300
cansend "$CAN_IF" 700#0600090139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D2FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#C9DC03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.010490
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.016050
cansend "$CAN_IF" 700#0600090139810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800CEFFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E5DC03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.028160
cansend "$CAN_IF" 700#0600090139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89FFFF00060007
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D3000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#03DD03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022020
cansend "$CAN_IF" 700#0600090139810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D0000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#1EDD03006A590100
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
sleep_scaled 0.009210
cansend "$CAN_IF" 7E0#77EA030083E50080
sleep_scaled 0.014420
cansend "$CAN_IF" 700#0600090139810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D0000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#39DD03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
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
sleep_scaled 0.027230
cansend "$CAN_IF" 700#0600090139810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D2000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#55DD03006A590100
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
sleep_scaled 0.017750
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.008530
cansend "$CAN_IF" 700#0600090139810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#89FFFFFFFBFFFC
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800CE000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000180
cansend "$CAN_IF" 412#73DD03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000340
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021250
cansend "$CAN_IF" 700#0600070139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D5000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#8DDD03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.014590
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.009310
cansend "$CAN_IF" 700#0600070139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CF000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#A7DD03006A590100
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
sleep_scaled 0.027900
cansend "$CAN_IF" 700#0600070139810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1000100
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#C4DD03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.006400
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019370
cansend "$CAN_IF" 700#0600070139810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#8900040000FFF8
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D1FFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E2DD03006A590100
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
sleep_scaled 0.011520
cansend "$CAN_IF" 7E0#3FEB030083E50080
sleep_scaled 0.010670
cansend "$CAN_IF" 700#0600070139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CDFFFC00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#FCDD03006A590100
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
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.002820
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.020650
cansend "$CAN_IF" 700#0600070139810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D4FFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#17DE03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.025690
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000770
cansend "$CAN_IF" 700#0600070139810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CFFFFC00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#33DE03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026800
cansend "$CAN_IF" 700#0600070139810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#890001FFFE0002
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D3FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#51DE03006A590100
sleep_scaled 0.000260
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
sleep_scaled 0.016810
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.006400
cansend "$CAN_IF" 700#0600070139810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CFFFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#6CDE03006A590100
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
sleep_scaled 0.023040
cansend "$CAN_IF" 700#0600070139810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D2FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#86DE03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.014340
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.011270
cansend "$CAN_IF" 700#0600070139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D0FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#A2DE03006A590100
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
sleep_scaled 0.020400
cansend "$CAN_IF" 7E0#08EC030083E50080
sleep_scaled 0.006740
cansend "$CAN_IF" 700#0600070139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89FFFA00050002
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#C0DE03006A590100
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
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005720
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.016560
cansend "$CAN_IF" 700#0600070139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D0000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#DBDE03006A590100
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
sleep_scaled 0.024060
cansend "$CAN_IF" 700#0600070139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800CF000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F5DE03006A590100
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
sleep_scaled 0.002990
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.022780
cansend "$CAN_IF" 700#0600070139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D2000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#11DF03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024490
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002220
cansend "$CAN_IF" 700#0600070139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89FFFFFFFE0007
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D0000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#2FDF03006A590100
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
sleep_scaled 0.023720
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D2000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#4ADF03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.017580
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.004690
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D0000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#65DF03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026790
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#80DF03006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000250
cansend "$CAN_IF" 7E0#CFEC030083E50080
sleep_scaled 0.012970
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013660
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#8900010000FFFB
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D4FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#9FDF03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024060
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D0FFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#BADF03006A590100
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
sleep_scaled 0.005720
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.015530
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#D4DF03006A590100
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
sleep_scaled 0.027570
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800CFFFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F0DF03006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.001620
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.024840
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89000400030002
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1FFFC00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#0EE003006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021330
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000680
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D1FFFC00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#29E003006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023470
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D0FFFC00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#43E003006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.004610
cansend "$CAN_IF" 7E0#97ED030083E50080
sleep_scaled 0.015870
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.006570
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D1FFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#5FE003006A590100
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
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027050
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#89000600000000
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CFFFFA00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#7DE003006A590100
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
sleep_scaled 0.009730
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.011780
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D2FFFA00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#98E003006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023630
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D2FFFA00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#B2E003006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.009050
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017830
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D0FFFA00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#CEE003006A590100
sleep_scaled 0.000340
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027570
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89FFFF0003FFFE
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2000100
sleep_scaled 0.000260
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#EDE003006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
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
sleep_scaled 0.021500
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D3000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#07E103006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.008280
cansend "$CAN_IF" 7E0#5FEE030083E50080
sleep_scaled 0.015440
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D1000100
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#22E103006A590100
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
sleep_scaled 0.027650
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D1000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#3EE103006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.016390
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.008870
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89FFFA00000002
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D0000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#5CE103006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022700
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1000600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#76E103006A590100
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
sleep_scaled 0.012880
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.010670
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800CE000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#91E103006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027900
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2000600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#AEE103006A590100
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
sleep_scaled 0.005120
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019790
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89FFFBFFFAFFF4
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D6000500
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#CBE103006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.011870
cansend "$CAN_IF" 7E0#28EF030083E50080
sleep_scaled 0.011520
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800CF000500
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E6E103006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.001280
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.022440
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800CF000500
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#01E203006A590100
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
sleep_scaled 0.023980
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002640
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1000500
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#1DE203006A590100
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
sleep_scaled 0.026020
cansend "$CAN_IF" 700#0600050139810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000180
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#8900020009FFF5
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2FFFE00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#3AE203006A590100
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
sleep_scaled 0.015780
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.006830
cansend "$CAN_IF" 700#0600030139810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D0FFFE00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#55E203006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023890
cansend "$CAN_IF" 700#0600030139810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CFFFFE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#70E203006A590100
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
sleep_scaled 0.012970
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.012890
cansend "$CAN_IF" 700#0600030139810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D3FFFE00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#8CE203006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.018610
cansend "$CAN_IF" 7E0#EFEF030083E50080
sleep_scaled 0.008360
cansend "$CAN_IF" 700#0600030139810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#8900030000FFFC
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D1FFFD00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#A9E203006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.004350
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.018610
cansend "$CAN_IF" 700#0600030139810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800CDFFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#C4E203006A590100
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
sleep_scaled 0.023720
cansend "$CAN_IF" 700#0600030139810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1FFFD00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#DFE203006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.001360
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001030
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.024230
cansend "$CAN_IF" 700#0600030139810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D2FFFD00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#FBE203006A590100
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
sleep_scaled 0.023120
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.003330
cansend "$CAN_IF" 700#0600030139810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#8900060005FFF9
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D1FFFA00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#18E303006A590100
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
sleep_scaled 0.023040
cansend "$CAN_IF" 700#0600030139810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800CEFFFA00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#33E303006A590100
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
sleep_scaled 0.017060
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.005980
cansend "$CAN_IF" 700#0600030139810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D1FFFA00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#4EE303006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.025510
cansend "$CAN_IF" 7E0#B7F0030083E50080
sleep_scaled 0.001370
cansend "$CAN_IF" 700#0600030139810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D4FFFA00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#6AE303006A590100
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
sleep_scaled 0.011690
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.014850
cansend "$CAN_IF" 700#0600030139810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89FFFC0002FFF6
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800CD000400
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#88E303006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022960
cansend "$CAN_IF" 700#0600030139810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE4800D2000400
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#A3E303006A590100
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
sleep_scaled 0.005720
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.016990
cansend "$CAN_IF" 700#0600030139810006
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE4800D1000400
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#BDE303006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027220
cansend "$CAN_IF" 700#0600030139810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D3000400
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#D9E303006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001070000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000510
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.027220
cansend "$CAN_IF" 700#0600030139810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#89FFFC0002FFF4
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D0000400
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F7E303006A590100
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
sleep_scaled 0.018950
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002310
cansend "$CAN_IF" 700#0000030131810006
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1000400
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#12E403006A590100
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
sleep_scaled 0.023470
cansend "$CAN_IF" 700#0000030131810006
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE4800D1000400
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#2CE403006A590100
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
sleep_scaled 0.002810
cansend "$CAN_IF" 7E0#7FF1030083E50080

echo "Done."