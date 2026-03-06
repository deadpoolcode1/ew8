#ifndef LVGL_WIDGETS_H
#define LVGL_WIDGETS_H

#include "lvgl.h"

namespace LvglWidgets {

struct StatusBarWidgets {
    lv_obj_t* hiBeamIcon;
    lv_obj_t* loBeamIcon;
    lv_obj_t* blinkerIcon;
    lv_obj_t* gpsIcon;
    lv_obj_t* gsmIcon;
    lv_obj_t* signedInIcon;
    lv_obj_t* signedOutIcon;
    lv_obj_t* signedProcessIcon;
    lv_obj_t* isaErrorIcon;
    lv_obj_t* isaInactiveIcon;
    lv_obj_t* isaPartialIcon;
    lv_obj_t* isaActiveIcon;
    lv_obj_t* muteIcon;
};

struct HMWWidgets {
    lv_obj_t* container;
    lv_obj_t* roadStrip;
    lv_obj_t* forwardCar;
    lv_obj_t* hostCar;
    lv_obj_t* valueLabel;
};

// Top status bar with logo and all status icons
StatusBarWidgets createStatusBar(lv_obj_t* parent);

// Full-screen disconnect overlay with warning icon and "Disconnected" label
lv_obj_t* createDisconnectOverlay(lv_obj_t* parent);

// Full-screen FCW alert with animated GIF
lv_obj_t* createFCWAlert(lv_obj_t* parent);

// Full-screen PCW alert with animated GIF
lv_obj_t* createPCWAlert(lv_obj_t* parent);

// Speed display panel at bottom-center; outputs valueLabel and unitLabel for dynamic text
lv_obj_t* createSpeedDisplay(lv_obj_t* parent, lv_obj_t** valueLabel, lv_obj_t** unitLabel = nullptr);

// HMW distance display with road strip GIF, forward car, host car, and time value
HMWWidgets createHMWDisplay(lv_obj_t* parent);

// LDW lane departure indicator (blinking line — isLeft=true for left, false for right)
lv_obj_t* createLDWIndicator(lv_obj_t* parent, bool isLeft);

// LDW lane off indicator (yellow lane — isLeft=true for left, false for right)
lv_obj_t* createLDWOffIndicator(lv_obj_t* parent, bool isLeft);

// LDW lane on indicator (green normal lane — isLeft=true for left, false for right)
lv_obj_t* createLDWOnIndicator(lv_obj_t* parent, bool isLeft);

// Full-screen error overlay with yellow error image
lv_obj_t* createErrorOverlay(lv_obj_t* parent);

// Full-screen failsafe overlay with eye icon and "Low Visibility" label
lv_obj_t* createFailsafeOverlay(lv_obj_t* parent);

// Operation mode overlay with centered label text
lv_obj_t* createOpModeOverlay(lv_obj_t* parent, const char* text);

// PDZ pedestrian danger zone overlay (positioned in main panel area)
lv_obj_t* createPDZOverlay(lv_obj_t* parent);

// Left panel sign (image only, e.g. TSR signs). upperSlot=true for top, false for bottom.
lv_obj_t* createLeftPanelSign(lv_obj_t* parent, const char* imageSrc, bool upperSlot);

// Speed limit sign with numeric overlay (SLI/ISA). Returns container, outputs speedLabel.
lv_obj_t* createSpeedLimitSign(lv_obj_t* parent, const char* signImgSrc, bool upperSlot, lv_obj_t** speedLabel);

// Full-screen RTW alert (black bg + large traffic light image)
lv_obj_t* createRTWAlert(lv_obj_t* parent);

// Right panel sign (image only, e.g. SmartADAS icons). upperSlot=true for top, false for bottom.
lv_obj_t* createRightPanelSign(lv_obj_t* parent, const char* imageSrc, bool upperSlot);

// Full-screen colored rectangle overlay (for RGB display tests)
lv_obj_t* createColorOverlay(lv_obj_t* parent, lv_color_t color);

// Full-screen TV pattern overlay (SMPTE test image)
lv_obj_t* createTVPatternOverlay(lv_obj_t* parent);

// Signal test background (320x240 image, used as modeGroup container)
lv_obj_t* createSignalTestScreen(lv_obj_t* parent);

// Peripheral test background (320x240 image, used as modeGroup container)
lv_obj_t* createPeripheralTestScreen(lv_obj_t* parent);

// Peripheral test group row container (title + sub-items area, 320x80)
// yPos: vertical position (0=top, 80=middle, 160=bottom)
lv_obj_t* createPeripheralTestGroupRow(lv_obj_t* parent, const char* title, int yPos);

} // namespace LvglWidgets

#endif // LVGL_WIDGETS_H
