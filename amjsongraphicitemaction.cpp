#include "amjsongraphicitemaction.h"
#include "graphicitemsenummap.h"

#include "amjsonargumentaction.h"

#include "amjsonaction.h"

#include "amjsonsignal.h"

#include "canintargumentsaccumulator.h"
#include "canstringargumentsaccumulator.h"

class AMJsonAction;
class AMJsonSignal;
class CanIntArgumentsAccumulator;
class CanStringArgumentsAccumulator;

AMJsonGraphicItemAction::AMJsonGraphicItemAction(AMJsonSignal * aJsonSignal, QString action, AMJsonAction * parent): AMJsonAction(aJsonSignal, action, parent)
{
   itsGraphicItemID = GraphicItemsEnumMap::getId(action);
   itsDisplay = aJsonSignal->itsProtocol->itsModel->getItsCanManager()->getItsDisplay();
   isActivated = false;
   hasArguments = false;
   areArgumentsReceived = false;
}

void AMJsonGraphicItemAction::process(QVariant extractedCANsignal)
{
    if (extractedCANsignal.toBool())
    {
        activate();
    }
    else
    {
        deactivate();
    }
}

void AMJsonGraphicItemAction::activate(bool do_reactivate)
{

    if(!isActivated || do_reactivate)
    {
        itsDisplay->mutex.lock();

        if(do_reactivate&&isActivated)
        {
            itsDisplay->deactivate(itsGraphicItemID);
        }

        if(!hasArguments)
        {
            itsDisplay->activate(itsGraphicItemID);
        }
        else if (areArgumentsReceived)
        {
            if(!isArgOfStringType)
            {
                itsDisplay->activate(itsGraphicItemID,argInt,argFrac,(visual_item_unit_t) argUnits);
            }
            else
            {
                itsDisplay->activate(itsGraphicItemID, argStr);
            }
        }
        itsDisplay->mutex.unlock();

        isActivated = true;
    }

}

void AMJsonGraphicItemAction::deactivate(void)
{
    if(isActivated)
    {
        itsDisplay->mutex.lock();
        itsDisplay->deactivate(itsGraphicItemID);
        itsDisplay->mutex.unlock();

        isActivated = false;
    }
}

void AMJsonGraphicItemAction::argumentComplete(QString anArg)
{

    bool isChanged = (argStr != anArg);

    argStr = anArg;

    if (isActivated)
    {
        if (!areArgumentsReceived)
        {
            areArgumentsReceived = true;
            activate(true);
        }
        else if (isChanged)
        {
            activate(true);
        }
    }

    areArgumentsReceived = true;
}

//TODO in same frame arguments must be handled before GraphicItems
void AMJsonGraphicItemAction::argumentComplete(quint8 intArg, quint8 fracArg, quint8 unitArg)
{
   qDebug("argumentComplete(quint8 intArg, quint8 fracArg, quint8 unitArg)");
   bool areChanged =
           (argInt != intArg ||
           argFrac != fracArg ||
           argUnits != unitArg)
           ;

   argInt = intArg;
   argFrac = fracArg;
   argUnits = unitArg;

   if (isActivated)
   {
       if (!areArgumentsReceived)
       {
           areArgumentsReceived = true;
           activate(true);
       }
       else if (areChanged)
       {
           activate(true);
       }
   }

   areArgumentsReceived = true;
}

bool AMJsonGraphicItemAction::getIsActived(void)
{
    return isActivated;
}


void AMJsonGraphicItemAction::connect2Arguments(AMJsonArgumentAction * argumentAction)
{
    if(!hasArguments)
    {
        if (argumentAction->getItsJsonSignal()->type == AMJsonSignal::IntArgument)
        {


            CanIntArgumentsAccumulator * intAcc = CanIntArgumentsAccumulator::getInstance(itsGraphicItemID);
            if(intAcc)
            {
                connect(intAcc, SIGNAL(argumentComplete(quint8,quint8,quint8)),this,SLOT(argumentComplete(quint8,quint8,quint8)));
                hasArguments = true;
                isArgOfStringType = false;
            }
        }
        else if(argumentAction->getItsJsonSignal()->type == AMJsonSignal::StringArgument)
        {
            CanStringArgumentsAccumulator * strAcc = CanStringArgumentsAccumulator::getInstance(itsGraphicItemID);

            if(strAcc)
            {
                connect(strAcc, SIGNAL(argumentComplete(QString)),this,SLOT(argumentComplete(QString)));
                hasArguments = true;
                isArgOfStringType = true;
            }

        }
    }

}


