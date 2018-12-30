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

void SimpleCanRxMsg::ack(CanManager *)
{
    /*skip*/
}

void SimpleCanRxMsg::canRxJsonSignalsParseAndProcess(struct can_frame * frame)
{

    QList<AMJsonSignal *>::iterator it;

    //WARNING: Did not use foreach to show, the sequence is important
    for (it = canJsonSignalsListInProcessOrder.begin(); it != canJsonSignalsListInProcessOrder.end(); it++)
    {

       AMJsonSignal * jsonsig = *it;

        QString currSignalStr = jsonsig->getName();


        if(jsonsig->itsProtocol->getIsEnabled()&&jsonsig->getIsEnabled())
        {

            switch(jsonsig->type)
            {
            case AMJsonSignal::GraphicItem:

                one2oneParseAndProcess(frame,currSignalStr.toLatin1(),(DISPLAY_ITEM_ID)AMSignalsModel::getInstance()->jsonGetGraphicItemEnum(jsonsig->action),jsonsig->polarity);

                break;

            case AMJsonSignal::StringArgument:
                argumentSignalProcess(frame, jsonsig);
                break;

            case AMJsonSignal::Enabler:

                enableSignalProcess(frame, jsonsig);

                break;

            default:
                qDebug("Usupported Json Signal Type");;
                break;

            }
        }
    }

}

void SimpleCanRxMsg::argumentSignalProcess(struct can_frame * recv, AMJsonSignal * jsonsig)
{
    char value;
    //TODO review this casting
    value = (char)(extractSignal((jsonsig->getName()).toLatin1(),recv).sg_val._int & 0xFF);

    qDebug("argumentSignalProcess signal %s, %c", qPrintable(jsonsig->getName()), value);

    CanStringArgumentsAccumulator::getInstance(jsonsig->action)->insertCharFromSignal(jsonsig->index,value);
}

void SimpleCanRxMsg:: enableSignalProcess(struct can_frame * recv, AMJsonSignal * jsonsig)
{
    bool desired = extractSignal(jsonsig->getName().toLatin1(),recv).sg_val._bool;

    bool do_active = (desired == jsonsig->polarity);

    emit jsonsig->enableDisableConnected(do_active);
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

