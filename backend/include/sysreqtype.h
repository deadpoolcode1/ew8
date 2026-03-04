#ifndef SYSREQTYPE_H
#define SYSREQTYPE_H

#include "core/enum_utils.h"
#include "core/types.h"

// sysreq_type_e is defined in core/enum_utils.h
// This class provides a fromString helper for compatibility

class SystemRequestType
{
public:
    static ::sysreq_type_e fromString(const String& aType)
    {
        return sysreqTypeFromString(aType);
    }

    static String toString(::sysreq_type_e value)
    {
        return sysreqTypeToString(value);
    }
};

#endif // SYSREQTYPE_H
