#ifndef APP_INIT_H
#define APP_INIT_H

#include <string>

struct AppConfig {
    bool testingMode = false;
    bool forceParsing = false;
    std::string mainQmlFileName;
};

AppConfig parseAppConfig(int argc, char* argv[]);
void initializeBackend(const AppConfig& config);
void postLaunchBackend(const AppConfig& config);

#endif // APP_INIT_H
