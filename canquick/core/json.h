#ifndef CORE_JSON_H
#define CORE_JSON_H

#include <string>
#include <vector>
#include <map>
#include <variant>
#include <memory>
#include <sstream>
#include <iomanip>
#include <cmath>
#include <stdexcept>

#include "types.h"
#include "file_utils.h"

namespace core {

// Forward declarations
class JsonValue;
class JsonObject;
class JsonArray;

// JSON Parse Error
class JsonParseError {
public:
    enum ParseError {
        NoError = 0,
        UnterminatedObject,
        UnterminatedArray,
        UnterminatedString,
        IllegalValue,
        IllegalNumber,
        IllegalEscapeSequence,
        GarbageAtEnd
    };

    JsonParseError() : error_(NoError), offset_(0) {}
    JsonParseError(ParseError err, int offset = 0) : error_(err), offset_(offset) {}

    ParseError error() const { return error_; }
    int offset() const { return offset_; }

    std::string errorString() const {
        switch (error_) {
            case NoError: return "no error";
            case UnterminatedObject: return "unterminated object";
            case UnterminatedArray: return "unterminated array";
            case UnterminatedString: return "unterminated string";
            case IllegalValue: return "illegal value";
            case IllegalNumber: return "illegal number";
            case IllegalEscapeSequence: return "illegal escape sequence";
            case GarbageAtEnd: return "garbage at end";
            default: return "unknown error";
        }
    }

private:
    ParseError error_;
    int offset_;
};

// JSON Value - can hold any JSON type
class JsonValue {
public:
    enum Type {
        Null,
        Bool,
        Double,
        String,
        Array,
        Object,
        Undefined
    };

    JsonValue() : type_(Undefined) {}
    JsonValue(std::nullptr_t) : type_(Null) {}
    JsonValue(bool b) : type_(Bool), boolVal_(b) {}
    JsonValue(int n) : type_(Double), numVal_(n) {}
    JsonValue(double n) : type_(Double), numVal_(n) {}
    JsonValue(const std::string& s) : type_(String), strVal_(s) {}
    JsonValue(const char* s) : type_(String), strVal_(s ? s : "") {}
    JsonValue(const JsonArray& arr);
    JsonValue(const JsonObject& obj);

    Type type() const { return type_; }
    bool isNull() const { return type_ == Null; }
    bool isBool() const { return type_ == Bool; }
    bool isDouble() const { return type_ == Double; }
    bool isString() const { return type_ == String; }
    bool isArray() const { return type_ == Array; }
    bool isObject() const { return type_ == Object; }
    bool isUndefined() const { return type_ == Undefined; }

    bool toBool(bool defaultValue = false) const {
        if (type_ == Bool) return boolVal_;
        return defaultValue;
    }

    int toInt(int defaultValue = 0) const {
        if (type_ == Double) return static_cast<int>(numVal_);
        return defaultValue;
    }

    double toDouble(double defaultValue = 0.0) const {
        if (type_ == Double) return numVal_;
        return defaultValue;
    }

    std::string toString(const std::string& defaultValue = "") const {
        if (type_ == String) return strVal_;
        return defaultValue;
    }

    JsonArray toArray() const;
    JsonArray toArray(const JsonArray& defaultValue) const;
    JsonObject toObject() const;
    JsonObject toObject(const JsonObject& defaultValue) const;

    // Variant conversion
    std::any toVariant() const {
        switch (type_) {
            case Null: return std::any();
            case Bool: return boolVal_;
            case Double: return numVal_;
            case String: return strVal_;
            default: return std::any();
        }
    }

    bool operator==(const JsonValue& other) const {
        if (type_ != other.type_) return false;
        switch (type_) {
            case Bool: return boolVal_ == other.boolVal_;
            case Double: return numVal_ == other.numVal_;
            case String: return strVal_ == other.strVal_;
            case Null:
            case Undefined:
                return true;
            default:
                return false; // Arrays and objects need deep comparison
        }
    }

