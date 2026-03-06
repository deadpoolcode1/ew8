#ifndef LVGL_WIDGETS_H
#define LVGL_WIDGETS_H

#include "lvgl.h"

namespace LvglWidgets {

// Top status bar with logo (always visible, not in display tree)
lv_obj_t* createStatusBar(lv_obj_t* parent);

// Full-screen disconnect overlay with warning icon and "Disconnected" label
lv_obj_t* createDisconnectOverlay(lv_obj_t* parent);

// Full-screen FCW alert with animated GIF
lv_obj_t* createFCWAlert(lv_obj_t* parent);

// Full-screen PCW alert with animated GIF
lv_obj_t* createPCWAlert(lv_obj_t* parent);

// Speed display panel at bottom-center; outputs valueLabel for dynamic text
lv_obj_t* createSpeedDisplay(lv_obj_t* parent, lv_obj_t** valueLabel);

// HMW distance display; outputs valueLabel for dynamic text
lv_obj_t* createHMWDisplay(lv_obj_t* parent, lv_obj_t** valueLabel);

// LDW lane indicator (isLeft=true for left, false for right)
lv_obj_t* createLDWIndicator(lv_obj_t* parent, bool isLeft);

// Full-screen error overlay with yellow error image
lv_obj_t* createErrorOverlay(lv_obj_t* parent);

} // namespace LvglWidgets

#endif // LVGL_WIDGETS_H
