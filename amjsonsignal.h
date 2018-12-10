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
    };
    Q_ENUM(action_type_e)

    typedef ACTION_ERRORS_t (* action_ptr_t)(QVariant);
    typedef std::map<QString,action_ptr_t> json_action_t;

    AMJsonSignal(QString aName, QString action, QString type);

private:

  QString name;

  QString action;

  action_type_e type;

  static json_action_t jsonSignalActionMap;
};

#endif // AMJSONSIGNAL_H
