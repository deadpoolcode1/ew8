#include "smartitem.h"
#include "defs.h"

#include <QTimer>
#include <QObject>
#include <stdint.h>




SmartItem * SmartItem::smartItemsPool[];
size_t  SmartItem::smartItemsPoolNumOfObjects = 0;

SmartItem::SmartItem(uint8_t aVisId, QObject * parent) : QObject(parent)
{
   visId = aVisId;
   //TODO ensure  SMART_BASE < range < ALERT_END_OF_TYPE
   itsAlert = (DISPLAY_ITEM_ID)(AlertTypes::SMART_BASE + aVisId);
   isActived = false;

   alertsDisplay = nullptr;

   minDurationTime = 0;
   minDurationQtimer = new QTimer(this);
   minDurationQtimer->setSingleShot(true);
   bool status = connect(minDurationQtimer, SIGNAL(timeout()), this, SLOT(fireItsMinActiveTime()));

   qDebug("SmartItem with VisId %d connected to min timer with status %d @%s:%d", aVisId, status, __func__, __LINE__);


   maxDurationTime = 0;
   maxDurationQtimer = new QTimer(this);
   maxDurationQtimer->setSingleShot(true);
   status = connect(maxDurationQtimer, SIGNAL(timeout()), this, SLOT(fireItsMaxActiveTime()));

   qDebug("SmartItem with VisId %d connected to max timer with status %d @%s:%d", aVisId, status, __func__, __LINE__);
}

SmartItem * SmartItem::getInstance(uint8_t aVisId)
{
    SmartItem * ret = nullptr;

    qDebug("Instance of SmartItem with VisId %d requested @%s:%d", aVisId, __func__, __LINE__);


    for (size_t i=0; i < smartItemsPoolNumOfObjects; i++)
    {
        if(aVisId == smartItemsPool[i]->visId)
        {
            ret = smartItemsPool[i];
            qDebug("Instance of SmartItem with VisId %d fetched @%s:%d", aVisId, __func__, __LINE__);
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
            qDebug("New instance of SmartItem with VisId %d created @%s:%d", aVisId, __func__, __LINE__);
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
   qDebug("SmartItem with VisId %d activation fired @%s:%d", visId, __func__, __LINE__);

   //WARNING: goes after the last received smart message
   maxDurationTime = _params.maxDurationMs;

   if(!isActived)
   {

      //WARNING: goes after the first received smart message
      minDurationTime = _params.minDurationMs;

        qDebug("SmartItem with VisId %d activation requested @%s:%d", visId, __func__, __LINE__);

      if (!(minDurationQtimer->isActive()))
      {
          qDebug("SmartItem with VisId %d -- minumum duration timer started with %u @%s:%d", visId, minDurationTime, __func__, __LINE__);

          qDebug("SmartItem with VisId %d minimal duration remained %d and active: %d @%s:%d", visId, minDurationQtimer->remainingTime(), minDurationQtimer->isActive(), __func__, __LINE__);
          qDebug("SmartItem with VisId %d maximal duration remained %d and active: %d @%s:%d", visId, maxDurationQtimer->remainingTime(), maxDurationQtimer->isActive(),__func__, __LINE__);

          minDurationQtimer->stop();

          if(0 != minDurationTime)
          {
              minDurationQtimer->setInterval(minDurationTime);
              minDurationQtimer->start();
          }
      }

      alertsDisplay->mutex.lock();

      alertsDisplay->activate(itsAlert,_params.paramInt, _params.paramFrac,
                              _params.visUnits);


      isActived = true;

      qDebug("SmartItem with VisId %d activated @%s:%d", visId, __func__, __LINE__);

      alertsDisplay->mutex.unlock();


   }
   else
   {
       //restart maxDurationTime
       maxDurationQtimer->stop();       
   }

   if(!maxDurationQtimer->isActive())
   {
       qDebug("SmartItem with VisId %d -- maximum duration timer started with %u @%s:%d", visId, maxDurationTime, __func__, __LINE__);

       maxDurationQtimer->stop();

       if(0 != maxDurationTime)
       {
           maxDurationQtimer->setInterval(maxDurationTime);
           maxDurationQtimer->start();
       }
   }
}

void SmartItem::setInactive(void)
{ 

     qDebug("SmartItem with VisId %d deactivation fired, isActivated = %d @%s:%d", visId, isActived, __func__, __LINE__);

    if(isActived)
    {
        isActived =  false;

         qDebug("SmartItem with VisId %d deactivation requested @%s:%d", visId, __func__, __LINE__);


        if(!minDurationQtimer->isActive())
        {

            visualDeactivate();

        }
    }
}

void SmartItem::visualDeactivate(void)
{
    if(maxDurationQtimer->isActive())
    {
        maxDurationQtimer->stop();
    }
    //Visually deactivate:

     alertsDisplay->mutex.lock();

     alertsDisplay->deactivate(itsAlert);

      qDebug("SmartItem with VisId %d deactivated @%s:%d", visId, __func__, __LINE__);

     alertsDisplay->mutex.unlock();

     isActived = false;
}

void SmartItem::fireItsMinActiveTime()
{

      qDebug("SmartItem with VisId %d minimal duration timer fired @%s:%d", visId, __func__, __LINE__);

    minDurationQtimer->stop();

    if(!isActived)
    {
       visualDeactivate();
    }
}


void SmartItem::fireItsMaxActiveTime()
{
    qDebug("SmartItem with VisId %d miximum duration timer fired @%s:%d", visId, __func__, __LINE__);

    //WARNING: Following funciong also stops the timer
    if(!minDurationQtimer->isActive())
    {
       visualDeactivate();
    }
    else
    {
        maxDurationQtimer->stop();
        isActived = false;
    }
}


