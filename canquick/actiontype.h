#ifndef ACTIONTYPE_H
#define ACTIONTYPE_H

#include <QObject>
#include <QMetaObject>
#include <QMetaEnum>

#ifndef ACTION_TYPE_ENUM_DEFINITION
#define ACTION_TYPE_ENUM_DEFINITION \
enum action_type_e \
{ \
    GraphicItem = 0, \
    Enabler = 1, \
    StringArgument = 2, \
    IntArgument = 3, \
    RequestId = 4, \
    Validator = 5, \
    SystemRequest = 6, \
};
#else
 #error Choose other macro name.
#endif

ACTION_TYPE_ENUM_DEFINITION

class ActionType
{
Q_GADGET

Q_ENUM(action_type_e)

public:

    ACTION_TYPE_ENUM_DEFINITION
    #undef ACTION_TYPE_ENUM_DEFINITION

    static ::action_type_e fromString(QString aType)
    {
        ::action_type_e ret;

        const QMetaObject  * metaObj = &staticMetaObject;
        QMetaEnum metaEnum = metaObj->enumerator(metaObj->indexOfEnumerator("action_type_e"));
        ret = (::action_type_e)metaEnum.keyToValue(aType.toLatin1());

        return ret;
    }
};


#endif // ACTIONTYPE_H
