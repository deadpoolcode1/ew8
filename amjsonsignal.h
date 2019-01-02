#ifndef AMJSONSIGNAL_H
#define AMJSONSIGNAL_H

#include <map>
#include "defs.h"

#include <QObject>

#include "amjsonprotocol.h"

#include "ialertdisplay.h"

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

    typedef ACTION_ERRORS_t (* action_ptr_t)(QVariant);
    //TODO replace with QMap
    typedef std::map<QString,action_ptr_t> json_action_t;

    AMJsonSignal(QString name, QString action, QString type, QObject * parent = nullptr);

    AMJsonSignal(QString name, QString action, qint32 trueValue, QString type , QObject * parent = nullptr);

    AMJsonSignal(QString name, QString action, QList<qint32> * trueValues, QString type , QObject * parent = nullptr);

    AMJsonSignal(QString name, QString action, bool polarity, QString type, QObject * parent = nullptr);

    AMJsonSignal(QString name, QString action, QString type, ssize_t index, QObject * parent = nullptr);

    QString getName(void);

    AMJsonProtocol * itsProtocol;

    bool getIsEnabled(void) {return disablers.isEmpty();}

    //TODO move two following statements to private section
    QString action;
    bool polarity;
    action_type_e type;
    QList<qint32> * trueValues;//actual, when is not boolean
    ssize_t index;//NOTE: used on distributed multiple bytes arguments

    //WARNING: connect the enabled signals and protocols
    //just after all of them are inserted in the model.
    void connect2EnabledDisabled(AMSignalsModel * model);

signals:

    void enableDisableConnected(bool OnOff, IAlertDisplay * alertDisplay);

public slots:

    void enableDisableThis(bool OnOff, IAlertDisplay * alertDisplay);

private:

  void init(QString name, QString action, bool polarity, QString type,ssize_t index, QList<qint32> * trueValues);

  QString name;

  QList<QObject *> disablers;

  static json_action_t jsonSignalActionMap;
};

#endif // AMJSONSIGNAL_H
