#ifndef LVGL_UI_H
#define LVGL_UI_H

#include "lvgl.h"
#include <atomic>

/**
 * LVGL UI Manager
 *
 * Creates and manages the UI widgets:
 * - Speed display (centered number with km/h label)
 * - FCW alert box (red warning box, shown when active)
 *
 * Thread-safe: uses atomic flags for cross-thread updates
 */
class LvglUI {
public:
    LvglUI();
    ~LvglUI();

    // Initialize UI (must be called after lv_init and display setup)
    void init();

    // Update methods (thread-safe, call from any thread)
    void setSpeed(int speed);
    void setFCWActive(bool active);
    void setDisconnected(bool disconnected);

    // Apply pending updates (call from LVGL thread in main loop)
    void processUpdates();

private:
    void createSpeedDisplay();
    void createFCWAlert();
    void createDisconnectedOverlay();

    // Widget pointers
    lv_obj_t* speedValueLabel_;
    lv_obj_t* speedUnitLabel_;
    lv_obj_t* fcwContainer_;
    lv_obj_t* fcwLabel_;
    lv_obj_t* disconnectedOverlay_;
    lv_obj_t* disconnectedLabel_;

    // Thread-safe update mechanism
    std::atomic<int> pendingSpeed_;
    std::atomic<bool> pendingFCW_;
    std::atomic<bool> pendingDisconnected_;
    std::atomic<bool> speedDirty_;
    std::atomic<bool> fcwDirty_;
    std::atomic<bool> disconnectedDirty_;

    // Display dimensions (matching original Qt project)
    static constexpr int DISPLAY_WIDTH = 320;
    static constexpr int DISPLAY_HEIGHT = 240;
};

#endif // LVGL_UI_H
