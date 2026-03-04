#ifndef IALERTDISPLAY_H
#define IALERTDISPLAY_H

#include "alerttypes_core.h"
#include "core/mutex.h"

#include <string>
#include <cstdint>

class IAlertDisplay
{

  public:

    virtual void activate(DISPLAY_ITEM_ID at, uint8_t valueInt = 0, uint8_t valueFrac = 0, uint8_t unit = 0) = 0;
    virtual void activate(DISPLAY_ITEM_ID at, const std::string& stringArg) = 0;
    virtual void deactivate(DISPLAY_ITEM_ID at) = 0;

    virtual void forceUpdate(void) = 0;
    virtual void message(const std::string& stringMessage) = 0;

    core::Mutex mutex;
};


#endif // IALERTDISPLAY_H
