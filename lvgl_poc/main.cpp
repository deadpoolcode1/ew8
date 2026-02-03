#include <cstdio>
#include <cstdlib>
#include <chrono>
#include <thread>
#include <atomic>

#include <SDL2/SDL.h>

#include "lvgl.h"
#include "lvgl_ui.h"
#include "can_receiver.h"
#include "lvgl_alert_display.h"
#include "medisconnectionreport_lvgl.h"

// Display dimensions (matching original Qt project)
static const int DISPLAY_WIDTH = 320;
static const int DISPLAY_HEIGHT = 240;

// SDL resources
static SDL_Window* window = nullptr;
static SDL_Renderer* renderer = nullptr;
static SDL_Texture* texture = nullptr;

// LVGL draw buffer - partial rendering (10 rows at a time)
// Use uint32_t to ensure 4 bytes per pixel for ARGB8888 format
static uint32_t draw_buf[DISPLAY_WIDTH * 10];

// Global UI instance
static LvglUI* g_ui = nullptr;

// Global alert display and disconnection report
static LvglAlertDisplay* g_alertDisplay = nullptr;
static MeDisconnectionReport* g_disconnectionReport = nullptr;

// Flag to track if display needs refresh
static bool display_needs_refresh = false;

// Debug: track first flush to print info
static bool first_flush = true;

// Flush counter for debugging
static int flush_count = 0;

/**
 * SDL display flush callback for LVGL
 */
static void sdl_display_flush(lv_display_t* disp, const lv_area_t* area, uint8_t* px_map)
{
    flush_count++;
    printf("Flush #%d: area=(%d,%d)-(%d,%d)\n", flush_count, area->x1, area->y1, area->x2, area->y2);
    fflush(stdout);

    int32_t x1 = area->x1;
    int32_t y1 = area->y1;
    int32_t w = area->x2 - area->x1 + 1;
    int32_t h = area->y2 - area->y1 + 1;

    // Debug: print first flush info
    if (first_flush) {
        printf("Buffer element size: %zu bytes (should be 4 for ARGB8888)\n", sizeof(draw_buf[0]));
        printf("px_map=%p, draw_buf=%p\n", (void*)px_map, (void*)draw_buf);
        printf("Color format: %d (should be %d for ARGB8888)\n",
               lv_display_get_color_format(disp), LV_COLOR_FORMAT_ARGB8888);
        first_flush = false;
    }

    SDL_Rect rect;
    rect.x = x1;
    rect.y = y1;
    rect.w = w;
    rect.h = h;

    // In PARTIAL mode, the pixel data is packed with area width as stride
    // (not display width), so pitch = w * bytes_per_pixel
    int32_t bytes_per_pixel = lv_color_format_get_size(lv_display_get_color_format(disp));
    int32_t pitch = w * bytes_per_pixel;

    printf("Flush #%d: calling SDL_UpdateTexture (pitch=%d)\n", flush_count, pitch);
    fflush(stdout);

    // Update texture with new pixels
    SDL_UpdateTexture(texture, &rect, px_map, pitch);

    printf("Flush #%d: SDL_UpdateTexture done\n", flush_count);
    fflush(stdout);

    display_needs_refresh = true;

    lv_display_flush_ready(disp);
    printf("Flush #%d: complete\n", flush_count);
    fflush(stdout);
}

/**
 * Initialize SDL2 for LVGL display
 */
static bool init_sdl()
{
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        printf("SDL_Init error: %s\n", SDL_GetError());
        return false;
    }

    window = SDL_CreateWindow(
        "LVGL POC - CAN Display",
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED,
        DISPLAY_WIDTH,
        DISPLAY_HEIGHT,
        SDL_WINDOW_SHOWN
    );

    if (!window) {
        printf("SDL_CreateWindow error: %s\n", SDL_GetError());
        SDL_Quit();
        return false;
    }

    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
    if (!renderer) {
        printf("SDL_CreateRenderer error: %s\n", SDL_GetError());
        SDL_DestroyWindow(window);
        SDL_Quit();
        return false;
    }

    // Set scaling quality
    SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "nearest");

    texture = SDL_CreateTexture(
        renderer,
        SDL_PIXELFORMAT_ARGB8888,
        SDL_TEXTUREACCESS_STREAMING,
        DISPLAY_WIDTH,
        DISPLAY_HEIGHT
    );

    if (!texture) {
        printf("SDL_CreateTexture error: %s\n", SDL_GetError());
        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
        SDL_Quit();
        return false;
    }

    // Clear the texture to black initially
    SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
    SDL_RenderClear(renderer);
    SDL_RenderPresent(renderer);

    printf("SDL2 initialized: %dx%d\n", DISPLAY_WIDTH, DISPLAY_HEIGHT);
    return true;
}

/**
 * Cleanup SDL2 resources
 */
