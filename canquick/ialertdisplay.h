#ifndef IALERTDISPLAY_H
#define IALERTDISPLAY_H

// Include Qt headers first via alerttypes.h and defs.h
#include "alerttypes.h"
#include "defs.h"

// Then include core library (which will skip Qt-like types if Qt is present)
#include "core/mutex.h"

#include <string>

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