    bool operator!=(const JsonValue& other) const { return !(*this == other); }

private:
    friend class JsonObject;
    friend class JsonArray;
    friend class JsonDocument;

    Type type_;
    bool boolVal_ = false;
    double numVal_ = 0.0;
    std::string strVal_;
    std::shared_ptr<std::vector<JsonValue>> arrVal_;
    std::shared_ptr<std::map<std::string, JsonValue>> objVal_;
};

// JSON Array
class JsonArray {
public:
    using iterator = std::vector<JsonValue>::iterator;
    using const_iterator = std::vector<JsonValue>::const_iterator;

    JsonArray() {}

    int size() const { return static_cast<int>(values_.size()); }
    int count() const { return size(); }
    bool isEmpty() const { return values_.empty(); }

    void append(const JsonValue& val) { values_.push_back(val); }
    void prepend(const JsonValue& val) { values_.insert(values_.begin(), val); }
    void insert(int i, const JsonValue& val) {
        if (i >= 0 && i <= static_cast<int>(values_.size())) {
            values_.insert(values_.begin() + i, val);
        }
    }
    void removeAt(int i) {
        if (i >= 0 && i < static_cast<int>(values_.size())) {
            values_.erase(values_.begin() + i);
        }
    }
    void removeFirst() { if (!values_.empty()) values_.erase(values_.begin()); }
    void removeLast() { if (!values_.empty()) values_.pop_back(); }

    JsonValue at(int i) const {
        if (i >= 0 && i < static_cast<int>(values_.size())) {
            return values_[i];
        }
        return JsonValue();
    }

    JsonValue first() const { return values_.empty() ? JsonValue() : values_.front(); }
    JsonValue last() const { return values_.empty() ? JsonValue() : values_.back(); }

    JsonValue operator[](int i) const { return at(i); }

    bool contains(const JsonValue& val) const {
        for (const auto& v : values_) {
            if (v == val) return true;
        }
        return false;
    }

    iterator begin() { return values_.begin(); }
    iterator end() { return values_.end(); }
    const_iterator begin() const { return values_.begin(); }
    const_iterator end() const { return values_.end(); }
    const_iterator constBegin() const { return values_.begin(); }
    const_iterator constEnd() const { return values_.end(); }

    // Convert to std::vector
    std::vector<JsonValue>& toStdVector() { return values_; }
    const std::vector<JsonValue>& toStdVector() const { return values_; }

private:
    friend class JsonValue;
    friend class JsonDocument;

    std::vector<JsonValue> values_;
};

// JSON Object
class JsonObject {
public:
    using iterator = std::map<std::string, JsonValue>::iterator;
    using const_iterator = std::map<std::string, JsonValue>::const_iterator;

    JsonObject() {}

    int size() const { return static_cast<int>(values_.size()); }
    int count() const { return size(); }
    bool isEmpty() const { return values_.empty(); }

    bool contains(const std::string& key) const {
        return values_.find(key) != values_.end();
    }

    std::vector<std::string> keys() const {
        std::vector<std::string> result;
        for (const auto& pair : values_) {
            result.push_back(pair.first);
        }
        return result;
    }

    void insert(const std::string& key, const JsonValue& val) {
        values_[key] = val;
    }

    void remove(const std::string& key) {
        values_.erase(key);
    }

    JsonValue take(const std::string& key) {
        auto it = values_.find(key);
        if (it != values_.end()) {
            JsonValue val = it->second;
            values_.erase(it);
            return val;
        }
        return JsonValue();
    }

    JsonValue value(const std::string& key, const JsonValue& defaultValue = JsonValue()) const {
        auto it = values_.find(key);
        if (it != values_.end()) {
            return it->second;
        }
        return defaultValue;
    }

    JsonValue operator[](const std::string& key) const {
        return value(key);
    }

    JsonValue& operator[](const std::string& key) {
        return values_[key];
    }

    iterator begin() { return values_.begin(); }
    iterator end() { return values_.end(); }
    const_iterator begin() const { return values_.begin(); }
    const_iterator end() const { return values_.end(); }
    const_iterator constBegin() const { return values_.begin(); }
    const_iterator constEnd() const { return values_.end(); }

