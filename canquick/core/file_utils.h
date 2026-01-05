#ifndef CORE_FILE_UTILS_H
#define CORE_FILE_UTILS_H

#include <string>
#include <vector>
#include <fstream>
#include <sstream>
#include <cstdio>
#include <sys/stat.h>
#include <dirent.h>
#include <unistd.h>
#include <cstring>

#include "types.h"

namespace core {

// File class - replacement for QFile
class File {
public:
    enum OpenMode {
        ReadOnly = 0x01,
        WriteOnly = 0x02,
        ReadWrite = ReadOnly | WriteOnly,
        Append = 0x04,
        Truncate = 0x08,
        Text = 0x10
    };

    File() : isOpen_(false) {}
    File(const std::string& path) : path_(path), isOpen_(false) {}

    void setFileName(const std::string& path) {
        if (isOpen_) close();
        path_ = path;
    }

    std::string fileName() const { return path_; }

    bool exists() const {
        struct stat st;
        return stat(path_.c_str(), &st) == 0;
    }

    static bool exists(const std::string& path) {
        struct stat st;
        return stat(path.c_str(), &st) == 0;
    }

    bool open(int mode) {
        std::ios_base::openmode iosMode = std::ios_base::binary;

        if (mode & ReadOnly) iosMode |= std::ios_base::in;
        if (mode & WriteOnly) iosMode |= std::ios_base::out;
        if (mode & Append) iosMode |= std::ios_base::app;
        if (mode & Truncate) iosMode |= std::ios_base::trunc;

        if (mode & WriteOnly) {
            stream_.open(path_, iosMode);
        } else {
            stream_.open(path_, iosMode);
        }

        isOpen_ = stream_.is_open();
        return isOpen_;
    }

    void close() {
        if (stream_.is_open()) {
            stream_.close();
        }
        isOpen_ = false;
    }

    bool isOpen() const { return isOpen_; }

    // Read all content
    std::string readAll() {
        if (!isOpen_) return "";

        stream_.seekg(0, std::ios::end);
        size_t size = stream_.tellg();
        stream_.seekg(0, std::ios::beg);

        std::string content(size, '\0');
        stream_.read(&content[0], size);
        return content;
    }

    // Read all as bytes
    std::vector<uint8_t> readAllBytes() {
        if (!isOpen_) return {};

        stream_.seekg(0, std::ios::end);
        size_t size = stream_.tellg();
        stream_.seekg(0, std::ios::beg);

        std::vector<uint8_t> data(size);
        stream_.read(reinterpret_cast<char*>(data.data()), size);
        return data;
    }

    // Read a line
    std::string readLine() {
        std::string line;
        if (isOpen_) {
            std::getline(stream_, line);
        }
        return line;
    }

    // Write data
    qint64 write(const std::string& data) {
        if (!isOpen_) return -1;
        stream_.write(data.data(), data.size());
        return stream_.good() ? data.size() : -1;
    }

    qint64 write(const char* data, qint64 len) {
        if (!isOpen_) return -1;
        stream_.write(data, len);
        return stream_.good() ? len : -1;
    }

    qint64 write(const std::vector<uint8_t>& data) {
        if (!isOpen_) return -1;
        stream_.write(reinterpret_cast<const char*>(data.data()), data.size());
        return stream_.good() ? data.size() : -1;
    }

    // Get file size
    qint64 size() const {
        struct stat st;
        if (stat(path_.c_str(), &st) == 0) {
            return st.st_size;
        }
        return -1;
    }

    // Check if at end of file
    bool atEnd() const {
        return !isOpen_ || stream_.eof();
    }

    // Seek
    bool seek(qint64 pos) {
        if (!isOpen_) return false;
        stream_.seekg(pos);
        stream_.seekp(pos);
        return stream_.good();
    }

    qint64 pos() const {
        if (!isOpen_) return -1;
        return const_cast<std::fstream&>(stream_).tellg();
    }

    // Remove file
    bool remove() {
        if (isOpen_) close();
        return std::remove(path_.c_str()) == 0;
    }

    static bool remove(const std::string& path) {
        return std::remove(path.c_str()) == 0;
    }

    // Rename file
    static bool rename(const std::string& oldPath, const std::string& newPath) {
        return std::rename(oldPath.c_str(), newPath.c_str()) == 0;
    }

    // Copy file
    static bool copy(const std::string& src, const std::string& dst) {
        std::ifstream srcFile(src, std::ios::binary);
        std::ofstream dstFile(dst, std::ios::binary);
        if (!srcFile || !dstFile) return false;
        dstFile << srcFile.rdbuf();
        return true;
    }

private:
    std::string path_;
    std::fstream stream_;
    bool isOpen_;
};

// Directory class - replacement for QDir
class Dir {
public:
    Dir() : path_(".") {}
    Dir(const std::string& path) : path_(path) {}

