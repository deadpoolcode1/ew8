#include "amjsonprotocol.h"

#include "amjsonsignal.h"

#include <QObject>

AMJsonProtocol::AMJsonProtocol(QString aName, QObject * parent) : QObject(parent)
{
    qDebug("JSON: new protocol extracted: %s",qPrintable(aName));
    name = aName;
    type = CAN; //default choise
    is_enabled = true;
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

void AMJsonProtocol::enableDisableThis(bool onOff)
{
    is_enabled = onOff;
    qDebug ("Protocol %s is %s",qPrintable(name), onOff?"enabled" : "disabled");
}
