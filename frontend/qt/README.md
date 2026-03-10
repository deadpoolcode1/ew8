# EW8 Qt/QML Frontend

The original production frontend. Uses Qt 5 Quick/QML for declarative UI with property bindings, animations, and a QML scene graph. This is the reference implementation that the LVGL frontend replicates.

## Architecture

```
frontend/qt/
├── include/              # C++ headers
│   ├── mainprocess.h     # Main application controller
│   ├── displaysignalizer.h  # Bridges backend alerts to QML properties
│   ├── alerttypes.h      # QML-exposed alert enums
│   ├── qquickqrcode.h    # QR code QML component (libqrencode)
│   ├── ewinfo.h          # Device info (serial number, versions)
│   └── rootedtree*.h     # QML object tree for display node mapping
├── src/                  # C++ implementation
│   ├── main.cpp          # Entry point, Qt app setup
│   ├── mainprocess.cpp   # CAN → QML bridge, display tree eval
│   └── ...
├── qml/                  # QML UI files
│   ├── main.qml          # Root scene — all panels, overlays, status bar
│   ├── SLI.qml           # Speed limit indicator sign
│   ├── HMW.qml           # Headway monitoring display
│   ├── HostCar.qml       # Host car image with shift animation
│   ├── BlinkingLine.qml  # LDW blink animation component
│   ├── SideIcon.qml      # Animated sign intro (scale + position)
│   ├── BrightnessMenu.qml, ISAMenu.qml, VolumeMenu.qml  # OSD menus
│   ├── AboutMenu.qml     # Device info screen
│   └── ...               # ~40 QML files total
├── plugins/              # Qt QML plugin modules
├── qml.qrc              # Qt resource file for QML bundling
├── CMakeLists.txt
└── canquick.pro          # Legacy qmake project file (Yocto builds)
```

## Key Components

### MainProcess (C++)
Creates the `CanManager` and `AlertController` from the backend. On each display update cycle, evaluates the display tree and maps entity activation states to QML properties via `DisplaySignalizer`.

### DisplaySignalizer (C++)
Exposes backend entity states as Qt signals/slots. QML components bind to these to show/hide and update their content (speed values, sign images, alert arguments).

### main.qml
The root QML file defining the entire 320x240 scene:
- **Status bar** (top 50px) — ME logo, speed, ISA icons, signed status, GPS/GSM, mute
- **Left panel** (50px wide) — SLI/TSR speed signs, supplementary signs, RTW warning
- **Right panel** (50px wide) — SADAS road signs
- **Center area** — LDW lanes, HMW distance, host car, PDZ overlay
- **Full-screen overlays** — FCW/PCW alerts, error, disconnect, failsafe, test screens
- **OSD menus** (z=20+) — Brightness, ISA, volume, about, QR code

### QML Animation Patterns
- **Sign intro:** Scale 1.0 to 0.732 (left) or 0.6028 (right) over 500ms, OutQuad easing
- **LDW blink:** 404ms fade in/out, InOutQuad easing, continuous
- **Overspeed blink:** 300ms fade + 500ms pause, repeated
- **Host car shift:** 200ms left/right, 600ms return to center, InOutQuad
- **HMW car scale:** 700ms InOutQuad between monitor and alert states

## Building

### Prerequisites

```bash
sudo apt install build-essential cmake qt5-default qtdeclarative5-dev \
    libqrencode-dev libdrm-dev libsocketcan-dev
```

### Build

```bash
cd frontend/qt
mkdir -p build && cd build
cmake ..
cmake --build .
```

The build creates symlinks under `/opt/canquick/` for QML files and shared assets (requires sudo).

### Output

- `build/canquick` — The executable

## Running

```bash
# Set up CAN interface
sudo modprobe vcan
sudo ip link add dev vcan0 type vcan
sudo ip link set up vcan0

# Run (needs /opt/canquick symlinks from build step)
./canquick

# With test signal support
./canquick -t
```

### Key Controls

| Key | Action |
|---|---|
| Enter | Cycle OSD menus (brightness / ISA / about) |
| Up/Down | Adjust current menu value |
| Up+Down (hold) | Start QR code activation (5s countdown) |

## Testing

```bash
# Shell-based tests (from Tests/scripts/), with canquick running:
cd Tests/scripts
./test_all_entities.sh can0 2       # auto mode
./test_all_entities.sh can0 2 -r    # review mode with report
./basic.sh                          # basic smoke test

# Python-based tests (from Tests/)
cd Tests
python general_test.py              # cycles through common alerts
python isa2tsr_test.py              # ISA-to-TSR transition test
```

## Dependencies

- Qt 5.9+ (Quick, Gui, Qml)
- libqrencode (QR code generation)
- libdrm (display management)
- SocketCAN + pthreads (via backend)
