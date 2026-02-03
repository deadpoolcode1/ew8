#ifndef IALERTDISPLAY_CORE_H
#define IALERTDISPLAY_CORE_H

#include "alerttypes_core.h"
#include "core/mutex.h"
#include <string>
#include <cstdint>

/**
 * Qt-free interface for alert display
 * Matches the interface in ialertdisplay.h for compatibility with Qt backend
 */
class IAlertDisplay {
public:
    virtual ~IAlertDisplay() = default;

    /**
     * Activate a display item with numeric values
     * @param at Display item ID (e.g., ALERT_NOCOM)
     * @param valueInt Integer part of value (e.g., speed)
     * @param valueFrac Fractional part of value
     * @param unit Unit identifier
     */
    virtual void activate(DISPLAY_ITEM_ID at, uint8_t valueInt = 0,
                         uint8_t valueFrac = 0, uint8_t unit = 0) = 0;

    /**
     * Activate a display item with string argument
     * @param at Display item ID
     * @param stringArg String argument (e.g., message text)
     */
    virtual void activate(DISPLAY_ITEM_ID at, const std::string& stringArg) = 0;

    /**
     * Deactivate (hide) a display item
     * @param at Display item ID to deactivate
     */
    virtual void deactivate(DISPLAY_ITEM_ID at) = 0;

    /**
     * Force immediate UI update
     */
    virtual void forceUpdate() = 0;

    /**
     * Display a message to the user
     * @param stringMessage Message to display
     */
    virtual void message(const std::string& stringMessage) = 0;

    /**
     * Mutex for thread-safe access to display
     */
    core::Mutex mutex;
};

#endif // IALERTDISPLAY_CORE_H
