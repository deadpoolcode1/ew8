#ifndef SYSREQTYPE_H
#define SYSREQTYPE_H

#include <QObject>
#include <QMetaObject>
#include <QMetaEnum>
#include "core/types.h"

#ifndef SYSREQ_TYPE_ENUM_DEFINITION
#define SYSREQ_TYPE_ENUM_DEFINITION \
enum sysreq_type_e \
{ \
    GetVersionInfo = 0, \
    DebugBrightness = 1, \
    DebugButtons = 2, \
    DebugAlerts = 3, \
    SwitchModeTest = 4, \
    SwitchModeAWS = 5, \
};
#else
 #error Choose other macro name.
#endif

SYSREQ_TYPE_ENUM_DEFINITION

class SystemRequestType
{
Q_GADGET

Q_ENUM(sysreq_type_e)

public:

    SYSREQ_TYPE_ENUM_DEFINITION
    #undef SYSREQ_TYPE_ENUM_DEFINITION

    static ::sysreq_type_e fromString(core::QString aType)
    {
        ::sysreq_type_e ret;

        const QMetaObject  * metaObj = &staticMetaObject;
        QMetaEnum metaEnum = metaObj->enumerator(metaObj->indexOfEnumerator("sysreq_type_e"));
        ret = (::sysreq_type_e)metaEnum.keyToValue(aType.toLatin1());

        return ret;
    }
};


#endif // SYSREQTYPE_H
