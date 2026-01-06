#ifndef CORE_TYPES_H
#define CORE_TYPES_H

#include <cstdint>
#include <cstddef>
#include <string>
#include <sstream>
#include <vector>
#include <map>
#include <unordered_map>
#include <any>
#include <variant>
#include <optional>

// QString replacement - use std::string
using String = std::string;

// ByteArray type - use std::vector<uint8_t> for binary data
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
#ifndef QT_CORE_LIB
#ifdef __GNUC__
#define Q_LIKELY(x)   __builtin_expect(!!(x), 1)
#define Q_UNLIKELY(x) __builtin_expect(!!(x), 0)
#else
#define Q_LIKELY(x)   (x)
#define Q_UNLIKELY(x) (x)
#endif
#endif // QT_CORE_LIB

// =============================================================================
// Qt-compatible container wrappers with Qt-like API
// These provide drop-in replacements for Qt containers with familiar methods
// Only defined when Qt is NOT present
// =============================================================================

#ifndef QT_CORE_LIB

#include <algorithm>
#include <functional>

// QChar replacement - simple character wrapper
class QChar {
public:
    QChar() : ch_(0) {}
    QChar(char c) : ch_(c) {}
    QChar(int c) : ch_(static_cast<char>(c)) {}

    char toLatin1() const { return ch_; }
    bool isNull() const { return ch_ == 0; }
    bool isDigit() const { return ch_ >= '0' && ch_ <= '9'; }
    bool isLetter() const { return (ch_ >= 'A' && ch_ <= 'Z') || (ch_ >= 'a' && ch_ <= 'z'); }
    bool isSpace() const { return ch_ == ' ' || ch_ == '\t' || ch_ == '\n' || ch_ == '\r'; }

    operator char() const { return ch_; }

private:
    char ch_;
};

// QString replacement with Qt-compatible API
class QString : public std::string {
public:
    using std::string::string;
    QString() : std::string() {}
    QString(const std::string& s) : std::string(s) {}
    QString(const char* s) : std::string(s ? s : "") {}

    // Qt-compatible methods
    bool isEmpty() const { return empty(); }
    int length() const { return static_cast<int>(size()); }
    QString toLower() const {
        QString result = *this;
        std::transform(result.begin(), result.end(), result.begin(), ::tolower);
        return result;
    }
    QString toUpper() const {
        QString result = *this;
        std::transform(result.begin(), result.end(), result.begin(), ::toupper);
        return result;
    }
    std::string toStdString() const { return *this; }
    static QString fromStdString(const std::string& s) { return QString(s); }
    static QString number(int n) { return QString(std::to_string(n)); }
    static QString number(double n) { return QString(std::to_string(n)); }

    // Returns std::string for byte-level access (replacement for Qt's QByteArray methods)
    std::string toLocal8Bit() const { return *this; }
    std::string toLatin1() const { return *this; }
    std::string toUtf8() const { return *this; }

    // QString::arg() - replaces %1, %2, etc. with provided arguments
    template<typename T>
    QString arg(const T& value) const {
        QString result = *this;
        // Find lowest placeholder %1-%9
        for (int i = 1; i <= 9; ++i) {
            std::string placeholder = "%" + std::to_string(i);
            size_t pos = result.find(placeholder);
            if (pos != std::string::npos) {
                std::ostringstream oss;
                oss << value;
                result.replace(pos, placeholder.length(), oss.str());
                return result;
            }
        }
        return result;
    }

    // Overload for int with zero-padding width
    QString arg(int value, int fieldWidth, int base = 10, char fillChar = ' ') const {
        QString result = *this;
        for (int i = 1; i <= 9; ++i) {
            std::string placeholder = "%" + std::to_string(i);
            size_t pos = result.find(placeholder);
            if (pos != std::string::npos) {
                std::ostringstream oss;
                if (base == 16) oss << std::hex;
                else if (base == 8) oss << std::oct;
                if (fieldWidth > 0) {
                    oss.width(fieldWidth);
                    oss.fill(fillChar);
                }
                oss << value;
                result.replace(pos, placeholder.length(), oss.str());
                return result;
            }
        }
        return result;
    }

