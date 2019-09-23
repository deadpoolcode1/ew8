#ifndef AMJSONACTIONSMULTIPLEXOR_H
#define AMJSONACTIONSMULTIPLEXOR_H


#include "defs.h"
#include <QHash>
#include <QJsonArray>
#include "amjsonaction.h"
#include "amjsonsignal.h"
#include "iamjsonactionfactory.h"

class AMJsonAction;
class AMJsonSignal;
class QJsonArray;
class IAMJsonActionFactory;

class AmJsonActionsMultiplexor: public QObject
{
    Q_OBJECT


public:

    AmJsonActionsMultiplexor(AMJsonProtocol * aProtocol, QJsonArray vt_rows, const vt_name2hex_t * name2hex, QString type, QObject * parent = nullptr);

    QHash<double,AMJsonAction *> * getItsValueTable();

    qint32 getItsValuesType(void);

private:
    const vt_name2hex_t * name2hex;
    action_type_e  type;
    QJsonArray itsRawRows;
    QHash<double,AMJsonAction *> itsValueTable;
    void initByType(QString aType);

    AMJsonProtocol * itsProtocol;
    IAMJsonActionFactory * itsActionFactory;

};

#endif // AMJSONACTIONSMULTIPLEXOR_H
