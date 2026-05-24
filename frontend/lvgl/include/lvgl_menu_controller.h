#ifndef LVGL_MENU_CONTROLLER_H
#define LVGL_MENU_CONTROLLER_H

#include "lvgl.h"
#include <string>

class CanManager;

class LvglMenuController {
public:
    LvglMenuController(lv_obj_t* parent, CanManager* canmgr);

    // SDL key event handler (SDLK_UP, SDLK_DOWN, SDLK_RETURN)
    void handleKeyEvent(int sdlKey);

    // Volume entity triggers
    void showVolumeMenu(uint8_t value, uint8_t min, uint8_t max);
    void hideVolumeMenu();
    void showVolumeFail();

    // QR code entity triggers
    void activateQRCode(const std::string& data);
    void deactivateQRCode();

    // Dual-key press handler for QR activation (Up+Down held simultaneously)
    void handleDualKeyPress();

    // ISA state machine: ISA available when STATE_ISA_NOT_TSR activated
    void setIsaAvailable(bool available);
    bool isIsaAvailable() const { return isaAvailable_; }

    // Gates the user-accessible menus (brightness/ISA/about), mirroring the QML
    // isDisplayOfMenusEnabled property: menus are blocked while the vehicle
    // speed is being shown or an error overlay is up. When disabled, any open
    // speed-gated menu is dismissed immediately (QML onIsDisplayOfMenusEnabledChanged).
    void setMenusEnabled(bool enabled);

    // Gates the idle-screen master-volume Up/Down shortcut, mirroring the QML
    // is_volume_enabled / is_remote_menu_request_enabled gate: the volume keys
    // are live only while no disconnect/error/FCW overlay is up. ("No menu open"
    // — the other half of is_volume_enabled — is implied by currentMenu_ ==
    // MENU_NONE at the call site.)
    void setVolumeEnabled(bool enabled);

private:
    enum MenuPage { MENU_NONE, MENU_BRIGHTNESS, MENU_ISA, MENU_ABOUT, MENU_VOLUME };

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
    static void qrActivateTimerCb(lv_timer_t* timer);
    static void qrDeactivateTimerCb(lv_timer_t* timer);

    lv_obj_t* parent_;
    CanManager* canmgr_;
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
    lv_obj_t* qrCode_;
    bool qrActive_;                // INFO_QRCODE entity is active (data ready)
    std::string qrData_;           // stored QR data string
    lv_timer_t* qrActivateTimer_;  // 5-second press-to-activate timer
    lv_timer_t* qrDeactivateTimer_; // 20-second auto-hide timer

    // ISA availability (driven by STATE_ISA_NOT_TSR / STATE_TSR_NOT_ISA)
    bool isaAvailable_;

    // Whether the speed-gated menus may be opened (QML isDisplayOfMenusEnabled).
    bool menusEnabled_;

    // Whether the idle-screen volume Up/Down shortcut is live (QML
    // is_remote_menu_request_enabled): false during disconnect/error/FCW.
    bool volumeEnabled_;

    // Auto-hide timer
    lv_timer_t* autoHideTimer_;
};

#endif // LVGL_MENU_CONTROLLER_H