static void cleanup_sdl()
{
    if (texture) SDL_DestroyTexture(texture);
    if (renderer) SDL_DestroyRenderer(renderer);
    if (window) SDL_DestroyWindow(window);
    SDL_Quit();
}

/**
 * Initialize LVGL display driver
 */
static lv_display_t* init_lvgl_display()
{
    lv_display_t* disp = lv_display_create(DISPLAY_WIDTH, DISPLAY_HEIGHT);
    lv_display_set_flush_cb(disp, sdl_display_flush);

    // Set color format to ARGB8888 (4 bytes per pixel) to match SDL texture
    // MUST be set before lv_display_set_buffers
    lv_display_set_color_format(disp, LV_COLOR_FORMAT_ARGB8888);

    // Use PARTIAL mode - buffer for 10 rows at a time
    // Buffer size: 320 * 10 * 4 bytes = 12800 bytes
    lv_display_set_buffers(disp, draw_buf, NULL, sizeof(draw_buf), LV_DISPLAY_RENDER_MODE_PARTIAL);

    return disp;
}

/**
 * Main entry point
 */
int main(int argc, char* argv[])
{
    // Default CAN interface (matches basic.sh test)
    const char* canInterface = "can0";

    // Allow override via command line
    if (argc > 1) {
        canInterface = argv[1];
    }

    printf("LVGL POC - CAN Display starting...\n");
    printf("Using CAN interface: %s\n", canInterface);

    // Initialize LVGL
    lv_init();
    printf("LVGL initialized\n");

    // Initialize SDL2
    if (!init_sdl()) {
        printf("Failed to initialize SDL2\n");
        return 1;
    }

    // Initialize LVGL display driver
    lv_display_t* disp = init_lvgl_display();
    if (!disp) {
        printf("Failed to create LVGL display\n");
        cleanup_sdl();
        return 1;
    }

    // Create UI
    g_ui = new LvglUI();
    g_ui->init();

    // Create alert display (bridges IAlertDisplay to LVGL UI)
    g_alertDisplay = new LvglAlertDisplay(g_ui);

    // Create disconnection report (manages heartbeat timeout)
    g_disconnectionReport = new MeDisconnectionReport(g_alertDisplay);

    // Create CAN receiver
    CanReceiver* canReceiver = new CanReceiver(canInterface);

    // Connect CAN signals to UI updates
    canReceiver->speedChanged.connect([](int speed) {
        printf("Speed received: %d km/h\n", speed);
        fflush(stdout);
        if (g_ui) {
            g_ui->setSpeed(speed);
        }
    });

    canReceiver->fcwChanged.connect([](bool active) {
        printf("FCW %s\n", active ? "ACTIVE" : "inactive");
        fflush(stdout);
        if (g_ui) {
            g_ui->setFCWActive(active);
        }
    });

    // Connect heartbeat to disconnection report
    canReceiver->heartbeatReceived.connect([]() {
        printf("Heartbeat received - resetting timeout\n");
        fflush(stdout);
        if (g_disconnectionReport) {
            g_disconnectionReport->resetConnectionTimeout();
        }
    });

    // Start CAN receiver thread
    canReceiver->start();
    printf("CAN receiver started\n");

    // Launch disconnection report (starts timeout timer)
    g_disconnectionReport->launch();
    printf("Disconnection report started\n");

    // Main loop
    printf("Entering main loop...\n");
    bool running = true;
    auto lastTick = std::chrono::steady_clock::now();

    while (running) {
        // Handle SDL events
        SDL_Event event;
        while (SDL_PollEvent(&event)) {
            if (event.type == SDL_QUIT) {
                running = false;
            }
            if (event.type == SDL_KEYDOWN && event.key.keysym.sym == SDLK_ESCAPE) {
                running = false;
            }
        }

        // Update LVGL tick
        auto now = std::chrono::steady_clock::now();
        auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(now - lastTick).count();
        lastTick = now;
        lv_tick_inc(elapsed);

        // Heartbeat timeout is now handled by MeDisconnectionReport
        // which calls g_alertDisplay->activate(ALERT_NOCOM) or deactivate()

        // Process any pending UI updates from CAN thread
        g_ui->processUpdates();

        // Handle LVGL tasks
        lv_timer_handler();

        // Present the frame if display was updated
        if (display_needs_refresh) {
            printf("Main loop: rendering frame\n");
            fflush(stdout);
            SDL_RenderCopy(renderer, texture, NULL, NULL);
            SDL_RenderPresent(renderer);
            display_needs_refresh = false;
            printf("Main loop: frame rendered\n");
            fflush(stdout);
        }

        // Small sleep to limit CPU usage (~60 FPS)
        std::this_thread::sleep_for(std::chrono::milliseconds(16));
    }

    printf("Shutting down...\n");

    // Cleanup
    delete canReceiver;
    delete g_disconnectionReport;
    delete g_alertDisplay;
    delete g_ui;
    cleanup_sdl();
    lv_deinit();

    printf("LVGL POC finished\n");
    return 0;
}
