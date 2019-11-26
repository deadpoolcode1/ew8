#ifndef AMJSONACTIONSMULTIPLEXOR_H
#define AMJSONACTIONSMULTIPLEXOR_H


#include "defs.h"
#include <QHash>
#include <QJsonArray>
#include "amjsonaction.h"
#include "amjsonsignal.h"
#include "iamjsonactionfactory.h"
#include "iamjsonprocessable.h"

class AMJsonAction;
class AMJsonSignal;
class QJsonArray;
class IAMJsonActionFactory;

class AmJsonActionsMultiplexor: public QObject
{
    Q_OBJECT


public:

    AmJsonActionsMultiplexor(AMJsonProtocol * aProtocol, QJsonArray vt_rows, QString type, QObject * parent = nullptr);

    QHash<double,IAMJsonProcessable *> * getItsValueTable();

    qint32 getItsValuesType(void);

private:
    action_type_e  type;
    QJsonArray itsRawRows;
    QHash<double, IAMJsonProcessable *> itsValueTable;
    void initByType(QString aType);

    AMJsonProtocol * itsProtocol;
    IAMJsonActionFactory * itsActionFactory;

};

#endif // AMJSONACTIONSMULTIPLEXOR_H
