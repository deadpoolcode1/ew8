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
    explicit AMJsonAction(AMJsonProtocol * aJsonProtocol, action_type_e type, const String& action, QObject *parent = nullptr);

    AMJsonProtocol * getItsJsonProtocol(void);

    String getActionName(void);

    virtual void process(QObject * sender, QVariant extractedCANsignal) = 0;
    bool setSupplimentary(QVariant extractedCANsignal);

    action_type_e getActionType(void);

private:

    String action;



    AMJsonProtocol * itsProtocol;


    uint32_t poolIndex;
    action_type_e type;
    static Map<uint32_t, AMJsonAction *> objectsPool;

signals:

public slots:
};

#endif // AMJSONACTION_H
