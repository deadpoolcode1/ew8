#ifndef IALERTDISPLAY_H
#define IALERTDISPLAY_H

// Use core library instead of Qt
#include "core/mutex.h"
#include "core/types.h"

#include <string>

#include "alerttypes.h"
#include "defs.h"

class IAlertDisplay
{

  public:

    virtual void activate(DISPLAY_ITEM_ID at, quint8 valueInt = 0, quint8 valueFrac = 0, quint8 unit = 0) = 0;
    virtual void activate(DISPLAY_ITEM_ID at, const std::string& stringArg) = 0;
    virtual void deactivate(DISPLAY_ITEM_ID at) = 0;

    virtual void forceUpdate(void) = 0;
    virtual void message(const std::string& stringMessage) = 0;

    core::Mutex mutex;
};


#endif // IALERTDISPLAY_H