    // Convert to std::map
    std::map<std::string, JsonValue>& toStdMap() { return values_; }
    const std::map<std::string, JsonValue>& toStdMap() const { return values_; }

private:
    friend class JsonValue;
    friend class JsonDocument;

    std::map<std::string, JsonValue> values_;
};

// JsonValue implementations that need JsonArray/JsonObject to be complete
inline JsonValue::JsonValue(const JsonArray& arr) : type_(Array) {
    arrVal_ = std::make_shared<std::vector<JsonValue>>(arr.values_);
}

inline JsonValue::JsonValue(const JsonObject& obj) : type_(Object) {
    objVal_ = std::make_shared<std::map<std::string, JsonValue>>(obj.values_);
}

inline JsonArray JsonValue::toArray() const {
    if (type_ == Array && arrVal_) {
        JsonArray arr;
        arr.values_ = *arrVal_;
        return arr;
    }
    return JsonArray();
}

inline JsonArray JsonValue::toArray(const JsonArray& defaultValue) const {
    if (type_ == Array && arrVal_) {
        JsonArray arr;
        arr.values_ = *arrVal_;
        return arr;
    }
    return defaultValue;
}

inline JsonObject JsonValue::toObject() const {
    if (type_ == Object && objVal_) {
        JsonObject obj;
        obj.values_ = *objVal_;
        return obj;
    }
    return JsonObject();
}

inline JsonObject JsonValue::toObject(const JsonObject& defaultValue) const {
    if (type_ == Object && objVal_) {
        JsonObject obj;
        obj.values_ = *objVal_;
        return obj;
    }
    return defaultValue;
}

// JSON Document - main parsing and serialization class
class JsonDocument {
public:
    JsonDocument() : isArray_(false) {}
    JsonDocument(const JsonObject& obj) : object_(obj), isArray_(false) {}
    JsonDocument(const JsonArray& arr) : array_(arr), isArray_(true) {}

    static JsonDocument fromJson(const std::string& json, JsonParseError* error = nullptr) {
        JsonDocument doc;
        Parser parser(json);
        if (!parser.parse(doc, error)) {
            doc = JsonDocument();
        }
        return doc;
    }

    static JsonDocument fromJson(const std::vector<uint8_t>& data, JsonParseError* error = nullptr) {
        std::string json(data.begin(), data.end());
        return fromJson(json, error);
    }

    std::string toJson(bool compact = false) const {
        Serializer ser(compact);
        if (isArray_) {
            return ser.serialize(array_);
        } else {
            return ser.serialize(object_);
        }
    }

    bool isNull() const { return !isArray_ && object_.isEmpty(); }
    bool isObject() const { return !isArray_; }
    bool isArray() const { return isArray_; }

    JsonObject object() const { return isArray_ ? JsonObject() : object_; }
    JsonArray array() const { return isArray_ ? array_ : JsonArray(); }

    void setObject(const JsonObject& obj) {
        object_ = obj;
        isArray_ = false;
    }

    void setArray(const JsonArray& arr) {
        array_ = arr;
        isArray_ = true;
    }

private:
    // JSON Parser
    class Parser {
    public:
        Parser(const std::string& json) : json_(json), pos_(0) {}

        bool parse(JsonDocument& doc, JsonParseError* error) {
            skipWhitespace();
            if (pos_ >= json_.size()) {
                if (error) *error = JsonParseError(JsonParseError::IllegalValue, pos_);
                return false;
            }

            if (json_[pos_] == '{') {
                JsonObject obj;
                if (!parseObject(obj, error)) return false;
                doc.setObject(obj);
            } else if (json_[pos_] == '[') {
                JsonArray arr;
                if (!parseArray(arr, error)) return false;
                doc.setArray(arr);
            } else {
                if (error) *error = JsonParseError(JsonParseError::IllegalValue, pos_);
                return false;
            }

            skipWhitespace();
            if (pos_ < json_.size()) {
                if (error) *error = JsonParseError(JsonParseError::GarbageAtEnd, pos_);
                return false;
            }

            if (error) *error = JsonParseError();
            return true;
        }

