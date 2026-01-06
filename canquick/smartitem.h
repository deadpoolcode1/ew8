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

    static SmartItem * getInstance(uint8_t aVisId);

    typedef struct smart_params_s{
     visual_item_unit_t visUnits;
     uint8_t paramInt;
     uint8_t paramFrac;
     uint32_t minDurationMs;
     uint32_t maxDurationMs;
    } smart_params_t;


    void setDisplay(IAlertDisplay *anAlertDisplay);

    void visualDeactivate(void);


    void setActive(smart_params_t & _params);
    void setInactive(void);

protected:
    explicit SmartItem(uint8_t aVisId, QObject * parent = nullptr);
    static SmartItem * smartItemsPool[MAX_SMART_ITEMS_NUM];
    static size_t  smartItemsPoolNumOfObjects;

    IAlertDisplay * alertsDisplay;

    //TODO addTimers:
    bool isActived;
    uint8_t visId;

    DISPLAY_ITEM_ID itsAlert;


    //functions:

public slots:

    void fireItsMinActiveTime();
    void fireItsMaxActiveTime();

private:
    uint32_t minDurationTime;
    uint32_t maxDurationTime;

    QTimer * minDurationQtimer;
    QTimer * maxDurationQtimer;

    smart_params_t params;
};

#endif // SMARTITEM_H
