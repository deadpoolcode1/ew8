#include "amjsonactionsmultiplexor.h"
#include "amjsonaction.h"
#include "amjsonactionfactory.h"
#include "amjsonfixedargumentsactioninvoker.h"
#include "defs.h"

AmJsonActionsMultiplexor::AmJsonActionsMultiplexor(AMJsonProtocol * aProtocol, core::JsonArray vt_rows, QString aType, QObject *parent) : QObject(parent)
{
    itsRawRows = vt_rows;


    itsProtocol = aProtocol;
    itsActionFactory = itsProtocol->itsModel->getItsAMJsonActionFactory();

    initByType(aType);
}

void AmJsonActionsMultiplexor::initByType(QString aType)
{

    type = ActionType::fromString(aType);

    //TODO: convert raw rows to QHash values table
    for (const core::JsonValue & row_val : itsRawRows) {

        core::JsonObject row_obj = row_val.toObject();

        bool valueStatus = row_obj["value"].isDouble();



        if (!valueStatus)
        {
            qDebug ("Value Table: broken value");
        }
        else
        {
            double triggerValue = row_obj["value"].toDouble();


            QString strAction = QString::fromStdString(row_obj["action"].toString());



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
                        QString arg = QString::fromStdString(arg_val.toString());
                        anActionTableItem =  new AMJsonFixedArgumentsActionInvoker((AMJsonGraphicItemAction *)anAction, arg);
                    }
                    else
                    {

                        QList<qint32> arglist;

                        if(arg_val.isArray())
                        {
                            core::JsonArray args_arr = arg_val.toArray();

                            for(const core::JsonValue & arg_item : args_arr)
                            {
                                if(arg_item.isDouble())
                                {
                                    arglist.append(arg_item.toInt());
                                }
                            }


                        }
                        else if(arg_val.isDouble())
                        {
                            arglist.append(arg_val.toInt());
                        }

                        if(!(arglist.isEmpty()))
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

qint32 AmJsonActionsMultiplexor::getItsValuesType(void)
{
    return type;
}