    private:
        void skipWhitespace() {
            while (pos_ < json_.size() && std::isspace(json_[pos_])) {
                ++pos_;
            }
        }

        bool parseValue(JsonValue& val, JsonParseError* error) {
            skipWhitespace();
            if (pos_ >= json_.size()) {
                if (error) *error = JsonParseError(JsonParseError::IllegalValue, pos_);
                return false;
            }

            char c = json_[pos_];
            if (c == '"') {
                std::string s;
                if (!parseString(s, error)) return false;
                val = JsonValue(s);
            } else if (c == '{') {
                JsonObject obj;
                if (!parseObject(obj, error)) return false;
                val = JsonValue(obj);
            } else if (c == '[') {
                JsonArray arr;
                if (!parseArray(arr, error)) return false;
                val = JsonValue(arr);
            } else if (c == 't' || c == 'f') {
                bool b;
                if (!parseBool(b, error)) return false;
                val = JsonValue(b);
            } else if (c == 'n') {
                if (!parseNull(error)) return false;
                val = JsonValue(nullptr);
            } else if (c == '-' || std::isdigit(c)) {
                double n;
                if (!parseNumber(n, error)) return false;
                val = JsonValue(n);
            } else {
                if (error) *error = JsonParseError(JsonParseError::IllegalValue, pos_);
                return false;
            }
            return true;
        }

        bool parseObject(JsonObject& obj, JsonParseError* error) {
            if (json_[pos_] != '{') {
                if (error) *error = JsonParseError(JsonParseError::IllegalValue, pos_);
                return false;
            }
            ++pos_;

            skipWhitespace();
            if (pos_ < json_.size() && json_[pos_] == '}') {
                ++pos_;
                return true;
            }

            while (true) {
                skipWhitespace();
                if (pos_ >= json_.size() || json_[pos_] != '"') {
                    if (error) *error = JsonParseError(JsonParseError::UnterminatedObject, pos_);
                    return false;
                }

                std::string key;
                if (!parseString(key, error)) return false;

                skipWhitespace();
                if (pos_ >= json_.size() || json_[pos_] != ':') {
                    if (error) *error = JsonParseError(JsonParseError::IllegalValue, pos_);
                    return false;
                }
                ++pos_;

                JsonValue val;
                if (!parseValue(val, error)) return false;
                obj.insert(key, val);

                skipWhitespace();
                if (pos_ >= json_.size()) {
                    if (error) *error = JsonParseError(JsonParseError::UnterminatedObject, pos_);
                    return false;
                }

                if (json_[pos_] == '}') {
                    ++pos_;
                    return true;
                }
                if (json_[pos_] != ',') {
                    if (error) *error = JsonParseError(JsonParseError::IllegalValue, pos_);
                    return false;
                }
                ++pos_;
            }
        }

        bool parseArray(JsonArray& arr, JsonParseError* error) {
            if (json_[pos_] != '[') {
                if (error) *error = JsonParseError(JsonParseError::IllegalValue, pos_);
                return false;
            }
            ++pos_;

            skipWhitespace();
            if (pos_ < json_.size() && json_[pos_] == ']') {
                ++pos_;
                return true;
            }

            while (true) {
                JsonValue val;
                if (!parseValue(val, error)) return false;
                arr.append(val);

                skipWhitespace();
                if (pos_ >= json_.size()) {
                    if (error) *error = JsonParseError(JsonParseError::UnterminatedArray, pos_);
                    return false;
                }

                if (json_[pos_] == ']') {
                    ++pos_;
                    return true;
                }
                if (json_[pos_] != ',') {
                    if (error) *error = JsonParseError(JsonParseError::IllegalValue, pos_);
                    return false;
                }
                ++pos_;
            }
        }

