#ifndef IALERTDISPLAY_H
#define IALERTDISPLAY_H


#include <QObject>
#include <QMutex>
#include "alerttypes.h"

class IAlertDisplay
{

  public:
    virtual void display(AlertTypes::EnAlert at) = 0;
    virtual void hide(AlertTypes::EnAlert at) = 0;


    QMutex mutex;
};


#endif // IALERTDISPLAY_H
