#ifndef CORE_FILE_WATCHER_H
#define CORE_FILE_WATCHER_H

#include <string>
#include <vector>
#include <map>
#include <thread>
#include <atomic>
#include <mutex>
#include <functional>

#ifdef __linux__
#include <sys/inotify.h>
#include <unistd.h>
#include <poll.h>
#endif

#include "signal.h"

namespace core {

// Drop-in replacement for QFileSystemWatcher using inotify on Linux
class FileSystemWatcher {
public:
    FileSystemWatcher() : running_(false) {
#ifdef __linux__
        inotifyFd_ = inotify_init1(IN_NONBLOCK);
        if (inotifyFd_ >= 0) {
            startWatching();
        }
#endif
    }

    ~FileSystemWatcher() {
        stop();
#ifdef __linux__
        if (inotifyFd_ >= 0) {
            close(inotifyFd_);
        }
#endif
    }

    // Add a path to watch
    bool addPath(const std::string& path) {
#ifdef __linux__
        if (inotifyFd_ < 0) return false;

        std::lock_guard<std::mutex> lock(mutex_);

        // Check if already watching
        if (watchDescriptors_.count(path) > 0) {
            return true;
        }

        uint32_t mask = IN_MODIFY | IN_CREATE | IN_DELETE | IN_MOVED_FROM | IN_MOVED_TO;
        int wd = inotify_add_watch(inotifyFd_, path.c_str(), mask);

        if (wd < 0) {
            return false;
        }

        watchDescriptors_[path] = wd;
        descriptorPaths_[wd] = path;
        return true;
#else
        return false;
#endif
    }

    // Add multiple paths
    std::vector<std::string> addPaths(const std::vector<std::string>& paths) {
        std::vector<std::string> added;
        for (const auto& path : paths) {
            if (addPath(path)) {
                added.push_back(path);
            }
        }
        return added;
    }

    // Remove a path from watching
    bool removePath(const std::string& path) {
#ifdef __linux__
        std::lock_guard<std::mutex> lock(mutex_);

        auto it = watchDescriptors_.find(path);
        if (it == watchDescriptors_.end()) {
            return false;
        }

        int wd = it->second;
        inotify_rm_watch(inotifyFd_, wd);

        watchDescriptors_.erase(it);
        descriptorPaths_.erase(wd);
        return true;
#else
        return false;
#endif
    }

    // Remove multiple paths
    std::vector<std::string> removePaths(const std::vector<std::string>& paths) {
        std::vector<std::string> removed;
        for (const auto& path : paths) {
            if (removePath(path)) {
                removed.push_back(path);
            }
        }
        return removed;
    }

    // Get list of watched files
    std::vector<std::string> files() const {
        std::lock_guard<std::mutex> lock(mutex_);
        std::vector<std::string> result;
        for (const auto& pair : watchDescriptors_) {
            result.push_back(pair.first);
        }
        return result;
    }

    // Get list of watched directories
    std::vector<std::string> directories() const {
        return files(); // For simplicity, treating all as the same
    }

    // Signals emitted when files/directories change
    Signal<std::string> fileChanged;
    Signal<std::string> directoryChanged;

private:
    void startWatching() {
#ifdef __linux__
        running_ = true;
        watchThread_ = std::thread([this]() {
            char buffer[4096];
            struct pollfd pfd;
            pfd.fd = inotifyFd_;
            pfd.events = POLLIN;

            while (running_) {
                int ret = poll(&pfd, 1, 100); // 100ms timeout
                if (ret < 0) {
                    if (errno == EINTR) continue;
                    break;
                }

                if (ret == 0) continue; // Timeout

                ssize_t len = read(inotifyFd_, buffer, sizeof(buffer));
                if (len < 0) {
                    if (errno == EAGAIN) continue;
                    break;
                }

                for (char* ptr = buffer; ptr < buffer + len; ) {
                    struct inotify_event* event = reinterpret_cast<struct inotify_event*>(ptr);

                    std::string path;
                    {
                        std::lock_guard<std::mutex> lock(mutex_);
                        auto it = descriptorPaths_.find(event->wd);
                        if (it != descriptorPaths_.end()) {
                            path = it->second;
                            if (event->len > 0) {
                                path += "/";
                                path += event->name;
                            }
                        }
                    }

                    if (!path.empty()) {
                        if (event->mask & IN_ISDIR) {
                            directoryChanged.fire(path);
                        } else {
                            fileChanged.fire(path);
                        }
                    }

                    ptr += sizeof(struct inotify_event) + event->len;
                }
            }
        });
#endif
    }

    void stop() {
        running_ = false;
        if (watchThread_.joinable()) {
            watchThread_.join();
        }
    }

#ifdef __linux__
    int inotifyFd_;
#endif
    std::atomic<bool> running_;
    std::thread watchThread_;
    mutable std::mutex mutex_;
    std::map<std::string, int> watchDescriptors_;
    std::map<int, std::string> descriptorPaths_;
};

} // namespace core

// Core-prefixed typedef (always available, no conflicts)
using CoreFileSystemWatcher = core::FileSystemWatcher;

// Qt-compatible typedef - used by DEFAULT, skipped when USE_QT_BACKEND is defined
#ifndef USE_QT_BACKEND
using QFileSystemWatcher = core::FileSystemWatcher;
#endif

#endif // CORE_FILE_WATCHER_H