    void setPath(const std::string& path) { path_ = path; }
    std::string path() const { return path_; }

    bool exists() const {
        struct stat st;
        return stat(path_.c_str(), &st) == 0 && S_ISDIR(st.st_mode);
    }

    static bool exists(const std::string& path) {
        struct stat st;
        return stat(path.c_str(), &st) == 0 && S_ISDIR(st.st_mode);
    }

    // Create directory
    bool mkdir(const std::string& dirName) const {
        std::string fullPath = path_ + "/" + dirName;
        return ::mkdir(fullPath.c_str(), 0755) == 0;
    }

    static bool mkdir(const std::string& path, bool createParents = false) {
        if (createParents) {
            // Create parent directories as needed
            std::string current;
            for (size_t i = 0; i < path.size(); ++i) {
                if (path[i] == '/' || i == path.size() - 1) {
                    if (i == path.size() - 1 && path[i] != '/') {
                        current += path[i];
                    }
                    if (!current.empty() && !Dir::exists(current)) {
                        if (::mkdir(current.c_str(), 0755) != 0) {
                            return false;
                        }
                    }
                }
                current += path[i];
            }
            return true;
        }
        return ::mkdir(path.c_str(), 0755) == 0;
    }

    // Remove directory
    bool rmdir(const std::string& dirName) const {
        std::string fullPath = path_ + "/" + dirName;
        return ::rmdir(fullPath.c_str()) == 0;
    }

    // List directory entries
    std::vector<std::string> entryList() const {
        std::vector<std::string> entries;
        DIR* dir = opendir(path_.c_str());
        if (dir) {
            struct dirent* entry;
            while ((entry = readdir(dir)) != nullptr) {
                if (strcmp(entry->d_name, ".") != 0 &&
                    strcmp(entry->d_name, "..") != 0) {
                    entries.push_back(entry->d_name);
                }
            }
            closedir(dir);
        }
        return entries;
    }

    // List with filter (simple glob matching)
    std::vector<std::string> entryList(const std::string& filter) const {
        std::vector<std::string> all = entryList();
        std::vector<std::string> filtered;
        for (const auto& entry : all) {
            if (matchesFilter(entry, filter)) {
                filtered.push_back(entry);
            }
        }
        return filtered;
    }

    // Get absolute path
    std::string absolutePath() const {
        char resolved[PATH_MAX];
        if (realpath(path_.c_str(), resolved) != nullptr) {
            return std::string(resolved);
        }
        return path_;
    }

    // Get current directory
    static std::string currentPath() {
        char cwd[PATH_MAX];
        if (getcwd(cwd, sizeof(cwd)) != nullptr) {
            return std::string(cwd);
        }
        return ".";
    }

    // Set current directory
    static bool setCurrent(const std::string& path) {
        return chdir(path.c_str()) == 0;
    }

    // Get home directory
    static std::string homePath() {
        const char* home = getenv("HOME");
        return home ? std::string(home) : "/";
    }

    // Get temp directory
    static std::string tempPath() {
        const char* tmp = getenv("TMPDIR");
        if (tmp) return std::string(tmp);
        tmp = getenv("TMP");
        if (tmp) return std::string(tmp);
        tmp = getenv("TEMP");
        if (tmp) return std::string(tmp);
        return "/tmp";
    }

    // Path separator
    static char separator() { return '/'; }

    // Clean path (remove redundant separators, . and ..)
    static std::string cleanPath(const std::string& path) {
        std::vector<std::string> parts;
        std::string current;
        bool absolute = !path.empty() && path[0] == '/';

        for (size_t i = 0; i < path.size(); ++i) {
            if (path[i] == '/') {
                if (!current.empty()) {
                    if (current == "..") {
                        if (!parts.empty() && parts.back() != "..") {
                            parts.pop_back();
                        } else if (!absolute) {
                            parts.push_back(current);
                        }
                    } else if (current != ".") {
                        parts.push_back(current);
                    }
                    current.clear();
                }
            } else {
                current += path[i];
            }
        }
        if (!current.empty()) {
            if (current == "..") {
                if (!parts.empty() && parts.back() != "..") {
                    parts.pop_back();
                } else if (!absolute) {
                    parts.push_back(current);
                }
            } else if (current != ".") {
                parts.push_back(current);
            }
        }

        std::string result;
        if (absolute) result = "/";
        for (size_t i = 0; i < parts.size(); ++i) {
            if (i > 0) result += "/";
            result += parts[i];
        }
        return result.empty() ? "." : result;
    }

private:
    std::string path_;

