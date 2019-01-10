#include "defs.h"
#include "canrxmsg.h"
#include "simplecanrxmsg.h"
#include "canmanager.h"

#include "canstringargumentsaccumulator.h"
#include "canintargumentsaccumulator.h"

#include "graphicitemsenummap.h"

class CanStringArgumentsAccumulator;
class CanIntArgumentsAccumulator;

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

                one2oneParseAndProcess(frame, jsonsig);

                break;

            case AMJsonSignal::IntArgument:
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

    DISPLAY_ITEM_ID alert = GraphicItemsEnumMap::getId(jsonsig->action);

    qDebug("argumentSignalProcess signal %s, %c", qPrintable(jsonsig->getName()), (qint8) value);

    if (AMJsonSignal::StringArgument == jsonsig->type)
    {
        CanStringArgumentsAccumulator::getInstance(alert)->insertValueFromSignal(jsonsig->index,value);
    }
    else if (AMJsonSignal::IntArgument == jsonsig->type)
    {
         CanIntArgumentsAccumulator::getInstance(alert)->insertValueFromSignal(jsonsig->index,value);
    }
}

bool SimpleCanRxMsg::extractSetUnsetAction(struct can_frame * recv, AMJsonSignal * jsonsig, bool * do_active)
{
    sg_var_t sgvar = extractSignal(jsonsig->getName().toLatin1(),recv);

    bool success = true;

    if (sgvar.sg_type == EXT_SG_VAL_TYPE_BOOL)
    {
        bool desired = sgvar.sg_val._bool;
        *do_active = (desired == jsonsig->polarity);
    }
    else if (sgvar.sg_type == EXT_SG_VAL_TYPE_INTEGER)
    {
        qint32 desired = sgvar.sg_val._int;
        *do_active = (nullptr != (jsonsig->trueValues))&&(jsonsig->trueValues->contains(desired));
    }
    else
    {
        //TODO verify on Json Parsing
        success = false;
        qDebug("Warning: On/Off json signals support boolean or integer input only");
    }

    return success;

}

void SimpleCanRxMsg:: enableSignalProcess(struct can_frame * recv, AMJsonSignal * jsonsig)
{
    bool do_active;

    bool success = extractSetUnsetAction(recv,jsonsig, &do_active);

    if (success)
    {
       emit jsonsig->enableDisableConnected(do_active);
    }
}



void SimpleCanRxMsg::one2oneParseAndProcess(struct can_frame * recv, AMJsonSignal * jsonsig)
{
    bool do_active;

    bool success = extractSetUnsetAction(recv,jsonsig, &do_active);

    if (success)
    {
        if (do_active)
        {           
            jsonsig->activate();
        }
        else
        {
            jsonsig->deactivate();
        }
    }
}

