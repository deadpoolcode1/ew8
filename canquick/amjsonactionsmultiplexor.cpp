#include "amjsonactionsmultiplexor.h"
#include "amjsonaction.h"
#include "amjsonactionfactory.h"
#include "amjsonfixedargumentsactioninvoker.h"
#include "defs.h"
#include "core/logger.h"

AmJsonActionsMultiplexor::AmJsonActionsMultiplexor(AMJsonProtocol * aProtocol, core::JsonArray vt_rows, const String& aType, QObject *parent) : QObject(parent)
{
    itsRawRows = vt_rows;


    itsProtocol = aProtocol;
    itsActionFactory = itsProtocol->itsModel->getItsAMJsonActionFactory();

    initByType(aType);
}

void AmJsonActionsMultiplexor::initByType(const String& aType)
{

    type = ActionType::fromString(aType);

    // Convert raw rows to values table
    for (const core::JsonValue & row_val : itsRawRows) {

        core::JsonObject row_obj = row_val.toObject();

        bool valueStatus = row_obj["value"].isDouble();



        if (!valueStatus)
        {
            LOG_DEBUG("Value Table: broken value");
        }
        else
        {
            double triggerValue = row_obj["value"].toDouble();


            String strAction = row_obj["action"].toString();



            AMJsonAction * anAction = itsActionFactory->createAMJsonActionInstance(itsProtocol, type, strAction, 0);

            IAMJsonProcessable * anActionTableItem =  anAction;

            //TODO verify is not NULL


            if(GraphicItem == type)
            {

                core::JsonValue arg_val = row_obj["arg"];

                if(!(arg_val.isUndefined()))
                {

                    if(arg_val.isString())
                    {
                        String arg = arg_val.toString();
                        anActionTableItem =  new AMJsonFixedArgumentsActionInvoker((AMJsonGraphicItemAction *)anAction, arg);
                    }
                    else
                    {

                        List<int32_t> arglist;

                        if(arg_val.isArray())
                        {
                            core::JsonArray args_arr = arg_val.toArray();

                            for(const core::JsonValue & arg_item : args_arr)
                            {
                                if(arg_item.isDouble())
                                {
                                    arglist.push_back(arg_item.toInt());
                                }
                            }


                        }
                        else if(arg_val.isDouble())
                        {
                            arglist.push_back(arg_val.toInt());
                        }

                        if(!(arglist.empty()))
                        {
                            anActionTableItem =  new AMJsonFixedArgumentsActionInvoker((AMJsonGraphicItemAction *)anAction, arglist);
                        }
                    }
                }
            }

            itsValueTable[triggerValue] = anActionTableItem;

            itsProtocol->itsModel->storeCollectedAction(anAction);

        }
    }
}

std::unordered_map<double, IAMJsonProcessable *> * AmJsonActionsMultiplexor::getItsValueTable()
{
    return &itsValueTable;
}

int32_t AmJsonActionsMultiplexor::getItsValuesType(void)
{
    return type;
}
