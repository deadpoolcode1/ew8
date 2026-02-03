#include "lvgl_alert_display.h"
#include "lvgl_ui.h"
#include <cstdio>

LvglAlertDisplay::LvglAlertDisplay(LvglUI* ui) : ui_(ui) {}

void LvglAlertDisplay::activate(DISPLAY_ITEM_ID at, uint8_t valueInt,
                                 uint8_t valueFrac, uint8_t unit)
{
    printf("LvglAlertDisplay::activate(%d, %d, %d, %d)\n", at, valueInt, valueFrac, unit);
    fflush(stdout);

    switch (at) {
        case AlertTypes::ALERT_NOCOM:
            ui_->setDisconnected(true);
            break;

        case AlertTypes::ALERT_REQFAIL:
            // Request timeout - could show a brief error indicator
            // For now, just log it
            printf("  Request timeout alert activated\n");
            break;

        // Future Phase 2+: Add more display items here
        // case INFO_VEH_SPEED:
        //     ui_->setSpeed(valueInt);
        //     break;
        // case ALERT_FCW:
        //     ui_->setFCWActive(true);
        //     break;

        default:
            printf("  Unhandled display item: %d\n", at);
            break;
    }
}

void LvglAlertDisplay::activate(DISPLAY_ITEM_ID at, const std::string& stringArg)
{
    printf("LvglAlertDisplay::activate(%d, \"%s\")\n", at, stringArg.c_str());
    fflush(stdout);

    // Handle string-based activations
    // Future: could be used for message displays
}

void LvglAlertDisplay::deactivate(DISPLAY_ITEM_ID at)
{
    printf("LvglAlertDisplay::deactivate(%d)\n", at);
    fflush(stdout);

    switch (at) {
        case AlertTypes::ALERT_NOCOM:
            ui_->setDisconnected(false);
            break;

        case AlertTypes::ALERT_REQFAIL:
            // Hide request timeout indicator
            break;

        // Future: Add more display items here
        // case ALERT_FCW:
        //     ui_->setFCWActive(false);
        //     break;

        default:
            break;
    }
}

void LvglAlertDisplay::forceUpdate()
{
    // The LVGL UI uses atomic flags, so updates are applied
    // in the next processUpdates() call in the main loop.
    // No additional action needed here.
    printf("LvglAlertDisplay::forceUpdate()\n");
    fflush(stdout);
}

void LvglAlertDisplay::message(const std::string& msg)
{
    printf("LvglAlertDisplay::message: %s\n", msg.c_str());
    fflush(stdout);

    // Future: Could display a toast or status message in the UI
}
