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
├── Tests/                # Integration tests (Python + shell scripts)
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

# Clone with submodules (LVGL library)
git clone --recurse-submodules <repo-url>

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

Two types of integration tests are available:

### Shell scripts (cansend-based)

Located in `Tests/scripts/`. Use `cansend` to inject raw CAN frames and visually verify display output.

```bash
cd Tests/scripts

# Comprehensive entity test (108 steps)
./test_all_entities.sh can0 2          # auto mode, 2s between steps
./test_all_entities.sh can0 2 -r       # review mode with report generation
./test_all_entities.sh -s 42           # run only step 42
./test_all_entities.sh -f 30 -r        # start from step 30 in review mode

# Basic smoke test
./basic.sh

# CAN replay scripts (recorded real-world scenarios)
./replay_FCW.sh
./replay_HMW_Alert.sh
./replay_HMW_Repeatable.sh
```

### Python scripts (DBC-based)

Located in `Tests/`. Use `python-can` and `cantools` with DBC files for structured message construction.

```bash
# Install dependencies (Windows)
depinstall.bat
# Or manually:
pip install cantools python-can

# General test — cycles through common alerts
python general_test.py

# ISA-to-TSR transition test
python isa2tsr_test.py
```

The `can2ew8testlib.py` module provides the `EW8test` class that loads DBC files from `~/canquick/DBC/` and constructs CAN frames by signal name.

All test scripts work with both Qt and LVGL frontends running on the same CAN bus.

## Target Hardware

- **Display:** 320x240 TFT
- **Platform:** ARM (Yocto Linux) for production, x86_64 Linux for development, Windows for development
- **CAN:** SocketCAN (Linux), UDP virtual CAN (Windows)

Desktop builds automatically define `REMOVE_EW8_HW` to disable hardware-specific code (watchdog, brightness GPIO, etc.).

---

## Windows Development

The LVGL frontend builds and runs natively on Windows using MSYS2/MinGW. Instead of SocketCAN (Linux-only), a **UDP virtual CAN** transport is used — the app listens on `localhost:18700` for CAN frames, and test tools send frames via UDP. No CAN hardware or drivers are required.

### Prerequisites

1. **MSYS2** — provides MinGW GCC, CMake, and SDL2:

   ```
   winget install -e --id MSYS2.MSYS2
   ```

2. **MinGW packages** — open an MSYS2 terminal and run:

   ```bash
   pacman -S --noconfirm mingw-w64-x86_64-gcc mingw-w64-x86_64-cmake mingw-w64-x86_64-SDL2 mingw-w64-x86_64-make
   ```

3. **Python** (for testing):

   ```
   pip install cantools python-can
   ```

   Or run `Tests/depinstall.bat`.

### Building on Windows

From a Git Bash or MSYS2 MinGW64 shell:

```bash
# Add MinGW to PATH
export PATH="/c/msys64/mingw64/bin:$PATH"

# Configure — set BASE_TARGET_DIR to the project root
cmake -B build_win -S frontend/lvgl \
  -G "MinGW Makefiles" \
  -DCMAKE_C_COMPILER=/c/msys64/mingw64/bin/gcc.exe \
  -DCMAKE_CXX_COMPILER=/c/msys64/mingw64/bin/g++.exe \
  -DCMAKE_MAKE_PROGRAM=/c/msys64/mingw64/bin/mingw32-make.exe \
  -DBASE_TARGET_DIR="C:/workspace/ew8/"

# Build
mingw32-make -C build_win -j$(nproc)
```

Or from a **PowerShell** prompt:

```powershell
# Add MinGW to PATH (this PowerShell session only)
$env:PATH = "C:\msys64\mingw64\bin;$env:PATH"

# Configure — set BASE_TARGET_DIR to the project root
cmake -B build_win -S frontend/lvgl `
  -G "MinGW Makefiles" `
  -DCMAKE_C_COMPILER=C:/msys64/mingw64/bin/gcc.exe `
  -DCMAKE_CXX_COMPILER=C:/msys64/mingw64/bin/g++.exe `
  -DCMAKE_MAKE_PROGRAM=C:/msys64/mingw64/bin/mingw32-make.exe `
  -DBASE_TARGET_DIR="C:/workspace/ew8/"

