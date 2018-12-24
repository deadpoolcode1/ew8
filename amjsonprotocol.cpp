#include "amjsonprotocol.h"

#include "amjsonsignal.h"

AMJsonProtocol::AMJsonProtocol(QString aName)
{
    qDebug("JSON: new protocol extracted: %s",qPrintable(aName));
    name = aName;
    type = CAN; //default choise
}

void AMJsonProtocol::append(AMJsonSignal *signal)
{

    jsonSignals.push_back(*signal);

}

AMJsonSignal * AMJsonProtocol::getSignal(QString aName)
{
    AMJsonSignal * ret = nullptr;

   for(std::vector<AMJsonSignal>::iterator iter = jsonSignals.begin();iter != jsonSignals.end();++iter)
    {
        if(iter->getName() ==  aName)
        {
            ret =  &*iter;
        }
    }
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