    bool matchesFilter(const std::string& name, const std::string& filter) const {
        // Simple wildcard matching (* only)
        if (filter == "*") return true;

        size_t ni = 0, fi = 0;
        size_t lastStar = std::string::npos, matchPos = 0;

        while (ni < name.size()) {
            if (fi < filter.size() && (filter[fi] == name[ni] || filter[fi] == '?')) {
                ++ni;
                ++fi;
            } else if (fi < filter.size() && filter[fi] == '*') {
                lastStar = fi++;
                matchPos = ni;
            } else if (lastStar != std::string::npos) {
                fi = lastStar + 1;
                ni = ++matchPos;
            } else {
                return false;
            }
        }

        while (fi < filter.size() && filter[fi] == '*') ++fi;
        return fi == filter.size();
    }
};

// FileInfo class - replacement for QFileInfo
class FileInfo {
public:
    FileInfo() {}
    FileInfo(const std::string& path) : path_(path) {}

    void setFile(const std::string& path) { path_ = path; }
    std::string filePath() const { return path_; }

    bool exists() const { return File::exists(path_); }

    std::string fileName() const {
        size_t pos = path_.rfind('/');
        return pos != std::string::npos ? path_.substr(pos + 1) : path_;
    }

    std::string baseName() const {
        std::string name = fileName();
        size_t pos = name.rfind('.');
        return pos != std::string::npos ? name.substr(0, pos) : name;
    }

    std::string suffix() const {
        std::string name = fileName();
        size_t pos = name.rfind('.');
        return pos != std::string::npos ? name.substr(pos + 1) : "";
    }

    std::string absolutePath() const {
        size_t pos = path_.rfind('/');
        std::string dir = pos != std::string::npos ? path_.substr(0, pos) : ".";
        return Dir(dir).absolutePath();
    }

    std::string absoluteFilePath() const {
        return Dir(path_).absolutePath();
    }

    qint64 size() const {
        struct stat st;
        if (stat(path_.c_str(), &st) == 0) {
            return st.st_size;
        }
        return 0;
    }

    bool isDir() const {
        struct stat st;
        return stat(path_.c_str(), &st) == 0 && S_ISDIR(st.st_mode);
    }

    bool isFile() const {
        struct stat st;
        return stat(path_.c_str(), &st) == 0 && S_ISREG(st.st_mode);
    }

    bool isReadable() const {
        return access(path_.c_str(), R_OK) == 0;
    }

    bool isWritable() const {
        return access(path_.c_str(), W_OK) == 0;
    }

    bool isExecutable() const {
        return access(path_.c_str(), X_OK) == 0;
    }

private:
    std::string path_;
};

// TextStream class - replacement for QTextStream
class TextStream {
public:
    TextStream() : file_(nullptr), ownedFile_(false) {}

    TextStream(File* file) : file_(file), ownedFile_(false) {}

    TextStream(const std::string& path, int mode = File::ReadOnly) {
        ownedFile_ = true;
        file_ = new File(path);
        file_->open(mode);
    }

    ~TextStream() {
        if (ownedFile_ && file_) {
            delete file_;
        }
    }

    void setDevice(File* file) {
        if (ownedFile_ && file_) delete file_;
        file_ = file;
        ownedFile_ = false;
    }

    std::string readLine() {
        return file_ ? file_->readLine() : "";
    }

    std::string readAll() {
        return file_ ? file_->readAll() : "";
    }

    bool atEnd() const {
        return !file_ || file_->atEnd();
    }

    TextStream& operator<<(const std::string& s) {
        if (file_) file_->write(s);
        return *this;
    }

    TextStream& operator<<(const char* s) {
        if (file_) file_->write(std::string(s));
        return *this;
    }

    TextStream& operator<<(int n) {
        if (file_) file_->write(std::to_string(n));
        return *this;
    }

    TextStream& operator<<(double n) {
        if (file_) file_->write(std::to_string(n));
        return *this;
    }

private:
    File* file_;
    bool ownedFile_;
};

} // namespace core

// Compatibility typedefs
using QFile = core::File;
using QDir = core::Dir;
using QFileInfo = core::FileInfo;
using QTextStream = core::TextStream;

// IODevice constants
namespace QIODevice {
    const int ReadOnly = core::File::ReadOnly;
    const int WriteOnly = core::File::WriteOnly;
    const int ReadWrite = core::File::ReadWrite;
    const int Append = core::File::Append;
    const int Truncate = core::File::Truncate;
    const int Text = core::File::Text;
}

#endif // CORE_FILE_UTILS_H
