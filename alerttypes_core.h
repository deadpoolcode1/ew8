#ifndef ALERTTYPES_CORE_H
#define ALERTTYPES_CORE_H

#include <cstdint>

/**
 * Qt-free alert type definitions.
 * The Qt wrapper class in alerttypes.h re-exposes these for QML.
 */
namespace AlertTypes {

enum EnAlert {
    QtQG = 0,              // group

    // Alert Items:
    ALERT_NONE = 1,
    ALERT_NOCOM = 2,
    ALERT_REQFAIL = 3,

    // Special Item:
    ALERT_END_OF_TYPE,
};

} // namespace AlertTypes

// Enables usage of JSON enums unlisted in C++
typedef int32_t DISPLAY_ITEM_ID;

#endif // ALERTTYPES_CORE_H
