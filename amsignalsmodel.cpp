#include "amsignalsmodel.h"
#include <QFile>

#include <QJsonArray>
#include <QJsonObject>

#include "amjsonprotocol.h"
#include "amjsonsignal.h"

#include "entitytype.h"
#include "rootedtreenode.h"

//TODO consider replace with QVector, and std::map with QMap
#include <vector>

AMSignalsModel * AMSignalsModel::instance = nullptr;

AMSignalsModel::AMSignalsModel()
{


    QFile jsonFile(QStringLiteral(BASE_TARGET_DIR)+QStringLiteral("signals/EyeWatch8_Signals.json"));

    if(jsonFile.exists())
    {
        qDebug ("JSON file exists");
        if(jsonFile.open(QIODevice::ReadOnly))
        {
            qDebug("signals JSON scheme  successfully found and open.");

            //TODO: evaluate json consistency


            jsonDocument = QJsonDocument::fromJson(jsonFile.readAll());
            jsonFile.close();

            //End of file usage

        }

        jsonInitGraphicItemEnumMap();

        jsonInitProtocolsAndSignalsVectors();
    }
    else
    {
        qDebug("signals JSON scheme association failed.");
        //TODO use some default scheme
        //TODO Error Alert
    }

}

AMSignalsModel * AMSignalsModel::getInstance(void)
{

   if(nullptr == instance)
   {
     instance = new AMSignalsModel();
   }

   return instance;
}


void AMSignalsModel::jsonInitGraphicItemEnumMap(void)
{
    QJsonObject jsonObject = jsonDocument.object();

    QJsonArray jsonArray = jsonObject["GraphicItem"].toArray();


    foreach (const QJsonValue & value, jsonArray) {
        QJsonObject obj = value.toObject();
        qDebug("JSON: %s",  qPrintable(obj["enum"].toString()));
        qDebug("JSON: %d",  obj["value"].toInt());

        graphicItemsEnumMap.insert(std::pair<QString, qint32>(obj["enum"].toString(),obj["value"].toInt()));

        //TODO verify that those values are presented also in JSON signals
        //TODO remove hardcoded ALERTS
        EntityType::generateSingleType((DISPLAY_ITEM_ID)obj["value"].toInt());
    }
}

qint32 AMSignalsModel::jsonGetGraphicItemEnum(QString jsonEnumItem)
{
    qint32 ret = -1;

    json_enum_t::iterator iter;

    iter = graphicItemsEnumMap.find(jsonEnumItem);

    if(iter != graphicItemsEnumMap.end())
    {
        ret = iter->second;
    }

    return ret;
}

AMJsonProtocol * AMSignalsModel::getProtocol(QString aName)
{

    AMJsonProtocol * ret;

    ret = jsonProtocols.value(aName,nullptr);

    return ret;

}


void AMSignalsModel::jsonInitProtocolsAndSignalsVectors(void)
{

    QJsonObject jsonObject = jsonDocument.object();

    QJsonArray jsonArray = jsonObject["Protocols"].toArray();

    foreach (const QJsonValue & value, jsonArray) {
        QJsonObject protocol_obj = value.toObject();

        QJsonValue protocolNameValue;
        QJsonValue protocolTypeValue;


        bool isNotDefaultProtocolType = (protocol_obj["protocol"].isArray());

        if(isNotDefaultProtocolType)
        {

            QJsonArray protocol_array = protocol_obj["protocol"].toArray();

           protocolNameValue = protocol_array.at(0);

           protocolTypeValue = protocol_array.at(1);


        }
        else
        {
            protocolNameValue = protocol_obj["protocol"];
        }

        AMJsonProtocol * amjp = new AMJsonProtocol(protocolNameValue.toString());

        if(isNotDefaultProtocolType)
        {
            //TODO set the protocol type
            amjp->setType(protocolTypeValue);
        }

         qDebug("JSON: extracted %s protocol, its type %s",  qPrintable(amjp->getName()),qPrintable(amjp->getTypeQString()));



        //construct the current protocol's signals collection:

        QJsonArray jsonSignalsArray = protocol_obj["signals"].toArray();


        foreach (const QJsonValue & signal_value, jsonSignalsArray) {
               QJsonObject signal_obj = signal_value.toObject();

               QString sigName;
               QString sigAction;
               QString sigType;
               bool polarity = true;
               qint32 sigIndex = -1;
               qint32 sigTrueValue;

               sigName = signal_obj["name"].toString();


               if (signal_obj["action"].isArray())
               {
                   QJsonArray actionArray = signal_obj["action"].toArray();

                   sigAction = actionArray[0].toString();
                   if ("inverted" == actionArray[1].toString())
                   {
                       polarity = false;
                   }
               }
               else
               {
                   sigAction = signal_obj["action"].toString();
               }

               sigType =  signal_obj["type"].toString();


               sigIndex = signal_obj["index"].toInt(-1);

               AMJsonSignal * amjsg;

               if(polarity)
               {
                   if(-1 == sigIndex)
                   {
                       //TODO verify syntax the signal on DBC side must be boolean
                       if(signal_obj.find("Set") == signal_obj.end())
                       {
                          amjsg = new AMJsonSignal(sigName, sigAction, sigType);
                       }
                       else
                       {
                          //TODO verify syntax the signal on DBC side must be non-boolean integer
                          sigTrueValue = signal_obj["Set"].toInt(0);
                          amjsg = new AMJsonSignal(sigName, sigAction, sigTrueValue, sigType);
                       }
                   }
                   else
                   {
                       amjsg = new AMJsonSignal(sigName, sigAction, sigType, sigIndex);
                   }
               }
               else
               {
                   amjsg = new AMJsonSignal(sigName, sigAction, false, sigType);
               }


               amjp->append(amjsg);
               amjsg->itsProtocol = amjp;

               if(AMJsonSignal::Enabler == amjsg->type)
               {
                   //TODO move the Enablers List inside this function
                   jsonEnablerSignals.append(amjsg);
               }
        }


        //insert protocol into Protocols collector.
        jsonProtocols.insert(amjp->getName(),amjp);

    }

    //TODO connect enablers to their enabled/disabled targets

    // //////////////////////////////////////

    foreach (AMJsonSignal * enabler, jsonEnablerSignals) {

        enabler->connect2EnabledDisabled(this);

    }

}





