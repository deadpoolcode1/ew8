#include "defs.h"
#include "canrxmsg.h"
#include "simplecanrxmsg.h"
#include "canmanager.h"

#include "canstringargumentsaccumulator.h"

class CanStringArgumentsAccumulator;

class CanManager;
class CanRxMsg;

SimpleCanRxMsg::SimpleCanRxMsg()
{
   setCanID(can_id_undefined);
}

void SimpleCanRxMsg::ack(CanManager * canMngr)
{
    /*skip*/
}

void SimpleCanRxMsg::canRxJsonSignalsParseAndProcess(struct can_frame * frame)
{
    for (size_t i = 0; i < canSignalsArray_size; i++)
    {

        //JSON Driven Alerts Triggering:


        QString currSignalStr = canSignalsArray[i].name;

        AMJsonSignal * jsonsig = itsJsonProtocol->getSignal(currSignalStr);

        if(nullptr != jsonsig)
        {

            if(AMJsonSignal::GraphicItem == jsonsig->type)
            {
                one2oneParseAndProcess(frame,currSignalStr.toLatin1(),(DISPLAY_ITEM_ID)AMSignalsModel::getInstance()->jsonGetGraphicItemEnum(jsonsig->action),jsonsig->polarity);
            }
            else if (AMJsonSignal::StringArgument == jsonsig->type)
            {
               argumentSignalProcess(frame, currSignalStr.toLatin1(), jsonsig);
            }
        }
    }
}

void SimpleCanRxMsg::argumentSignalProcess(struct can_frame * recv, const char * name, AMJsonSignal * jsonsig)
{
    char value;
    //TODO review this casting
    value = (char)(extractSignal(name,recv).sg_val._int & 0xFF);

    qDebug("argumentSignalProcess signal %s, %c", name, value);

    CanStringArgumentsAccumulator::getInstance(jsonsig->action)->insertCharFromSignal(jsonsig->index,value);
}



void SimpleCanRxMsg::one2oneParseAndProcess(struct can_frame * recv, const char * name, DISPLAY_ITEM_ID alert, bool polarity)
{
    bool desired = extractSignal(name,recv).sg_val._bool;

    bool do_active = (desired == polarity);

    alertsDisplay->mutex.lock();
    if(do_active)
    {
         alertsDisplay->activate(alert);
    }
    else
    {
        alertsDisplay->deactivate(alert);
    }
    alertsDisplay->mutex.unlock();
}

void SimpleCanRxMsg::one2oneParseAndProcess(struct can_frame * recv, const char * name, bool * flag, bool polarity)
{
    bool desired = extractSignal(name,recv).sg_val._bool;

    bool do_active = (desired == polarity);

    if(do_active)
    {
        *flag = true;
    }
    else
    {
        *flag = false;
    }
}

