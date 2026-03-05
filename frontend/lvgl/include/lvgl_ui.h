#ifndef LVGL_UI_H
#define LVGL_UI_H

#include "lvgl.h"
#include <atomic>

class LvglUI {
public:
    LvglUI();

    // Initialize UI widgets (call after lv_init + display setup)
    void init();

    // Thread-safe: call from any thread
    void setDisconnected(bool disconnected);

    // Apply pending updates (call from main loop / LVGL thread)
    void processUpdates();

private:
    void createDisconnectedOverlay();

    lv_obj_t* disconnectedOverlay_;

    std::atomic<bool> pendingDisconnected_;
    std::atomic<bool> disconnectedDirty_;

    static constexpr int DISPLAY_WIDTH = 320;
    static constexpr int DISPLAY_HEIGHT = 240;
};

#endif // LVGL_UI_H
