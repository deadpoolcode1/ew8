#ifndef CORE_CORE_H
#define CORE_CORE_H

// Main include file for core library
// This provides Qt-free replacements for common Qt functionality

// Basic types (qint32, quint8, QString, QList, QMap, etc.)
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

// Compatibility macros for easier migration

// Q_UNUSED equivalent
#define Q_UNUSED(x) (void)(x)

// Q_ASSERT equivalent
#include <cassert>
#define Q_ASSERT(x) assert(x)

// nullptr check
#define Q_NULLPTR nullptr

// For Qt compatibility - these need to be defined somewhere
#ifndef Q_OBJECT
#define Q_OBJECT
#endif

#ifndef Q_PROPERTY
#define Q_PROPERTY(...)
#endif

#ifndef Q_ENUM
#define Q_ENUM(x)
#endif

#ifndef Q_GADGET
#define Q_GADGET
#endif

#ifndef Q_INVOKABLE
#define Q_INVOKABLE
#endif

#ifndef Q_SLOT
#define Q_SLOT
#endif

#ifndef Q_SIGNAL
#define Q_SIGNAL
#endif

#ifndef Q_EMIT
#define Q_EMIT
#endif

#ifndef emit
#define emit
#endif

#ifndef signals
#define signals public
#endif

#ifndef slots
#define slots
#endif

// Process (replaces QProcess - simplified version using fork/exec)
#include <cstdlib>
#include <sys/wait.h>
#include <unistd.h>

namespace core {

class Process {
public:
    enum ProcessState {
        NotRunning,
        Starting,
        Running
    };

    Process() : pid_(-1), state_(NotRunning) {}

    void start(const std::string& program, const std::vector<std::string>& args = {}) {
        state_ = Starting;
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
    }

    bool waitForFinished(int msecs = -1) {
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
    }

    int exitCode() const { return exitCode_; }
    ProcessState state() const { return state_; }

    static int execute(const std::string& program, const std::vector<std::string>& args = {}) {
        Process p;
        p.start(program, args);
        p.waitForFinished();
        return p.exitCode();
    }

private:
    pid_t pid_;
    ProcessState state_;
    int exitCode_ = 0;
};

} // namespace core

using QProcess = core::Process;

#endif // CORE_CORE_H
