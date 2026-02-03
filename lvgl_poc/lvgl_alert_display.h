#ifndef LVGL_ALERT_DISPLAY_H
#define LVGL_ALERT_DISPLAY_H

#include "ialertdisplay_core.h"

class LvglUI;

/**
 * LVGL implementation of IAlertDisplay
 *
 * Maps DISPLAY_ITEM_ID to LVGL widget updates.
 * Thread-safe via atomic flags in LvglUI.
 */
class LvglAlertDisplay : public IAlertDisplay {
public:
    /**
     * Construct LVGL alert display
     * @param ui Pointer to LvglUI instance for widget updates
     */
    explicit LvglAlertDisplay(LvglUI* ui);

    /**
     * Activate a display item with numeric values
     */
    void activate(DISPLAY_ITEM_ID at, uint8_t valueInt,
                  uint8_t valueFrac, uint8_t unit) override;

    /**
     * Activate a display item with string argument
     */
    void activate(DISPLAY_ITEM_ID at, const std::string& stringArg) override;

    /**
     * Deactivate (hide) a display item
     */
    void deactivate(DISPLAY_ITEM_ID at) override;

    /**
     * Force immediate UI update
     */
    void forceUpdate() override;

    /**
     * Display a message to the user
     */
    void message(const std::string& msg) override;

private:
    LvglUI* ui_;
};

#endif // LVGL_ALERT_DISPLAY_H
