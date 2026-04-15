#ifndef CORE_CORE_H
#define CORE_CORE_H

// Main include file for core library
// This provides Qt-free replacements for common Qt functionality

// Basic types (int32_t, uint8_t, QString, QList, QMap, etc.)
#include "types.h"

// Logging (replaces QDebug)
#include "logger.h"

// Timer utilities (replaces QElapsedTimer)
#include "elapsed_timer.h"

// Mutex and synchronization (replaces QMutex, QMutexLocker)
#include "mutex.h"

// Signal/slot system (replaces Qt signals/slots)
#include "signal.h"

// Threading (replaces QThread)
#include "thread.h"

// Timer (replaces QTimer)
#include "timer.h"

// File utilities (replaces QFile, QDir, QFileInfo, QTextStream)
#include "file_utils.h"

// File system watcher (replaces QFileSystemWatcher)
#include "file_watcher.h"

// JSON (replaces QJsonDocument, QJsonObject, QJsonArray, QJsonValue)
#include "json.h"

// Serialization (replaces QDataStream, QSaveFile)
#include "serialization.h"

// Settings (replaces QSettings)
#include "settings.h"

// Enum utilities (replaces Q_ENUM/QMetaEnum)
#include "enum_utils.h"

// Command-line parser (replaces QCommandLineParser)
#include "cmdline_parser.h"

// Resource handling (replaces QResource)
#include "resource.h"

// Compatibility macros for easier migration
// Only define these if Qt is NOT present

#include <cassert>

#ifndef QT_CORE_LIB
// Q_UNUSED equivalent
#define Q_UNUSED(x) (void)(x)

// Q_ASSERT equivalent
#define Q_ASSERT(x) assert(x)

// nullptr check
#define Q_NULLPTR nullptr

// Qt meta-object system macros
#define Q_OBJECT
#define Q_PROPERTY(...)
#define Q_ENUM(x)
#define Q_GADGET
#define Q_INVOKABLE
#define Q_SIGNAL
#define Q_SLOT
#define Q_EMIT

// Signal/slot keywords
#define signals public
#define slots
#define emit

#endif // QT_CORE_LIB

// Process (replaces QProcess - simplified version)
#include <cstdlib>

#ifdef _WIN32
#include <windows.h>
#else
#include <sys/wait.h>
#include <unistd.h>
#endif

namespace core {

class Process {
public:
    enum ProcessState {
        NotRunning,
        Starting,
        Running
    };

#ifdef _WIN32
    Process() : state_(NotRunning) {
        memset(&pi_, 0, sizeof(pi_));
    }
#else
    Process() : pid_(-1), state_(NotRunning) {}
#endif

    void start(const std::string& program, const std::vector<std::string>& args = {}) {
        state_ = Starting;

#ifdef _WIN32
        std::string cmdLine = program;
        for (const auto& arg : args) {
            cmdLine += " " + arg;
        }

        STARTUPINFOA si;
        memset(&si, 0, sizeof(si));
        si.cb = sizeof(si);
        memset(&pi_, 0, sizeof(pi_));

        std::vector<char> cmdBuf(cmdLine.begin(), cmdLine.end());
        cmdBuf.push_back('\0');

        if (CreateProcessA(nullptr, cmdBuf.data(), nullptr, nullptr,
                           FALSE, 0, nullptr, nullptr, &si, &pi_)) {
            state_ = Running;
        } else {
            state_ = NotRunning;
        }
#else
        pid_ = fork();

        if (pid_ == 0) {
            // Child process
            std::vector<char*> argv;
            argv.push_back(const_cast<char*>(program.c_str()));
            for (const auto& arg : args) {
                argv.push_back(const_cast<char*>(arg.c_str()));
            }
            argv.push_back(nullptr);

            execvp(program.c_str(), argv.data());
            _exit(127); // exec failed
        } else if (pid_ > 0) {
            state_ = Running;
        } else {
            state_ = NotRunning;
        }
#endif
    }

