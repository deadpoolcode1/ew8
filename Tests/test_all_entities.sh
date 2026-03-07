#!/bin/bash
###############################################################################
# test_all_entities.sh — Comprehensive CAN test script for EW8 frontends
#
# Sends CAN messages to trigger every display entity, covering all 10
# categories from the audit plan. Run both Qt and LVGL frontends against
# the same CAN bus and compare visually.
#
# Usage:  ./test_all_entities.sh [can_interface] [delay] [flags]
#   can_interface: defaults to "can0" (use "vcan0" for virtual CAN)
#   delay:         seconds between test steps (default 2)
#   flags:
#     -t    Enable signal/peripheral test sections (app must run with -t)
#     -r    Review mode: pause after each step for manual inspection.
#           Type an issue description and press Enter, or just Enter for OK.
#           Generates a timestamped report file in the current directory.
#
# Examples:
#   ./test_all_entities.sh can0 2           # auto mode, skip test screens
#   ./test_all_entities.sh can0 2 -r        # review mode with report
#   ./test_all_entities.sh can0 2 -t        # include test screen sections
#   ./test_all_entities.sh can0 2 "-t -r"   # review + test screens
#
# IMPORTANT: Each CAN frame carries ALL signals for that message ID.
# When a frame is sent, ALL bits are processed — zeroed bits deactivate
# their entities. Therefore we maintain "base" frames with safe defaults
# and OR test-specific bits on top.
#
# Prerequisites:
#   - can-utils installed (cansend)
#   - CAN interface up:  sudo ip link set up type vcan dev vcan0
###############################################################################

CAN=${1:-can0}
DELAY=${2:-2}
FLAGS=${3:-}

# Parse flags
TEST_MODE=""
REVIEW_MODE=""
for flag in $FLAGS; do
    case "$flag" in
        -t) TEST_MODE="-t" ;;
        -r) REVIEW_MODE="-r" ;;
    esac
done

RED='\033[0;31m'
GRN='\033[0;32m'
YEL='\033[1;33m'
CYN='\033[0;36m'
NC='\033[0m'

step=0
step_name=""
issues_found=0
total_reviewed=0

# Report file (only in review mode)
if [ -n "$REVIEW_MODE" ]; then
    REPORT_FILE="test_report_$(date +%Y%m%d_%H%M%S).txt"
    echo "EW8 Entity Test Report — $(date)" > "$REPORT_FILE"
    echo "CAN interface: $CAN" >> "$REPORT_FILE"
    echo "========================================" >> "$REPORT_FILE"
    echo ""
    echo -e "${GRN}Review mode enabled. Report will be saved to: ${REPORT_FILE}${NC}"
fi

send() {
    cansend "$CAN" "$1"
}

pause() {
    if [ -n "$REVIEW_MODE" ]; then
        review_step
    else
        sleep "$DELAY"
    fi
}

short_pause() {
    if [ -n "$REVIEW_MODE" ]; then
        sleep 0.3
    else
        sleep 0.5
    fi
}

review_step() {
    echo ""
    echo -e "  ${CYN}Enter issue (or press Enter for OK):${NC} "
    read -r feedback
    total_reviewed=$((total_reviewed + 1))
    if [ -z "$feedback" ]; then
        echo -e "  ${GRN}[OK]${NC}"
        echo "Step $step: $step_name — OK" >> "$REPORT_FILE"
    else
        issues_found=$((issues_found + 1))
        echo -e "  ${RED}[ISSUE] $feedback${NC}"
        echo "Step $step: $step_name — ISSUE: $feedback" >> "$REPORT_FILE"
    fi
}

