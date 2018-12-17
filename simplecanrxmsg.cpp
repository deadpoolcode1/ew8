#include "defs.h"
#include "canrxmsg.h"
#include "simplecanrxmsg.h"

class CanRxMsg;

SimpleCanRxMsg::SimpleCanRxMsg()
{
   setCanID(can_id_undefined);
}

void SimpleCanRxMsg::ack()
{
    /*skip*/
}

void SimpleCanRxMsg::graphicItemsParseAndProcess(struct can_frame * frame)
{
#if 1

    for (size_t i = 0; i < canSignalsArray_size; i++)
    {

        //JSON Driven Alerts Triggering:


        QString currSignalStr = canSignalsArray[i].name;

        AMJsonSignal * jsonsig = itsJsonProtocol->getSignal(currSignalStr);

        if(nullptr != jsonsig)
        {

            if(AMJsonSignal::GraphicItem == jsonsig->type)
            {
                one2oneParseAndProcess(frame,currSignalStr.toLatin1(),(DISPLAY_ITEM_ID)AMSignalsModel::getInstance()->jsonGetGraphicItemEnum(jsonsig->action));
            }
        }
    }

#endif

}


void SimpleCanRxMsg::one2oneParseAndProcess(struct can_frame * recv, const char * name, DISPLAY_ITEM_ID alert, bool polarity)
{
#if 0
    one2oneParseAndProcessGeneral(alertsDisplay, recv, name, alert, polarity);
#else

    bool desired = extractSignal(name,recv).sg_val._bool;

    bool do_active = (desired == polarity);

    if(do_active)
    {
         alertsDisplay->activate(alert);
    }
    else
    {
        alertsDisplay->deactivate(alert);
    }
#endif
}

void SimpleCanRxMsg::one2oneParseAndProcess(struct can_frame * recv, const char * name, bool * flag, bool polarity)
{
#if 0
    one2oneParseAndProcessGeneral(alertsDisplay, recv, name, alert, polarity);
#else

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
#endif
}