    bool waitForFinished(int msecs = -1) {
#ifdef _WIN32
        if (pi_.hProcess == nullptr) return true;

        DWORD waitTime = (msecs < 0) ? INFINITE : static_cast<DWORD>(msecs);
        DWORD result = WaitForSingleObject(pi_.hProcess, waitTime);

        if (result == WAIT_OBJECT_0) {
            DWORD code = 0;
            GetExitCodeProcess(pi_.hProcess, &code);
            exitCode_ = static_cast<int>(code);
            CloseHandle(pi_.hProcess);
            CloseHandle(pi_.hThread);
            memset(&pi_, 0, sizeof(pi_));
            state_ = NotRunning;
            return true;
        }
        return false;
#else
        if (pid_ <= 0) return true;

        int status;
        if (msecs < 0) {
            waitpid(pid_, &status, 0);
        } else {
            // Simplified timeout handling
            int elapsed = 0;
            while (elapsed < msecs) {
                int result = waitpid(pid_, &status, WNOHANG);
                if (result > 0) break;
                if (result < 0) break;
                usleep(10000); // 10ms
                elapsed += 10;
            }
        }

        if (WIFEXITED(status)) {
            exitCode_ = WEXITSTATUS(status);
        }
        state_ = NotRunning;
        pid_ = -1;
        return true;
#endif
    }

    int exitCode() const { return exitCode_; }
    ProcessState state() const { return state_; }

    static int execute(const std::string& program, const std::vector<std::string>& args = {}) {
        Process p;
        p.start(program, args);
        p.waitForFinished();
        return p.exitCode();
    }

    // Replacement for QProcess::startDetached - launches a process detached from parent
    static bool startDetached(const std::string& program, const std::vector<std::string>& args = {}) {
#ifdef _WIN32
        std::string cmdLine = program;
        for (const auto& arg : args) {
            cmdLine += " " + arg;
        }

        STARTUPINFOA si;
        memset(&si, 0, sizeof(si));
        si.cb = sizeof(si);
        PROCESS_INFORMATION pi;
        memset(&pi, 0, sizeof(pi));

        std::vector<char> cmdBuf(cmdLine.begin(), cmdLine.end());
        cmdBuf.push_back('\0');

        if (CreateProcessA(nullptr, cmdBuf.data(), nullptr, nullptr,
                           FALSE, CREATE_NEW_PROCESS_GROUP | DETACHED_PROCESS,
                           nullptr, nullptr, &si, &pi)) {
            CloseHandle(pi.hProcess);
            CloseHandle(pi.hThread);
            return true;
        }
        return false;
#else
        pid_t pid = fork();

        if (pid == 0) {
            // Child process - create new session to detach from parent
            setsid();

            // Fork again to prevent zombie processes
            pid_t pid2 = fork();
            if (pid2 > 0) {
                _exit(0); // First child exits
            } else if (pid2 < 0) {
                _exit(127); // Fork failed
            }

            // Second child (grandchild) continues - now fully detached
            std::vector<char*> argv;
            argv.push_back(const_cast<char*>(program.c_str()));
            for (const auto& arg : args) {
                argv.push_back(const_cast<char*>(arg.c_str()));
            }
            argv.push_back(nullptr);

            execvp(program.c_str(), argv.data());
            _exit(127); // exec failed
        } else if (pid > 0) {
            // Parent waits for first child to exit
            int status;
            waitpid(pid, &status, 0);
            return true;
        }

        return false; // fork failed
#endif
    }

    // Overload that takes a single string command (parses it)
    static bool startDetachedCommand(const std::string& command) {
        // Simple space-separated parsing for single command string
        std::vector<std::string> parts;
        std::string current;
        for (char c : command) {
            if (c == ' ' && !current.empty()) {
                parts.push_back(current);
                current.clear();
            } else if (c != ' ') {
                current += c;
            }
        }
        if (!current.empty()) {
            parts.push_back(current);
        }

        if (parts.empty()) return false;

        std::string program = parts[0];
        std::vector<std::string> args(parts.begin() + 1, parts.end());
        return startDetached(program, args);
    }

private:
#ifdef _WIN32
    PROCESS_INFORMATION pi_;
#else
    pid_t pid_;
#endif
    ProcessState state_;
    int exitCode_ = 0;
};

} // namespace core

// Core-prefixed typedef (always available, no conflicts)
using CoreProcess = core::Process;

// Qt-compatible typedef - only define if not using Qt
#ifndef QT_CORE_LIB
using QProcess = core::Process;
#endif

#endif // CORE_CORE_H
