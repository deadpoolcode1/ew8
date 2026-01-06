#ifndef CORE_SETTINGS_H
#define CORE_SETTINGS_H

#include <string>
#include <map>
#include <fstream>
#include <sstream>
#include <mutex>
#include <any>
#include <type_traits>

#include "types.h"
#include "file_utils.h"

namespace core {

// Simple INI-style settings replacement for QSettings
class Settings {
public:
    enum Format {
        IniFormat,
        NativeFormat = IniFormat
    };

    Settings() : format_(IniFormat) {
        // Default path
        path_ = Dir::homePath() + "/.config/app.ini";
    }

    Settings(const std::string& organization, const std::string& application)
        : format_(IniFormat) {
        path_ = Dir::homePath() + "/.config/" + organization + "/" + application + ".ini";
        load();
    }

    Settings(const std::string& fileName, Format format = IniFormat)
        : path_(fileName), format_(format) {
        load();
    }

    ~Settings() {
        sync();
    }

    // Set a value
    void setValue(const std::string& key, const std::string& value) {
        std::lock_guard<std::mutex> lock(mutex_);
        values_[currentGroup_ + key] = value;
        modified_ = true;
    }

    void setValue(const std::string& key, int value) {
        setValue(key, std::to_string(value));
    }

    void setValue(const std::string& key, double value) {
        setValue(key, std::to_string(value));
    }

    void setValue(const std::string& key, bool value) {
        setValue(key, value ? "true" : "false");
    }

    // Get a value
    std::string value(const std::string& key, const std::string& defaultValue = "") const {
        std::lock_guard<std::mutex> lock(mutex_);
        auto it = values_.find(currentGroup_ + key);
        if (it != values_.end()) {
            return it->second;
        }
        return defaultValue;
    }

    int valueInt(const std::string& key, int defaultValue = 0) const {
        std::string val = value(key, "");
        if (val.empty()) return defaultValue;
        try {
            return std::stoi(val);
        } catch (...) {
            return defaultValue;
        }
    }

    double valueDouble(const std::string& key, double defaultValue = 0.0) const {
        std::string val = value(key, "");
        if (val.empty()) return defaultValue;
        try {
            return std::stod(val);
        } catch (...) {
            return defaultValue;
        }
    }

    bool valueBool(const std::string& key, bool defaultValue = false) const {
        std::string val = value(key, "");
        if (val.empty()) return defaultValue;
        return (val == "true" || val == "1" || val == "yes");
    }

    // Check if key exists
    bool contains(const std::string& key) const {
        std::lock_guard<std::mutex> lock(mutex_);
        return values_.find(currentGroup_ + key) != values_.end();
    }

    // Remove a key
    void remove(const std::string& key) {
        std::lock_guard<std::mutex> lock(mutex_);
        values_.erase(currentGroup_ + key);
        modified_ = true;
    }

    // Clear all settings
    void clear() {
        std::lock_guard<std::mutex> lock(mutex_);
        values_.clear();
        modified_ = true;
    }

    // Begin/end group
    void beginGroup(const std::string& prefix) {
        if (!currentGroup_.empty() && currentGroup_.back() != '/') {
            currentGroup_ += '/';
        }
        currentGroup_ += prefix + '/';
    }

    void endGroup() {
        size_t pos = currentGroup_.rfind('/');
        if (pos != std::string::npos && pos > 0) {
            pos = currentGroup_.rfind('/', pos - 1);
            if (pos != std::string::npos) {
                currentGroup_ = currentGroup_.substr(0, pos + 1);
            } else {
                currentGroup_.clear();
            }
        } else {
            currentGroup_.clear();
        }
    }

    std::string group() const { return currentGroup_; }

    // Get all keys
    std::vector<std::string> allKeys() const {
        std::lock_guard<std::mutex> lock(mutex_);
        std::vector<std::string> keys;
        for (const auto& pair : values_) {
            keys.push_back(pair.first);
        }
        return keys;
    }

    // Get keys in current group
    std::vector<std::string> childKeys() const {
        std::lock_guard<std::mutex> lock(mutex_);
        std::vector<std::string> keys;
        for (const auto& pair : values_) {
            if (pair.first.compare(0, currentGroup_.size(), currentGroup_) == 0) {
                std::string remainder = pair.first.substr(currentGroup_.size());
                if (remainder.find('/') == std::string::npos) {
                    keys.push_back(remainder);
                }
            }
        }
        return keys;
    }

