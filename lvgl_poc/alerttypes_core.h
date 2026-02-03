#ifndef ALERTTYPES_CORE_H
#define ALERTTYPES_CORE_H

#include <cstdint>

/**
 * Qt-free alert type definitions
 * Matches the values in alerttypes.h for compatibility with Qt backend
 */
namespace AlertTypes {

enum EnAlert {
    QtQG = 0,              // group

    // Alert Items:
    ALERT_NONE = 1,
    ALERT_NOCOM = 2,       // Disconnected - shows yellow triangle
    ALERT_REQFAIL = 3,     // Request timeout

    // Special Item:
    ALERT_END_OF_TYPE,
};

} // namespace AlertTypes

// DISPLAY_ITEM_ID type (matches defs.h)
typedef int32_t DISPLAY_ITEM_ID;

// Connection timeout values
// Note: The Qt backend reads this from EW8_Signals.json "timeout" field
// For IMS_Status_Protocol_System, it's 20000ms (20 seconds)
constexpr int DEFAULT_EW_CAN_CONNECTION_TIMEOUT = 20000;  // 20 seconds (from JSON config)
constexpr int DEFAULT_EW_KEEP_ALIVE_TIMEOUT = 200;

#endif // ALERTTYPES_CORE_H
