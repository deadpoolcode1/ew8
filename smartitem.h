#ifndef SMARTITEM_H
#define SMARTITEM_H

#include <QTimer>
#include <QTimerEvent>
#include "defs.h"
#include "smartcanrxmsg.h"
#include <QObject>

class IAlertDisplay;

class SmartItem : public QObject
{
    Q_OBJECT

public:

    static SmartItem * getInstance(quint8 aVisId);

    typedef struct smart_params_s{
     visual_item_unit_t visUnits;
     quint8 paramInt;
     quint8 paramFrac;
     quint32 minDurationMs;
     quint32 maxDurationMs;
    } smart_params_t;


    void setDisplay(IAlertDisplay *anAlertDisplay);

    void visualDeactivate(void);


    void setActive(smart_params_t & _params);
    void setInactive(void);

protected:
     explicit SmartItem(quint8 aVisId);
    static SmartItem * smartItemsPool[MAX_SMART_ITEMS_NUM];
    static size_t  smartItemsPoolNumOfObjects;

    IAlertDisplay * alertsDisplay;

    //TODO addTimers:
    //QDateTime qdt;
    bool isActived;
    quint8 visId;

    DISPLAY_ITEM_ID itsAlert;


    //functions:

public slots:

    void fireItsMinActiveTime();
    void fireItsMaxActiveTime();

private:
    quint32 minDurationTime;
    quint32 maxDurationTime;

    QTimer * minDurationQtimer;
    QTimer * maxDurationQtimer;

    smart_params_t params;
};

#endif // SMARTITEM_H
