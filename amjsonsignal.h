#ifndef AMJSONSIGNAL_H
#define AMJSONSIGNAL_H

#include "defs.h"

#include <QObject>

#include "amjsonprotocol.h"

#include "ialertdisplay.h"

#include "amjsonaction.h"

#include "iamjsonactionfactory.h"

#include <QHash>

class AMJsonAction;

class IAMJsonActionFactory;

class AMSignalsModel;

class AMJsonProtocol;

class IAlertDisplay;

class AMJsonSignal: public QObject
{
    Q_OBJECT

public:

    //TODO split to oop-pattern
    enum action_type_e
    {
        GraphicItem = 1,
        Enabler = 2,
        EnumItem = 3,
        StringArgument = 4,
        IntArgument = 5,
    };
    Q_ENUM(action_type_e)

    AMJsonSignal(AMJsonProtocol * aProtocol, QString name, QString action, QString type, QObject * parent = nullptr);

    AMJsonSignal(AMJsonProtocol * aProtocol, QString name, QString action, qint32 trueValue, QString type , QObject * parent = nullptr);

    AMJsonSignal(AMJsonProtocol * aProtocol, QString name, QString action, QList<qint32> * trueValues, QString type , QObject * parent = nullptr);

    AMJsonSignal(AMJsonProtocol * aProtocol, QString name, QString action, bool polarity, QString type, QObject * parent = nullptr);

    AMJsonSignal(AMJsonProtocol * aProtocol, QString name, QString action, QString type, ssize_t index, QObject * parent = nullptr);

    QString getName(void);

    AMJsonProtocol * itsProtocol;

    bool getIsEnabled(void) {return disablers.isEmpty();}

    void process(QVariant pureExtractedCANsignal);

    void deactivateAllGraphicItems(void);

    void triggerAllDisablers(void);

    Signal * getCanDbSignal(void);

    void setItsCanDbSignal(Signal * canSignalPtr);

    //TODO move two following statements to private section

    //TODO remove
    QString action;

    bool polarity;
    action_type_e type;
    QList<qint32> * trueValues;//actual, when is not boolean
    ssize_t index;//NOTE: used on distributed multiple bytes arguments

    AMJsonAction * getItsAction(){return itsValueTable ? nullptr : itsAction;}


    bool extractSetUnsetAction(QVariant extractedCANsignal, bool * do_active);

public slots:

    void enableDisableThis(bool OnOff);

private:

  AMJsonAction * itsAction;

  QHash<qint32,AMJsonAction *> * itsValueTable;

  IAMJsonActionFactory * itsAMJsonActionFactory;

  void init(AMJsonProtocol * aProtocol, QString name, QString action, bool polarity, QString type,ssize_t index, QList<qint32> * trueValues);

  QString name;

  QList<QObject *> disablers;

  Signal * itsCanDbSignal;
};

#endif // AMJSONSIGNAL_H
