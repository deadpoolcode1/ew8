#include "version_info.h"
#include "amjsonconfigreader.h"
#include "core/json.h"

VersionInfo buildVersionInfo()
{
    VersionInfo info;

    // Engine version
    info.engine = std::to_string(MAJOR_VERSION) + "." + std::to_string(MINOR_VERSION) + "." + std::to_string(OTA_TEST_VERSION);

    // Config version
    core::JsonArray jsonArray = AMJsonConfigReader::getInstance()->getJsonTopEntry("ConfigVersion").toArray();
    if (!jsonArray.isEmpty())
    {
        info.config = std::to_string(jsonArray.at(0).toInt(0xff)) + "." + std::to_string(jsonArray.at(1).toInt(0x3f)) + "." + std::to_string((jsonArray.at(2).toInt(0x3)) & 0x3);
    }

    return info;
}
