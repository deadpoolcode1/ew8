#include "amjsonactionfactory.h"

#include "amjsongraphicitemaction.h"
#include "amjsonenableraction.h"
#include "amjsonnumericargumentaction.h"
#include "amjsonstringargumentaction.h"

#include "amjsonsignal.h"

class AMJsonSignal;
class AMJsonStringArgumentAction;
class AMJsonNumericArgumentAction;

AMJsonAction * AMJsonActionFactory::createAMJsonActionInstance(AMJsonSignal * aJsonSignal, qint32 type, QString action)
{
    AMJsonAction * ret = nullptr;

    AMJsonStringArgumentAction * tmpStr;
    AMJsonNumericArgumentAction * tmpNum;

    switch(type)
    {
    case (qint32)AMJsonSignal::GraphicItem:
        ret =  new AMJsonGraphicItemAction(aJsonSignal, action);
        break;

    case (qint32)AMJsonSignal::Enabler:
        ret =  new AMJsonEnablerAction(aJsonSignal, action);
        break;

    case (qint32)AMJsonSignal::EnumItem:

        qDebug("Unsupported AMJsonActionType");

        break;

    case (qint32)AMJsonSignal::StringArgument:
        tmpStr = new AMJsonStringArgumentAction(aJsonSignal, action);
        tmpStr->setIndex(aJsonSignal->index);
        ret = (AMJsonAction *) tmpStr;
        break;

    case (qint32)AMJsonSignal::IntArgument:
        tmpNum = new AMJsonNumericArgumentAction(aJsonSignal, action);
        tmpNum->setIndex(aJsonSignal->index);
        ret =  (AMJsonAction *) tmpNum;
        break;

    default:

        qDebug("Unsupported AMJsonActionType");
        break;

    }

    return ret;

}


