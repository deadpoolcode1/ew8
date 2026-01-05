#ifndef AMJSONACTIONSMULTIPLEXOR_H
#define AMJSONACTIONSMULTIPLEXOR_H


#include "defs.h"
#include <QHash>
#include "core/json.h"
#include "amjsonaction.h"
#include "amjsonsignal.h"
#include "iamjsonactionfactory.h"
#include "iamjsonprocessable.h"

class AMJsonAction;
class AMJsonSignal;
class IAMJsonActionFactory;

class AmJsonActionsMultiplexor: public QObject
{
    Q_OBJECT


public:

    AmJsonActionsMultiplexor(AMJsonProtocol * aProtocol, core::JsonArray vt_rows, QString type, QObject * parent = nullptr);

    QHash<double,IAMJsonProcessable *> * getItsValueTable();

    qint32 getItsValuesType(void);

private:
    action_type_e  type;
    core::JsonArray itsRawRows;
    QHash<double, IAMJsonProcessable *> itsValueTable;
    void initByType(QString aType);

    AMJsonProtocol * itsProtocol;
    IAMJsonActionFactory * itsActionFactory;

};

#endif // AMJSONACTIONSMULTIPLEXOR_H
