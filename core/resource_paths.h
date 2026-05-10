#ifndef CORE_RESOURCE_PATHS_H
#define CORE_RESOURCE_PATHS_H

#include <string>
#include <sys/stat.h>

#ifdef _WIN32
#include <windows.h>
#else
#include <unistd.h>
#include <limits.h>
#endif

#ifndef BASE_TARGET_DIR
#define BASE_TARGET_DIR ""
#endif

namespace core {

inline std::string executableDir() {
#ifdef _WIN32
    char buf[MAX_PATH];
    DWORD len = GetModuleFileNameA(nullptr, buf, MAX_PATH);
    if (len == 0 || len >= MAX_PATH) return std::string();
    std::string path(buf, len);
    size_t pos = path.find_last_of("\\/");
    if (pos == std::string::npos) return std::string();
    return path.substr(0, pos + 1);
#else
    char buf[PATH_MAX];
    ssize_t len = ::readlink("/proc/self/exe", buf, PATH_MAX);
    if (len <= 0) return std::string();
    std::string path(buf, static_cast<size_t>(len));
    size_t pos = path.find_last_of('/');
    if (pos == std::string::npos) return std::string();
    return path.substr(0, pos + 1);
#endif
}

// Base directory for runtime resources (configs/, dbc/, qml/, ...).
// Picks the first directory that contains "configs/EW8_Config.json":
//   1. <exe-dir>/             — resources shipped alongside the binary
//   2. <exe-dir>/../          — binary in a bin/ subfolder
//   3. BASE_TARGET_DIR        — compile-time default (dev tree)
//   4. <exe-dir>/             — last resort, beats a stale absolute path
// Always returns a string ending in a separator.
inline const std::string& resourceBaseDir() {
    static const std::string cached = []() -> std::string {
        const std::string sentinel = "configs/EW8_Config.json";
        auto fileExists = [](const std::string& p) {
            struct stat st;
            return ::stat(p.c_str(), &st) == 0;
        };

        const std::string exeDir = executableDir();
        if (!exeDir.empty() && fileExists(exeDir + sentinel)) {
            return exeDir;
        }
        if (!exeDir.empty() && fileExists(exeDir + "../" + sentinel)) {
            return exeDir + "../";
        }
        const std::string compiled = BASE_TARGET_DIR;
        if (!compiled.empty() && fileExists(compiled + sentinel)) {
            return compiled;
        }
        return exeDir.empty() ? compiled : exeDir;
    }();
    return cached;
}

} // namespace core

#endif // CORE_RESOURCE_PATHS_H