        bool parseString(std::string& str, JsonParseError* error) {
            if (json_[pos_] != '"') {
                if (error) *error = JsonParseError(JsonParseError::IllegalValue, pos_);
                return false;
            }
            ++pos_;

            str.clear();
            while (pos_ < json_.size()) {
                char c = json_[pos_];
                if (c == '"') {
                    ++pos_;
                    return true;
                }
                if (c == '\\') {
                    ++pos_;
                    if (pos_ >= json_.size()) {
                        if (error) *error = JsonParseError(JsonParseError::IllegalEscapeSequence, pos_);
                        return false;
                    }
                    c = json_[pos_];
                    switch (c) {
                        case '"': str += '"'; break;
                        case '\\': str += '\\'; break;
                        case '/': str += '/'; break;
                        case 'b': str += '\b'; break;
                        case 'f': str += '\f'; break;
                        case 'n': str += '\n'; break;
                        case 'r': str += '\r'; break;
                        case 't': str += '\t'; break;
                        case 'u': {
                            // Parse \uXXXX
                            if (pos_ + 4 >= json_.size()) {
                                if (error) *error = JsonParseError(JsonParseError::IllegalEscapeSequence, pos_);
                                return false;
                            }
                            // Simplified: just skip and add as-is for now
                            str += "\\u";
                            str += json_.substr(pos_ + 1, 4);
                            pos_ += 4;
                            break;
                        }
                        default:
                            if (error) *error = JsonParseError(JsonParseError::IllegalEscapeSequence, pos_);
                            return false;
                    }
                } else {
                    str += c;
                }
                ++pos_;
            }

            if (error) *error = JsonParseError(JsonParseError::UnterminatedString, pos_);
            return false;
        }

        bool parseNumber(double& num, JsonParseError* error) {
            size_t start = pos_;
            if (json_[pos_] == '-') ++pos_;

            if (pos_ >= json_.size() || !std::isdigit(json_[pos_])) {
                if (error) *error = JsonParseError(JsonParseError::IllegalNumber, pos_);
                return false;
            }

            while (pos_ < json_.size() && std::isdigit(json_[pos_])) ++pos_;

            if (pos_ < json_.size() && json_[pos_] == '.') {
                ++pos_;
                if (pos_ >= json_.size() || !std::isdigit(json_[pos_])) {
                    if (error) *error = JsonParseError(JsonParseError::IllegalNumber, pos_);
                    return false;
                }
                while (pos_ < json_.size() && std::isdigit(json_[pos_])) ++pos_;
            }

            if (pos_ < json_.size() && (json_[pos_] == 'e' || json_[pos_] == 'E')) {
                ++pos_;
                if (pos_ < json_.size() && (json_[pos_] == '+' || json_[pos_] == '-')) ++pos_;
                if (pos_ >= json_.size() || !std::isdigit(json_[pos_])) {
                    if (error) *error = JsonParseError(JsonParseError::IllegalNumber, pos_);
                    return false;
                }
                while (pos_ < json_.size() && std::isdigit(json_[pos_])) ++pos_;
            }

            try {
                num = std::stod(json_.substr(start, pos_ - start));
            } catch (...) {
                if (error) *error = JsonParseError(JsonParseError::IllegalNumber, start);
                return false;
            }
            return true;
        }

        bool parseBool(bool& val, JsonParseError* error) {
            if (json_.compare(pos_, 4, "true") == 0) {
                val = true;
                pos_ += 4;
                return true;
            }
            if (json_.compare(pos_, 5, "false") == 0) {
                val = false;
                pos_ += 5;
                return true;
            }
            if (error) *error = JsonParseError(JsonParseError::IllegalValue, pos_);
            return false;
        }

        bool parseNull(JsonParseError* error) {
            if (json_.compare(pos_, 4, "null") == 0) {
                pos_ += 4;
                return true;
            }
            if (error) *error = JsonParseError(JsonParseError::IllegalValue, pos_);
            return false;
        }

        const std::string& json_;
        size_t pos_;
    };

    // JSON Serializer
    class Serializer {
    public:
        Serializer(bool compact = false) : compact_(compact), indent_(0) {}

