#ifndef CORE_TYPES_H
#define CORE_TYPES_H

#include <cstdint>
#include <cstddef>
#include <string>
#include <vector>
#include <map>
#include <unordered_map>
#include <any>
#include <variant>
#include <optional>

// Qt type compatibility layer
// These typedefs provide drop-in replacements for Qt integer types
// Only define if Qt is NOT present

#ifndef QT_VERSION
// Qt-compatible integer types
using qint8 = int8_t;
using quint8 = uint8_t;
using qint16 = int16_t;
using quint16 = uint16_t;
using qint32 = int32_t;
using quint32 = uint32_t;
using qint64 = int64_t;
using quint64 = uint64_t;
using qsizetype = ssize_t;
#endif // QT_VERSION

// QString replacement - use std::string
using String = std::string;

// QByteArray replacement - use std::vector<uint8_t>
using ByteArray = std::vector<uint8_t>;

// Container aliases for easier migration
template<typename T>
using List = std::vector<T>;

template<typename K, typename V>
using Map = std::map<K, V>;

template<typename K, typename V>
using MultiMap = std::multimap<K, V>;

template<typename K, typename V>
using Hash = std::unordered_map<K, V>;

// QVariant replacement using std::any
using Variant = std::any;

// Helper functions for Variant
template<typename T>
T variantValue(const Variant& v) {
    return std::any_cast<T>(v);
}

template<typename T>
bool variantCanConvert(const Variant& v) {
    return v.type() == typeid(T);
}

// Q_LIKELY / Q_UNLIKELY macros - only define if Qt is NOT present
#ifndef QT_VERSION
#ifdef __GNUC__
#define Q_LIKELY(x)   __builtin_expect(!!(x), 1)
#define Q_UNLIKELY(x) __builtin_expect(!!(x), 0)
#else
#define Q_LIKELY(x)   (x)
#define Q_UNLIKELY(x) (x)
#endif
#endif // QT_VERSION

#endif // CORE_TYPES_H
