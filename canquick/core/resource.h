#ifndef CORE_RESOURCE_H
#define CORE_RESOURCE_H

#include <string>
#include "file_utils.h"

// Simple resource handling to replace QResource
// Since we're transitioning away from Qt resources, this just checks if resource files exist
// and provides paths. For Qt-based builds, you can still use QResource if needed.

namespace core {

class Resource {
public:
    // Check if a resource file exists on the filesystem
    static bool exists(const std::string& path) {
        return FileInfo::exists(path);
    }

    // For compiled resources (.rcc files), this is a no-op
    // since we're using file system access instead
    // Returns true if the file exists (for compatibility)
    static bool registerResource(const std::string& rccPath) {
        // Just check if the rcc file exists - actual registration
        // would require Qt's QResource
        (void)rccPath;
        return false; // Always return false to force filesystem fallback
    }

    // Get the file system path for a resource
    static std::string filePath(const std::string& basePath, const std::string& resourceName) {
        return basePath + resourceName;
    }
};

} // namespace core

// Core-prefixed typedef (always available)
using CoreResource = core::Resource;

#endif // CORE_RESOURCE_H
