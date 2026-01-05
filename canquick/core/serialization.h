#ifndef CORE_SERIALIZATION_H
#define CORE_SERIALIZATION_H

#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <cstdint>
#include <cstring>
#include <type_traits>

#include "types.h"
#include "file_utils.h"

namespace core {

// Drop-in replacement for QDataStream
class DataStream {
public:
    enum ByteOrder {
        BigEndian,
        LittleEndian
    };

    enum Status {
        Ok,
        ReadPastEnd,
        WriteFailed,
        ReadCorruptData
    };

    // Constructor from buffer
    DataStream(std::vector<uint8_t>* buffer, int mode = 0)
        : buffer_(buffer), file_(nullptr), pos_(0),
          byteOrder_(LittleEndian), status_(Ok), mode_(mode) {}

    // Constructor from file
    DataStream(File* file)
        : buffer_(nullptr), file_(file), pos_(0),
          byteOrder_(LittleEndian), status_(Ok), mode_(0) {}

    // Set byte order
    void setByteOrder(ByteOrder order) { byteOrder_ = order; }
    ByteOrder byteOrder() const { return byteOrder_; }

    // Get status
    Status status() const { return status_; }
    void resetStatus() { status_ = Ok; }

    // Check if at end
    bool atEnd() const {
        if (buffer_) return pos_ >= buffer_->size();
        if (file_) return file_->atEnd();
        return true;
    }

    // Skip bytes
    int skipRawData(int len) {
        if (buffer_) {
            int skipped = std::min(len, static_cast<int>(buffer_->size() - pos_));
            pos_ += skipped;
            return skipped;
        }
        // For file, we'd need to seek
        return 0;
    }

    // Write operators
    DataStream& operator<<(qint8 val) { writeRaw(&val, 1); return *this; }
    DataStream& operator<<(quint8 val) { writeRaw(&val, 1); return *this; }
    DataStream& operator<<(qint16 val) { writeWithOrder(&val, 2); return *this; }
    DataStream& operator<<(quint16 val) { writeWithOrder(&val, 2); return *this; }
    DataStream& operator<<(qint32 val) { writeWithOrder(&val, 4); return *this; }
    DataStream& operator<<(quint32 val) { writeWithOrder(&val, 4); return *this; }
    DataStream& operator<<(qint64 val) { writeWithOrder(&val, 8); return *this; }
    DataStream& operator<<(quint64 val) { writeWithOrder(&val, 8); return *this; }
    DataStream& operator<<(float val) { writeWithOrder(&val, 4); return *this; }
    DataStream& operator<<(double val) { writeWithOrder(&val, 8); return *this; }
    DataStream& operator<<(bool val) { quint8 v = val ? 1 : 0; return *this << v; }

    DataStream& operator<<(const std::string& val) {
        quint32 len = val.size();
        *this << len;
        writeRaw(val.data(), len);
        return *this;
    }

    DataStream& operator<<(const char* val) {
        return *this << std::string(val ? val : "");
    }

    template<typename T>
    DataStream& operator<<(const std::vector<T>& vec) {
        quint32 size = vec.size();
        *this << size;
        for (const auto& item : vec) {
            *this << item;
        }
        return *this;
    }

    // Read operators
    DataStream& operator>>(qint8& val) { readRaw(&val, 1); return *this; }
    DataStream& operator>>(quint8& val) { readRaw(&val, 1); return *this; }
    DataStream& operator>>(qint16& val) { readWithOrder(&val, 2); return *this; }
    DataStream& operator>>(quint16& val) { readWithOrder(&val, 2); return *this; }
    DataStream& operator>>(qint32& val) { readWithOrder(&val, 4); return *this; }
    DataStream& operator>>(quint32& val) { readWithOrder(&val, 4); return *this; }
    DataStream& operator>>(qint64& val) { readWithOrder(&val, 8); return *this; }
    DataStream& operator>>(quint64& val) { readWithOrder(&val, 8); return *this; }
    DataStream& operator>>(float& val) { readWithOrder(&val, 4); return *this; }
    DataStream& operator>>(double& val) { readWithOrder(&val, 8); return *this; }
    DataStream& operator>>(bool& val) { quint8 v; *this >> v; val = (v != 0); return *this; }

