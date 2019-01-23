#ifndef AMJSONACTION_H
#define AMJSONACTION_H

#include <QObject>

class AMJsonSignal;

class AMJsonAction : public QObject
{
    Q_OBJECT

public:
    explicit AMJsonAction(AMJsonSignal * aJsonSignal, QString action, QObject *parent = nullptr);

    AMJsonSignal * getItsJsonSignal(void);

     QString getActionName(void);

    virtual void process(QVariant extractedCANsignal) = 0;

protected:

    QString action;

    AMJsonSignal * itsCANSignal;

signals:

public slots:
};

#endif // AMJSONACTION_H
