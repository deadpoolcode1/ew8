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
// Only define if Qt's types are not already defined (e.g., when QtGlobal is not included)

#ifndef QT_CORE_LIB
// Only define Qt-like types when not building with Qt
typedef int8_t   qint8;
typedef uint8_t  quint8;
typedef int16_t  qint16;
typedef uint16_t quint16;
typedef int32_t  qint32;
typedef uint32_t quint32;
typedef int64_t  qint64;
typedef uint64_t quint64;
typedef ssize_t  qsizetype;
#endif // QT_CORE_LIB

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

// Q_LIKELY / Q_UNLIKELY macros
#ifdef __GNUC__
#define Q_LIKELY(x)   __builtin_expect(!!(x), 1)
#define Q_UNLIKELY(x) __builtin_expect(!!(x), 0)
#else
#define Q_LIKELY(x)   (x)
#define Q_UNLIKELY(x) (x)
#endif

#endif // CORE_TYPES_H
