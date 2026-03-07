#include "sdl_display.h"
#include <SDL2/SDL.h>
#include <cstdio>

// SDL resources
static SDL_Window* window = nullptr;
static SDL_Renderer* renderer = nullptr;
static SDL_Texture* texture = nullptr;

// LVGL draw buffers (double-buffered, full-screen sized for partial rendering)
static uint32_t* draw_buf1 = nullptr;
static uint32_t* draw_buf2 = nullptr;
static int display_width = 0;
static int display_height = 0;

// Flag to track if display needs refresh
static bool display_needs_refresh = false;

// Last key pressed during poll
static int last_key_pressed = 0;

// Track held keys for dual-key detection
static bool key_up_held = false;
static bool key_down_held = false;
static bool dual_key_detected = false;

/**
 * SDL display flush callback for LVGL
 */
static void sdl_display_flush(lv_display_t* disp, const lv_area_t* area, uint8_t* px_map)
{
    SDL_Rect rect;
    rect.x = area->x1;
    rect.y = area->y1;
    rect.w = area->x2 - area->x1 + 1;
    rect.h = area->y2 - area->y1 + 1;

    int32_t bytes_per_pixel = lv_color_format_get_size(lv_display_get_color_format(disp));
    int32_t pitch = rect.w * bytes_per_pixel;

    SDL_UpdateTexture(texture, &rect, px_map, pitch);
    display_needs_refresh = true;
    lv_display_flush_ready(disp);
}

lv_display_t* sdl_display_init(int width, int height)
{
    display_width = width;
    display_height = height;

    // Initialize SDL2
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        printf("SDL_Init error: %s\n", SDL_GetError());
        return nullptr;
    }

    window = SDL_CreateWindow(
        "EW8 LVGL Frontend",
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        width, height,
        SDL_WINDOW_SHOWN
    );
    if (!window) {
        printf("SDL_CreateWindow error: %s\n", SDL_GetError());
        SDL_Quit();
        return nullptr;
    }

    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (!renderer) {
        printf("SDL_CreateRenderer error: %s\n", SDL_GetError());
        SDL_DestroyWindow(window);
        SDL_Quit();
        return nullptr;
    }

    SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "nearest");

    texture = SDL_CreateTexture(
        renderer,
        SDL_PIXELFORMAT_ARGB8888,
        SDL_TEXTUREACCESS_STREAMING,
        width, height
    );
    if (!texture) {
        printf("SDL_CreateTexture error: %s\n", SDL_GetError());
        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
        SDL_Quit();
        return nullptr;
    }

    // Clear to black
    SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
    SDL_RenderClear(renderer);
    SDL_RenderPresent(renderer);

    // Create LVGL display driver — double-buffered, partial rendering
    // Partial mode only redraws dirty areas; full-screen buffers avoid band-splitting
    size_t buf_size = width * height * sizeof(uint32_t);
    draw_buf1 = new uint32_t[width * height];
    draw_buf2 = new uint32_t[width * height];

    lv_display_t* disp = lv_display_create(width, height);
    lv_display_set_flush_cb(disp, sdl_display_flush);
    lv_display_set_color_format(disp, LV_COLOR_FORMAT_ARGB8888);
    lv_display_set_buffers(disp, draw_buf1, draw_buf2, buf_size,
                           LV_DISPLAY_RENDER_MODE_PARTIAL);

    printf("SDL2 + LVGL display initialized: %dx%d\n", width, height);
    return disp;
}

void sdl_display_cleanup()
{
    delete[] draw_buf1;
    delete[] draw_buf2;
    draw_buf1 = nullptr;
    draw_buf2 = nullptr;
    if (texture) SDL_DestroyTexture(texture);
    if (renderer) SDL_DestroyRenderer(renderer);
    if (window) SDL_DestroyWindow(window);
    SDL_Quit();
}

void sdl_display_present_if_needed()
{
    if (display_needs_refresh) {
        SDL_RenderCopy(renderer, texture, NULL, NULL);
        SDL_RenderPresent(renderer);
        display_needs_refresh = false;
    }
}

bool sdl_display_poll_events()
{
    last_key_pressed = 0;
    dual_key_detected = false;
    SDL_Event event;
    while (SDL_PollEvent(&event)) {
        if (event.type == SDL_QUIT)
            return false;
        if (event.type == SDL_KEYDOWN) {
            if (event.key.keysym.sym == SDLK_ESCAPE)
                return false;
            last_key_pressed = event.key.keysym.sym;
            if (event.key.keysym.sym == SDLK_UP) key_up_held = true;
            if (event.key.keysym.sym == SDLK_DOWN) key_down_held = true;
        }
        if (event.type == SDL_KEYUP) {
            if (event.key.keysym.sym == SDLK_UP) key_up_held = false;
            if (event.key.keysym.sym == SDLK_DOWN) key_down_held = false;
        }
    }
    if (key_up_held && key_down_held)
        dual_key_detected = true;
    return true;
}

int sdl_display_get_last_key()
{
    return last_key_pressed;
}

bool sdl_display_get_dual_key_press()
{
    return dual_key_detected;
}
