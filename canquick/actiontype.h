#ifndef ACTIONTYPE_H
#define ACTIONTYPE_H

#include "core/enum_utils.h"
#include "core/types.h"

// action_type_e is defined in core/enum_utils.h
// This class provides a fromString helper for compatibility

class ActionType
{
public:
    static ::action_type_e fromString(const String& aType)
    {
        return actionTypeFromString(aType);
    }

    static String toString(::action_type_e value)
    {
        return actionTypeToString(value);
    }
};

#endif // ACTIONTYPE_H
