#ifndef IALERTDISPLAY_H
#define IALERTDISPLAY_H


#include <QObject>
#include <QMutex>
#include "alerttypes.h"
#include "defs.h"

class IAlertDisplay
{

  public:

    virtual void activate(AlertTypes::EnAlert at, quint8 valueInt = 0, quint8 valueFrac = 0, visual_item_unit_t unit = viu_None) = 0;
    virtual void deactivate(AlertTypes::EnAlert at) = 0;

    QMutex mutex;
};


#endif // IALERTDISPLAY_H
