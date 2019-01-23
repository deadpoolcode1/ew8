#include "defs.h"
#include "canrxmsg.h"
#include "simplecanrxmsg.h"
#include "canmanager.h"

#include "canstringargumentsaccumulator.h"
#include "canintargumentsaccumulator.h"

#include "graphicitemsenummap.h"

#include "amjsonaction.h"

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

        Signal * canSignal = jsonsig->getCanDbSignal();

        sg_var_t sgvar = extractSignal(canSignal,frame);

        //NOTE: convert to QVariant(?)
        QVariant arg = 0;

        switch(sgvar.sg_type)
        {
           case EXT_SG_VAL_TYPE_INTEGER:
             arg = QVariant(sgvar.sg_val._int);
             break;
        case EXT_SG_VAL_TYPE_BOOL:
          arg = QVariant(sgvar.sg_val._bool);
          break;

        case EXT_SG_VAL_TYPE_DOUBLE:
          arg = QVariant(sgvar.sg_val._double);
          break;

        default:

            qDebug ("Extracted sqvar %s signal type broken", qPrintable(currSignalStr));

        }

        jsonsig->process(arg);
    }

}

