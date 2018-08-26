#ifndef IALERTDISPLAY_H
#define IALERTDISPLAY_H


#include <QObject>
#include <QMutex>
#include "alerttypes.h"

class IAlertDisplay
{

  public:

    virtual void activate(AlertTypes::EnAlert at, quint8 value = 0) = 0;
    virtual void deactivate(AlertTypes::EnAlert at) = 0;

    QMutex mutex;
};


#endif // IALERTDISPLAY_H
