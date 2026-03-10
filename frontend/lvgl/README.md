# EW8 LVGL Frontend

A lightweight replacement for the Qt/QML frontend, using [LVGL](https://lvgl.io/) (v9.2) with an SDL2 display driver. Designed to replicate the Qt frontend pixel-for-pixel on resource-constrained hardware without Qt dependencies.

## Architecture

```
frontend/lvgl/
├── include/                        # C++ headers
│   ├── lvgl_main_process.h         # Main controller (builds UI, runs display loop)
│   ├── lvgl_display_node.h         # Display tree node base + LvglAnimatedSignNode
│   ├── lvgl_widgets.h              # Widget factory (all UI element creation)
│   ├── lvgl_menu_controller.h      # OSD menus (brightness, ISA, volume, QR)
│   ├── lvgl_menu_display_node.h    # Specialized nodes (volume, QR, SHAPE_USA, blink)
│   ├── lvgl_value_display_node.h   # Numeric value display (speed, HMW distance)
│   ├── lvgl_string_display_node.h  # String value display
│   ├── lvgl_blink_display_node.h   # Blink animation node (LDW, signed status)
│   ├── lvgl_hmw_state_node.h       # HMW car scale/position state machine
│   ├── lvgl_test_display_node.h    # Peripheral/signal test screen nodes
│   └── sdl_display.h               # SDL2 display driver for LVGL
├── src/
│   ├── main.cpp                    # Entry point, SDL event loop
│   ├── sdl_display.cpp             # SDL2 init, flush callback, key handling
│   ├── lvgl_main_process.cpp       # Display tree construction + update logic
│   ├── lvgl_widgets.cpp            # All widget creation functions
│   ├── lvgl_display_node.cpp       # Node visibility, animation logic
│   ├── lvgl_menu_controller.cpp    # Menu screens (brightness, ISA, volume, QR)
│   ├── lvgl_menu_display_node.cpp  # Volume/QR/ShapeUSA/Overspeed/ISA state nodes
│   ├── lvgl_value_display_node.cpp # Speed + HMW value formatting
│   ├── lvgl_blink_display_node.cpp # Opacity blink via lv_anim
│   ├── lvgl_hmw_state_node.cpp     # HMW monitor/alert car transitions
│   ├── lvgl_test_display_node.cpp  # Test screen rendering
│   ├── lvgl_string_display_node.cpp
│   └── lvgl_string_display_node.cpp
├── fonts/                          # Custom IntelOne font files (.c)
├── lvgl/                           # LVGL v9.2 library (git submodule)
├── lv_conf.h                       # LVGL configuration
├── build/                          # Out-of-source build directory
│   └── images/                     # Copied from assets/ at cmake time
└── CMakeLists.txt
```

## Design Decisions

### Display Tree
The backend's `AlertController` manages entity activation states. The LVGL frontend builds a parallel tree of `LvglDisplayNode` objects that mirrors the QML scene graph hierarchy. On each update cycle, the tree is evaluated top-down: sibling nodes compete by layer priority, and only the highest-priority active subtree becomes visible. Nodes that own LVGL widgets toggle `LV_OBJ_FLAG_HIDDEN`.

### Widget Creation Order = Z-Order
LVGL renders children in creation order (later = on top). Widgets are created to match QML z-values:
1. Content widgets (lanes, HMW, signs, host car)
2. Status bar
3. Overlays in ascending priority: failsafe, RTW, disconnect, RGB/TV tests, FCW/PCW, error, menus

### Image Assets
All image paths use the `A:` LVGL drive letter, mapped to the `images/` directory copied into the build folder. PNG format is used throughout (LVGL's built-in PNG decoder).

### Animations
QML animations are replicated using `lv_anim_t`:

| Animation | Duration | Easing |
|---|---|---|
| Sign intro (scale) | 500ms | OutQuad |
| LDW blink (opacity) | 404ms | InOutQuad |
| Overspeed blink | 300ms fade + 500ms pause | Linear |
| Host car shift | 200ms (left/right), 600ms (center) | InOutQuad |
| HMW car transition | 700ms | InOutQuad |

## Building

### Prerequisites

```bash
sudo apt install build-essential cmake pkg-config libsdl2-dev libsocketcan-dev
```

LVGL v9.2 is vendored as a git submodule at `frontend/lvgl/lvgl/`.

### Build

```bash
cd frontend/lvgl
mkdir -p build && cd build
cmake ..
cmake --build .
```

### Output

- `build/ew8_lvgl` — The executable
- `build/images/` — Runtime image assets (copied from `assets/images/`)

## Running

```bash
# Set up CAN interface
sudo modprobe vcan
sudo ip link add dev vcan0 type vcan
sudo ip link set up vcan0

# Run from the build directory (images/ must be present)
cd build
./ew8_lvgl
```

An SDL2 window opens at 320x240 pixels showing the EW8 display.

### Key Controls

| Key | Action |
|---|---|
| Enter | Cycle OSD menus (brightness / ISA / about) |
| Up / Down | Adjust current menu value |
| Up+Down (hold) | Start QR code activation (5s countdown) |
| Escape | Quit |

## Testing

Run the shared CAN test scripts while `ew8_lvgl` is running:

```bash
# Shell-based tests (from Tests/scripts/)
cd Tests/scripts
./test_all_entities.sh can0 2          # auto mode, 2s per step
./test_all_entities.sh can0 2 -r       # review mode with report
./basic.sh                             # basic smoke test

# Python-based tests (from Tests/)
cd Tests
python general_test.py                 # cycles through common alerts
python isa2tsr_test.py                 # ISA-to-TSR transition test
```

### Side-by-Side Comparison
Run both frontends simultaneously on the same CAN bus to compare output:

```bash
# Terminal 1: Qt frontend
cd frontend/qt/build && ./canquick

# Terminal 2: LVGL frontend
cd frontend/lvgl/build && ./ew8_lvgl

# Terminal 3: Send test CAN messages
cd Tests/scripts && ./test_all_entities.sh can0 2 -r
```

## Dependencies

- **LVGL 9.2** — UI framework (vendored as git submodule, `ew8-fixes` branch)
- **SDL2** — Display driver and input handling
- **SocketCAN** + **pthreads** — Via backend library
- **C++17** — Required standard

## LVGL Submodule

The LVGL library is vendored at `frontend/lvgl/lvgl/` as a git submodule based on LVGL v9.2.2 with two local fixes on the `ew8-fixes` branch:

1. **GIF decoder buffer overflow fix** (`src/libs/gif/gifdec.c`) — Clamps LZW decoded data and frame dimensions to buffer bounds instead of aborting, preventing crashes on edge-case GIF files.
2. **Skip hidden GIF decoding** (`src/libs/gif/lv_gif.c`) — Skips frame decoding when the GIF widget or any ancestor is hidden, avoiding wasted CPU on invisible animations (e.g., FCW/PCW overlays when not active).
