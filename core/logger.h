#ifndef CORE_LOGGER_H
#define CORE_LOGGER_H

#include <cstdio>
#include <cstdarg>
#include <cstring>
#include <string>
#include <sstream>
#include <chrono>
#include <mutex>

// Include Qt headers if Qt is present (for QString streaming support)
#ifdef QT_CORE_LIB
#include <QString>
#endif

// Simple logging system to replace QDebug

namespace core {

enum class LogLevel {
    Debug,
    Info,
    Warning,
    Error,
    Critical
};

class Logger {
public:
    static Logger& instance() {
        static Logger logger;
        return logger;
    }

    void setLevel(LogLevel level) { minLevel_ = level; }
    LogLevel level() const { return minLevel_; }

    // Mirror every log line to a file in addition to stderr, so the output
    // survives a crash that closes the console window (IMS-11652). The file is
    // opened for append and each line is flushed immediately, so logs are
    // preserved even if the process dies abruptly. Passing an empty path (or a
    // path that cannot be opened) leaves file logging disabled.
    void setLogFile(const std::string& path) {
        std::lock_guard<std::mutex> lock(mutex_);
        if (logFile_) { fclose(logFile_); logFile_ = nullptr; }
        if (path.empty()) return;
        logFile_ = fopen(path.c_str(), "a");
        if (logFile_) {
            fprintf(logFile_, "\n===== EW8 log session started =====\n");
            fflush(logFile_);
        }
    }

    void log(LogLevel level, const char* /*file*/, int /*line*/, const char* /*func*/, const char* fmt, ...) {
        if (level < minLevel_) return;

        std::lock_guard<std::mutex> lock(mutex_);

        // Timestamp
        auto now = std::chrono::system_clock::now();
        auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(
            now.time_since_epoch()).count() % 1000;
        auto time = std::chrono::system_clock::to_time_t(now);
        struct tm* tm_info = localtime(&time);

        const char* levelStr = "";
        switch (level) {
            case LogLevel::Debug:    levelStr = "DEBUG"; break;
            case LogLevel::Info:     levelStr = "INFO "; break;
            case LogLevel::Warning:  levelStr = "WARN "; break;
            case LogLevel::Error:    levelStr = "ERROR"; break;
            case LogLevel::Critical: levelStr = "CRIT "; break;
        }

        // Format the message body once, then emit the full line to every sink
        // so stderr and the log file stay identical.
        char msgbuf[1024];
        va_list args;
        va_start(args, fmt);
        vsnprintf(msgbuf, sizeof(msgbuf), fmt, args);
        va_end(args);

        char linebuf[1152];
        snprintf(linebuf, sizeof(linebuf), "[%02d:%02d:%02d.%03d] [%s] %s\n",
                 tm_info->tm_hour, tm_info->tm_min, tm_info->tm_sec, (int)ms,
                 levelStr, msgbuf);

        fputs(linebuf, stderr);
        if (logFile_) {
            fputs(linebuf, logFile_);
            fflush(logFile_);  // crash-safe: don't rely on buffered exit
        }
    }

private:
    Logger() : minLevel_(LogLevel::Debug), logFile_(nullptr) {}
    ~Logger() { if (logFile_) fclose(logFile_); }
    LogLevel minLevel_;
    std::mutex mutex_;
    FILE* logFile_;
};

// Stream-style logger for qDebug() << style logging
class LogStream {
public:
    LogStream(LogLevel level = LogLevel::Debug) : level_(level) {}

    ~LogStream() {
        Logger::instance().log(level_, "", 0, "", "%s", ss_.str().c_str());
    }

    template<typename T>
    LogStream& operator<<(const T& value) {
        ss_ << value;
        return *this;
    }

    // Special handling for std::string
    LogStream& operator<<(const std::string& value) {
        ss_ << value;
        return *this;
    }

    // Special handling for C-strings
    LogStream& operator<<(const char* value) {
        ss_ << (value ? value : "(null)");
        return *this;
    }

    // Pointer formatting
    LogStream& operator<<(void* ptr) {
        ss_ << ptr;
        return *this;
    }

#ifdef QT_CORE_LIB
    // Qt QString support
    LogStream& operator<<(const QString& value) {
        ss_ << value.toStdString();
        return *this;
    }
#endif // QT_CORE_LIB

private:
    LogLevel level_;
    std::stringstream ss_;
};

} // namespace core

// Core logging macros (always available, no conflicts)
#define coreDebug() core::LogStream(core::LogLevel::Debug)
#define coreInfo() core::LogStream(core::LogLevel::Info)
#define coreWarning() core::LogStream(core::LogLevel::Warning)
#define coreCritical() core::LogStream(core::LogLevel::Critical)

// printf-style logging macros
#define LOG_DEBUG(fmt, ...) core::Logger::instance().log(core::LogLevel::Debug, __FILE__, __LINE__, __func__, fmt, ##__VA_ARGS__)
#define LOG_INFO(fmt, ...) core::Logger::instance().log(core::LogLevel::Info, __FILE__, __LINE__, __func__, fmt, ##__VA_ARGS__)
#define LOG_WARN(fmt, ...) core::Logger::instance().log(core::LogLevel::Warning, __FILE__, __LINE__, __func__, fmt, ##__VA_ARGS__)
#define LOG_ERROR(fmt, ...) core::Logger::instance().log(core::LogLevel::Error, __FILE__, __LINE__, __func__, fmt, ##__VA_ARGS__)

// Qt-compatible macros - only define if Qt is NOT present
#ifndef QT_CORE_LIB
#define qDebug() core::LogStream(core::LogLevel::Debug)
#define qInfo() core::LogStream(core::LogLevel::Info)
#define qWarning() core::LogStream(core::LogLevel::Warning)
#define qCritical() core::LogStream(core::LogLevel::Critical)
#endif // QT_CORE_LIB

#endif // CORE_LOGGER_H
