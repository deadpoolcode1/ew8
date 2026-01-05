#include <QObject>

#include "amjsonprotocol.h"
#include "core/json.h"
#include "core/logger.h"

#include "amjsonsignal.h"

#include "graphicitemsenummap.h"

AMJsonProtocol::AMJsonProtocol(AMSignalsModel * aModel, core::JsonValue protocolNameAndType, QObject * parent) : QObject(parent)
{
    core::JsonValue protocolNameValue;
    core::JsonValue protocolTypeValue;

    itsModel = aModel;

    // /////////////////////
    bool isNotDefaultProtocolType = (protocolNameAndType.isArray());

    if(isNotDefaultProtocolType)
    {

        core::JsonArray protocol_array = protocolNameAndType.toArray();

       protocolNameValue = protocol_array.at(0);

       protocolTypeValue = protocol_array.at(1);


    }
    else
    {
        protocolNameValue = protocolNameAndType;
    }

    name = QString::fromStdString(protocolNameValue.toString());
    LOG_DEBUG("JSON: new protocol extracted: %s", qPrintable(name));

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
        LOG_DEBUG("uninitialized signal");
    }
}


void AMJsonProtocol::collectValueTables(core::JsonValue protocolValueTables)
{
    //fetch the current protocol's value tables:
     core::JsonArray jsonValueTablesArray = protocolValueTables.toArray();

      QString vt_name;
      QString vt_type;
      core::JsonArray vt_rows;

     //collect the value tables names:
     for (const core::JsonValue & vt_raw : jsonValueTablesArray) {
            core::JsonObject vt_obj = vt_raw.toObject();

            //take the name and create an empty corresponding multiplexor entry.
          vt_name = QString::fromStdString(vt_obj["name"].toString());
          vt_type = QString::fromStdString(vt_obj["type"].toString());
          vt_rows = vt_obj["rows"].toArray();

          AmJsonActionsMultiplexor * aMultiplexor = new AmJsonActionsMultiplexor(this, vt_rows, vt_type);

          addMultiplexor(vt_name,aMultiplexor);
     }

}


QList<AMJsonSignal*> AMJsonProtocol::getSignalEntries(QString aName)
{
    QList<AMJsonSignal*> ret;
    ret = jsonSignals.values(aName);
    return ret;
}

void AMJsonProtocol::setType(core::JsonValue typeValue)
{

    QMetaObject metaObj = this->staticMetaObject;
    QMetaEnum metaEnum = metaObj.enumerator(metaObj.indexOfEnumerator("protocol_type_e"));

    type = (protocol_type_e)metaEnum.keyToValue(typeValue.toString().c_str());
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
AmJsonActionsMultiplexor * AMJsonProtocol::getMultiplexorByName(QString name)
{
    AmJsonActionsMultiplexor * ret = nullptr;

    if(jsonMultiplexors.contains(name))
    {
        ret = jsonMultiplexors.value(name);
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
        LOG_DEBUG("Protocol %s is %s", qPrintable(name), "disabled");


        foreach (AMJsonSignal * jsonsig , jsonSignals)
        {
            if(Enabler == jsonsig->type)
            {
                jsonsig->triggerAllDisablers();
            }
        }


        foreach (AMJsonSignal * jsonsig , jsonSignals)
        {
            if((jsonsig->getIsEnabled())&&(GraphicItem == jsonsig->type))
            {
                jsonsig->deactivateAllGraphicItems();
            }
        }
    }
    else if (!is_pre_enabled && is_post_enabled)
    {
        LOG_DEBUG("Protocol %s is %s", qPrintable(name), "enabled");
    }
}

