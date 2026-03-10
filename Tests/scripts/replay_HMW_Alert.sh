#!/usr/bin/env bash
set -euo pipefail

# Auto-generated replay script from HMW_Alert.txt
# Source log contains: Channel, Identifier, DLC, data bytes, timestamp (s).
# Usage: ./script.sh [can_if] [speedup]
#   can_if  : interface name (default: can0)
#   speedup : timing speed-up factor, e.g. 2.0 means twice as fast (default: 1.0)
# Env:
#   NO_TIMING=1  -> send frames without sleeps

CAN_IF="${1:-can0}"
SPEEDUP="${2:-1.0}"
NO_TIMING="${NO_TIMING:-0}"

echo "Replaying: HMW_Alert.txt on ${CAN_IF} (speedup=${SPEEDUP}, no_timing=${NO_TIMING})"

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
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000180
cansend "$CAN_IF" 760#40FE5300D3FFFD00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#42AD0A006A590100
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
sleep_scaled 0.009640
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017150
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFA0005FFF5
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CC000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#60AD0A006A590100
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
sleep_scaled 0.022870
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000180
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#7BAD0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.003500
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019790
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000180
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#95AD0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026120
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#B1AD0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7E0#FFBA0A0083E50080
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026880
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFF0002FFF7
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000100
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#CFAD0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.017490
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.004350
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000100
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#EAAD0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.023720
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#05AE0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.016550
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.010500
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#21AE0A006A590100
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
sleep_scaled 0.027650
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFA00010001
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#3FAE0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005380
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.015360
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#59AE0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.024070
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D3000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#74AE0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.004010
cansend "$CAN_IF" 7E0#C7BB0A0083E50080
sleep_scaled 0.001280
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.021930
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CC000600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#90AE0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024400
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001030
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.001450
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88000600050019
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFFA00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#AEAE0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022360
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CDFFFA00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#C8AE0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.020650
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.003500
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFFA00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#E3AE0A006A590100
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
sleep_scaled 0.027050
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2FFFA00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#FFAE0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.013150
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013490
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#880002FFFBFFFD
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CCFFFE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#1DAF0A006A590100
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
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021420
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFE00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#37AF0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.008100
cansend "$CAN_IF" 7E0#8FBC0A0083E50080
sleep_scaled 0.001540
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.014680
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0FFFE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#52AF0A006A590100
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
sleep_scaled 0.028160
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#6FAF0A006A590100
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
sleep_scaled 0.000940
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.024150
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000340
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFD00070000
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#8DAF0A006A590100
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
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022950
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000340
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#A8AF0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.022870
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CD000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#C2AF0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.020400
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.006140
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000180
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#DEAF0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026370
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFDFFFEFFFD
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#FCAF0A006A590100
sleep_scaled 0.000170
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
sleep_scaled 0.011010
cansend "$CAN_IF" 7E0#58BD0A0083E50080
sleep_scaled 0.000850
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.011180
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000300
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#17B00A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023560
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0000300
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#31B00A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000180
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.009050
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.016890
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#4DB00A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026880
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#880004FFFB0001
sleep_scaled 0.000180
cansend "$CAN_IF" 760#40FE5300CEFFFC00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#6BB00A006A590100
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
sleep_scaled 0.000680
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.022190
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFC00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#86B00A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.023900
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFC00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#A0B00A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.025770
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFFC00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#BCB00A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.018340
cansend "$CAN_IF" 7E0#1FBE0A0083E50080
sleep_scaled 0.001110
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.007680
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#880000FFFB0001
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#DAB00A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022440
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F5B00A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.013230
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.009980
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#10B10A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026710
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#2CB10A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.007930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019030
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFBFFFE0001
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000500
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#4AB10A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.023470
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3000500
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#65B10A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.000930
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001030
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.021160
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CB000500
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#7FB10A006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.024750
cansend "$CAN_IF" 7E0#E7BE0A0083E50080
sleep_scaled 0.001360
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CD000500
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#9BB10A006A590100
sleep_scaled 0.000350
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.027230
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#880000FFFE0004
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#B9B10A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.015950
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.005810
cansend "$CAN_IF" 700#00001301B0800001
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
cansend "$CAN_IF" 412#D3B10A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023980
cansend "$CAN_IF" 700#00001301B0800001
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
cansend "$CAN_IF" 412#EEB10A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.014930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.011950
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CC000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#0AB20A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026970
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88000000050014
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#28B20A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.004530
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017500
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CB000000
sleep_scaled 0.000180
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#43B20A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.023550
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#5DB20A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.002980
cansend "$CAN_IF" 7E0#B0BF0A0083E50080
sleep_scaled 0.000600
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.023640
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CF000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#7AB20A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000340
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022700
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002820
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88FFFEFFFEFFFA
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CD000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#97B20A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022700
cansend "$CAN_IF" 700#00001301B0800001
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
cansend "$CAN_IF" 412#B2B20A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.018860
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.005460
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CC000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000180
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#CDB20A006A590100
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
sleep_scaled 0.026450
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#E9B20A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.011780
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.014590
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#8800010001FFFA
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#07B30A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021760
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CCFFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#21B30A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.007170
cansend "$CAN_IF" 7E0#78C00A0083E50080
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.016730
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#3CB30A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027220
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CDFFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#59B30A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000430
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.025600
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88000000030004
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CE000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#76B30A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021500
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2000000
sleep_scaled 0.000180
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#90B30A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.024750
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#ABB30A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.018690
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001030
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.007420
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#C8B30A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026630
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88FFFAFFFEFFFA
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000180
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#E5B30A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.009130
cansend "$CAN_IF" 7E0#3FC10A0083E50080
sleep_scaled 0.001190
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.011690
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#FFB30A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024490
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#1AB40A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.007510
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019540
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CC000600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#37B40A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026200
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#880007FFF90004
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFF900
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#55B40A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021760
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFF900
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#6FB40A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.023120
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.000250
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CDFFF900
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#8AB40A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026710
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFF900
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#A6B40A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.016130
cansend "$CAN_IF" 7E0#07C20A0083E50080
sleep_scaled 0.001370
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.009130
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFDFFFCFFFD
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CE000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#C4B40A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022780
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000300
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#DEB40A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.011520
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.011610
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000300
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F9B40A006A590100
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
sleep_scaled 0.026710
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CD000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000180
cansend "$CAN_IF" 412#15B50A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.006320
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.020480
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#880001FFFEFFFD
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0FFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#33B50A006A590100
sleep_scaled 0.000180
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022610
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CDFFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000180
cansend "$CAN_IF" 412#4EB50A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000350
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.022620
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#68B50A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024070
cansend "$CAN_IF" 7E0#D0C20A0083E50080
sleep_scaled 0.000680
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002050
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#84B50A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027820
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#880004FFF60000
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#A2B50A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.013570
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.007340
cansend "$CAN_IF" 700#00001301B1810001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#BDB50A006A590100
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
sleep_scaled 0.023720
cansend "$CAN_IF" 700#00001301B1810001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CCFFFC00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#D7B50A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.013650
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013060
cansend "$CAN_IF" 700#00001301B1810001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0FFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F3B50A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.028160
cansend "$CAN_IF" 700#00001301B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#880000FFFE000C
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#12B60A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.002220
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001030
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.018430
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#2CB60A006A590100
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
sleep_scaled 0.023890
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CC000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#47B60A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.002220
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.001620
cansend "$CAN_IF" 7E0#9AC30A0083E50080
sleep_scaled 0.023380
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#63B60A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021250
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001030
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.004600
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88FFFAFFFD0004
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2000600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#81B60A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022100
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CF000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#9BB60A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.017580
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.006400
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CE000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#B6B60A006A590100
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
sleep_scaled 0.026970
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#D2B60A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.015960
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFD00010000
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#F0B60A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.022700
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#0BB70A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005210
cansend "$CAN_IF" 7E0#60C40A0083E50080
sleep_scaled 0.000600
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017660
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#25B70A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027640
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000300
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000250
cansend "$CAN_IF" 412#42B70A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026030
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFE0000FFFF
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CC000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#5FB70A006A590100
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
sleep_scaled 0.019970
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002640
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#7AB70A006A590100
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
sleep_scaled 0.023720
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CC000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#95B70A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.017400
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.009130
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#B1B70A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026620
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#880001000BFFFF
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#CFB70A006A590100
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
sleep_scaled 0.007770
cansend "$CAN_IF" 7E0#28C50A0083E50080
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013310
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E9B70A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CCFFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#04B80A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005880
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.020400
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#20B80A006A590100
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
sleep_scaled 0.026970
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#8800040004FFFD
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CEFFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#3EB80A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021160
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFFC00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#58B80A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.022110
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.001790
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#74B80A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027130
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000180
cansend "$CAN_IF" 760#40FE5300CDFFFC00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#90B80A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.014250
cansend "$CAN_IF" 7E0#EFC50A0083E50080
sleep_scaled 0.001280
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.010840
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88000900040004
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1FFF700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#ADB80A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022270
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CDFFF700
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#C8B80A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.010320
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013150
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFF700
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E3B80A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.026370
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0FFF700
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#FEB80A006A590100
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
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005030
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.022110
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#8800010000FFF8
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#1DB90A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.023210
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CBFFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 412#37B90A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022780
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#52B90A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022700
cansend "$CAN_IF" 7E0#B8C60A0083E50080
sleep_scaled 0.000520
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.004180
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#6EB90A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.026370
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFD0001FFFB
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CB000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#8CB90A006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.012970
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.009050
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0000300
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#A7B90A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023720
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000300
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#C1B90A006A590100
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
sleep_scaled 0.011950
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.015360
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#DDB90A006A590100
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
sleep_scaled 0.026800
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88FFFF00040000
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#FBB90A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.001280
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019880
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000180
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CC000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#15BA0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024500
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#31BA0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.003670
cansend "$CAN_IF" 7E0#84C70A0083E50080
sleep_scaled 0.022610
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#4CBA0A006A590100
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
sleep_scaled 0.020050
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.005980
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88FFFAFFF9FFFD
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CC000600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#6ABA0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.022100
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#85BA0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.016390
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.008100
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000180
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#A0BA0A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027400
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CE000600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#BCBA0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000180
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.008190
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017150
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#8800040000000C
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFC00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#DABA0A006A590100
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
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022100
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CEFFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#F4BA0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.003500
cansend "$CAN_IF" 7E0#47C80A0083E50080
sleep_scaled 0.001620
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019280
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFFC00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#0FBB0A006A590100
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
sleep_scaled 0.027050
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000260
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CFFFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#2BBB0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026110
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88FFFDFFFC0000
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#49BB0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.018770
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.003670
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#63BB0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024150
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#7EBB0A006A590100
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
sleep_scaled 0.015870
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.010240
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#9ABB0A006A590100
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
sleep_scaled 0.026540
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFEFFFF0009
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#B8BB0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.006920
cansend "$CAN_IF" 7E0#10C90A0083E50080
sleep_scaled 0.000760
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.015710
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#D3BB0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023890
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#EEBB0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.004100
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.021930
cansend "$CAN_IF" 700#00001301B0800001
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
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#0ABC0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.025420
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.001200
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#880001FFFFFFF6
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CCFFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#27BC0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.021930
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#42BC0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.020310
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.003070
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#5DBC0A006A590100
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
sleep_scaled 0.026970
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CDFFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#79BC0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.013230
cansend "$CAN_IF" 7E0#D7C90A0083E50080
sleep_scaled 0.001110
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.012450
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88FFFA00000000
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#97BC0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022950
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#B1BC0A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.008020
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.014680
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#CCBC0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026800
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#E8BC0A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.003160
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.024150
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#8800040003FFF5
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CDFFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#06BD0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.022010
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000340
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFC00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#21BD0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023210
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0FFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#3BBD0A006A590100
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
sleep_scaled 0.020480
cansend "$CAN_IF" 7E0#9FCA0A0083E50080
sleep_scaled 0.001370
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.005120
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CCFFFC00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#57BD0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.028160
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88000600000001
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFFA00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#76BD0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.010240
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.010240
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFFA00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#90BD0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.023980
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CCFFFA00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#AABD0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.010500
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.016640
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D3FFFA00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#C7BD0A006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.027050
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFD0006FFF2
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CD000300
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#E5BD0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000420
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.021250
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#FFBD0A006A590100
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
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024230
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CF000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#1ABE0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.003670
cansend "$CAN_IF" 7E0#6DCB0A0083E50080
sleep_scaled 0.023380
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#36BE0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.018180
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.007850
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88000000090000
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#54BE0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022190
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#6EBE0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.014330
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.009480
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000180
cansend "$CAN_IF" 412#89BE0A006A590100
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
sleep_scaled 0.027480
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#A5BE0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.006830
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.018940
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFF0003FFF8
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000100
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#C3BE0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.022450
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#DEBE0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000180
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.002560
cansend "$CAN_IF" 7E0#30CC0A0083E50080
sleep_scaled 0.000510
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.020830
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#F8BE0A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.025510
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.001280
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#15BF0A006A590100
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
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026290
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#880000FFFC0000
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#33BF0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.016890
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.005380
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#4DBF0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.024060
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#68BF0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.014330
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.012200
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#84BF0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.026200
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#880000FFF4FFFD
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#A1BF0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.005120
cansend "$CAN_IF" 7E0#F8CC0A0083E50080
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.016290
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CA000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#BCBF0A006A590100
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
sleep_scaled 0.024920
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#D7BF0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.002560
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.023210
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#F3BF0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.024150
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002130
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#880000FFFB0002
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#11C00A006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.023640
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CC000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#2CC00A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.017580
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.004780
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#46C00A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027220
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#63C00A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.011090
cansend "$CAN_IF" 7E0#BFCD0A0083E50080
sleep_scaled 0.001280
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013740
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#880000FFFF000A
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#80C00A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022700
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#9BC00A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.007080
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.016300
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CE000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#B6C00A006A590100
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
sleep_scaled 0.026280
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#D1C00A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.002050
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.024920
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88000BFFFC0002
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CEFFF500
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#EFC00A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.021160
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.001110
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CDFFF500
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#0AC10A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023380
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0FFF500
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#25C10A006A590100
sleep_scaled 0.000170
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
sleep_scaled 0.019540
cansend "$CAN_IF" 7E0#88CE0A0083E50080
sleep_scaled 0.000510
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.006660
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFF500
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#41C10A006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.027730
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#880006FFFFFFF5
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0FFFA00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#5FC10A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.009050
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.012200
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFA00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#7AC10A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023630
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFFA00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#94C10A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.008870
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.018180
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFFA00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#B0C10A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.028160
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000260
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#8800000009FFFB
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#CFC10A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021590
cansend "$CAN_IF" 700#00001301B1810001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E9C10A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022620
cansend "$CAN_IF" 7E0#50CF0A0083E50080
sleep_scaled 0.000510
cansend "$CAN_IF" 700#00001301B1810001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#03C20A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026880
cansend "$CAN_IF" 700#00001301B1810001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#1FC20A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.016900
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.008790
cansend "$CAN_IF" 700#00001301B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFEFFFF0005
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#3DC20A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021930
cansend "$CAN_IF" 700#00001301B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#57C20A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001020000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.013730
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.010930
cansend "$CAN_IF" 700#00001301B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CE000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#72C20A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027390
cansend "$CAN_IF" 700#00001301B1810001
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#8FC20A006A590100
sleep_scaled 0.000340
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005370
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.021080
cansend "$CAN_IF" 700#00001301B1810001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88FFFBFFFCFFFE
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000500
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#ADC20A006A590100
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
sleep_scaled 0.022270
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000500
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#C8C20A006A590100
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
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000250
cansend "$CAN_IF" 7E0#17D00A0083E50080
sleep_scaled 0.000860
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.022270
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0000500
sleep_scaled 0.000180
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E2C20A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.024070
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002810
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000500
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#FEC20A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026020
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#880005FFFFFFFB
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFFB00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#1CC30A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.015530
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.007680
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFB00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#37C30A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023120
cansend "$CAN_IF" 700#00001301B0800001
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
sleep_scaled 0.000260
cansend "$CAN_IF" 412#51C30A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.012890
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013820
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFB00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#6EC30A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026020
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFEFFF9FFF3
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#8BC30A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.003420
cansend "$CAN_IF" 7E0#DFD00A0083E50080
sleep_scaled 0.001190
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.018180
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#A6C30A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.024320
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#C1C30A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.001280
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.024490
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
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
cansend "$CAN_IF" 412#DCC30A006A590100
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
sleep_scaled 0.022780
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.003760
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#8800000003FFFB
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#FAC30A006A590100
sleep_scaled 0.000180
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022530
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#15C40A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.017240
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.005980
cansend "$CAN_IF" 700#00001301B0800001
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
cansend "$CAN_IF" 412#30C40A006A590100
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
sleep_scaled 0.026800
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CD000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#4BC40A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.011100
cansend "$CAN_IF" 7E0#A8D10A0083E50080
sleep_scaled 0.000590
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.015450
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#880004FFF7FFF3
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CDFFFC00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#6AC40A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022440
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#84C40A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005630
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017660
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#9FC40A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026960
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#BBC40A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026200
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#8800000002FFFF
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CE000000
sleep_scaled 0.000180
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#D9C40A006A590100
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
sleep_scaled 0.019710
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001030
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002050
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F3C40A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023810
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#0EC50A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.017920
cansend "$CAN_IF" 7E0#70D20A0083E50080
sleep_scaled 0.000850
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.007770
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#2AC50A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027570
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88FFFEFFFF0002
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000200
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#48C50A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.008110
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013230
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#62C50A006A590100
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
sleep_scaled 0.023980
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
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
cansend "$CAN_IF" 412#7DC50A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.007420
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019710
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#9AC50A006A590100
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
sleep_scaled 0.026710
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000250
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88000000030010
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#B8C50A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021760
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#D2C50A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022020
cansend "$CAN_IF" 7E0#37D30A0083E50080
sleep_scaled 0.001110
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.001540
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#EDC50A006A590100
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
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026790
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000180
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#09C60A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.015360
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.010410
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88000000010000
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#27C60A006A590100
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
sleep_scaled 0.022700
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#41C60A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.011350
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.012540
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CE000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#5CC60A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027480
cansend "$CAN_IF" 700#00001301B0800001
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
cansend "$CAN_IF" 412#78C60A006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.003670
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.023380
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88000800090000
sleep_scaled 0.000180
cansend "$CAN_IF" 760#40FE5300CEFFF800
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#97C60A006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.020990
cansend "$CAN_IF" 700#00001301B1810001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFF800
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#B1C60A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000260
cansend "$CAN_IF" 7E0#00D40A0083E50080
sleep_scaled 0.023380
cansend "$CAN_IF" 700#00001301B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CFFFF800
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#CBC60A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022530
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.004090
cansend "$CAN_IF" 700#00001301B1810001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFF800
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#E8C60A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026200
cansend "$CAN_IF" 700#00001301B1810001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88FFF90004FFFB
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000700
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#05C70A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.014160
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.007940
cansend "$CAN_IF" 700#00001301B1810001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000700
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#1FC70A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024750
cansend "$CAN_IF" 700#00001301B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000700
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#3BC70A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.011010
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.015020
cansend "$CAN_IF" 700#00001301B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CF000700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#57C70A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027050
cansend "$CAN_IF" 700#00001301B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFB00040002
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000500
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#74C70A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.001530
cansend "$CAN_IF" 7E0#C8D40A0083E50080
sleep_scaled 0.000770
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.020140
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000500
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#90C70A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024060
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000500
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#AAC70A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.026790
cansend "$CAN_IF" 700#00001301B0800001
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
cansend "$CAN_IF" 412#C6C70A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.020560
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.005290
cansend "$CAN_IF" 700#00001301B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88FFFBFFF8FFF9
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000500
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000340
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#E4C70A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022690
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000180
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CE000500
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#FEC70A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.015440
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.007760
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000500
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#19C80A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026450
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000500
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#35C80A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.009300
cansend "$CAN_IF" 7E0#8FD50A0083E50080
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.016810
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#8800020000FFF9
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0FFFE00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#53C80A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022440
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CCFFFE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#6EC80A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.004270
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019290
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFFE00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#89C80A006A590100
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
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027050
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0FFFE00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#A5C80A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.025850
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFF900000002
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000700
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#C2C80A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.018270
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.004530
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#DEC80A006A590100
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
sleep_scaled 0.022950
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#F8C80A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.015870
cansend "$CAN_IF" 7E0#57D60A0083E50080
sleep_scaled 0.001280
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.009810
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#14C90A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027820
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88FFFD0003FFF7
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CC000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#32C90A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005890
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.014930
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#4CC90A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024070
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#67C90A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005720
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.021590
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#83C90A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024830
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000680
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#8800000000FFFB
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#A1C90A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023040
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CF000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#BCC90A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.019970
cansend "$CAN_IF" 7E0#20D70A0083E50080
sleep_scaled 0.000680
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002730
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#D6C90A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027130
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#F2C90A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.013910
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.011860
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#880001FFFF0005
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CEFFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#10CA0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023120
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#2BCA0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.009470
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.014000
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#45CA0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027740
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CEFFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000180
cansend "$CAN_IF" 412#62CA0A006A590100
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
sleep_scaled 0.001960
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001030
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.023380
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#8800040001FFFB
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CDFFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#80CA0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022700
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFC00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#9ACA0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000260
cansend "$CAN_IF" 7E0#E7D70A0083E50080
sleep_scaled 0.023210
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CEFFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#B5CA0A006A590100
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
sleep_scaled 0.020990
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.005380
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2FFFC00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#D1CA0A006A590100
sleep_scaled 0.000170
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
sleep_scaled 0.026030
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFF0004FFFE
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#EFCA0A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.012890
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.009810
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000100
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000180
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#09CB0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024490
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000100
sleep_scaled 0.000180
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#24CB0A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.009470
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017160
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CE000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#41CB0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026280
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFAFFFF0002
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#5ECB0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7E0#AFD80A0083E50080
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000770
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.021420
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CE000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#79CB0A006A590100
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
sleep_scaled 0.024150
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000600
sleep_scaled 0.000260
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#94CB0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026200
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0000600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#AFCB0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.019800
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.007510
cansend "$CAN_IF" 700#00001101B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFFFFFFFFFE
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CE000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#CDCB0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022010
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#E8CB0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.013910
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.009220
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#03CC0A006A590100
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
sleep_scaled 0.027050
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#1FCC0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.007680
cansend "$CAN_IF" 7E0#78D90A0083E50080
sleep_scaled 0.000510
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017920
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#8800040001FFFB
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#3CCC0A006A590100
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
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023290
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#58CC0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.002220
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.020560
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFC00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#72CC0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026620
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#8ECC0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.026710
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#880001FFFFFFF1
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#ACCC0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.016550
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001030
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.004860
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#C6CC0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024660
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E2CC0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.014340
cansend "$CAN_IF" 7E0#40DA0A0083E50080
sleep_scaled 0.000770
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.011430
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#FDCC0A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.026970
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFFFFFDFFF6
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#1CCD0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.005030
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017150
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#36CD0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023120
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#50CD0A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.004360
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.023380
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#6DCD0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.023040
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002480
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFEFFFB0006
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#8BCD0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022020
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#A4CD0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.019030
cansend "$CAN_IF" 7E0#07DB0A0083E50080
sleep_scaled 0.001030
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.004260
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#C0CD0A006A590100
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
sleep_scaled 0.026880
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#DCCD0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.012540
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.014340
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFA0002FFFB
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#FACD0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021760
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D3000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#14CE0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.008360
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.016040
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#2FCE0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026530
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CD000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#4BCE0A006A590100
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
sleep_scaled 0.001190
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.024750
cansend "$CAN_IF" 700#00001101B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFA00010003
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CE000600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#69CE0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021080
cansend "$CAN_IF" 7E0#CFDB0A0083E50080
sleep_scaled 0.001110
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#83CE0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023980
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#9ECE0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.019720
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.006750
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CF000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#BBCE0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027130
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFF00010006
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000100
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#D8CE0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.010500
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.011350
cansend "$CAN_IF" 700#00000F01B1810001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D3000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F3CE0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.024240
cansend "$CAN_IF" 700#00000F01B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CD000100
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#0ECF0A006A590100
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
sleep_scaled 0.008020
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017920
cansend "$CAN_IF" 700#00000F01B1810001
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#2ACF0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026110
cansend "$CAN_IF" 700#00000F01B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFF7FFFD0003
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000900
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#47CF0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000340
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.003410
cansend "$CAN_IF" 7E0#9CDC0A0083E50080
sleep_scaled 0.019030
cansend "$CAN_IF" 700#00000F01B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000900
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#62CF0A006A590100
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
sleep_scaled 0.023890
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000600
cansend "$CAN_IF" 700#00000F01B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000900
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#7DCF0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027050
cansend "$CAN_IF" 700#00000F01B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000900
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#99CF0A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.017670
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.008360
cansend "$CAN_IF" 700#00000F01B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000180
cansend "$CAN_IF" 703#880003FFFF0009
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#B7CF0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023120
cansend "$CAN_IF" 700#00000F01B1810001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0FFFD00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#D2CF0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.012030
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.010660
cansend "$CAN_IF" 700#00000F01B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CDFFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000180
cansend "$CAN_IF" 412#ECCF0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027050
cansend "$CAN_IF" 700#00000F01B1810001
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0FFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#08D00A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005710
cansend "$CAN_IF" 7E0#5FDD0A0083E50080
sleep_scaled 0.000860
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.020390
cansend "$CAN_IF" 700#00000F01B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFFFFFD0003
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#26D00A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023550
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#42D00A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.022010
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#5BD00A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.025260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.001530
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#77D00A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026800
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFF00040003
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#95D00A006A590100
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
sleep_scaled 0.015100
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.007170
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#B0D00A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023380
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CF000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#CBD00A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.013050
cansend "$CAN_IF" 7E0#27DE0A0083E50080
sleep_scaled 0.001030
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013140
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E7D00A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026800
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFF7FFFDFFFF
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CC000900
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#05D10A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.003490
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.018090
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CD000900
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#1FD10A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023560
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0000900
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#3AD10A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.002900
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.024230
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0000900
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#56D10A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.022020
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.003930
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#8800030006FFFC
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CDFFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#74D10A006A590100
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
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022440
cansend "$CAN_IF" 700#00000F01B0800001
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
cansend "$CAN_IF" 412#8FD10A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.016730
cansend "$CAN_IF" 7E0#EFDE0A0083E50080
sleep_scaled 0.001280
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.005630
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CFFFFD00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#A9D10A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027310
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000180
cansend "$CAN_IF" 760#40FE5300CEFFFD00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#C5D10A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.010580
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.015190
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFA00020003
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E4D10A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022190
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#FDD10A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.006990
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017070
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#18D20A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027900
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#35D20A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.025770
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#880006FFF40002
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CDFFFA00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#53D20A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.020050
cansend "$CAN_IF" 7E0#B8DF0A0083E50080
sleep_scaled 0.000510
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.001710
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFA00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000180
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#6DD20A006A590100
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
sleep_scaled 0.023980
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFFA00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#88D20A006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.018090
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.008110
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CBFFFA00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#A4D20A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026710
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFEFFFD0005
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#C2D20A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.009650
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.012540
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#DCD20A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024500
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CD000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#F7D20A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.006650
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019800
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#13D30A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026710
cansend "$CAN_IF" 7E0#7FE00A0083E50080
sleep_scaled 0.000260
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88FFF60002FFFB
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000A00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#31D30A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021840
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CF000A00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#4CD30A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.021930
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.001110
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000A00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#66D30A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026790
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000A00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#82D30A006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.016730
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.010490
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88000700000002
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFF900
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#A0D30A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022190
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFF900
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#BBD30A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.010830
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.012030
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFF900
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#D6D30A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.027050
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFF900
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F2D30A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.004100
cansend "$CAN_IF" 7E0#47E10A0083E50080
sleep_scaled 0.001280
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.021760
cansend "$CAN_IF" 700#00000F01B0800001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#8800050000FFFB
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFFB00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#10D40A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022950
cansend "$CAN_IF" 700#00000F01B1810001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFFB00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#2BD40A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022530
cansend "$CAN_IF" 700#00000F01B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFFB00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#45D40A006A590100
sleep_scaled 0.000170
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
sleep_scaled 0.023980
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.003330
cansend "$CAN_IF" 700#00000F01B1810001
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFFB00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#61D40A006A590100
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
sleep_scaled 0.026540
cansend "$CAN_IF" 700#00000F01B1810001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88000000020000
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CE000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#7FD40A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.013570
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.008280
cansend "$CAN_IF" 700#00000F01B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000180
cansend "$CAN_IF" 412#99D40A006A590100
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
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023800
cansend "$CAN_IF" 700#00000F01B1810001
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#B4D40A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.011950
cansend "$CAN_IF" 7E0#10E20A0083E50080
sleep_scaled 0.000510
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.014000
cansend "$CAN_IF" 700#00000F01B1810001
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
cansend "$CAN_IF" 412#D0D40A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.029010
cansend "$CAN_IF" 700#00000F01B1810001
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88000200000002
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFFE00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#EED40A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000430
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.020390
cansend "$CAN_IF" 700#00000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CDFFFE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#09D50A006A590100
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
sleep_scaled 0.023120
cansend "$CAN_IF" 700#00000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0FFFE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#23D50A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.001190
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.026030
cansend "$CAN_IF" 700#00000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFFE00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#40D50A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.020390
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.005290
cansend "$CAN_IF" 700#00000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88000A00020000
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CEFFF600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#5ED50A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022790
cansend "$CAN_IF" 700#00000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFF600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#78D50A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.015530
cansend "$CAN_IF" 7E0#D7E20A0083E50080
sleep_scaled 0.000850
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.007260
cansend "$CAN_IF" 700#00000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFF600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#93D50A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.027570
cansend "$CAN_IF" 700#00000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CEFFF600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#AFD50A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.008870
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.018180
cansend "$CAN_IF" 700#00000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#880000FFFB0000
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#CDD50A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.020820
cansend "$CAN_IF" 700#00000D01B0800002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000000
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#E7D50A006A590100
sleep_scaled 0.000340
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005300
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.018940
cansend "$CAN_IF" 700#00000D01B0800002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000180
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#02D60A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026970
cansend "$CAN_IF" 700#00000D01B0800002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000180
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#1ED60A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026030
cansend "$CAN_IF" 700#00000D01B0800002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#8800020000FFEE
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CEFFFE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#3CD60A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.018090
cansend "$CAN_IF" 7E0#9FE30A0083E50080
sleep_scaled 0.001200
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.003150
cansend "$CAN_IF" 700#00000D01B0800002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3FFFE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#56D60A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.023810
cansend "$CAN_IF" 700#00000D01B0800002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CCFFFE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#71D60A006A590100
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
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.009990
cansend "$CAN_IF" 700#00000D01B0800002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CDFFFE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000180
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#8ED60A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026620
cansend "$CAN_IF" 700#00000D01B0800002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88FFFFFFFCFFFA
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#ABD60A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.007850
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.014670
cansend "$CAN_IF" 700#00000D01B0800002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CD000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#C6D60A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024060
cansend "$CAN_IF" 700#00000D01B0800002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#E1D60A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.004950
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.021420
cansend "$CAN_IF" 700#00000D01B0800002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CD000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000180
cansend "$CAN_IF" 412#FDD60A006A590100
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
sleep_scaled 0.025600
cansend "$CAN_IF" 7E0#68E40A0083E50080
sleep_scaled 0.000340
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000430
cansend "$CAN_IF" 700#00000D01B0800002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88000AFFF80000
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFF600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#1BD70A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023640
cansend "$CAN_IF" 700#00000D01B0800002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CEFFF600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#36D70A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.019370
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002730
cansend "$CAN_IF" 700#00000D01B0800002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFF600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#50D70A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027140
cansend "$CAN_IF" 700#00000D01B0800002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFF600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#6CD70A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.014850
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013830
cansend "$CAN_IF" 700#00000D01B0800002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#8800070007FFFD
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFF900
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#8AD70A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021250
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CCFFF900
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#A5D70A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.008450
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.013740
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFF900
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#BFD70A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026450
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1FFF900
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#DBD70A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.003590
cansend "$CAN_IF" 7E0#30E50A0083E50080
sleep_scaled 0.000590
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.023980
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88001200000001
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CDFFEE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F9D70A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021590
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFEE00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#14D80A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023300
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CCFFEE00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#2ED80A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022440
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.004700
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1FFEE00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#4AD80A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.028670
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFDFFFBFFF8
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#69D80A006A590100
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
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.010150
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.010580
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#84D80A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022950
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000300
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#9DD80A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.010240
cansend "$CAN_IF" 7E0#F7E50A0083E50080
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.016220
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000300
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#BAD80A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.027820
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFF800020000
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000800
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#D8D80A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.021410
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D2000800
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#F3D80A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023300
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CE000800
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#0DD90A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027560
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000800
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#29D90A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.018440
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.006910
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFD00040001
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#47D90A006A590100
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
sleep_scaled 0.023560
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#62D90A006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.012720
cansend "$CAN_IF" 7E0#BFE60A0083E50080
sleep_scaled 0.001190
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.008880
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000300
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#7CD90A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027650
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000300
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#98D90A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.007260
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.018770
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#8800070004000C
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CEFFF900
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000180
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#B6D90A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021590
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFF900
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#D0D90A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.004090
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.020140
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CDFFF900
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#EBD90A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026280
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000680
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0FFF900
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#08DA0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027820
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFC00000002
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1000400
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#26DA0A006A590100
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
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.016130
cansend "$CAN_IF" 7E0#88E70A0083E50080
sleep_scaled 0.000510
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.005550
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000400
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#41DA0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023130
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CF000400
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#5BDA0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.015020
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.011180
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CF000400
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#77DA0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.026620
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#8800010000000E
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0FFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#95DA0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.006570
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017070
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#B0DA0A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023300
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CDFFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#CADA0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.003330
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.022950
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D4FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#E7DA0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023550
cansend "$CAN_IF" 7E0#4FE80A0083E50080
sleep_scaled 0.000850
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002140
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#8800010003FFF7
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#04DB0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.023120
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#1FDB0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.018260
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.004180
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#39DB0A006A590100
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
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027810
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CFFFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#56DB0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.012630
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013060
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88000100000006
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2FFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#73DB0A006A590100
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
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023120
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CDFFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#8EDB0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.007340
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.015270
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CEFFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#A9DB0A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027050
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#C5DB0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.002130
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002140
cansend "$CAN_IF" 7E0#1AE90A0083E50080
sleep_scaled 0.021840
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#8800030002FFFB
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CDFFFD00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#E2DB0A006A590100
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
sleep_scaled 0.022110
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000850
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1FFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#FDDB0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023550
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000180
cansend "$CAN_IF" 760#40FE5300CDFFFD00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#18DC0A006A590100
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
sleep_scaled 0.020820
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.006310
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CEFFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#34DC0A006A590100
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
sleep_scaled 0.027050
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFF0002FFFD
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000100
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#52DC0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000180
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.010160
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.011860
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CD000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#6DDC0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023210
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#87DC0A006A590100
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
sleep_scaled 0.008450
cansend "$CAN_IF" 7E0#DFE90A0083E50080
sleep_scaled 0.001190
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017750
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000100
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#A4DC0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027730
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#880001FFFD0004
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#C2DC0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021850
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#DCDC0A006A590100
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
sleep_scaled 0.022960
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CEFFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000180
cansend "$CAN_IF" 412#F6DC0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027050
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CDFFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#13DD0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.017410
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.008360
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#880001FFFBFFFB
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0FFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#31DD0A006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.022360
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CCFFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#4BDD0A006A590100
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
sleep_scaled 0.013320
cansend "$CAN_IF" 7E0#A8EA0A0083E50080
sleep_scaled 0.000420
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.010330
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#66DD0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.027480
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CBFFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#82DD0A006A590100
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
sleep_scaled 0.005970
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019790
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88000600000000
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFFA00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#A0DD0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022270
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFFA00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#BADD0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.002390
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.021760
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFFA00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#D5DD0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024570
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001030
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.001880
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CEFFFA00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F1DD0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026280
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#880003FFFDFFF8
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFD00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#0FDE0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.015450
cansend "$CAN_IF" 7E0#6FEB0A0083E50080
sleep_scaled 0.000850
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.006400
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000180
cansend "$CAN_IF" 760#40FE5300D1FFFD00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#29DE0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.023890
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFD00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#44DE0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.013390
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013140
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#61DE0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.025940
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#8800060000000C
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFFA00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#7EDE0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005290
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.018170
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFFA00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#99DE0A006A590100
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
sleep_scaled 0.023810
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CCFFFA00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#B4DE0A006A590100
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
sleep_scaled 0.001710
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.023640
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFA00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#CFDE0A006A590100
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
sleep_scaled 0.022700
cansend "$CAN_IF" 7E0#37EC0A0083E50080
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.003670
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#8800090002FFF8
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFF700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#EEDE0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022270
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CFFFF700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#08DF0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.017580
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.005890
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0FFF700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#23DF0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026540
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFF700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#3FDF0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.012200
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.014420
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#8800010000000D
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#5DDF0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023470
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#78DF0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005640
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.016810
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#92DF0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026880
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#AEDF0A006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.000420
cansend "$CAN_IF" 7E0#00ED0A0083E50080
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.025860
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#880005FFFC0005
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CEFFFB00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#CCDF0A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.020310
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002040
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1FFFB00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E7DF0A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023300
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CEFFFB00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#01E00A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.019280
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.008190
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFB00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#1EE00A006A590100
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
sleep_scaled 0.027990
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFF00000000
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CC000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#3CE00A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.007340
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.012800
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CE000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#56E00A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023900
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#71E00A006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.007420
cansend "$CAN_IF" 7E0#C8ED0A0083E50080
sleep_scaled 0.000600
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019630
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#8DE00A006A590100
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
sleep_scaled 0.026540
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000260
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#8800030004FFFA
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D1FFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#ABE00A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021330
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFD00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#C5E00A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023730
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000680
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFD00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#E0E00A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027220
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1FFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#FCE00A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.015780
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.010500
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFF0000FFF2
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CE000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#1AE10A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022440
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#35E10A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.010580
cansend "$CAN_IF" 7E0#8FEE0A0083E50080
sleep_scaled 0.000860
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.012030
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000100
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#4FE10A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027220
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#6BE10A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.004520
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.021420
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88000300020000
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFFD00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#8AE10A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022280
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CCFFFD00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#A4E10A006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.000770
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.023210
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2FFFD00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#BEE10A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023220
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.003670
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D1FFFD00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#DBE10A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.025850
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88FFFD000A0005
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000300
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F8E10A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.014670
cansend "$CAN_IF" 7E0#58EF0A0083E50080
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.008280
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0000300
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#14E20A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.023550
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#2EE20A006A590100
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
sleep_scaled 0.011780
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.014510
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0000300
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#4AE20A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000340
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026370
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFF00020000
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#67E20A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.003500
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.019370
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000100
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#82E20A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.023970
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000180
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#9DE20A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000340
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.025940
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#B9E20A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.020820
cansend "$CAN_IF" 7E0#20F00A0083E50080
sleep_scaled 0.000510
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.004950
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88000100000005
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D0FFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#D7E20A006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.022700
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CDFFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#F2E20A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.015780
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001030
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.007160
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CDFFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#0CE30A006A590100
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
sleep_scaled 0.027480
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#29E30A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.009990
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.016120
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#880001FFF8FFF3
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CBFFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#46E30A006A590100
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
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.024230
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#62E30A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.003150
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.018260
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#7CE30A006A590100
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
sleep_scaled 0.027050
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CDFFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#98E30A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.003670
cansend "$CAN_IF" 7E0#EDF00A0083E50080
sleep_scaled 0.022950
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFA00030006
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#B5E30A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.018430
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.003420
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CB000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000180
cansend "$CAN_IF" 412#D1E30A006A590100
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
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023630
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D2000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#EBE30A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.017580
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.009900
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CB000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#08E40A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026540
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#88FFFE00000016
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CD000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#25E40A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.006990
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.015020
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D3000200
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#40E40A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023210
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CB000200
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#5AE40A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005890
cansend "$CAN_IF" 7E0#AFF10A0083E50080
sleep_scaled 0.000600
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.020990
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000200
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#77E40A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.025420
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFA0002FFF6
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#94E40A006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.022870
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#AFE40A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000180
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021330
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002470
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#CAE40A006A590100
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026970
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#E6E40A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.014260
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.011440
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFF00020002
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CE000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#04E50A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023210
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000100
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#1FE50A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.008870
cansend "$CAN_IF" 7E0#77F20A0083E50080
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013400
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CD000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#39E50A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.027130
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CF000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#55E50A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.003080
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.022790
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFFFFFBFFF8
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CE000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#73E50A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023210
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000100
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#8EE50A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022780
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2000100
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#A8E50A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.021590
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001030
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.004690
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000100
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000180
cansend "$CAN_IF" 412#C4E50A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026200
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFA00000005
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D2000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#E2E50A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.013230
cansend "$CAN_IF" 7E0#40F30A0083E50080
sleep_scaled 0.000340
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.009810
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000180
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#FDE50A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023810
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CF000600
sleep_scaled 0.000180
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#17E60A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.010070
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.016300
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#34E60A006A590100
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
sleep_scaled 0.026710
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#8800010004FFFB
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#52E60A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.001450
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.021840
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFFF00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000180
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#6DE60A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023120
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CEFFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#87E60A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026460
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFFF00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#A3E60A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.019460
cansend "$CAN_IF" 7E0#07F40A0083E50080
sleep_scaled 0.000600
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.006820
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#8800090001FFFE
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFF700
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#C0E60A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022190
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CEFFF700
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#DBE60A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.014500
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.008880
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0FFF700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#F6E60A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026540
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFF700
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#12E70A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000080
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.009220
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017580
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#8800040004FFF6
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CFFFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#30E70A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023890
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CDFFFC00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#4CE70A006A590100
sleep_scaled 0.000250
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
sleep_scaled 0.001960
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 121#0060EB0100000000
sleep_scaled 0.019630
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#65E70A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026190
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CFFFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#81E70A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000170
cansend "$CAN_IF" 7E0#CFF40A0083E50080
sleep_scaled 0.028420
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#8800070000FFF3
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CFFFF900
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#9FE70A006A590100
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
sleep_scaled 0.015780
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.005640
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CEFFF900
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#BBE70A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.022780
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFF900
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#D4E70A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.016300
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.011010
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D0FFF900
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#F1E70A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026960
cansend "$CAN_IF" 700#03000D01B0800002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 703#88FFFA0007FFFF
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300CE000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000180
cansend "$CAN_IF" 412#0EE80A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.005380
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.001020
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.017070
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000170
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#2AE80A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.023120
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 760#40FE5300D1000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 412#44E80A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.003420
cansend "$CAN_IF" 7E0#97F50A0083E50080
sleep_scaled 0.000930
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.022190
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CD000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#60E80A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.024230
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.002050
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88FFFAFFF8000A
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CF000600
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#7EE80A006A590100
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
sleep_scaled 0.022270
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000600
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 412#98E80A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
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
sleep_scaled 0.020130
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.003760
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0000600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000250
cansend "$CAN_IF" 412#B3E80A006A590100
sleep_scaled 0.000260
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000170
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.026970
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000250
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CE000600
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#CFE80A006A590100
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
sleep_scaled 0.013050
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.013400
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000080
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000170
cansend "$CAN_IF" 703#88000400010002
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300D0FFFC00
sleep_scaled 0.000250
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#EDE80A006A590100
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
sleep_scaled 0.022010
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000090
cansend "$CAN_IF" 701#00
sleep_scaled 0.000260
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CFFFFC00
sleep_scaled 0.000170
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000250
cansend "$CAN_IF" 412#07E90A006A590100
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
sleep_scaled 0.008700
cansend "$CAN_IF" 7E0#60F60A0083E50080
sleep_scaled 0.000350
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.015010
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000180
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300CCFFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000170
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#22E90A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.028070
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000180
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 760#40FE5300D4FFFC00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000250
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000260
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 412#3FE90A006A590100
sleep_scaled 0.000250
cansend "$CAN_IF" 413#0001050000000000
sleep_scaled 0.000260
cansend "$CAN_IF" 593#0000000000000000
sleep_scaled 0.000250
cansend "$CAN_IF" 7BC#00010000000000
sleep_scaled 0.000090
cansend "$CAN_IF" 7BD#28170C
sleep_scaled 0.000680
cansend "$CAN_IF" 122#0000000800000000
sleep_scaled 0.000940
cansend "$CAN_IF" 110#0000000000000000
sleep_scaled 0.024750
cansend "$CAN_IF" 700#03000D01B1810002
sleep_scaled 0.000170
cansend "$CAN_IF" 701#00
sleep_scaled 0.000170
cansend "$CAN_IF" 727#FE00FE00FE00FE00
sleep_scaled 0.000250
cansend "$CAN_IF" 703#8800010000FFEE
sleep_scaled 0.000260
cansend "$CAN_IF" 760#40FE5300CCFFFF00
sleep_scaled 0.000260
cansend "$CAN_IF" 410#3131323230343731
sleep_scaled 0.000170
cansend "$CAN_IF" 123#0000000000000080
sleep_scaled 0.000250
cansend "$CAN_IF" 124#0000000008000C03
sleep_scaled 0.000260
cansend "$CAN_IF" 411#3330533030303338
sleep_scaled 0.000260
cansend "$CAN_IF" 412#5CE90A006A590100

echo "Done."