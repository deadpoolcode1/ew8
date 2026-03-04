#include "sdl_display.h"
#include "app_init.h"
#include "lvgl.h"

#include <cstdio>
#include <cstdlib>
#include <chrono>
#include <thread>

static const int DISPLAY_WIDTH = 320;
static const int DISPLAY_HEIGHT = 240;

int main(int argc, char* argv[])
{
    printf("EW8 LVGL Frontend starting...\n");

    // Setup vcan0 for desktop builds
#ifdef REMOVE_EW8_HW
    if (system("ip link show can0 > /dev/null 2>&1") != 0) {
        system("sudo modprobe vcan 2>/dev/null");
        system("sudo ip link add dev can0 type vcan 2>/dev/null");
        system("sudo ip link set up can0 2>/dev/null");
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

    // Set black background on active screen
    lv_obj_t* screen = lv_screen_active();
    lv_obj_set_style_bg_color(screen, lv_color_black(), 0);
    lv_obj_set_style_bg_opa(screen, LV_OPA_COVER, 0);

    postLaunchBackend(config);

    printf("Entering main loop (Escape or close window to quit)...\n");

    // Main loop
    auto lastTick = std::chrono::steady_clock::now();
    while (sdl_display_poll_events()) {
        auto now = std::chrono::steady_clock::now();
        auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(now - lastTick).count();
        lastTick = now;

        lv_tick_inc(elapsed);
        lv_timer_handler();
        sdl_display_present_if_needed();

        std::this_thread::sleep_for(std::chrono::milliseconds(16));
    }

    printf("Shutting down...\n");
    sdl_display_cleanup();
    lv_deinit();

    return 0;
}
