#include "app_init.h"
#include "core/cmdline_parser.h"
#include "core/types.h"
#include "amjsonconfigreader.h"
#include "canrxmsg.h"

AppConfig parseAppConfig(int argc, char* argv[])
{
    AppConfig config;

    core::CommandLineParser cmdLnParser;

    core::CommandLineOption forceParsing("f", "force-parsing", "Parsing config files, even cache is available");
    core::CommandLineOption testingConfig("t", "testing-mode", "Run the application with with testing mode configs");

    cmdLnParser.addOption(forceParsing);
    cmdLnParser.addOption(testingConfig);

    cmdLnParser.process(argc, argv);

    config.testingMode = cmdLnParser.isSet(testingConfig);
    config.forceParsing = config.testingMode || cmdLnParser.isSet(forceParsing);

    if (config.testingMode)
    {
        config.mainQmlFileName = "tests.qml";
    }
    else
    {
        config.mainQmlFileName = "main.qml";
    }

    return config;
}

void initializeBackend(const AppConfig& config)
{
    if (config.testingMode)
    {
        AMJsonConfigReader::getInstance()->readJsonDocument("signals/ME_Test_Signals.json");
    }
    else
    {
        AMJsonConfigReader::getInstance()->readJsonDocument("signals/EW8_Signals.json");
    }

    if (config.forceParsing)
    {
        CanRxMsg::forceDBCParsing();
    }
}

void postLaunchBackend(const AppConfig& config)
{
    if (!config.testingMode)
    {
        CanRxMsg::saveToStorage();
    }
}
