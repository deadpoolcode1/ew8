#ifndef AMJSONACTION_H
#define AMJSONACTION_H

#include <QObject>
#include "actiontype.h"
#include "iamjsonprocessable.h"

class AMJsonProtocol;

class AMJsonAction : public QObject, public IAMJsonProcessable
{
    Q_OBJECT

public:
    explicit AMJsonAction(AMJsonProtocol * aJsonProtocol, action_type_e type, QString action, QObject *parent = nullptr);

    AMJsonProtocol * getItsJsonProtocol(void);

     QString getActionName(void);

    virtual void process(QObject * sender, QVariant extractedCANsignal) = 0;

    action_type_e getActionType(void);

private:

    QString action;

    action_type_e type;

    AMJsonProtocol * itsProtocol;

signals:

public slots:
};

#endif // AMJSONACTION_H
