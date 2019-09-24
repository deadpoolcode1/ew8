#include "amjsonactionsmultiplexor.h"
#include <QJsonObject>
#include "amjsonaction.h"
#include "amjsonactionfactory.h"
#include "defs.h"

AmJsonActionsMultiplexor::AmJsonActionsMultiplexor(AMJsonProtocol * aProtocol, QJsonArray vt_rows, QString aType, QObject *parent) : QObject(parent)
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
    foreach (const QJsonValue & row_val, itsRawRows) {

        QJsonObject row_obj = row_val.toObject();

        bool valueStatus = row_obj["value"].isDouble();



        if (!valueStatus)
        {
            qDebug ("Value Table: broken value");
        }
        else
        {
            double triggerValue = row_obj["value"].toDouble();


            QString strAction = row_obj["action"].toString();

#if 0
            if(row_obj["arg"].isArray())
            {
                QJsonArray args_arr = row_obj["arg"].toArray();
            }
            else
            {
                row_obj["arg"].toString();
            }
#endif
            //TODO verify the type is GraphicItem or Enabler

            AMJsonAction * anAction = itsActionFactory->createAMJsonActionInstance(itsProtocol, type, strAction, 0);


            //TODO verify is not NULL

            //Assign forced args

            itsValueTable.insert(triggerValue,anAction);

            itsProtocol->itsModel->storeCollectedAction(anAction);
        }
    }

}

QHash<double, AMJsonAction *> * AmJsonActionsMultiplexor::getItsValueTable()
{
    return &itsValueTable;
}

qint32 AmJsonActionsMultiplexor::getItsValuesType(void)
{
    return type;
}
