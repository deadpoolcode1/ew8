#include <QJsonArray>
#include <QJsonObject>
#include <QObject>


#include "amjsonprotocol.h"

#include "amjsonsignal.h"

#include "graphicitemsenummap.h"

AMJsonProtocol::AMJsonProtocol(QJsonValue protocolNameAndType,  AMSignalsModel * aModel, QObject * parent) : QObject(parent)
{
    QJsonValue protocolNameValue;
    QJsonValue protocolTypeValue;

    itsModel = aModel;

    // /////////////////////
    bool isNotDefaultProtocolType = (protocolNameAndType.isArray());

    if(isNotDefaultProtocolType)
    {

        QJsonArray protocol_array = protocolNameAndType.toArray();

       protocolNameValue = protocol_array.at(0);

       protocolTypeValue = protocol_array.at(1);


    }
    else
    {
        protocolNameValue = protocolNameAndType;
    }

    name = protocolNameValue.toString();
    qDebug("JSON: new protocol extracted: %s",qPrintable(name));

    if(isNotDefaultProtocolType)
    {
        //TODO set the protocol type
        setType(protocolTypeValue);
    }
    else
    {
        type = CAN; //default choise
    }
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


void AMJsonProtocol::collectValueTables(QJsonValue protocolValueTables)
{
    //fetch the current protocol's value tables:
     QJsonArray jsonValueTablesArray = protocolValueTables.toArray();

      QString vt_name;
      QJsonArray vt_rows;

     //collect the value tables names:
     foreach (const QJsonValue & vt_raw, jsonValueTablesArray) {
            QJsonObject vt_obj = vt_raw.toObject();

            //take the name and create an empty corresponding multiplexor entry.
          vt_name = vt_obj["name"].toString();
          vt_rows = vt_obj["rows"].toArray();

          AmJsonActionsMultiplexor * aMultiplexor = new AmJsonActionsMultiplexor(vt_rows);

          addMultiplexor(vt_name,aMultiplexor);
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


bool AMJsonProtocol::addMultiplexor(QString name, AmJsonActionsMultiplexor * mux)
{
   bool ret;
   if(jsonMultiplexors.contains(name))
   {
       ret = false;
   }
   else
   {
       jsonMultiplexors.insert(name,mux);
       ret = true;
   }

   return ret;
}

//NOTE: fails when lacks name or different type already assigned
bool AMJsonProtocol::initMultiplexorByType(QString name,QString type)
{
    bool ret = false;

    if(jsonMultiplexors.contains(name))
    {
        AmJsonActionsMultiplexor * mux = jsonMultiplexors.value(name);
        ret = mux->initByType(type);
    }

    return ret;
}



void AMJsonProtocol::enableDisableThis(bool onOff)
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
                jsonsig->triggerAllDisablers();
            }
        }


        foreach (AMJsonSignal * jsonsig , jsonSignals)
        {
            if((jsonsig->getIsEnabled())&&(AMJsonSignal::GraphicItem == jsonsig->type))
            {
                jsonsig->deactivateAllGraphicItems();
            }
        }
    }
    else if (!is_pre_enabled && is_post_enabled)
    {
        qDebug ("Protocol %s is %s",qPrintable(name), "enabled");
    }
}

