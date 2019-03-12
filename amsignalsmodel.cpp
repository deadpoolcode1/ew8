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

#include "canmanager.h"

#include "amjsonactionfactory.h"


class CanIntArgumentsAccumulator;
class CanStringArgumentsAccumulator;

AMSignalsModel::AMSignalsModel(CanManager * aCanManager)
{
    itsCanManager =  aCanManager;
    itsAMJsonActionFactory = new AMJsonActionFactory();

    jsonInitProtocolsAndSignalsVectors();
}

CanManager * AMSignalsModel::getItsCanManager(void)
{
    return itsCanManager;
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

        AMJsonProtocol *amjp = new AMJsonProtocol(protocol_obj["protocol"], this);

        amjp->collectValueTables(protocol_obj["value_tables"]);

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


               //Action parsing:
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
               //end of Action parsing

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


               //functional connections:



               switch (amjsg->type)
               {
               case AMJsonSignal::Enabler:

                   jsonEnablerActions.append((AMJsonEnablerAction *)amjsg->getItsAction());

                   //TODO: consider value table case

                   break;

               case AMJsonSignal::GraphicItem:

                   jsonGraphicItemActions.insert(amjsg->getItsAction()->getActionName(), (AMJsonGraphicItemAction *)amjsg->getItsAction());


                   //TODO: consider value table case

                   break;

               case AMJsonSignal::StringArgument:
               case AMJsonSignal::IntArgument:

                   jsonArgumentActions.append((AMJsonArgumentAction *)(amjsg->getItsAction()));

                   //TODO: consider value table case

                   break;


                default:
                   /* skip*/
                   break;
               }
        }



        //insert protocol into Protocols collector.
        jsonProtocols.insert(amjp->getName(),amjp);

    }


    foreach (AMJsonEnablerAction * enabler, jsonEnablerActions)
    {

        enabler->connect2EnabledDisabled();

    }

    foreach (AMJsonArgumentAction * argument, jsonArgumentActions)
    {
        //TODO: think about arguments : actions 1:n
        QMap<QString,AMJsonGraphicItemAction *>::iterator it = jsonGraphicItemActions.find(argument->getActionName());

        if(it != jsonGraphicItemActions.end())
        {
            AMJsonGraphicItemAction *jsonaction = it.value();
            //TODO add forced arguments feature to graphicItemAction
            jsonaction->connect2Arguments(argument);

            jsonGraphicItemActions.remove(argument->getActionName());
        }
    }
}





