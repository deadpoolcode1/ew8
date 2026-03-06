#ifndef LVGL_MENU_CONTROLLER_H
#define LVGL_MENU_CONTROLLER_H

#include "lvgl.h"
#include <string>

class LvglMenuController {
public:
    LvglMenuController(lv_obj_t* parent);

    // SDL key event handler (SDLK_UP, SDLK_DOWN, SDLK_RETURN)
    void handleKeyEvent(int sdlKey);

    // Volume entity triggers
    void showVolumeMenu(uint8_t value, uint8_t min, uint8_t max);
    void hideVolumeMenu();
    void showVolumeFail();

    // QR code entity triggers
    void showQRCode(const std::string& data);
    void hideQRCode();

private:
    enum MenuPage { MENU_NONE, MENU_BRIGHTNESS, MENU_ISA, MENU_ABOUT };

    void showMenu(MenuPage page);
    void hideAllMenus();
    void restartAutoHide(int intervalMs);

    void updateBrightnessDisplay();
    void updateISADisplay();
    void updateVolumeDisplay();

    // Progress bar helper
    struct ProgressBar {
        lv_obj_t* fillBar;
        lv_obj_t* ball;
        int barWidth;
        int barX;
    };

    ProgressBar createProgressBar(lv_obj_t* parent, int y, int numSegments, int lowerLimit,
                                   bool useImages = false);
    void updateProgressBar(ProgressBar& pb, int value, int lowerLimit, int numSegments);

    lv_obj_t* createFooterDots(lv_obj_t* parent, int numDots, int activeDot);

    static void autoHideTimerCb(lv_timer_t* timer);

    lv_obj_t* parent_;
    MenuPage currentMenu_;

    // Brightness (levels 1-5)
    int brightnessLevel_;
    lv_obj_t* brightnessScreen_;
    lv_obj_t* brightnessIcon_;
    lv_obj_t* brightnessValueLabel_;
    ProgressBar brightnessBar_;

    // Volume
    uint8_t volumeValue_, volumeMin_, volumeMax_;
    lv_obj_t* volumeScreen_;
    lv_obj_t* volumeIcon_;
    lv_obj_t* volumeValueLabel_;
    ProgressBar volumeBar_;

    // ISA (modes 0-2)
    int isaMode_;
    lv_obj_t* isaScreen_;
    lv_obj_t* isaIcon_;
    ProgressBar isaBar_;

    // About
    lv_obj_t* aboutScreen_;

    // QR code
    lv_obj_t* qrScreen_;
    lv_obj_t* qrLabel_;

    // Auto-hide timer
    lv_timer_t* autoHideTimer_;
};

#endif // LVGL_MENU_CONTROLLER_H
