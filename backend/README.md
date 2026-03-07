# EW8 Backend

Shared static library containing all non-UI logic: CAN bus communication, DBC signal parsing, alert state machine, and the display tree that drives frontend rendering.

## Architecture

The backend is frontend-agnostic. Both the Qt and LVGL frontends link against it and use the same `AlertController` and `CanManager` APIs.

```
backend/
├── include/              # Public headers
│   ├── canmanager.h      # CAN bus send/receive, DBC parsing
│   ├── alertcontroller.h # Alert state machine, entity activation
│   ├── display_tree.h    # Generic display tree traversal
│   ├── entitytype.h      # Display entity ID enum (DISPLAY_ITEM_ID)
│   ├── canrxmsg.h        # CAN message receive handler base
│   ├── amjson*.h         # JSON config/signal protocol (Aftermarket JSON)
│   ├── brightnesscontrol.h
│   ├── watchdogdevice.h
│   └── ...
├── src/                  # Implementation files
├── candbgrammar.peg      # PEG grammar for DBC file parsing
├── candbgrammar.h.in     # Template for embedding grammar into header
└── CMakeLists.txt
```

## Key Components

### CanManager
Manages the SocketCAN interface. Parses DBC files to decode incoming CAN frames into signal values. Routes decoded signals to the alert controller. Also provides send methods for ISA commands and volume control.

### AlertController
Maintains the activation state of all ~100 display entities. Each entity has an activation semaphore — when a CAN signal activates an entity, its semaphore increments; deactivation decrements it. The alert controller notifies the frontend when any entity state changes so the display tree can be re-evaluated.

### Display Tree
A generic tree structure where each node has a layer priority. When the tree is evaluated, sibling nodes compete — only the highest-priority active node (and its children) become visible. This implements the mutual exclusion logic (e.g., FCW overrides HMW, SLI overrides RTW in the same panel slot).

### AMJson Protocol
Parses `EW8_Signals.json` to map CAN signals to display entities. Each signal definition specifies which CAN message/signal triggers which entity, with optional argument extraction (numeric, string, or fixed values).

## Building

The backend is built as a static library (`libew8_backend.a`) by the frontend CMake projects. It is not built standalone.

```bash
# Built automatically when building either frontend:
cd frontend/lvgl/build && cmake .. && cmake --build .
# or
cd frontend/qt/build && cmake .. && cmake --build .
```

### CMake variables set by frontends

| Variable | Purpose | Example |
|---|---|---|
| `BASE_TARGET_DIR` | Runtime resource path prefix | `/opt/canquick/bin/../` |
| `MAJOR_VERSION` | Firmware major version | `3` |
| `MINOR_VERSION` | Firmware minor version | `0` |

### Compile definitions

- `REMOVE_EW8_HW` — Defined automatically on x86_64 builds. Disables watchdog, hardware brightness, and other target-specific code.
- `VERIFY_ALL_ALERTS_IMPLEMENTED` — Compile-time check that all entity IDs are handled.

## Dependencies

- **SocketCAN** (`libsocketcan`) — Linux CAN bus interface
- **pthreads** — Threading
- **C++17** — Required standard
