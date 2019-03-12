#ifndef AMJSONACTIONSMULTIPLEXOR_H
#define AMJSONACTIONSMULTIPLEXOR_H


#include "defs.h"
#include <QHash>
#include <QJsonArray>
#include "amjsonaction.h"
#include "amjsonsignal.h"

class AMJsonAction;
class AMJsonSignal;
class QJsonArray;

class AmJsonActionsMultiplexor
{
private:
    QString type;
    QJsonArray itsRawRows;
    QHash<qint32,AMJsonAction *> itsValueTable;

public: 
    AmJsonActionsMultiplexor(QJsonArray vt_rows);

    //NOTE: returns true if the type is newly initialized, or same as previous
    bool initByType(QString aType);
};

#endif // AMJSONACTIONSMULTIPLEXOR_H
