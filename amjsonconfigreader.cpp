#include "amjsonconfigreader.h"

// Use core library instead of Qt
#include "core/json.h"
#include "core/file_utils.h"
#include "core/logger.h"

#include <string>
#include <map>

AMJsonConfigReader * AMJsonConfigReader::instance = nullptr;
core::Mutex AMJsonConfigReader::instanceMutex;

core::JsonValue AMJsonConfigReader::getJsonTopEntry(const std::string& entryKey)
{
   core::JsonValue ret;
   auto it = jsonEntriesList.find(entryKey);
   if(it != jsonEntriesList.end())
   {
       ret = it->second;
   }
   return ret;
}


AMJsonConfigReader * AMJsonConfigReader::getInstance(void)
{
    if(nullptr == instance){
        instanceMutex.lock();
        if(nullptr == instance)
        {
            instance = new AMJsonConfigReader();
        }
        instanceMutex.unlock();
    }

    return instance;
}

AMJsonConfigReader::AMJsonConfigReader(void)
{
    readJsonDocument("configs/EW8_Config.json");
}

void AMJsonConfigReader::readJsonDocument(const std::string& arg)
{
    core::JsonDocument jdoc;

    std::string filePath = std::string(BASE_TARGET_DIR) + arg;
    core::File jsonFile(filePath);

    if(jsonFile.exists())
    {
        coreDebug() << "JSON file exists";
        if(jsonFile.open(core::File::ReadOnly))
        {
            //TODO evaluate json consistency

            core::JsonParseError errStatus;

            std::string fileContent = jsonFile.readAll();
            jdoc = core::JsonDocument::fromJson(fileContent, &errStatus);

            if(core::JsonParseError::NoError != errStatus.error())
            {
                coreDebug() << "Json reader reading file:" << arg << " Error status:" << errStatus.errorString();
            }

            jsonFile.close();

            //End of file usage

        }

    }
    else
    {
        coreDebug() << "signals JSON scheme file read failed.";
        //TODO use some default scheme
        //TODO Error Alert
     }

    core::JsonObject jobj = jdoc.object();

    for (auto it = jobj.constBegin(); it != jobj.constEnd(); ++it)
    {
        jsonEntriesList.insert({it->first, it->second});
    }
}