    // toUInt for parsing strings as unsigned integers
    unsigned int toUInt(bool* ok = nullptr, int base = 10) const {
        try {
            size_t pos;
            unsigned long val = std::stoul(*this, &pos, base);
            if (ok) *ok = (pos == size());
            return static_cast<unsigned int>(val);
        } catch (...) {
            if (ok) *ok = false;
            return 0;
        }
    }

    // toInt for parsing strings as integers
    int toInt(bool* ok = nullptr, int base = 10) const {
        try {
            size_t pos;
            long val = std::stol(*this, &pos, base);
            if (ok) *ok = (pos == size());
            return static_cast<int>(val);
        } catch (...) {
            if (ok) *ok = false;
            return 0;
        }
    }

    // toDouble for parsing strings as doubles
    double toDouble(bool* ok = nullptr) const {
        try {
            size_t pos;
            double val = std::stod(*this, &pos);
            if (ok) *ok = (pos == size());
            return val;
        } catch (...) {
            if (ok) *ok = false;
            return 0.0;
        }
    }

    // contains - check if string contains substring
    bool contains(const QString& str) const {
        return find(str) != std::string::npos;
    }
    bool contains(const char* str) const {
        return find(str) != std::string::npos;
    }
    bool contains(char ch) const {
        return find(ch) != std::string::npos;
    }

    // append methods for Qt compatibility
    QString& append(const QString& str) {
        std::string::append(str);
        return *this;
    }
    QString& append(const char* str) {
        if (str) std::string::append(str);
        return *this;
    }
    QString& append(char ch) {
        std::string::push_back(ch);
        return *this;
    }
    QString& append(const QChar& ch) {
        std::string::push_back(static_cast<char>(ch));
        return *this;
    }

    // number() overloads for additional types
    static QString number(long n) { return QString(std::to_string(n)); }
    static QString number(unsigned int n) { return QString(std::to_string(n)); }
    static QString number(unsigned long n) { return QString(std::to_string(n)); }
    static QString number(long long n) { return QString(std::to_string(n)); }
    static QString number(unsigned long long n) { return QString(std::to_string(n)); }
};

// qPrintable macro for QString
#define qPrintable(str) ((str).c_str())

// foreach macro replacement - Qt's foreach is equivalent to range-based for
// Usage: foreach(Type item, container) { ... }
// This simple implementation uses range-based for under the hood
#define foreach(variable, container) \
    for (variable : container)

// QList replacement with Qt-compatible API
template<typename T>
class QList : public std::vector<T> {
public:
    using std::vector<T>::vector;
    QList() : std::vector<T>() {}

    // Qt-compatible methods
    bool isEmpty() const { return this->empty(); }
    int count() const { return static_cast<int>(this->size()); }
    int length() const { return static_cast<int>(this->size()); }
    void append(const T& value) { this->push_back(value); }
    void prepend(const T& value) { this->insert(this->begin(), value); }
    T& first() { return this->front(); }
    const T& first() const { return this->front(); }
    T& last() { return this->back(); }
    const T& last() const { return this->back(); }
    void removeFirst() { if (!this->empty()) this->erase(this->begin()); }
    void removeLast() { if (!this->empty()) this->pop_back(); }
    void removeAt(int i) { if (i >= 0 && i < (int)this->size()) this->erase(this->begin() + i); }
    bool contains(const T& value) const {
        return std::find(this->begin(), this->end(), value) != this->end();
    }
    int indexOf(const T& value) const {
        auto it = std::find(this->begin(), this->end(), value);
        return it != this->end() ? static_cast<int>(std::distance(this->begin(), it)) : -1;
    }
};

// QVector is same as QList in Qt6
template<typename T>
using QVector = QList<T>;

// QMap replacement with Qt-compatible API
template<typename K, typename V>
class QMap : public std::map<K, V> {
public:
    using std::map<K, V>::map;
    QMap() : std::map<K, V>() {}

    // Qt-compatible methods
    bool isEmpty() const { return this->empty(); }
    int count() const { return static_cast<int>(this->size()); }
    bool contains(const K& key) const { return this->find(key) != this->end(); }
    V value(const K& key, const V& defaultValue = V()) const {
        auto it = this->find(key);
        return it != this->end() ? it->second : defaultValue;
    }
    void insert(const K& key, const V& value) { (*this)[key] = value; }
    QList<K> keys() const {
        QList<K> result;
        for (const auto& pair : *this) {
            result.push_back(pair.first);
        }
        return result;
    }
    QList<V> values() const {
        QList<V> result;
        for (const auto& pair : *this) {
            result.push_back(pair.second);
        }
        return result;
    }
};

