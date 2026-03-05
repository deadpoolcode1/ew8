#include "sdl_display.h"
#include "lvgl_ui.h"
#include "lvgl_main_process.h"
#include "lvgl_nocom_bridge.h"
#include "app_init.h"
#include "entitytype.h"
#include "alerttypes_core.h"
#include "lvgl.h"

#include <cstdio>
#include <cstdlib>
#include <csignal>
#include <chrono>
#include <thread>

core::ElapsedTimer bootUpTimer;

static const int DISPLAY_WIDTH = 320;
static const int DISPLAY_HEIGHT = 240;

// Global UI instance (accessed by main loop)
static LvglUI* g_ui = nullptr;
static volatile sig_atomic_t g_running = 1;

static void signalHandler(int sig)
{
    (void)sig;
    g_running = 0;
}

int main(int argc, char* argv[])
{
    signal(SIGINT, signalHandler);
    signal(SIGTERM, signalHandler);

    bootUpTimer.start();
    printf("EW8 LVGL Frontend starting...\n");

    // Setup vcan0 for desktop builds
#ifdef REMOVE_EW8_HW
    if (system("ip link show can0 > /dev/null 2>&1") != 0) {
        printf("Setting up vcan interface can0...\n");
        int r = 0;
        r |= system("sudo modprobe vcan");
        r |= system("sudo ip link add dev can0 type vcan");
        r |= system("sudo ip link set up can0");
        if (r != 0) {
            printf("WARNING: vcan setup failed (need sudo). CAN will not work.\n");
        } else {
            printf("vcan interface can0 created and up.\n");
        }
    } else {
        printf("CAN interface can0 already exists.\n");
    }
#endif

    // Initialize backend (reads JSON signal configs, parses DBC files)
    AppConfig config = parseAppConfig(argc, argv);
    initializeBackend(config);

    // Initialize LVGL
    lv_init();

    // Initialize SDL2 + LVGL display driver
    lv_display_t* disp = sdl_display_init(DISPLAY_WIDTH, DISPLAY_HEIGHT);
    if (!disp) {
        printf("Failed to initialize display\n");
        return 1;
    }

    // Create UI
    g_ui = new LvglUI();
    g_ui->init();

    // Create main process (owns AlertController + CanManager)
    LvglMainProcess* mainProcess = new LvglMainProcess();

    // Register a temporary NOCOM bridge node so ALERT_NOCOM drives the overlay
    // (This will be replaced by the proper display tree in Stage 3)
    LvglNocomBridge* nocomBridge = new LvglNocomBridge(g_ui);
    EntityType::linkByEntityType(AlertTypes::ALERT_NOCOM, nocomBridge);

    // Launch backend (starts CAN reader thread, heartbeat timer, etc.)
    mainProcess->launch();

    postLaunchBackend(config);

    printf("Entering main loop (Escape or close window to quit)...\n");

    // Main loop
    auto lastTick = std::chrono::steady_clock::now();
    while (g_running && sdl_display_poll_events()) {
        auto now = std::chrono::steady_clock::now();
        auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(now - lastTick).count();
        lastTick = now;

        lv_tick_inc(elapsed);

        // Apply pending UI updates from backend threads
        g_ui->processUpdates();

        lv_timer_handler();
        sdl_display_present_if_needed();

        std::this_thread::sleep_for(std::chrono::milliseconds(16));
    }

    printf("Shutting down...\n");
    // Backend threads (CAN reader) block on I/O and can't be cleanly joined.
    // Clean up what we can, then force exit.
    sdl_display_cleanup();
    _exit(0);
}