# Build
mingw32-make -C build_win -j$env:NUMBER_OF_PROCESSORS
```

The resulting executable is `build_win/ew8_lvgl.exe`.

### Running on Windows

From Git Bash / MSYS2 MinGW64:

```bash
export PATH="/c/msys64/mingw64/bin:$PATH"
cd build_win
./ew8_lvgl.exe
```

From **PowerShell**:

```powershell
$env:PATH = "C:\msys64\mingw64\bin;$env:PATH"
cd build_win
.\ew8_lvgl.exe
```

> **Note:** The build now copies the MinGW C++ runtime and `SDL2.dll`
> (`libgcc_s_seh-1.dll`, `libstdc++-6.dll`, `libwinpthread-1.dll`, `SDL2.dll`)
> next to `ew8_lvgl.exe` at build time, so the executable runs without
> `C:\msys64\mingw64\bin` on `PATH`. If CMake warned that a DLL was not found
> (uncommon toolchain layout), put `C:\msys64\mingw64\bin` on `PATH` instead —
> otherwise the missing DLL makes the process exit silently with no output.
>
> To make the PATH change persistent for your user account (then reopen PowerShell):
>
> ```powershell
> [Environment]::SetEnvironmentVariable(
>   "PATH",
>   "C:\msys64\mingw64\bin;" + [Environment]::GetEnvironmentVariable("PATH","User"),
>   "User"
> )
> ```

The app will open an SDL2 window (320x240) and print:
```
Using UDP virtual CAN on port 18700 (send CAN frames via cansend.py)
```

### Testing on Windows

All tests use the UDP virtual CAN transport automatically on Windows.

#### Quick smoke test

With the app running, open another terminal:

```bash
# Send a single CAN frame
python Tests/cansend.py can0 700#0000190100800001

# Run the basic test (10 iterations of core messages)
bash Tests/scripts/basic_crossplatform.sh
```

#### E2E test suite

Runs 8 test scenarios (keepalive, FCW, HMW, LDW, TSR, ISA, speed, clear) and reports results:

```bash
python Tests/e2e_test.py
```

Options:
- `--delay 1.0` — seconds between test steps (default 2.0)
- `--port 18700` — UDP port (default 18700)

#### Interactive test

```bash
python Tests/general_test.py
```

Press any key to advance through alert states (FCW, HMW, lane warnings, TSR signs).

#### DBC-based tests

```bash
python Tests/isa2tsr_test.py
```

Requires DBC files in `~/canquick/DBC/` (same as Linux).

### Cross-platform test tools

| Tool | Description |
|------|-------------|
| `Tests/cansend.py` | Drop-in `cansend` replacement — UDP on Windows, native `cansend` on Linux |
| `Tests/cansend_wrapper.sh` | Shell wrapper that auto-selects the right sender |
| `Tests/e2e_test.py` | Full E2E test suite (8 scenarios, works on both platforms) |
| `Tests/scripts/basic_crossplatform.sh` | Cross-platform version of `basic.sh` |

### How UDP virtual CAN works

```
   Test Tool (cansend.py)          EW8 App (ew8_lvgl.exe)
   ─────────────────────           ──────────────────────
   Encodes CAN frame as:           Listens on UDP port 18700
   [4B CAN ID, LE]                 Decodes 13-byte packets
   [1B DLC]                        Feeds frames to CanManager
   [8B data, zero-padded]          Same processing as SocketCAN
          │                                   │
          └──── UDP localhost:18700 ──────────┘
```

The wire format is 13 bytes: 4-byte CAN ID (little-endian) + 1-byte DLC + 8-byte data. This is handled transparently by `cansend.py` and the backend.

### Notes

- The `can0` interface argument in test scripts is accepted for compatibility but ignored on Windows (UDP always targets `localhost:18700`).
- The existing Linux bash test scripts (`test_all_entities.sh`, `replay_FCW.sh`, etc.) require `cansend` from `can-utils` and do not run on Windows. Use the cross-platform equivalents (`basic_crossplatform.sh`, `e2e_test.py`) instead.
- To build with Kvaser CAN hardware instead of UDP, pass `-DEW8_USE_KVASER=ON` to cmake.