    DataStream& operator>>(std::string& val) {
        quint32 len;
        *this >> len;
        if (len > 0 && status_ == Ok) {
            val.resize(len);
            readRaw(&val[0], len);
        } else {
            val.clear();
        }
        return *this;
    }

    template<typename T>
    DataStream& operator>>(std::vector<T>& vec) {
        quint32 size;
        *this >> size;
        vec.clear();
        vec.reserve(size);
        for (quint32 i = 0; i < size && status_ == Ok; ++i) {
            T item;
            *this >> item;
            vec.push_back(item);
        }
        return *this;
    }

    // Raw read/write
    int writeRawData(const char* data, int len) {
        writeRaw(data, len);
        return status_ == Ok ? len : -1;
    }

    int readRawData(char* data, int len) {
        readRaw(data, len);
        return status_ == Ok ? len : -1;
    }

private:
    void writeRaw(const void* data, size_t len) {
        if (buffer_) {
            const uint8_t* bytes = static_cast<const uint8_t*>(data);
            buffer_->insert(buffer_->end(), bytes, bytes + len);
        } else if (file_) {
            if (file_->write(static_cast<const char*>(data), len) != static_cast<qint64>(len)) {
                status_ = WriteFailed;
            }
        }
    }

    void readRaw(void* data, size_t len) {
        if (buffer_) {
            if (pos_ + len > buffer_->size()) {
                status_ = ReadPastEnd;
                return;
            }
            std::memcpy(data, buffer_->data() + pos_, len);
            pos_ += len;
        }
        // File reading would need different handling
    }

    void writeWithOrder(const void* data, size_t len) {
        if (needsSwap()) {
            uint8_t temp[8];
            const uint8_t* src = static_cast<const uint8_t*>(data);
            for (size_t i = 0; i < len; ++i) {
                temp[i] = src[len - 1 - i];
            }
            writeRaw(temp, len);
        } else {
            writeRaw(data, len);
        }
    }

    void readWithOrder(void* data, size_t len) {
        readRaw(data, len);
        if (needsSwap() && status_ == Ok) {
            uint8_t* bytes = static_cast<uint8_t*>(data);
            for (size_t i = 0; i < len / 2; ++i) {
                std::swap(bytes[i], bytes[len - 1 - i]);
            }
        }
    }

    bool needsSwap() const {
        static const uint32_t test = 1;
        bool systemIsLittle = (*reinterpret_cast<const uint8_t*>(&test) == 1);
        return (byteOrder_ == BigEndian) == systemIsLittle;
    }

    std::vector<uint8_t>* buffer_;
    File* file_;
    size_t pos_;
    ByteOrder byteOrder_;
    Status status_;
    int mode_;
};

// SaveFile class - replacement for QSaveFile (atomic file writes)
class SaveFile : public File {
public:
    SaveFile(const std::string& path) : File(), targetPath_(path), committed_(false) {
        // Create temporary file in same directory
        size_t lastSlash = path.rfind('/');
        std::string dir = (lastSlash != std::string::npos) ? path.substr(0, lastSlash) : ".";
        std::string name = (lastSlash != std::string::npos) ? path.substr(lastSlash + 1) : path;
        tempPath_ = dir + "/." + name + ".tmp";
        setFileName(tempPath_);
    }

    ~SaveFile() {
        if (!committed_) {
            cancelWriting();
        }
    }

    bool commit() {
        close();
        if (File::rename(tempPath_, targetPath_)) {
            committed_ = true;
            return true;
        }
        return false;
    }

    void cancelWriting() {
        close();
        File::remove(tempPath_);
    }

private:
    std::string targetPath_;
    std::string tempPath_;
    bool committed_;
};

} // namespace core

// Compatibility typedefs
using QDataStream = core::DataStream;
using QSaveFile = core::SaveFile;

#endif // CORE_SERIALIZATION_H
