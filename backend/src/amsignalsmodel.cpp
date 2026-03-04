#include "amsignalsmodel.h"
#include "core/file_utils.h"

#include "core/json.h"
#include "core/logger.h"

#include "amjsonprotocol.h"
#include "amjsonsignal.h"

#include "entitytype.h"

#include "canstringargumentsaccumulator.h"
#include "canintargumentsaccumulator.h"

#include "amjsonconfigreader.h"

#include "canmanager.h"

#include "amjsonactionfactory.h"
#include "icanrxmsgfactory.h"


class CanIntArgumentsAccumulator;
class CanStringArgumentsAccumulator;

AMSignalsModel::AMSignalsModel(CanManager * aCanManager)
{
    itsCanManager =  aCanManager;
    itsAMJsonActionFactory = new AMJsonActionFactory();
    CanRxMsg::initCanRxMsgsPool(aCanManager->getItsCanRxMsgFactory(), this);
    jsonInitProtocolsAndSignalsVectors();
}

CanManager * AMSignalsModel::getItsCanManager(void)
{
    return itsCanManager;
}

AMJsonProtocol * AMSignalsModel::getProtocol(const String& aName)
{

    AMJsonProtocol * ret;

    auto it = jsonProtocols.find(aName);
    ret = (it != jsonProtocols.end()) ? it->second : nullptr;

    return ret;

}

void AMSignalsModel::jsonInitProtocolsAndSignalsVectors(void)
{
    core::JsonArray jsonArray = AMJsonConfigReader::getInstance()->getJsonTopEntry("Protocols").toArray();

    for (const core::JsonValue& value : jsonArray) {
        core::JsonObject protocol_obj = value.toObject();

        AMJsonProtocol *amjp = new AMJsonProtocol(this, protocol_obj["protocol"]);

        bool status = true;

        if (amjp->getType() == CAN)
        {

            if(!CanRxMsg::isAlreadyLoaded)
            {
                CanDBSignal candb;
                status = candb.processDBCFile(amjp);
            }
        }

        if (status)
        {

        //TODO find if exist
        String keepAliveMsgName = "";
        int32_t keepAliveTimeout;

        if(protocol_obj.contains("keepAlive"))//TODO check necessity of the check
        {
            keepAliveMsgName = protocol_obj["keepAlive"].toString("");
            keepAliveTimeout = protocol_obj["timeout"].toInt(500);
            CanRxMsg::setKeepAliveMsg(keepAliveMsgName, keepAliveTimeout);
        }

        amjp->collectValueTables(protocol_obj["value_tables"]);

        // //////////////////////////////////////

        core::JsonArray jsonSignalsArray = protocol_obj["signals"].toArray();

        for (const core::JsonValue& signal_value : jsonSignalsArray) {

               // /////////////////////////////////////////////////////////////////

               AMJsonSignal * amjsg;

               amjsg = new AMJsonSignal(amjp, signal_value);


               AMJsonAction * anAction = amjsg->getItsAction();

               //Verify is Value Table
               if(anAction != nullptr)
               {
                   storeCollectedAction(anAction);
               }

        }


        //insert protocol into Protocols collector.
        jsonProtocols[amjp->getName()] = amjp;

        }
        else {
            LOG_DEBUG("Skip CAN Protocol:%s", amjp->getName().c_str());
            //TODO clean the allocated memory
        }

    }

    //functional connections of the stored Actions:

    for (AMJsonEnablerAction * enabler : jsonEnablerActions)
    {
        enabler->connect2EnabledDisabled();
    }

    for (AMJsonArgumentAction * argument : jsonArgumentActions)
    {
        //TODO: think about arguments : actions 1:n
        Map<String,AMJsonGraphicItemAction *>::iterator it = jsonGraphicItemActions.find(argument->getActionName());

        if(it != jsonGraphicItemActions.end())
        {
            AMJsonGraphicItemAction *jsonaction = it->second;
            //TODO add forced arguments feature to graphicItemAction
            jsonaction->connect2Arguments(argument);

            jsonGraphicItemActions.erase(argument->getActionName());
        }
    }
}

void AMSignalsModel::storeCollectedAction(AMJsonAction * anAction)
{
    switch (anAction->getActionType())
    {
    case Enabler:

        jsonEnablerActions.push_back((AMJsonEnablerAction *)anAction);

        break;

    case GraphicItem:

        jsonGraphicItemActions[anAction->getActionName()] = (AMJsonGraphicItemAction *)anAction;

        break;

    case StringArgument:
    case IntArgument:

        jsonArgumentActions.push_back((AMJsonArgumentAction *)anAction);

        break;


     default:
        /* skip*/
        break;
    }
}





