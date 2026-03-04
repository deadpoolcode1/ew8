#include "smartitem.h"
#include "defs.h"
#include "core/logger.h"

#include <stdint.h>



SmartItem * SmartItem::smartItemsPool[];
size_t  SmartItem::smartItemsPoolNumOfObjects = 0;

SmartItem::SmartItem(uint8_t aVisId)
{
   visId = aVisId;
   //TODO ensure  SMART_BASE < range < ALERT_END_OF_TYPE
   itsAlert = (DISPLAY_ITEM_ID)(AlertTypes::SMART_BASE + aVisId);
   isActived = false;

   alertsDisplay = nullptr;

   minDurationTime = 0;
   minDurationTimer = new core::Timer();
   minDurationTimer->setSingleShot(true);
   minDurationTimer->timeout.connect([this]() {
       fireItsMinActiveTime();
   });

   LOG_DEBUG("SmartItem with VisId %d connected to min timer @%s:%d", aVisId, __func__, __LINE__);


   maxDurationTime = 0;
   maxDurationTimer = new core::Timer();
   maxDurationTimer->setSingleShot(true);
   maxDurationTimer->timeout.connect([this]() {
       fireItsMaxActiveTime();
   });

   LOG_DEBUG("SmartItem with VisId %d connected to max timer @%s:%d", aVisId, __func__, __LINE__);
}

SmartItem::~SmartItem()
{
    if (minDurationTimer) {
        minDurationTimer->stop();
        delete minDurationTimer;
    }
    if (maxDurationTimer) {
        maxDurationTimer->stop();
        delete maxDurationTimer;
    }
}

SmartItem * SmartItem::getInstance(uint8_t aVisId)
{
    SmartItem * ret = nullptr;

    LOG_DEBUG("Instance of SmartItem with VisId %d requested @%s:%d", aVisId, __func__, __LINE__);


    for (size_t i=0; i < smartItemsPoolNumOfObjects; i++)
    {
        if(aVisId == smartItemsPool[i]->visId)
        {
            ret = smartItemsPool[i];
            LOG_DEBUG("Instance of SmartItem with VisId %d fetched @%s:%d", aVisId, __func__, __LINE__);
            i = smartItemsPoolNumOfObjects;
        }
    }

    if(nullptr == ret)
    {
        if(smartItemsPoolNumOfObjects < MAX_SMART_ITEMS_NUM)
        {
            smartItemsPool[smartItemsPoolNumOfObjects] = new SmartItem(aVisId);
            ret = smartItemsPool[smartItemsPoolNumOfObjects];
            smartItemsPoolNumOfObjects ++;
            LOG_DEBUG("New instance of SmartItem with VisId %d created @%s:%d", aVisId, __func__, __LINE__);
        }
        else
        {
            //skip
        }
    }

    return ret;
}

void SmartItem::setDisplay(IAlertDisplay *anAlertDisplay)
{
    //TODO verify if the (display,alert) connection in use
    if(nullptr == alertsDisplay)
    {
        alertsDisplay = anAlertDisplay;
    }
}

void SmartItem::setActive(smart_params_t & _params)
{
   LOG_DEBUG("SmartItem with VisId %d activation fired @%s:%d", visId, __func__, __LINE__);

   //WARNING: goes after the last received smart message
   maxDurationTime = _params.maxDurationMs;

   if(!isActived)
   {

      //WARNING: goes after the first received smart message
      minDurationTime = _params.minDurationMs;

        LOG_DEBUG("SmartItem with VisId %d activation requested @%s:%d", visId, __func__, __LINE__);

      if (!(minDurationTimer->isActive()))
      {
          LOG_DEBUG("SmartItem with VisId %d -- minumum duration timer started with %u @%s:%d", visId, minDurationTime, __func__, __LINE__);

          LOG_DEBUG("SmartItem with VisId %d minimal duration remained %d and active: %d @%s:%d", visId, minDurationTimer->remainingTime(), minDurationTimer->isActive(), __func__, __LINE__);
          LOG_DEBUG("SmartItem with VisId %d maximal duration remained %d and active: %d @%s:%d", visId, maxDurationTimer->remainingTime(), maxDurationTimer->isActive(),__func__, __LINE__);

          minDurationTimer->stop();

          if(0 != minDurationTime)
          {
              minDurationTimer->setInterval(minDurationTime);
              minDurationTimer->start();
          }
      }

      alertsDisplay->mutex.lock();

      alertsDisplay->activate(itsAlert,_params.paramInt, _params.paramFrac,
                              _params.visUnits);


      isActived = true;

      LOG_DEBUG("SmartItem with VisId %d activated @%s:%d", visId, __func__, __LINE__);

      alertsDisplay->mutex.unlock();


   }
   else
   {
       //restart maxDurationTime
       maxDurationTimer->stop();
   }

   if(!maxDurationTimer->isActive())
   {
       LOG_DEBUG("SmartItem with VisId %d -- maximum duration timer started with %u @%s:%d", visId, maxDurationTime, __func__, __LINE__);

       maxDurationTimer->stop();

       if(0 != maxDurationTime)
       {
           maxDurationTimer->setInterval(maxDurationTime);
           maxDurationTimer->start();
       }
   }
}

void SmartItem::setInactive(void)
{

     LOG_DEBUG("SmartItem with VisId %d deactivation fired, isActivated = %d @%s:%d", visId, isActived, __func__, __LINE__);

    if(isActived)
    {
        isActived =  false;

         LOG_DEBUG("SmartItem with VisId %d deactivation requested @%s:%d", visId, __func__, __LINE__);


        if(!minDurationTimer->isActive())
        {

            visualDeactivate();

        }
    }
}

void SmartItem::visualDeactivate(void)
{
    if(maxDurationTimer->isActive())
    {
        maxDurationTimer->stop();
    }
    //Visually deactivate:

     alertsDisplay->mutex.lock();

     alertsDisplay->deactivate(itsAlert);

      LOG_DEBUG("SmartItem with VisId %d deactivated @%s:%d", visId, __func__, __LINE__);

     alertsDisplay->mutex.unlock();

     isActived = false;
}

void SmartItem::fireItsMinActiveTime()
{

      LOG_DEBUG("SmartItem with VisId %d minimal duration timer fired @%s:%d", visId, __func__, __LINE__);

    minDurationTimer->stop();

    if(!isActived)
    {
       visualDeactivate();
    }
}


void SmartItem::fireItsMaxActiveTime()
{
    LOG_DEBUG("SmartItem with VisId %d miximum duration timer fired @%s:%d", visId, __func__, __LINE__);

    //WARNING: Following funciong also stops the timer
    if(!minDurationTimer->isActive())
    {
       visualDeactivate();
    }
    else
    {
        maxDurationTimer->stop();
        isActived = false;
    }
}
