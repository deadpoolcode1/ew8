#ifndef IALERTDISPLAY_H
#define IALERTDISPLAY_H


#include <QObject>
#include <QMutex>
#include "alerttypes.h"
#include "defs.h"

class IAlertDisplay
{

  public:

    virtual void activate(DISPLAY_ITEM_ID at, quint8 valueInt = 0, quint8 valueFrac = 0, visual_item_unit_t unit = viu_None) = 0;
    virtual void activate(DISPLAY_ITEM_ID at, QString stringArg) = 0;
    virtual void deactivate(DISPLAY_ITEM_ID at) = 0;

    virtual void forceUpdate(void) = 0;

    QMutex mutex;
};


#endif // IALERTDISPLAY_H
