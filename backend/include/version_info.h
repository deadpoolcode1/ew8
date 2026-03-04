#ifndef VERSION_INFO_H
#define VERSION_INFO_H

#include <string>

struct VersionInfo {
    std::string engine;
    std::string config;
};

VersionInfo buildVersionInfo();

#endif // VERSION_INFO_H
