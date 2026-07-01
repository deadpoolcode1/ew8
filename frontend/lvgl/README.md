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

## Configuration Framework

Most of the display can be changed **without recompiling**. Three JSON files
under `configs/` drive the UI; edit one, save, and restart `ew8_lvgl` — the app
re-reads them at startup. This is the LVGL equivalent of the old Qt/QML
"describe the scene in markup" model: fonts, animations, positions, z-order, and
even whole new signal-driven alerts are config, not C++.

> The files are copied next to the executable at CMake **configure** time. For a
> dev build you can re-copy without reconfiguring:
> `cp configs/scene.json frontend/lvgl/build/configs/`.

| File | Drives | Reload |
|---|---|---|
| `configs/scene.json` | The display tree — every on-screen node, its parent, widget, position, layer, and intro animation | Restart |
| `configs/notices.json` | Full-screen notice/overlay screens (disconnect, failsafe, error, op-mode) | Restart |
| `configs/EW8_Config.json` | Hardware config (illuminance/brightness curves, CAN baud) | Restart |

### `scene.json` — the display tree

The C++ `buildDisplayTree()` creates only a skeleton of named **parent groups**
plus the Tier-2 logic-bearing widgets. Everything else — which node hangs where,
what image it shows, how it animates in — lives in `scene.json` and is assembled
by `lvgl_scene_loader.cpp`. Each entry attaches a node (or a subtree via
`children`) under a named parent:

```json
{
  "parent": "mainPanel",
  "type": "image",
  "graphic_item": "ALERT_LEFT_LCAI",
  "src": "A:images/LCA/LCA_Yellow.png",
  "align": "left_mid", "offset": [2, 0],
  "layer": 0
}
```

**Named parents** you can attach to (seeded by `buildDisplayTree`):
`root`, `generalPanel`, `mainPanel`, `disconPanel`, `groupCIPV`, `groupGAG`,
`groupFCW`, `statusPanel`, `leftPanel`. Nodes you give an `"id"` can also be
used as parents by later entries and as cross-reference targets.

**How nodes are chosen for display:** the tree is evaluated top-down each update
cycle. Siblings compete by `layer` (higher wins); within a `mutex` group only the
single highest-priority active child shows; a node named in another node's
`blocked_by` is suppressed while the blocker is active. A node owning a widget
toggles `LV_OBJ_FLAG_HIDDEN`. Creation order in the file = LVGL z-order (later
siblings paint on top).

**Common fields (most node types):**

| Field | Meaning |
|---|---|
| `type` | Node kind (see table below). Required. |
| `parent` | Named parent group (top-level entries only). |
| `id` | Optional handle for parenting / cross-refs / C++ glue lookup. |
| `graphic_item` | Binds the node to a `GraphicItem` entity from `EW8_Signals.json` (drives when it activates). Omit for pure containers. |
| `layer` | Priority among siblings (int, higher = wins). |
| `mutex` / `mode` | On `group` nodes: mutual-exclusion / mode-group semantics. |
| `children` | Array of child specs (recursive). |
| `pos` `[x,y]` | Absolute position, **or**… |
| `align` + `offset` `[dx,dy]` | Align to a nine-point anchor (`top_left`, `top_mid`, `center`, `left_mid`, `right_mid`, `bottom_mid`, …) plus offset. |
| `scale` | Image scale, 256 = 1.0. |
| `pivot` `[x,y]` | Image scale/rotate pivot. |
| `src` | Inline image path (`A:` = runtime asset drive). |
| `widget` `{factory, src, upper}` | Build the widget via a geometry factory instead of an inline image: `left_panel_sign`, `right_panel_sign`, `speed_limit_sign`. Keeps pixels byte-identical to the old hand-built tree. |
| `widget_id` | Reuse a widget created in C++ and registered by id (preserves creation order / z-order for logic-bearing widgets). |
| `intro_anim` `{start,target,delay}` | Container scale intro (256 = 1.0) after `delay` ms. |
| `intro_x` / `intro_y` `{start,target}` | Container slide intro. |
| `move_to_front` | Raise to front on show. |
| `blocked_by` | Id of a node that suppresses this one while active. |

