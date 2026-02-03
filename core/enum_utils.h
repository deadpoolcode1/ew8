#ifndef CORE_ENUM_UTILS_H
#define CORE_ENUM_UTILS_H

#include <string>
#include <map>
#include <algorithm>
#include <cstring>

// Enum-to-string utilities to replace Qt's Q_ENUM/QMetaEnum
// This provides compile-time registration of enum values with their string names

namespace core {

// Helper macro to generate enum-to-string mappings
// Usage: ENUM_MAP_BEGIN(MyEnum), ENUM_VALUE(Value1), ENUM_VALUE(Value2), ENUM_MAP_END()
#define ENUM_MAP_BEGIN(EnumType) \
    inline const std::map<EnumType, std::string>& get##EnumType##Map() { \
        static const std::map<EnumType, std::string> enumMap = {

#define ENUM_VALUE(value) { value, #value }

#define ENUM_MAP_END() \
        }; \
        return enumMap; \
    }

// Template for enum-to-string conversion
template<typename EnumType>
std::string enumToString(EnumType value, const std::map<EnumType, std::string>& enumMap) {
    auto it = enumMap.find(value);
    if (it != enumMap.end()) {
        return it->second;
    }
    return "";
}

// Template for string-to-enum conversion
template<typename EnumType>
EnumType stringToEnum(const std::string& str, const std::map<EnumType, std::string>& enumMap, EnumType defaultValue = EnumType()) {
    for (const auto& pair : enumMap) {
        if (pair.second == str) {
            return pair.first;
        }
    }
    return defaultValue;
}

// Helper to build reverse map for faster lookups
template<typename EnumType>
std::map<std::string, EnumType> buildReverseMap(const std::map<EnumType, std::string>& enumMap) {
    std::map<std::string, EnumType> reverseMap;
    for (const auto& pair : enumMap) {
        reverseMap[pair.second] = pair.first;
    }
    return reverseMap;
}

} // namespace core

// ============================================================================
// Enum definitions with string mappings for the application
// ============================================================================

// System Request Type enum
enum sysreq_type_e {
    GetVersionInfo = 0,
    DebugBrightness = 1,
    DebugButtons = 2,
    DebugAlerts = 3,
    SwitchModeTest = 4,
    SwitchModeAWS = 5,
};

inline const std::map<sysreq_type_e, std::string>& getSysReqTypeMap() {
    static const std::map<sysreq_type_e, std::string> enumMap = {
        { GetVersionInfo, "GetVersionInfo" },
        { DebugBrightness, "DebugBrightness" },
        { DebugButtons, "DebugButtons" },
        { DebugAlerts, "DebugAlerts" },
        { SwitchModeTest, "SwitchModeTest" },
        { SwitchModeAWS, "SwitchModeAWS" },
    };
    return enumMap;
}

inline sysreq_type_e sysreqTypeFromString(const std::string& str) {
    return core::stringToEnum(str, getSysReqTypeMap(), GetVersionInfo);
}

inline std::string sysreqTypeToString(sysreq_type_e value) {
    return core::enumToString(value, getSysReqTypeMap());
}

// Action Type enum
enum action_type_e {
    GraphicItem = 0,
    Enabler = 1,
    StringArgument = 2,
    IntArgument = 3,
    RequestId = 4,
    Validator = 5,
    SystemRequest = 6,
};

inline const std::map<action_type_e, std::string>& getActionTypeMap() {
    static const std::map<action_type_e, std::string> enumMap = {
        { GraphicItem, "GraphicItem" },
        { Enabler, "Enabler" },
        { StringArgument, "StringArgument" },
        { IntArgument, "IntArgument" },
        { RequestId, "RequestId" },
        { Validator, "Validator" },
        { SystemRequest, "SystemRequest" },
    };
    return enumMap;
}

inline action_type_e actionTypeFromString(const std::string& str) {
    return core::stringToEnum(str, getActionTypeMap(), GraphicItem);
}

inline std::string actionTypeToString(action_type_e value) {
    return core::enumToString(value, getActionTypeMap());
}

// Protocol Type enum
enum protocol_type_e {
    GPIO = 1,
    CAN = 2,
    Disabled = 3,
};

inline const std::map<protocol_type_e, std::string>& getProtocolTypeMap() {
    static const std::map<protocol_type_e, std::string> enumMap = {
        { GPIO, "GPIO" },
        { CAN, "CAN" },
        { Disabled, "Disabled" },
    };
    return enumMap;
}

inline protocol_type_e protocolTypeFromString(const std::string& str) {
    return core::stringToEnum(str, getProtocolTypeMap(), CAN);
}

inline std::string protocolTypeToString(protocol_type_e value) {
    return core::enumToString(value, getProtocolTypeMap());
}

#endif // CORE_ENUM_UTILS_H
