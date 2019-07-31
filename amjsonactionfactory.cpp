#include "amjsonactionfactory.h"

#include "amjsongraphicitemaction.h"
#include "amjsonenableraction.h"
#include "amjsonnumericargumentaction.h"
#include "amjsonstringargumentaction.h"

#include "amjsonsignal.h"

class AMJsonProtocol;
class AMJsonStringArgumentAction;
class AMJsonNumericArgumentAction;

AMJsonAction * AMJsonActionFactory::createAMJsonActionInstance(AMJsonProtocol * aJsonProtocol, action_type_e type, QString action, ssize_t index)
{
    AMJsonAction * ret = nullptr;

    AMJsonStringArgumentAction * tmpStr;
    AMJsonNumericArgumentAction * tmpNum;

    switch(type)
    {
    case GraphicItem:
        //TODO NOTE: must be uniq to the action.
        ret =  AMJsonGraphicItemAction::getInstance(aJsonProtocol, action);
        break;

    case Enabler:
        ret =  new AMJsonEnablerAction(aJsonProtocol, action);
        break;

    case StringArgument:
        tmpStr = new AMJsonStringArgumentAction(aJsonProtocol, action);
        tmpStr->setIndex(index);
        ret = (AMJsonAction *) tmpStr;
        break;

    case IntArgument:
        tmpNum = new AMJsonNumericArgumentAction(aJsonProtocol, action);
        tmpNum->setIndex(index);
        ret =  (AMJsonAction *) tmpNum;
        break;

    default:

        qDebug("Unsupported AMJsonActionType");
        break;

    }

    return ret;

}


