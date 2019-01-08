#include "amsignalsmodel.h"
#include <QFile>

#include <QJsonArray>
#include <QJsonObject>

#include <QObject>

#include "amjsonprotocol.h"
#include "amjsonsignal.h"

#include "entitytype.h"
#include "rootedtreenode.h"

#include "canstringargumentsaccumulator.h"
#include "canintargumentsaccumulator.h"

#include "amjsonconfigreader.h"


class CanIntArgumentsAccumulator;
class CanStringArgumentsAccumulator;

AMSignalsModel * AMSignalsModel::instance = nullptr;
QMutex AMSignalsModel::instanceMutex;


AMSignalsModel::AMSignalsModel()
{
    jsonInitProtocolsAndSignalsVectors();
}

AMSignalsModel * AMSignalsModel::getInstance(void)
{
    if(nullptr == instance){
        instanceMutex.lock();
        if(nullptr == instance)
        {
            instance = new AMSignalsModel();
        }
        instanceMutex.unlock();
    }

   return instance;
}

AMJsonProtocol * AMSignalsModel::getProtocol(QString aName)
{

    AMJsonProtocol * ret;

    ret = jsonProtocols.value(aName,nullptr);

    return ret;

}


void AMSignalsModel::jsonInitProtocolsAndSignalsVectors(void)
{

    QJsonObject jsonObject = AMJsonConfigReader::getInstance()->object();
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

        AMJsonProtocol * amjp = new AMJsonProtocol(protocolNameValue.toString(),this);

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
                          amjsg = new AMJsonSignal(amjp, sigName, sigAction, sigType);
                       }
                       else if (signal_obj["Set"].isArray())
                       {
                           //TODO verify syntax the signal on DBC side must be non-boolean integer
                           QJsonArray sigTrueValues_Array = signal_obj["Set"].toArray();

                           QList<qint32> * sigTrueValues = new QList<qint32>();

                           foreach(QJsonValue value, sigTrueValues_Array)
                           {
                               sigTrueValues->append(value.toInt(0));
                           }

                           amjsg = new AMJsonSignal(amjp, sigName, sigAction, sigTrueValues, sigType);
                       }
                       else
                       {
                          //TODO verify syntax the signal on DBC side must be non-boolean integer
                          sigTrueValue = signal_obj["Set"].toInt(0);
                          amjsg = new AMJsonSignal(amjp, sigName, sigAction, sigTrueValue, sigType);
                       }
                   }
                   else
                   {
                       amjsg = new AMJsonSignal(amjp, sigName, sigAction, sigType, sigIndex);
                   }
               }
               else
               {
                   amjsg = new AMJsonSignal(amjp, sigName, sigAction, false, sigType);
               }


               amjp->append(amjsg);
               amjsg->itsProtocol = amjp;


               switch (amjsg->type)
               {
               case AMJsonSignal::Enabler:

                   jsonEnablerSignals.append(amjsg);

                   break;

               case AMJsonSignal::GraphicItem:

                   jsonGraphicItemSignals.insert(amjsg->action, amjsg);

                   break;

               case AMJsonSignal::StringArgument:
               case AMJsonSignal::IntArgument:

                   jsonArgumentSignals.append(amjsg);

                   break;
                default:
                   /* skip*/
                   break;
               }
        }


        //insert protocol into Protocols collector.
        jsonProtocols.insert(amjp->getName(),amjp);

    }

    //TODO connect enablers to their enabled/disabled targets

    // //////////////////////////////////////

    foreach (AMJsonSignal * enabler, jsonEnablerSignals)
    {

        enabler->connect2EnabledDisabled();

    }

    foreach (AMJsonSignal * argument, jsonArgumentSignals)
    {
        QMap<QString,AMJsonSignal *>::iterator it = jsonGraphicItemSignals.find(argument->action);

        if(it != jsonGraphicItemSignals.end())
        {
            AMJsonSignal *jsonsig = it.value();
            jsonsig->connect2Arguments(argument);

            jsonGraphicItemSignals.remove(argument->action);
        }
    }
}





