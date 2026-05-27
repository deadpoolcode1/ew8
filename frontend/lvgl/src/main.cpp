#include "sdl_display.h"
#include "lvgl_main_process.h"
#include "app_init.h"
#include "lvgl.h"
#include "core/logger.h"
#include "core/resource_paths.h"

#include <cstdio>
#include <cstdlib>
#include <csignal>
#include <string>
#include <chrono>
#include <thread>
#include <SDL2/SDL.h>
#ifdef _WIN32
#include <process.h>  // for _exit on MSVC
#endif

core::ElapsedTimer bootUpTimer;

static const int DISPLAY_WIDTH = 320;
static const int DISPLAY_HEIGHT = 240;

static volatile sig_atomic_t g_running = 1;

static void signalHandler(int sig)
{
    (void)sig;
    g_running = 0;
}

int main(int argc, char* argv[])
{
#ifdef SDL_MAIN_HANDLED
    SDL_SetMainReady();
#endif

    signal(SIGINT, signalHandler);
    signal(SIGTERM, signalHandler);

    // Mirror all logs to a file so they survive a crash that closes the console
    // window (IMS-11652). EW8_LOG_FILE overrides the default of ew8.log next to
    // the executable. Each line is flushed immediately, so the file is complete
    // even if the process dies abruptly.
    {
        const char* envLog = std::getenv("EW8_LOG_FILE");
        std::string logPath = envLog ? std::string(envLog)
                                     : (core::executableDir() + "ew8.log");
        core::Logger::instance().setLogFile(logPath);
        LOG_INFO("EW8 LVGL Frontend starting (log file: %s)", logPath.c_str());
    }

    bootUpTimer.start();
    printf("EW8 LVGL Frontend starting...\n");

    // Setup virtual CAN for desktop builds
#ifdef REMOVE_EW8_HW
#ifdef _WIN32
    // Windows: CanManager auto-detects between Kvaser and UDP virtual CAN
    // at init time. Don't pre-announce a transport here.
#else
    // Linux: set up vcan kernel module
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
#endif

    // Initialize backend (reads JSON signal configs, parses DBC files)
    AppConfig config = parseAppConfig(argc, argv);
    initializeBackend(config);

    // Initialize LVGL
    lv_init();

    // Initialize SDL2 + LVGL display driver
    lv_display_t* disp = sdl_display_init(DISPLAY_WIDTH, DISPLAY_HEIGHT);
    if (!disp) {
        LOG_ERROR("Failed to initialize display");
        printf("Failed to initialize display\n");
        return 1;
    }

    // Set up screen background
    lv_obj_t* screen = lv_screen_active();
    lv_obj_set_style_bg_color(screen, lv_color_black(), 0);
    lv_obj_set_style_bg_opa(screen, LV_OPA_COVER, 0);

    // Create main process (owns AlertController + CanManager + display tree)
    LvglMainProcess* mainProcess = new LvglMainProcess(screen);

    // Launch backend (starts CAN reader thread, heartbeat timer, etc.)
    mainProcess->launch();

    postLaunchBackend(config);

    LOG_INFO("Entering main loop (Escape or close window to quit)");
    printf("Entering main loop (Escape or close window to quit)...\n");

    // Main loop
    auto lastTick = std::chrono::steady_clock::now();
    while (g_running && sdl_display_poll_events()) {
        auto now = std::chrono::steady_clock::now();
        auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(now - lastTick).count();
        lastTick = now;

        lv_tick_inc(elapsed);

        // Route SDL key events to menu controller
        int key = sdl_display_get_last_key();
        if (key) {
            mainProcess->handleKeyEvent(key);
        }
        // Dual-key press (Up+Down) for QR code activation
        if (sdl_display_get_dual_key_press()) {
            mainProcess->handleDualKeyPress();
        }

        // Apply pending display tree updates from backend threads
        mainProcess->applyPendingDisplayUpdate();

        lv_timer_handler();
        sdl_display_present_if_needed();

        std::this_thread::sleep_for(std::chrono::milliseconds(1));
    }

    LOG_INFO("Shutting down");
    printf("Shutting down...\n");
    // Backend threads (CAN reader) block on I/O and can't be cleanly joined.
    // Clean up what we can, then force exit.
    sdl_display_cleanup();
    _exit(0);
}
