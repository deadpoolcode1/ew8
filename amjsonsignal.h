#ifndef AMJSONSIGNAL_H
#define AMJSONSIGNAL_H

#include <map>
#include "defs.h"

class AMSignalsModel;

class AMJsonSignal
{
    Q_GADGET

public:

    enum action_type_e
    {
        GraphicItem = 1,
        Enabler = 2,
        StringArgument = 3,
    };
    Q_ENUM(action_type_e)

    typedef ACTION_ERRORS_t (* action_ptr_t)(QVariant);
    typedef std::map<QString,action_ptr_t> json_action_t;

    AMJsonSignal(QString name, QString action, QString type, ssize_t index = -1);

    QString getName(void);

    //TODO move two following statements to private section
    QString action;
    action_type_e type;
    ssize_t index;//NOTE: used on distributed multiple bytes arguments

private:

  QString name;



  static json_action_t jsonSignalActionMap;
};

#endif // AMJSONSIGNAL_H