announce() {
    step=$((step + 1))
    step_name="$1"
    echo ""
    echo -e "${CYN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YEL}  Step $step: $1${NC}"
    echo -e "${CYN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

section() {
    echo ""
    echo -e "${GRN}═══════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GRN}  SECTION: $1${NC}"
    echo -e "${GRN}═══════════════════════════════════════════════════════════════════${NC}"
}

info() {
    echo -e "  ${NC}$1${NC}"
}

###############################################################################
# CAN Message ID Reference (from DBC files):
#
#   0x412 (1042) - IMS_Status_Protocol_System (keepalive)
#   0x413 (1043) - IMS_Connectivity (GSM/GPS/Gyro status + peripheral tests)
#   0x700 (1792) - AfterMarket AWS (ADAS alerts, LDW, FCW, HMW, beams, etc.)
#   0x727 (1831) - Vision_Only_TSR_continuous (4 sign slots, 2 bytes each)
#   0x760 (1888) - CarInfo (speed, brakes, blinkers, wipers, highbeam)
#   0x761 (1889) - SignalTest (test status for each signal)
#   0x7AC (1964) - EW8TestProtocol (RGB, TV pattern, debug)
#   0x7BC (1980) - IMS_ISA (ISA state, legal speed, overspeed)
#   0x7BD (1981) - IMS_ISA_Version (version + bundle)
#   0x593 (1427) - IMS_SmartADAS_Restricted (SADAS icons)
#   0x632 (1586) - VolumeReply (volume value, min, max)
#   0x410 (1040) - SeeQInfo Part1 (serial number)
#   0x411 (1041) - SeeQInfo Part2 (serial number)
###############################################################################

###############################################################################
# 0x700 — AfterMarket AWS byte layout (little-endian @1+):
#
#   byte0: [2:0]=Sound_type, [4:3]=time_indicator, [6:5]=SoundRepeat, [7]=SoundSuppressed
#   byte1: [2:0]=Secondary_Diagnostic, [3]=TSR_Shape, [4]=SLI_Alert,
#          [5]=Zero_speed, [6]=Hi_Low_BeamControl, [7]=FLA_Armed
#   byte2: [0]=Headway_valid, [7:1]=Headway_measurement
#   byte3: [0]=Error_Active, [7:1]=Error_code
#   byte4: [0]=LDW_Left_Lane_Not_Available, [1]=LLDW_on, [2]=RLDW_on,
#          [3]=FCW_on, [4]=SpeedIndication, [5]=ShowTamperAlert,
#          [6]=Maintenance, [7]=Fail_safe
#   byte5: [0]=LDW_Right_Lane_Not_Available, [1..2]=PCW_PedDZ,
#          [3]=Blinker_Reminder, [4]=cyclist, [5]=TamperAlert,
#          [6]=Speed_format, [7]=TSR_enabbled
#   byte6: [2:0]=TSR_warning_level, [4:3]=Failsafe_Level, [7:5]=FCW_X_Active
#   byte7: [1:0]=HW_Warning_level, [2]=HW_repeatable_enabled,
#          [4:3]=TrafficLightWarning, [7:5]=PCW_X_Active
#
# CRITICAL: Error_Active=0 with inverted action ACTIVATES ALERT_ERROR!
#           Must always set Error_Active=1 (byte3 bit0) to suppress error overlay.
#
#           LDW_*_Not_Available=0 with inverted action activates LDWON.
#           Set byte4 bit0=1 and byte5 bit0=1 to suppress lane lines when unwanted.
#
# 0x760 — CarInfo byte layout:
#   byte0: bit0=Brakes, bit1=Left_blink, bit2=Right_blink, bit3=Wipers,
#          bit4=Reverse_Gear, bit5=HighBeam
#   byte1: bit8=Brakes_avail, bit9=Left_blink_avail, bit10=Right_blink_avail,
#          bit11=Wipers_avail, bit12=Reverse_avail, bit13=HighBeam_avail,
#          bit14=Gyro_avail, bit15=Speed_availabled
#   byte2: Speed (8-bit, km/h)
#
# 0x7BC — IMS_ISA byte layout:
#   byte0: ISA_Legal_Speed (8-bit)
#   byte1: [5:0]=VehicleType, [7:6]=VehicleClass
#   byte2: [1:0]=Legal_Speed_Validity, [6:4]=ISA_STATE_Value
#   byte3: [2:0]=ISA_SLWF, [6:4]=ISA_SLIF
#   byte4: suspenededSpeed
#   byte5: IMS_ISA_Error
#
# 0x727 — Vision_Only_TSR_continuous:
#   byte0/1: D1 sign/supp, byte2/3: D2, byte4/5: D3, byte6/7: D4
#
# 0x412 — IMS_Status_Protocol_System:
#   byte0-3: Uptime, byte4-5: SessionId
#   byte6: [3:0]=RunningMode, [7:4]=Present_app
#   byte7: [3:0]=Driver_mode, [6:4]=Driver_assignment, [7]=Validity(0=valid)
###############################################################################

###############################################################################
# BASE FRAMES — safe defaults that suppress unwanted entities
###############################################################################

# 0x700 base: Error_Active=1(byte3=0x01), LDW_Left_Not_Avail=1(byte4=0x01),
#             LDW_Right_Not_Avail=1(byte5=0x01)
# This ensures: no error overlay, no LDW-on lanes by default
BASE_700="0000010101000000"

# 0x760 base: Speed_availabled=1(byte1=0x80)
BASE_760="0080000000000000"

# 0x7BC base: all zeros (ISA disabled by default)
BASE_7BC="000000000000"

# 0x727 base: all zeros (no signs)
BASE_727="0000000000000000"

# Helper: build 0x412 keepalive frame
# Args: RunningMode(0-4) Present_app(0-3) Driver_assignment(0-3) Validity(0=valid)
build_keepalive() {
    local mode=${1:-1}
    local app=${2:-0}
    local drvassign=${3:-0}
    local validity=${4:-0}
    local byte6=$(printf "%02X" $(( (mode & 0x0F) | ((app & 0x0F) << 4) )))
    local byte7=$(printf "%02X" $(( (drvassign << 4) | (validity << 7) )))
    echo "412#00000000AB42${byte6}${byte7}"
}

# Send keepalive (normal mode, valid)
keepalive() {
    send "$(build_keepalive 1 0 0 0)"
}

# Send all base frames — resets display to clean state
send_base() {
    send "700#${BASE_700}"
    send "760#${BASE_760}"
    send "7BC#${BASE_7BC}"
    send "727#${BASE_727}"
    send "593#0000000000000000"
    send "413#0000000000000000"
    send "761#0000000000000000"
    send "7AC#0000000000000000"
    keepalive
}

# Clear all and wait
clear_all() {
    info "Clearing all signals..."
    send_base
    short_pause
}

###############################################################################
echo -e "${RED}╔═══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${RED}║     EW8 Comprehensive Entity Test Script                        ║${NC}"
echo -e "${RED}║     CAN interface: $CAN                                         ║${NC}"
echo -e "${RED}║     Delay between steps: ${DELAY}s                                     ║${NC}"
echo -e "${RED}╚═══════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Press ENTER to start, Ctrl+C to abort..."
read -r

###############################################################################
# SECTION 0: KEEPALIVE — Establish connection
###############################################################################
section "0. KEEPALIVE — Establish Connection"

announce "Send keepalive (normal mode, valid) + base frames"
info "0x412: RunningMode=1(Normal), Validity=0(valid)"
info "0x700: Error_Active=1 (suppress error), LDW not avail=1 (suppress lanes)"
send_base
pause

announce "Verify disconnect overlay appears when keepalive stops"
info "NOT sending keepalive — disconnect overlay should appear after timeout"
info "(Timeout=20s, waiting ${DELAY}s — increase delay or wait longer to see it)"
pause

announce "Re-establish keepalive"
send_base
pause

###############################################################################
# SECTION 1: STATUS BAR ICONS
###############################################################################
section "1. STATUS BAR ICONS"

clear_all

# --- Hi Beam ---
announce "ALERT_HI_BEAM — High beam ON"
info "0x700: FLA_Armed=1(bit15), Hi_Low_BeamControl=1(bit14), time_indicator=1(bit3)"
info "  byte0=0x08(time=1), byte1=0xC0(FLA+HiLo), byte3=0x01(Error_Active)"
info "  byte4=0x01(LDW_Left_NA), byte5=0x01(LDW_Right_NA)"
send "700#08C0010101000000"
keepalive
pause

announce "ALERT_LOW_BEAM — Low beam ON (Hi_Low_BeamControl=0, inverted)"
info "0x700: FLA_Armed=1, Hi_Low_BeamControl=0, time_indicator=1"
send "700#0880010101000000"
keepalive
pause

# --- Blinkers ---
announce "ALERT_BLINKERS — Blinker reminder ON"
info "0x700: Blinker_Reminder=1(bit43)=>byte5 bit3"
info "  byte5=0x01|0x08=0x09"
send "700#0000010109000000"
keepalive
pause

# --- No GSM ---
announce "INFO_NO_GSM — GSM disconnected (CellularCommunicationStatus=2)"
info "0x413: byte2 bits[3:0]=2 => byte2=0x02"
send "413#0000020000000000"
send "700#${BASE_700}"
keepalive
pause

announce "INFO_NO_GSM — GSM critical error (CellularCommunicationStatus=4)"
send "413#0000040000000000"
send "700#${BASE_700}"
keepalive
pause

announce "Clear GSM status"
send "413#0000000000000000"
keepalive
pause

# --- Driver Auth ---
announce "INFO_DRIVER_AUTH_OUT — Driver not assigned"
info "0x412: Driver_assignment=1(not_assigned)"
send "$(build_keepalive 1 0 1 0)"
send "700#${BASE_700}"
pause

announce "INFO_DRIVER_AUTH_PROCESS — Assignment in process"
send "$(build_keepalive 1 0 2 0)"
send "700#${BASE_700}"
pause

announce "INFO_DRIVER_AUTH_IN — Driver assigned"
send "$(build_keepalive 1 0 3 0)"
send "700#${BASE_700}"
pause

# Reset to no driver auth
keepalive
pause

# --- ISA status icons ---
announce "INFO_ISA_INACTIVE — ISA full deactivation (STATE=1)"
info "0x7BC: ISA_STATE_Value=1 => byte2 bits[6:4]=001 => byte2=0x10"
send "7BC#000010000000"
send "700#${BASE_700}"
keepalive
pause

announce "INFO_ISA_PARTIAL — ISA partial deactivation (STATE=2)"
send "7BC#000020000000"
send "700#${BASE_700}"
keepalive
pause

announce "INFO_ISA_FULL_ACTIVE — ISA active (STATE=3)"
send "7BC#000030000000"
send "700#${BASE_700}"
keepalive
pause

announce "ALERT_ISA_ERROR — ISA error (STATE=4)"
send "7BC#000040000000"
send "700#${BASE_700}"
keepalive
pause

clear_all

###############################################################################
# SECTION 2: SPEED DISPLAY
###############################################################################
section "2. SPEED DISPLAY"

announce "INFO_VEH_SPEED — Speed 0 km/h"
info "0x760: Speed_availabled=1(byte1=0x80), Speed=0"
send "760#0080000000000000"
send "700#${BASE_700}"
keepalive
pause

announce "INFO_VEH_SPEED — Speed 60 km/h"
send "760#00803C0000000000"
send "700#${BASE_700}"
keepalive
pause

announce "INFO_VEH_SPEED — Speed 120 km/h"
send "760#0080780000000000"
send "700#${BASE_700}"
keepalive
pause

announce "Speed cycling 0 → 120 km/h"
for spd in 0 20 40 60 80 100 120; do
    local_hex=$(printf "%02X" $spd)
    info "  Speed = $spd km/h"
    send "760#0080${local_hex}0000000000"
    send "700#${BASE_700}"
    keepalive
    short_pause
done
pause

clear_all

###############################################################################
# SECTION 3: HMW (Headway Monitoring Warning)
###############################################################################
section "3. HMW STATES"

announce "ALERT_HMW_MONITOR — Monitor mode, distance=1.2s"
info "0x700: HW_Warning_level=1(byte7=0x01), Headway_valid=1+measurement=12"
info "  byte2=(12<<1)|1=0x19, byte3=0x01, byte4=0x01, byte5=0x01"
send "700#0000190101010001"
send "760#0080500000000000"
keepalive
pause

announce "ALERT_HMW_MONITOR — Distance=0.6s"
info "  byte2=(6<<1)|1=0x0D"
send "700#00000D0101010001"
send "760#0080500000000000"
keepalive
pause

announce "ALERT_HMW_ALERT — Alert mode (red road)"
info "0x700: HW_Warning_level=2(byte7=0x02)"
send "700#0000190101010002"
send "760#0080500000000000"
keepalive
pause

announce "ALERT_HMW_DISTANCE — Distance=1.8s text"
info "  byte2=(18<<1)|1=0x25"
send "700#0000250101010001"
send "760#0080500000000000"
keepalive
pause

clear_all

###############################################################################
# SECTION 4: LDW (Lane Departure Warning)
###############################################################################
section "4. LDW VARIANTS"

announce "ALERT_LEFT_LDWOFF — Left lane not available (yellow left)"
info "0x700: LDW_Left_NA=1(byte4 bit0=1), LDW_Right_NA=1(byte5 bit0=1)"
info "  This is the base state — both yellow"
send "700#${BASE_700}"
keepalive
pause

announce "ALERT_LEFT_LDWON — Left lane available (green left, yellow right)"
info "0x700: LDW_Left_NA=0(byte4 bit0=0), LDW_Right_NA=1(byte5 bit0=1)"
send "700#0000010100010000"
keepalive
pause

announce "ALERT_RIGHT_LDWON — Right lane available (yellow left, green right)"
info "0x700: LDW_Left_NA=1(byte4 bit0=1), LDW_Right_NA=0(byte5 bit0=0)"
send "700#0000010101000000"
keepalive
pause

announce "Both LDWON — Both lanes available (green+green)"
info "0x700: LDW_Left_NA=0, LDW_Right_NA=0"
send "700#0000010100000000"
keepalive
pause

announce "ALERT_LLDW — Left LDW active alert (blinking left)"
info "0x700: LLDW_on=1(byte4 bit1) => byte4=0x02"
send "700#0000010102000000"
keepalive
pause

announce "ALERT_RLDW — Right LDW active alert (blinking right)"
info "0x700: RLDW_on=1(byte4 bit2) => byte4=0x04"
send "700#0000010104000000"
keepalive
pause

announce "Both LDW alerts simultaneously"
info "LLDW+RLDW => byte4=0x06"
send "700#0000010106000000"
keepalive
pause

clear_all

###############################################################################
# SECTION 5: FCW / PCW / PDZ
###############################################################################
section "5. FCW / PCW / PDZ"

announce "ALERT_FCW — Forward Collision Warning"
info "0x700: FCW_on=1(byte4 bit3) => byte4=0x01|0x08=0x09"
send "700#0000010109010000"
send "760#0080500000000000"
keepalive
pause

announce "Clear FCW"
send "700#${BASE_700}"
keepalive
pause

announce "ALERT_PCW — Pedestrian Collision Warning (PCW_PedDZ=1)"
info "0x700: PCW_PedDZ=1 => byte5 bits[2:1]=01 => byte5=0x01|0x02=0x03"
send "700#0000010101030000"
keepalive
pause

announce "ALERT_PDZ — Pedestrian in Danger Zone (PCW_PedDZ=2)"
info "0x700: PCW_PedDZ=2 => byte5 bits[2:1]=10 => byte5=0x01|0x04=0x05"
send "700#0000010101050000"
keepalive
pause

announce "ALERT_PCW — PCW value=3 (also PCW)"
info "PCW_PedDZ=3 => byte5=0x01|0x06=0x07"
send "700#0000010101070000"
keepalive
pause

clear_all

###############################################################################
# SECTION 6: LEFT PANEL SIGNS (SLI + TSR)
###############################################################################
section "6. LEFT PANEL SIGNS (SLI + TSR)"

# TSR signs use Vision_Only_TSR_continuous (0x727)
# TSR_enabbled must be set in 0x700 (byte5 bit7)
# 0x700 base with TSR: byte5=0x01|0x80=0x81

announce "Enable TSR — show SLI 50 km/h"
info "0x727: D1 Sign_Type=4 (SLI 50)"
info "0x700: TSR_enabbled=1 => byte5=0x81"
send "700#0000010101810000"
send "727#0400000000000000"
keepalive
pause

announce "ALERT_SLI — Speed limit 80 km/h (value=7)"
send "727#0700000000000000"
send "700#0000010101810000"
keepalive
pause

announce "ALERT_SLI — Speed limit 130 km/h (value=12)"
send "727#0C00000000000000"
send "700#0000010101810000"
keepalive
pause

announce "ALERT_SLI — Speed limit 5 km/h (value=100=0x64)"
send "727#6400000000000000"
send "700#0000010101810000"
keepalive
pause

announce "ALERT_SLI — Electronic sign 60 (value=33=0x21)"
send "727#2100000000000000"
send "700#0000010101810000"
keepalive
pause

announce "ALERT_SLI + ALERT_SLI_SUPP — SLI 60 + supp 60"
info "D1: sign=5(SLI 60), supp=5(SLI_SUPP 60)"
send "727#0505000000000000"
send "700#0000010101810000"
keepalive
pause

announce "ALERT_MOTORWAY — Motorway sign (value=173=0xAD)"
send "727#AD00000000000000"
send "700#0000010101810000"
keepalive
pause

announce "ALERT_MOTORWAY_END — End of motorway (174=0xAE)"
send "727#AE00000000000000"
send "700#0000010101810000"
keepalive
pause

announce "ALERT_EXPRESSWAY — Expressway (171=0xAB)"
send "727#AB00000000000000"
send "700#0000010101810000"
keepalive
pause

announce "ALERT_EXPRESSWAY_END — End of expressway (172=0xAC)"
send "727#AC00000000000000"
send "700#0000010101810000"
keepalive
pause

announce "ALERT_PLAYGROUND — Playground zone (175=0xAF)"
send "727#AF00000000000000"
send "700#0000010101810000"
keepalive
pause

announce "ALERT_PLAYGROUND_END — End playground (176=0xB0)"
send "727#B000000000000000"
send "700#0000010101810000"
keepalive
pause

announce "ALERT_NO_PASS — No passing (200=0xC8)"
send "727#C800000000000000"
send "700#0000010101810000"
keepalive
pause

announce "ALERT_NO_PASS_END — End no passing (201=0xC9)"
send "727#C900000000000000"
send "700#0000010101810000"
keepalive
pause

announce "ALERT_END_ALL_RESTR — End all restrictions (64=0x40)"
send "727#4000000000000000"
send "700#0000010101810000"
keepalive
pause

announce "Multiple signs: SLI 50 (D1) + Motorway (D2)"
info "byte0=0x04(SLI 50), byte2=0xAD(Motorway)"
send "727#0400AD0000000000"
send "700#0000010101810000"
keepalive
pause

announce "ISA speed sign — 80 km/h (via 0x7BC)"
info "0x7BC: ISA_Legal_Speed=80(0x50), ISA_STATE=3(active), Legal_Speed_Validity=2"
info "  byte0=0x50, byte2=(3<<4)|2=0x32"
send "7BC#500032000000"
send "700#0000010101810000"
keepalive
pause

announce "ISA highway sign (Legal_Speed_Validity=3)"
send "7BC#500033000000"
send "700#0000010101810000"
keepalive
pause

announce "Clear signs"
send "727#0000000000000000"
send "7BC#${BASE_7BC}"
send "700#${BASE_700}"
keepalive
pause

clear_all

###############################################################################
# SECTION 7: RIGHT PANEL SADAS (Smart ADAS)
###############################################################################
section "7. RIGHT PANEL SADAS (Smart ADAS)"

announce "SMART_CROWDED — Crowd zone (FirstIcon=1)"
send "593#0100000000000000"
send "700#${BASE_700}"
keepalive
pause

announce "SMART_PED_HWY — Pedestrian on highway (2)"
send "593#0200000000000000"
send "700#${BASE_700}"
keepalive
pause

announce "SMART_CYC_HWY — Cyclist on highway (3)"
send "593#0300000000000000"
send "700#${BASE_700}"
keepalive
pause

announce "SMART_WEA_ROAD — Weather: Road (4)"
send "593#0400000000000000"
send "700#${BASE_700}"
keepalive
pause

announce "SMART_WEA_HYDRO — Weather: Hydroplaning (5)"
send "593#0500000000000000"
send "700#${BASE_700}"
keepalive
pause

announce "SMART_WEA_FG — Weather: Fog (6)"
send "593#0600000000000000"
send "700#${BASE_700}"
keepalive
pause

announce "SMART_WEA_WND — Weather: Wind (7)"
send "593#0700000000000000"
send "700#${BASE_700}"
keepalive
pause

announce "SMART_WEA_HAIL — Weather: Hail (8)"
send "593#0800000000000000"
send "700#${BASE_700}"
keepalive
pause

announce "SMART_WEA_TSTM — Weather: Thunderstorm (9)"
send "593#0900000000000000"
send "700#${BASE_700}"
keepalive
pause

announce "SMART_HARSH_DZ — Harsh braking zone (12=0x0C)"
send "593#0C00000000000000"
send "700#${BASE_700}"
keepalive
pause

announce "SMART_CA — Construction area (14=0x0E)"
send "593#0E00000000000000"
send "700#${BASE_700}"
keepalive
pause

announce "Two SADAS: Crowd(1) + Pedestrian(2)"
info "byte0=1(First), byte1=2(Second)"
send "593#0102000000000000"
send "700#${BASE_700}"
keepalive
pause

announce "Two SADAS: Construction(14) + Fog(6)"
send "593#0E06000000000000"
send "700#${BASE_700}"
keepalive
pause

clear_all

###############################################################################
# SECTION 8: RTW (Red Traffic Light Warning)
###############################################################################
section "8. RTW (Red Traffic Light Warning)"

announce "ALERT_RTW_WARN — Warning (TrafficLightWarning=1)"
info "0x700: byte7 bits[4:3]=01 => byte7=0x08"
send "700#0000010101010008"
keepalive
pause

announce "ALERT_RTW_ALERT — Alert (TrafficLightWarning=2)"
info "byte7 bits[4:3]=10 => byte7=0x10"
send "700#0000010101010010"
keepalive
pause

announce "ALERT_RTW_ALERT — Alert (TrafficLightWarning=3)"
info "byte7 bits[4:3]=11 => byte7=0x18"
send "700#0000010101010018"
keepalive
pause

clear_all

###############################################################################
# SECTION 9: OVERLAYS (Error, Failsafe, Op Modes)
###############################################################################
section "9. OVERLAYS"

announce "ALERT_ERROR — Error overlay"
info "0x700: Error_Active=0(byte3 bit0=0), TamperAlert=1(byte5 bit5=0x20)"
info "  ShowTamperAlert=1(byte4 bit5=0x20)"
info "  byte3=0x00, byte4=0x21, byte5=0x21"
send "700#0000000021210000"
keepalive
pause

announce "Clear error — restore Error_Active=1"
send "700#${BASE_700}"
keepalive
pause

announce "INFO_FAILSAFE — Failsafe overlay"
info "0x700: Fail_safe=1(byte4 bit7) => byte4=0x01|0x80=0x81"
send "700#0000010181010000"
keepalive
pause

announce "Clear failsafe"
send "700#${BASE_700}"
keepalive
pause

announce "OM_POWEROFF — Operation mode: Power off (RunningMode=0)"
send "$(build_keepalive 0 0 0 0)"
send "700#${BASE_700}"
pause

announce "OM_NORMAL — Operation mode: Normal (RunningMode=1)"
send "$(build_keepalive 1 0 0 0)"
send "700#${BASE_700}"
pause

announce "OM_MUTE — Operation mode: Mute (RunningMode=2)"
send "$(build_keepalive 2 0 0 0)"
send "700#${BASE_700}"
pause

announce "OM_KEEPPWR — Operation mode: Keep power (RunningMode=3)"
send "$(build_keepalive 3 0 0 0)"
send "700#${BASE_700}"
pause

announce "OM_PILOT — Operation mode: Pilot (RunningMode=4)"
send "$(build_keepalive 4 0 0 0)"
send "700#${BASE_700}"
pause

# Restore normal mode
keepalive
pause

clear_all

###############################################################################
# SECTION 10: TEST SCREENS (RGB, TV, Signal, Peripheral)
###############################################################################
section "10. TEST SCREENS"

announce "RGB_RED — Full screen red (TestDisplay=1)"
info "0x7AC: byte1 bits[2:0]=001 => byte1=0x01"
send "7AC#0001000000000000"
send "700#${BASE_700}"
keepalive
pause

announce "RGB_GREEN — Full screen green (TestDisplay=2)"
send "7AC#0002000000000000"
send "700#${BASE_700}"
keepalive
pause

announce "RGB_BLUE — Full screen blue (TestDisplay=3)"
send "7AC#0003000000000000"
send "700#${BASE_700}"
keepalive
pause

announce "RGB_WHITE — Full screen white (TestDisplay=4)"
send "7AC#0004000000000000"
send "700#${BASE_700}"
keepalive
pause

announce "TV_PATTERN — SMPTE test pattern (TestDisplay=5)"
send "7AC#0005000000000000"
send "700#${BASE_700}"
keepalive
pause

announce "Clear test display"
send "7AC#0000000000000000"
keepalive
pause

# --- Signal Test Screen ---
# NOTE: Present_app=2/3 triggers SwitchModeTest→exit(0) in normal mode.
# These test sections require the app to be started with -t flag.
if [ -n "$TEST_MODE" ]; then

announce "INFO_TEST_SIGNALS — Enter signal test mode"
info "0x412: Present_app=2(Signals_Test)"
send "$(build_keepalive 1 2 0 0)"
send "700#${BASE_700}"
pause

announce "TEST_BRAKES — Brakes: IN_TEST (1)"
info "0x761: Brake_Test_Status(bits[19:18])=1 => byte2 bits[3:2]=01 => byte2=0x04"
send "761#0000040000000000"
send "$(build_keepalive 1 2 0 0)"
send "700#${BASE_700}"
pause

announce "TEST_BRAKES — Brakes: PASS (2)"
send "761#0000080000000000"
send "$(build_keepalive 1 2 0 0)"
send "700#${BASE_700}"
pause

announce "TEST_BRAKES — Brakes: FAIL (3)"
send "761#00000C0000000000"
send "$(build_keepalive 1 2 0 0)"
send "700#${BASE_700}"
pause

announce "TEST_SPEED — Speed: PASS (2)"
info "0x761: Speed_Test_Status(bits[9:8])=2 => byte1 bits[1:0]=10 => byte1=0x02"
send "761#0002000000000000"
send "$(build_keepalive 1 2 0 0)"
send "700#${BASE_700}"
pause

announce "TEST_HIGH_BEAM — High beam: PASS (2)"
info "0x761: High_Beam_Test_Status(bits[17:16])=2 => byte2 bits[1:0]=10 => byte2=0x02"
send "761#0000020000000000"
send "$(build_keepalive 1 2 0 0)"
send "700#${BASE_700}"
pause

announce "TEST_BLINKER_LEFT — Left blinker: IN_TEST (1)"
info "0x761: bits[15:14]=01 => byte1 bits[7:6]=01 => byte1=0x40"
send "761#0040000000000000"
send "$(build_keepalive 1 2 0 0)"
send "700#${BASE_700}"
pause

announce "TEST_BLINKER_RIGHT — Right blinker: PASS (2)"
info "0x761: bits[13:12]=10 => byte1 bits[5:4]=10 => byte1=0x20"
send "761#0020000000000000"
send "$(build_keepalive 1 2 0 0)"
send "700#${BASE_700}"
pause

announce "TEST_REVERSE — Reverse: FAIL (3)"
info "0x761: bits[11:10]=11 => byte1 bits[3:2]=11 => byte1=0x0C"
send "761#000C000000000000"
send "$(build_keepalive 1 2 0 0)"
send "700#${BASE_700}"
pause

announce "TEST_WIPERS — Wipers: PASS (2)"
info "0x761: bits[21:20]=10 => byte2 bits[5:4]=10 => byte2=0x20"
send "761#0000200000000000"
send "$(build_keepalive 1 2 0 0)"
send "700#${BASE_700}"
pause

announce "All signal tests — mixed results"
info "Speed=PASS(2),Reverse=FAIL(3),BlinkerR=PASS(2),BlinkerL=IN_TEST(1)"
info "HighBeam=PASS(2),Brake=FAIL(3),Wipers=PASS(2)"
info "byte1=0b01_10_11_10=0x6E, byte2=0b00_10_11_10=0x2E"
send "761#006E2E0000000000"
send "$(build_keepalive 1 2 0 0)"
send "700#${BASE_700}"
pause

# --- Peripheral Test Screen ---
announce "INFO_TEST_PERIPHERALS — Enter peripheral test mode"
info "0x412: Present_app=3(Peripherals_Test)"
send "$(build_keepalive 1 3 0 0)"
send "700#${BASE_700}"
pause

announce "INFO_TEST_GSM — GSM test: PASS, status=GSM_ENABLED"
info "0x413: GSMTestResult=0(PASS)(bits[33:32])=byte4[1:0]=0"
info "       GSMTestStatus=1(GSM_ENABLED)(bits[37:34])=byte4[5:2]=0001 => 0x04"
send "413#0000000004000000"
send "$(build_keepalive 1 3 0 0)"
send "700#${BASE_700}"
pause

announce "INFO_TEST_GPS — GPS test: PASS, status=GPS_LOCKED"
info "0x413: GPSTestResult=0(bits[39:38])=byte4[7:6]=0"
info "       GPSTestStatus=3(GPS_LOCKED)(bits[42:40])=byte5[2:0]=011 => 0x03"
send "413#0000000000030000"
send "$(build_keepalive 1 3 0 0)"
send "700#${BASE_700}"
pause

announce "INFO_TEST_GYRO — Gyro test: FAIL, status=GYRO_VALUE_RANGE"
info "0x413: GyroTestResult=1(FAIL)(bits[29:28])=byte3[5:4]=01 => 0x10"
info "       GyroTestStatus=2(GYRO_VALUE_RANGE)(bits[31:30])=byte3[7:6]=10 => 0x80"
info "       byte3=0x10|0x80=0x90"
send "413#0000009000000000"
send "$(build_keepalive 1 3 0 0)"
send "700#${BASE_700}"
pause

announce "Return to normal mode"
send "$(build_keepalive 1 0 0 0)"
send "761#0000000000000000"
send "413#0000000000000000"
send "700#${BASE_700}"
pause

clear_all

else
    echo ""
    echo -e "${YEL}  SKIPPED: Signal/Peripheral test sections (require app started with -t flag)${NC}"
    echo -e "${YEL}  Run:  ./test_all_entities.sh $CAN $DELAY -t${NC}"
    echo ""
fi

###############################################################################
# SECTION 11: MENU TRIGGERS (Volume, QR Code)
###############################################################################
section "11. MENU TRIGGERS"

announce "VOLUME_DONE — Volume menu: value=3, min=0, max=5"
info "0x632: Reply_status=1(done)(byte2[1:0]=01)=0x01"
info "       New_general_volume_value=3(byte3), min=0(byte4), max=5(byte5)"
send "632#000001030005FFFF"
send "700#${BASE_700}"
keepalive
pause

announce "VOLUME_FAIL — Volume fail (Reply_status=0)"
send "632#000000000000FFFF"
send "700#${BASE_700}"
keepalive
pause

announce "INFO_QRCODE — QR code display (Zero_speed=1)"
info "0x700: Zero_speed=1(bit13)=>byte1 bit5 => byte1=0x20"
info "  byte3=0x01(Error_Active), byte4=0x01(LDW_L), byte5=0x01(LDW_R)"
send "700#0020010101010000"
keepalive
pause

announce "Clear QR code"
send "700#${BASE_700}"
keepalive
pause

clear_all

###############################################################################
# SECTION 12: ISA OVERSPEED
###############################################################################
section "12. ISA OVERSPEED"

announce "ALERT_ISA_OVERSPEED — Blink (ISA_SLWF=2)"
info "0x7BC: ISA_Legal_Speed=80(0x50), ISA_STATE=3(byte2[6:4]=011)"
info "       Legal_Speed_Validity=2(byte2[1:0]=10) => byte2=0x32"
info "       ISA_SLWF=2(byte3[2:0]=010) => byte3=0x02"
send "7BC#500032020000"
send "700#0000010101810000"
keepalive
pause

announce "ALERT_ISA_OVERSPEED — With sound (ISA_SLWF=3)"
send "7BC#500032030000"
send "700#0000010101810000"
keepalive
pause

clear_all

###############################################################################
# SECTION 13: ISA/TSR STATE MACHINE
###############################################################################
section "13. ISA/TSR STATE MACHINE"

announce "STATE_ISA_NOT_TSR — ISA available (ISA_STATE != 0, inverted)"
info "0x7BC: ISA_STATE_Value=1(FULL_DEACT) => byte2=0x10"
send "7BC#000010000000"
send "700#${BASE_700}"
keepalive
pause

announce "STATE_TSR_NOT_ISA — TSR mode (ISA_STATE=0)"
send "7BC#000000000000"
send "700#${BASE_700}"
keepalive
pause

clear_all

###############################################################################
# SECTION 14: COMBINED SCENARIOS
###############################################################################
section "14. COMBINED SCENARIOS (Priority/Overlap Tests)"

announce "Speed 80 + HMW monitor + SLI 80 + SADAS Crowd"
info "All coexist in mainPanel"
send "700#0000190101810001"
send "727#0700000000000000"
send "593#0100000000000000"
send "760#0080500000000000"
keepalive
pause

announce "FCW overlay on top of everything"
info "FCW_on=1 => byte4 bit3 => byte4=0x01|0x08=0x09"
send "700#0000190109810001"
keepalive
pause

announce "Clear FCW, rest remains"
send "700#0000190101810001"
keepalive
pause

announce "Error overlay over everything"
info "Error_Active=0 (byte3=0x00) => error shows"
send "700#0000190001810000"
keepalive
pause

announce "Clear error, restore normal"
send "700#0000190101810001"
keepalive
pause

announce "Failsafe over normal content"
info "byte4 = 0x01|0x80=0x81"
send "700#0000190181810001"
keepalive
pause

clear_all

announce "RTW alert full-screen overlay"
send "700#0000010101010010"
send "760#0080500000000000"
keepalive
pause

clear_all

###############################################################################
# SECTION 15: SeeQ / Serial Number
###############################################################################
section "15. SERIAL NUMBER / SEEQ INFO"

announce "SeeQInfo Part1 — Production date + product code"
info "0x410: Week='12', Year='25', Product='EW8', Mfr='M'"
send "410#313232354557384D"
send "700#${BASE_700}"
keepalive
short_pause

announce "SeeQInfo Part2 — Manufacturer + serial"
info "0x411: MfrCode1='E', Serial='12345'"
send "411#4500003132333435"
send "700#${BASE_700}"
keepalive
pause

clear_all

###############################################################################
# SECTION 16: SHAPE USA
###############################################################################
section "16. SHAPE USA"

announce "SHAPE_USA=1 — Rectangular sign shape + SLI 50"
info "0x700: TSR_Shape=1(bit11)=>byte1 bit3 => byte1=0x08"
info "  TSR_enabbled=1 => byte5=0x81"
send "700#0008010101810000"
send "727#0400000000000000"
keepalive
pause

announce "SHAPE_USA=0 — Circular sign shape (default) + SLI 50"
send "700#0000010101810000"
send "727#0400000000000000"
keepalive
pause

clear_all

###############################################################################
# SECTION 17: ISA VERSION / BUNDLE
###############################################################################
section "17. ISA VERSION + BUNDLE"

announce "INFO_ISA_VERSION — ISA v3.15"
info "0x7BD: byte0 = Minor(15)|(Major(3)<<5) = 0x0F|0x60 = 0x6F"
send "7BD#6F0000"
send "700#${BASE_700}"
keepalive
pause

announce "INFO_ISA_BUNDLE — Bundle 2025-03"
info "0x7BD: Bundle_year=25(byte1=0x19), Bundle_mounth=3(byte2=0x03)"
send "7BD#6F1903"
send "700#${BASE_700}"
keepalive
pause

clear_all

###############################################################################
# DONE
###############################################################################
echo ""
echo -e "${RED}╔═══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${RED}║     TEST COMPLETE — $step steps executed                          ║${NC}"
echo -e "${RED}╚═══════════════════════════════════════════════════════════════════╝${NC}"

if [ -n "$REVIEW_MODE" ]; then
    echo "" >> "$REPORT_FILE"
    echo "========================================" >> "$REPORT_FILE"
    echo "SUMMARY: $total_reviewed steps reviewed, $issues_found issues found" >> "$REPORT_FILE"
    echo ""
    echo -e "${GRN}Report saved to: ${REPORT_FILE}${NC}"
    echo -e "${YEL}  Steps reviewed: $total_reviewed${NC}"
    if [ "$issues_found" -gt 0 ]; then
        echo -e "${RED}  Issues found:   $issues_found${NC}"
        echo ""
        echo -e "${RED}Issues:${NC}"
        grep "ISSUE:" "$REPORT_FILE"
    else
        echo -e "${GRN}  Issues found:   0${NC}"
    fi
fi