**Node `type` values** (see `makeNode` in `lvgl_scene_loader.cpp` for the exact
constructor args each one reads):

`group`, `dummy`, `image`, `blink`, `timed` (`max_duration_ms`), `value`
(`divisor`, `label_id`/factory), `string`, `speed`, `error`, `gif`,
`hmw_state`, `supp_sign`, `shape_usa`, `overspeed`, `isa_state`, `tsr_state`,
`volume_done`, `volume_fail`, `qrcode`, and the test-screen nodes
`signal_test_item`, `signal_test_speed`, `peripheral_test_group`.

The logic-bearing types (`shape_usa`, `overspeed`, `isa_state`, `hmw_state`, …)
reference C++-created widgets by id (`sli_widget_id`, `road_strip_id`, etc.) and
cross-reference other nodes by id (`sli_node`, `shape_usa_node`,
`isa_speed_node`, …) in a second wiring pass, so ordering within the file
doesn't matter for references.

### Changing things without recompiling

- **Positions / layout** — edit `pos` or `align`+`offset` on the node. (Two
  pixel-parity anchors, e.g. the HMW container x, are still set in
  `lvgl_widgets.cpp`; everything attached in `scene.json` is config.)
- **Animations** — edit `intro_anim` / `intro_x` / `intro_y` (delay + start/target)
  for slide/scale intros; blink timings live in the blink nodes. Durations map
  1:1 to the Qt SideIcon / BlinkingLine values.
- **Fonts** — labels use a **compiled** IntelOne font registry (bitmaps baked in
  at build time for pixel parity). Pick from the available sizes; adding a *new*
  size means adding the `.c` font and an `LV_FONT_DECLARE`. Available:
  `intelone_medium_{14,17,20,22,24,26,28,32,36,37,44}`,
  `intelone_bold_{18,20,26,28,32,37}`. In `notices.json` set `"font"` to one of
  these names.
- **Notice screens** — text, colour (`#rrggbb`), position, image, and font of the
  disconnect / failsafe / error / op-mode overlays are all in `notices.json`.
- **A whole new alert, config-only** — add the signal to the DBC + `EW8_Signals.json`
  (so a `GraphicItem` entity fires), drop the image under `images/`, and add a
  `scene.json` node with the matching `graphic_item`. No C++. The **PLCA
  lane-change alert** was added this way — see
  `docs/Configuring-Lane-Change-Alert.docx` and the `lcaPanel` entry in
  `scene.json` for the worked example.

## Building

### Prerequisites

```bash
sudo apt install build-essential cmake pkg-config libsdl2-dev libsocketcan-dev
```

LVGL v9.2.2 is vendored as a git submodule at `frontend/lvgl/lvgl/`. Local patches in `patches/` are auto-applied during CMake configuration.

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
- `build/configs/` — Runtime configuration (copied from `configs/`)
- `build/signals/` — CAN signal definitions (copied from `signals/`)
- `build/dbc/` — CAN database files (copied from `DBC/`)

All four resource trees are copied next to the executable at CMake
configure time so the app finds them via `core::resourceBaseDir()`.

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

- **LVGL 9.2** — UI framework (vendored as git submodule at v9.2.2)
- **SDL2** — Display driver and input handling
- **SocketCAN** + **pthreads** — Via backend library
- **C++17** — Required standard

## LVGL Patches

The LVGL submodule is kept at the upstream v9.2.2 tag. Local fixes are maintained as patch files in `patches/` and auto-applied during CMake configuration:

- **`lvgl-gif-fixes.patch`** — Two GIF decoder fixes:
  1. `gifdec.c`: Clamps LZW decoded data and frame dimensions to buffer bounds instead of aborting, preventing crashes on edge-case GIF files.
  2. `lv_gif.c`: Skips frame decoding when the GIF widget or any ancestor is hidden, avoiding wasted CPU on invisible animations (e.g., FCW/PCW overlays when not active).
