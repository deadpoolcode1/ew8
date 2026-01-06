#ifndef AMJSONACTION_H
#define AMJSONACTION_H

#include <QObject>
#include "core/types.h"
#include "actiontype.h"
#include "iamjsonprocessable.h"

class AMJsonProtocol;

class AMJsonAction : public QObject, public IAMJsonProcessable
{
    Q_OBJECT

public:
    explicit AMJsonAction(AMJsonProtocol * aJsonProtocol, action_type_e type, core::QString action, QObject *parent = nullptr);

    AMJsonProtocol * getItsJsonProtocol(void);

    core::QString getActionName(void);

    virtual void process(QObject * sender, core::QVariant extractedCANsignal) = 0;
    bool setSupplimentary(core::QVariant extractedCANsignal);

    action_type_e getActionType(void);

private:

    core::QString action;



    AMJsonProtocol * itsProtocol;


    uint32_t poolIndex;
    action_type_e type;
    static core::QMap<uint32_t, AMJsonAction *> objectsPool;

signals:

public slots:
};

#endif // AMJSONACTION_H