// QMultiMap replacement
template<typename K, typename V>
class QMultiMap : public std::multimap<K, V> {
public:
    using std::multimap<K, V>::multimap;
    QMultiMap() : std::multimap<K, V>() {}

    bool isEmpty() const { return this->empty(); }
    int count() const { return static_cast<int>(this->size()); }
    bool contains(const K& key) const { return this->find(key) != this->end(); }
    void insert(const K& key, const V& value) { std::multimap<K, V>::insert({key, value}); }
    QList<V> values(const K& key) const {
        QList<V> result;
        auto range = this->equal_range(key);
        for (auto it = range.first; it != range.second; ++it) {
            result.push_back(it->second);
        }
        return result;
    }
};

// QHash replacement with Qt-compatible API
template<typename K, typename V>
class QHash : public std::unordered_map<K, V> {
public:
    using std::unordered_map<K, V>::unordered_map;
    QHash() : std::unordered_map<K, V>() {}

    // Qt-compatible methods
    bool isEmpty() const { return this->empty(); }
    int count() const { return static_cast<int>(this->size()); }
    bool contains(const K& key) const { return this->find(key) != this->end(); }
    V value(const K& key, const V& defaultValue = V()) const {
        auto it = this->find(key);
        return it != this->end() ? it->second : defaultValue;
    }
    void insert(const K& key, const V& value) { (*this)[key] = value; }
    QList<K> keys() const {
        QList<K> result;
        for (const auto& pair : *this) {
            result.push_back(pair.first);
        }
        return result;
    }
    QList<V> values() const {
        QList<V> result;
        for (const auto& pair : *this) {
            result.push_back(pair.second);
        }
        return result;
    }
};

// QVariant replacement using std::any with Qt-compatible API
class QVariant {
public:
    QVariant() = default;

    template<typename T>
    QVariant(const T& value) : data_(value) {}

    bool isValid() const { return data_.has_value(); }
    bool isNull() const { return !data_.has_value(); }

    template<typename T>
    T value() const { return std::any_cast<T>(data_); }

    bool toBool() const {
        if (!data_.has_value()) return false;
        if (data_.type() == typeid(bool)) return std::any_cast<bool>(data_);
        if (data_.type() == typeid(int)) return std::any_cast<int>(data_) != 0;
        if (data_.type() == typeid(double)) return std::any_cast<double>(data_) != 0.0;
        return false;
    }

    int toInt(bool* ok = nullptr) const {
        if (ok) *ok = true;
        if (!data_.has_value()) { if (ok) *ok = false; return 0; }
        if (data_.type() == typeid(int)) return std::any_cast<int>(data_);
        if (data_.type() == typeid(double)) return static_cast<int>(std::any_cast<double>(data_));
        if (data_.type() == typeid(bool)) return std::any_cast<bool>(data_) ? 1 : 0;
        if (ok) *ok = false;
        return 0;
    }

    double toDouble(bool* ok = nullptr) const {
        if (ok) *ok = true;
        if (!data_.has_value()) { if (ok) *ok = false; return 0.0; }
        if (data_.type() == typeid(double)) return std::any_cast<double>(data_);
        if (data_.type() == typeid(int)) return static_cast<double>(std::any_cast<int>(data_));
        if (data_.type() == typeid(float)) return static_cast<double>(std::any_cast<float>(data_));
        if (ok) *ok = false;
        return 0.0;
    }

    QString toString() const {
        if (!data_.has_value()) return QString();
        if (data_.type() == typeid(QString)) return std::any_cast<QString>(data_);
        if (data_.type() == typeid(std::string)) return QString(std::any_cast<std::string>(data_));
        if (data_.type() == typeid(int)) return QString::number(std::any_cast<int>(data_));
        if (data_.type() == typeid(double)) return QString::number(std::any_cast<double>(data_));
        return QString();
    }

    template<typename T>
    bool canConvert() const {
        return data_.type() == typeid(T);
    }

private:
    std::any data_;
};

// QStringList
using QStringList = QList<QString>;

// QStringBuilder compatibility
#define QStringBuilder QString

#endif // QT_CORE_LIB - end of Qt-compatible wrappers

#endif // CORE_TYPES_H
