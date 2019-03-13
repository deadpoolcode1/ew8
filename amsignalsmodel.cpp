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

        AMJsonProtocol *amjp = new AMJsonProtocol(this, protocol_obj["protocol"]);

        amjp->collectValueTables(protocol_obj["value_tables"]);

        // //////////////////////////////////////

        QJsonArray jsonSignalsArray = protocol_obj["signals"].toArray();


        foreach (const QJsonValue & signal_value, jsonSignalsArray) {

               // /////////////////////////////////////////////////////////////////

               AMJsonSignal * amjsg;

               amjsg = new AMJsonSignal(amjp, signal_value);


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





