#ifndef SDL_DISPLAY_H
#define SDL_DISPLAY_H

#include "lvgl.h"

// Initialize SDL2 window + LVGL display driver.
// Returns the LVGL display, or nullptr on failure.
lv_display_t* sdl_display_init(int width, int height);

// Cleanup SDL2 resources.
void sdl_display_cleanup();

// Present rendered frame to screen (call after lv_timer_handler).
void sdl_display_present_if_needed();

// Poll SDL events. Returns false if quit requested (window close or Escape).
bool sdl_display_poll_events();

// Get last key pressed during poll (SDL key code, or 0 if none).
int sdl_display_get_last_key();

// Returns true if Up+Down are held simultaneously (for QR code activation).
bool sdl_display_get_dual_key_press();

#endif // SDL_DISPLAY_H
