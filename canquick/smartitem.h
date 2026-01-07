#ifndef SMARTITEM_H
#define SMARTITEM_H

#include "core/timer.h"
#include "defs.h"
#include "smartcanrxmsg.h"

class IAlertDisplay;

class SmartItem
{
public:

    static SmartItem * getInstance(uint8_t aVisId);
    ~SmartItem();

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

    void fireItsMinActiveTime();
    void fireItsMaxActiveTime();

protected:
    explicit SmartItem(uint8_t aVisId);
    static SmartItem * smartItemsPool[MAX_SMART_ITEMS_NUM];
    static size_t  smartItemsPoolNumOfObjects;

    IAlertDisplay * alertsDisplay;

    //TODO addTimers:
    bool isActived;
    uint8_t visId;

    DISPLAY_ITEM_ID itsAlert;

private:
    uint32_t minDurationTime;
    uint32_t maxDurationTime;

    core::Timer* minDurationTimer;
    core::Timer* maxDurationTimer;

    smart_params_t params;
};

#endif // SMARTITEM_H