    // Sync to disk
    void sync() {
        if (!modified_) return;

        std::lock_guard<std::mutex> lock(mutex_);

        // Ensure directory exists
        size_t pos = path_.rfind('/');
        if (pos != std::string::npos) {
            std::string dir = path_.substr(0, pos);
            Dir::mkdir(dir, true);
        }

        std::ofstream file(path_);
        if (!file) return;

        std::string currentSection;
        for (const auto& pair : values_) {
            // Extract section from key
            std::string key = pair.first;
            std::string section;
            size_t slashPos = key.rfind('/');
            if (slashPos != std::string::npos) {
                section = key.substr(0, slashPos);
                key = key.substr(slashPos + 1);
            }

            if (section != currentSection) {
                if (!section.empty()) {
                    file << "\n[" << section << "]\n";
                }
                currentSection = section;
            }

            file << key << "=" << pair.second << "\n";
        }

        modified_ = false;
    }

    std::string fileName() const { return path_; }

    // Qt2/Qt3 compatibility methods for legacy code
    bool readBoolEntry(const std::string& key, bool defaultValue = false, bool* ok = nullptr) const {
        std::string val = value(key, "");
        if (val.empty()) {
            if (ok) *ok = false;
            return defaultValue;
        }
        if (ok) *ok = true;
        return (val == "true" || val == "1" || val == "yes");
    }

    int readNumEntry(const std::string& key, int defaultValue = 0, bool* ok = nullptr) const {
        std::string val = value(key, "");
        if (val.empty()) {
            if (ok) *ok = false;
            return defaultValue;
        }
        try {
            if (ok) *ok = true;
            return std::stoi(val);
        } catch (...) {
            if (ok) *ok = false;
            return defaultValue;
        }
    }

    std::string readEntry(const std::string& key, const std::string& defaultValue = "", bool* ok = nullptr) const {
        std::string val = value(key, "");
        if (val.empty()) {
            if (ok) *ok = false;
            return defaultValue;
        }
        if (ok) *ok = true;
        return val;
    }

    std::vector<std::string> readListEntry(const std::string& key, bool* ok = nullptr) const {
        std::string val = value(key, "");
        std::vector<std::string> result;
        if (val.empty()) {
            if (ok) *ok = false;
            return result;
        }
        // Parse comma-separated list
        std::stringstream ss(val);
        std::string item;
        while (std::getline(ss, item, ',')) {
            // Trim whitespace
            size_t start = item.find_first_not_of(" \t");
            size_t end = item.find_last_not_of(" \t");
            if (start != std::string::npos && end != std::string::npos) {
                result.push_back(item.substr(start, end - start + 1));
            }
        }
        if (ok) *ok = true;
        return result;
    }

    // Qt2/Qt3 style writeEntry - template for any type
    template<typename T>
    bool writeEntry(const std::string& key, const T& value) {
        if constexpr (std::is_same_v<T, bool>) {
            setValue(key, value);
        } else if constexpr (std::is_same_v<T, std::string>) {
            setValue(key, value);
        } else if constexpr (std::is_integral_v<T>) {
            setValue(key, static_cast<int>(value));
        } else if constexpr (std::is_floating_point_v<T>) {
            setValue(key, static_cast<double>(value));
        } else {
            // Convert to string using stringstream
            std::ostringstream oss;
            oss << value;
            setValue(key, oss.str());
        }
        return true;
    }

private:
    void load() {
        std::ifstream file(path_);
        if (!file) return;

        std::string line;
        std::string currentSection;

        while (std::getline(file, line)) {
            // Trim whitespace
            size_t start = line.find_first_not_of(" \t\r\n");
            if (start == std::string::npos) continue;
            size_t end = line.find_last_not_of(" \t\r\n");
            line = line.substr(start, end - start + 1);

            // Skip comments
            if (line.empty() || line[0] == '#' || line[0] == ';') continue;

            // Section header
            if (line[0] == '[' && line.back() == ']') {
                currentSection = line.substr(1, line.size() - 2) + '/';
                continue;
            }

            // Key=value
            size_t eqPos = line.find('=');
            if (eqPos != std::string::npos) {
                std::string key = line.substr(0, eqPos);
                std::string val = line.substr(eqPos + 1);

                // Trim key
                end = key.find_last_not_of(" \t");
                if (end != std::string::npos) key = key.substr(0, end + 1);

                // Trim value
                start = val.find_first_not_of(" \t");
                if (start != std::string::npos) val = val.substr(start);

                values_[currentSection + key] = val;
            }
        }
    }

    std::string path_;
    Format format_;
    std::map<std::string, std::string> values_;
    std::string currentGroup_;
    mutable std::mutex mutex_;
    bool modified_ = false;
};

} // namespace core

// Compatibility typedef
using QSettings = core::Settings;

#endif // CORE_SETTINGS_H
