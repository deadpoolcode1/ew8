#include "amjsonprotocol.h"

#include "amjsonsignal.h"

#include <QObject>

AMJsonProtocol::AMJsonProtocol(QString aName, QObject * parent) : QObject(parent)
{
    qDebug("JSON: new protocol extracted: %s",qPrintable(aName));
    name = aName;
    type = CAN; //default choise
}

void AMJsonProtocol::append(AMJsonSignal * signal)
{
    if(signal)
    {
        jsonSignals.insert(signal->getName(), signal);
    }
    else
    {
        qDebug("uninitialized signal");
    }
}

QList<AMJsonSignal*> AMJsonProtocol::getSignalEntries(QString aName)
{
    QList<AMJsonSignal*> ret;
    ret = jsonSignals.values(aName);
    return ret;
}

void AMJsonProtocol::setType(QJsonValue typeValue)
{

    QMetaObject metaObj = this->staticMetaObject;
    QMetaEnum metaEnum = metaObj.enumerator(metaObj.indexOfEnumerator("protocol_type_e"));

    type = (protocol_type_e)metaEnum.keyToValue(typeValue.toString().toLatin1());
}


AMJsonProtocol::protocol_type_e AMJsonProtocol::getType(void)
{
    return type;
}

QString AMJsonProtocol::getTypeQString(void)
{
    QString ret;

    QMetaObject metaObj = this->staticMetaObject;
    QMetaEnum metaEnum = metaObj.enumerator(metaObj.indexOfEnumerator("protocol_type_e"));

    ret = QString(metaEnum.valueToKey(type));

    return ret;
}


QString AMJsonProtocol::getName(void)
{
    return name;
}

void AMJsonProtocol::enableDisableThis(bool onOff, IAlertDisplay * alertDisplay)
{

    bool is_pre_enabled = disablers.isEmpty();

    if (false == onOff && !disablers.contains(sender()))
    {
        disablers.append(sender());
    }
    else if (true == onOff && disablers.contains(sender()))
    {
        disablers.removeOne(sender());
    }

    bool is_post_enabled = disablers.isEmpty();

    if(is_pre_enabled && !is_post_enabled)
    {
        qDebug ("Protocol %s is %s",qPrintable(name), "disabled");


        foreach (AMJsonSignal * jsonsig , jsonSignals)
        {
            if(AMJsonSignal::Enabler == jsonsig->type)
            {
                jsonsig->enableDisableConnected(false, alertDisplay);
            }
        }

        if(alertDisplay)
        {
            //Turn all Graphic Item off
            alertDisplay->mutex.lock();
            foreach (AMJsonSignal * jsonsig , jsonSignals)
            {
                if((jsonsig->getIsEnabled())&&(AMJsonSignal::GraphicItem == jsonsig->type))
                {
                    alertDisplay->deactivate(AMSignalsModel::getInstance()->jsonGetGraphicItemEnum(jsonsig->action));
                }
            }
            alertDisplay->mutex.unlock();
        }
    }
    else if (!is_pre_enabled && is_post_enabled)
    {
        qDebug ("Protocol %s is %s",qPrintable(name), "enabled");
    }
}