        std::string serialize(const JsonValue& val) {
            std::ostringstream ss;
            writeValue(ss, val);
            return ss.str();
        }

        std::string serialize(const JsonObject& obj) {
            std::ostringstream ss;
            writeObject(ss, obj);
            return ss.str();
        }

        std::string serialize(const JsonArray& arr) {
            std::ostringstream ss;
            writeArray(ss, arr);
            return ss.str();
        }

    private:
        void writeValue(std::ostringstream& ss, const JsonValue& val) {
            switch (val.type()) {
                case JsonValue::Null: ss << "null"; break;
                case JsonValue::Bool: ss << (val.toBool() ? "true" : "false"); break;
                case JsonValue::Double: {
                    double d = val.toDouble();
                    if (std::floor(d) == d && std::abs(d) < 1e15) {
                        ss << static_cast<long long>(d);
                    } else {
                        ss << std::setprecision(15) << d;
                    }
                    break;
                }
                case JsonValue::String: writeString(ss, val.toString()); break;
                case JsonValue::Array: writeArray(ss, val.toArray()); break;
                case JsonValue::Object: writeObject(ss, val.toObject()); break;
                case JsonValue::Undefined: ss << "null"; break;
            }
        }

        void writeString(std::ostringstream& ss, const std::string& str) {
            ss << '"';
            for (char c : str) {
                switch (c) {
                    case '"': ss << "\\\""; break;
                    case '\\': ss << "\\\\"; break;
                    case '\b': ss << "\\b"; break;
                    case '\f': ss << "\\f"; break;
                    case '\n': ss << "\\n"; break;
                    case '\r': ss << "\\r"; break;
                    case '\t': ss << "\\t"; break;
                    default:
                        if (static_cast<unsigned char>(c) < 0x20) {
                            ss << "\\u" << std::hex << std::setw(4) << std::setfill('0')
                               << static_cast<int>(c);
                        } else {
                            ss << c;
                        }
                }
            }
            ss << '"';
        }

        void writeObject(std::ostringstream& ss, const JsonObject& obj) {
            ss << '{';
            if (!compact_) { ss << '\n'; ++indent_; }

            bool first = true;
            for (const auto& pair : obj) {
                if (!first) {
                    ss << ',';
                    if (!compact_) ss << '\n';
                }
                first = false;

                if (!compact_) writeIndent(ss);
                writeString(ss, pair.first);
                ss << ':';
                if (!compact_) ss << ' ';
                writeValue(ss, pair.second);
            }

            if (!compact_) { ss << '\n'; --indent_; writeIndent(ss); }
            ss << '}';
        }

        void writeArray(std::ostringstream& ss, const JsonArray& arr) {
            ss << '[';
            if (!compact_) { ss << '\n'; ++indent_; }

            bool first = true;
            for (const auto& val : arr) {
                if (!first) {
                    ss << ',';
                    if (!compact_) ss << '\n';
                }
                first = false;

                if (!compact_) writeIndent(ss);
                writeValue(ss, val);
            }

            if (!compact_) { ss << '\n'; --indent_; writeIndent(ss); }
            ss << ']';
        }

        void writeIndent(std::ostringstream& ss) {
            for (int i = 0; i < indent_; ++i) ss << "  ";
        }

        bool compact_;
        int indent_;
    };

    JsonObject object_;
    JsonArray array_;
    bool isArray_;
};

} // namespace core

// Core-prefixed typedefs (always available, no conflicts)
using CoreJsonValue = core::JsonValue;
using CoreJsonObject = core::JsonObject;
using CoreJsonArray = core::JsonArray;
using CoreJsonDocument = core::JsonDocument;
using CoreJsonParseError = core::JsonParseError;

// Qt-compatible typedefs - only define if not using Qt
#ifndef QT_CORE_LIB
using QJsonValue = core::JsonValue;
using QJsonObject = core::JsonObject;
using QJsonArray = core::JsonArray;
using QJsonDocument = core::JsonDocument;
using QJsonParseError = core::JsonParseError;
#endif

#endif // CORE_JSON_H
