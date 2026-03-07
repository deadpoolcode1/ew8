# EW8 — Mobileye Aftermarket Display Unit

EW8 is the embedded display firmware for Mobileye's EyeWatch aftermarket ADAS (Advanced Driver Assistance Systems) product line. It receives CAN bus messages from the Mobileye vision processing unit and renders real-time safety alerts, traffic sign recognition, and driver status information on a 320x240 TFT display.

## Architecture

The project is split into a shared **backend** (CAN protocol handling, alert state machine, display tree) and swappable **frontends** (Qt/QML or LVGL) that render the UI.

```
ew8/
├── backend/              # Shared backend library (CAN, alerts, display tree)
├── frontend/
│   ├── qt/               # Qt/QML frontend (original, production)
│   └── lvgl/             # LVGL frontend (lightweight replacement)
├── core/                 # Header-only platform abstractions (threads, timers, mutex)
├── assets/               # Shared runtime resources
│   ├── images/           # PNG/GIF image assets for all UI elements
│   └── fonts/            # Custom font files
├── signals/              # CAN signal definition JSON files
│   ├── EW8_Signals.json
│   └── ME_Test_Signals.json
├── configs/              # Runtime configuration
│   └── EW8_Config.json
├── DBC/                  # CAN database files (.dbc) for all protocols
├── Tests/                # CAN-based integration test scripts
├── tools/                # Build and asset helper utilities
├── CMakeLists.txt        # Top-level CMake (builds Qt frontend by default)
└── EW8Linux_ReadMe.txt   # Legacy Yocto SDK setup notes
```

## Display Entities

The system handles ~100 display entities organized into categories:

| Category | Examples |
|---|---|
| Status indicators | Speed, GPS, GSM, driver auth, mute |
| Speed limit (SLI/TSR) | Speed signs (circular EU / rectangular US), supplementary signs |
| Lane departure (LDW) | Left/right lane indicators with blink animation |
| Headway monitoring (HMW) | Following distance with lead car visualization |
| Forward collision (FCW/PCW) | Full-screen red/yellow alert overlays |
| Traffic light (RTW) | Red-light violation warning |
| Pedestrian (PDZ) | Pedestrian detection alert |
| SADAS signs | Right-panel regulatory road signs |
| ISA | Intelligent Speed Assist status and menu |
| System overlays | Disconnect, error, failsafe, QR code, test screens |

## CAN Bus Interface

EW8 communicates over SocketCAN (Linux) using DBC-defined message formats. Key CAN IDs:

- `0x700-0x701` — Main alert/status messages
- `0x760` — Speed and vehicle info
- `0x7BC-0x7BD` — TSR/SLI sign data
- `0x412` — System status (connectivity, auth)
- `0x350-0x355` — ISA and SADAS data

DBC files in the `DBC/` directory define the complete protocol.

## Building

Each frontend has its own CMake build. See the frontend-specific READMEs:

- [Backend README](backend/README.md)
- [Qt Frontend README](frontend/qt/README.md)
- [LVGL Frontend README](frontend/lvgl/README.md)

### Quick start (LVGL frontend, Linux desktop)

```bash
# Install dependencies
sudo apt install build-essential cmake libsdl2-dev libsocketcan-dev

# Build
cd frontend/lvgl
mkdir -p build && cd build
cmake ..
cmake --build .

# Run (requires a CAN interface, real or virtual)
sudo modprobe vcan
sudo ip link add dev vcan0 type vcan
sudo ip link set up vcan0
./ew8_lvgl
```

## Testing

Integration tests use `cansend` to inject CAN messages and visually verify display output.

```bash
# Run the comprehensive entity test (108 steps)
cd Tests
./test_all_entities.sh can0 2          # auto mode, 2s between steps
./test_all_entities.sh can0 2 -r       # review mode with report generation

# Basic smoke test
./basic.sh
```

The test scripts work with both Qt and LVGL frontends running on the same CAN bus.

## Target Hardware

- **Display:** 320x240 TFT
- **Platform:** ARM (Yocto Linux) for production, x86_64 Linux for development
- **CAN:** SocketCAN interface (real or virtual)

Desktop builds automatically define `REMOVE_EW8_HW` to disable hardware-specific code (watchdog, brightness GPIO, etc.).
