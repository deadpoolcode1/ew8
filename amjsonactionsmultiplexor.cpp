#include "amjsonactionsmultiplexor.h"

AmJsonActionsMultiplexor::AmJsonActionsMultiplexor(QJsonArray vt_rows)
{
    type = "";

    itsRawRows = vt_rows;
}

bool AmJsonActionsMultiplexor::initByType(QString aType)
{
    bool ret;

    if("" == type)
    {
        //TODO: convert raw rows to QHash values table

        //NOTE: The type field informs that the values table is ready for use
        type = aType;
    }

    ret = (aType == type);

    return ret;
}
