#include "amjsonactionsmultiplexor.h"
#include <QJsonObject>
#include "amjsonaction.h"
#include "amjsonactionfactory.h"
#include "defs.h"

AmJsonActionsMultiplexor::AmJsonActionsMultiplexor(AMJsonProtocol * aProtocol, QJsonArray vt_rows, const vt_name2hex_t * aName2hex, QString aType, QObject *parent) : QObject(parent)
{
    name2hex = aName2hex;

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

        //TODO convert to qint32 using table
        QString strValue = row_obj["value"].toString();

        qint32 intValue = -1;

        for(size_t i = 0; i< name2hex->vt_array_size; i++)
        {
            if(0 == strValue.compare(name2hex->vt_array[i].name))
            {
                intValue = name2hex->vt_array[i].value;
                i = name2hex->vt_array_size;
            }
        }


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

        itsValueTable.insert(intValue,anAction);

        itsProtocol->itsModel->storeCollectedAction(anAction);
    }

}

QHash<qint32,AMJsonAction *> * AmJsonActionsMultiplexor::getItsValueTable()
{
    return &itsValueTable;
}

qint32 AmJsonActionsMultiplexor::getItsValuesType(void)
{
    return type;
}
