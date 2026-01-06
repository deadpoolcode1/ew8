#include "amjsongraphicitemaction.h"
#include "graphicitemsenummap.h"
#include "core/logger.h"

#include <algorithm>

#include "amjsonargumentaction.h"

#include "amjsonaction.h"

#include "amjsonsignal.h"

#include "canintargumentsaccumulator.h"
#include "canstringargumentsaccumulator.h"

class AMJsonAction;
class AMJsonSignal;
class CanIntArgumentsAccumulator;
class CanStringArgumentsAccumulator;

Map<DISPLAY_ITEM_ID, AMJsonGraphicItemAction *> AMJsonGraphicItemAction::itsObjects;

AMJsonGraphicItemAction * AMJsonGraphicItemAction::getInstance(AMJsonProtocol * aJsonProtocol, const String& action)
{
    DISPLAY_ITEM_ID aGraphicItemID = GraphicItemsEnumMap::getId(action);

    AMJsonGraphicItemAction * ret =  nullptr;

    auto it = itsObjects.find(aGraphicItemID);
    ret = (it != itsObjects.end()) ? it->second : nullptr;

    if(nullptr == ret)
    {
        ret = new AMJsonGraphicItemAction(aJsonProtocol, aGraphicItemID, action);
        itsObjects[aGraphicItemID] = ret;
    }

    return ret;
}

AMJsonGraphicItemAction * AMJsonGraphicItemAction::getInstanceByItemID(DISPLAY_ITEM_ID aGraphicItemID)
{
    AMJsonGraphicItemAction * ret;

    auto it = itsObjects.find(aGraphicItemID);
    ret = (it != itsObjects.end()) ? it->second : nullptr;

    return ret;
}

bool AMJsonGraphicItemAction::setSupplimentary(QVariant extractedCANsignal)
{
    bool ret = false;
  
    if(!isSupplemented || (itsSupplimentary != extractedCANsignal))
    {
        itsSupplimentary =  extractedCANsignal;
        isSupplemented = true;
        ret = true;
    }

    return ret;
}

AMJsonGraphicItemAction::AMJsonGraphicItemAction(AMJsonProtocol * aJsonProtocol, DISPLAY_ITEM_ID aGraphicItemID, const String& action, AMJsonAction * parent): AMJsonAction(aJsonProtocol, GraphicItem, action, parent)
{
   itsGraphicItemID = aGraphicItemID;
   itsDisplay = aJsonProtocol->itsModel->getItsCanManager()->getItsDisplay();
   hasArguments = false;
   areArgumentsReceived = false;
   isSupplemented =  false;
}

void AMJsonGraphicItemAction::process(QObject * sender, QVariant extractedCANsignal)
{
    auto it = std::find(activators.begin(), activators.end(), sender);
    bool isSenderListed = (it != activators.end());

    if (extractedCANsignal.toBool())
    {
        if(!isSenderListed)
        {
            activate();
            activators.push_back(sender);
        }
    }
    else
    {
        if(isSenderListed)
        {
            if(1 == activators.size())
            {
                deactivate();
            }
            activators.erase(it);
        }
    }
}

void AMJsonGraphicItemAction::activate(bool do_reactivate)
{

    bool isActivated = getIsActived();

    if(!isActivated || do_reactivate)
    {
        itsDisplay->mutex.lock();

        if(do_reactivate&&isActivated)
        {
            itsDisplay->deactivate(itsGraphicItemID);
        }

        if(!hasArguments)
        {
            if(!isSupplemented)
            {
                itsDisplay->activate(itsGraphicItemID);
            }
            else
            {
                itsDisplay->activate(itsGraphicItemID,(uint8_t)itsSupplimentary.toInt());
            }

        }
        else if (areArgumentsReceived)
        {
            if(!isArgOfStringType)
            {
                if(!isSupplemented)
                {
                     itsDisplay->activate(itsGraphicItemID, argInt, argFrac, argUnits);
                }
                else
                {
                     itsDisplay->activate(itsGraphicItemID, argInt, (uint8_t)itsSupplimentary.toInt());
                }

            }
            else
            {
                itsDisplay->activate(itsGraphicItemID, argStr);
            }
        }
        itsDisplay->mutex.unlock();
    }

}

void AMJsonGraphicItemAction::forceDeactivation(void)
{
        deactivate();
        activators.clear();
}

void AMJsonGraphicItemAction::deactivate(void)
{
    if(getIsActived())
    {
        itsDisplay->mutex.lock();
        itsDisplay->deactivate(itsGraphicItemID);
        itsDisplay->mutex.unlock();
        areArgumentsReceived = false;
    }
}

void AMJsonGraphicItemAction::argumentComplete(const String& anArg)
{

    bool isChanged = (argStr != anArg);

    argStr = anArg;

    bool isActivated =  getIsActived();

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
void AMJsonGraphicItemAction::argumentComplete(uint8_t intArg, uint8_t fracArg, uint8_t unitArg)
{
   LOG_DEBUG("argumentComplete(uint8_t intArg, uint8_t fracArg, uint8_t unitArg)");
   bool areChanged =
           (argInt != intArg ||
           argFrac != fracArg ||
           argUnits != unitArg)
           ;

   argInt = intArg;
   argFrac = fracArg;
   argUnits = unitArg;

   bool isActivated = getIsActived();

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
    return !(activators.empty());
}


void AMJsonGraphicItemAction::connect2Arguments(AMJsonArgumentAction * argumentAction)
{
    if(!hasArguments)
    {
        if (argumentAction->isItsArgumentsType(IntArgument))
        {


            CanIntArgumentsAccumulator * intAcc = CanIntArgumentsAccumulator::getInstance(itsGraphicItemID);
            if(intAcc)
            {
                connect(intAcc, SIGNAL(argumentComplete(uint8_t,uint8_t,uint8_t)),this,SLOT(argumentComplete(uint8_t,uint8_t,uint8_t)));
                hasArguments = true;
                isArgOfStringType = false;
            }
        }
        else if(argumentAction->isItsArgumentsType(StringArgument))
        {
            CanStringArgumentsAccumulator * strAcc = CanStringArgumentsAccumulator::getInstance(itsGraphicItemID);

            if(strAcc)
            {
                connect(strAcc, SIGNAL(argumentComplete(String)),this,SLOT(argumentComplete(String)));
                hasArguments = true;
                isArgOfStringType = true;
            }

        }
    }

}

void AMJsonGraphicItemAction::setCalledWithFixedArgument(bool anIsArgOfStringType)
{
   hasArguments = true;
   isArgOfStringType = anIsArgOfStringType;
}


