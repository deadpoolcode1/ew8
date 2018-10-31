#include "smartitem.h"
#include "defs.h"

#include <QDateTime>


SmartItem * SmartItem::smartItemsPool[];
size_t  SmartItem::smartItemsPoolNumOfObjects = 0;

SmartItem::SmartItem(quint8 aVisId)
{
   visId = aVisId;
   isActive = false;
   isNextActive = false;

   minDurationQtimer = new QTimer(this);
   minDurationQtimer->setSingleShot(true);
   connect(minDurationQtimer, SIGNAL(timeout()), this, SLOT(fireItsMinActiveTime()));


   maxDurationQtimer = new QTimer(this);
   maxDurationQtimer->setSingleShot(true);
   connect(maxDurationQtimer, SIGNAL(timeout()), this, SLOT(fireItsMaxActiveTime()));


   //TODO use to update current time
   //qdt = QDateTime::currentSecsSinceEpoch();
}

SmartItem * SmartItem::getInstance(quint8 aVisId)
{
    SmartItem * ret = nullptr;

    for (size_t i=0; i < smartItemsPoolNumOfObjects; i++)
    {
        if(aVisId == smartItemsPool[i]->visId)
        {
            ret = smartItemsPool[i];
            i = smartItemsPoolNumOfObjects;
        }
    }

    if(nullptr == ret)
    {
        if(smartItemsPoolNumOfObjects < MAX_SMART_ITEMS_NUM)
        {
            ret = new SmartItem(aVisId);
            smartItemsPoolNumOfObjects ++;
        }
        else
        {
            //skip
        }
    }

    return ret;
}

void SmartItem::setActive(smart_params_t _params)
{
   if(!isActive)
   {
      minDurationQtimer->start(minDurationTime);
      maxDurationQtimer->start(maxDurationTime);
   }
   isActive = true;
}

void SmartItem::setInactive(void)
{
    if(isActive)
    {
        minDurationQtimer->stop();
        maxDurationQtimer->stop();
    }
}

void SmartItem::fireItsMinActiveTime(void)
{
    //minDurationQtimer->stop();
}


void SmartItem::fireItsMaxActiveTime(void)
{
    //maxDurationQtimer->stop();
    isActive = false;
}


