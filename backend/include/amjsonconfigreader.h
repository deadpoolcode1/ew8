#ifndef AMJSONCONFIGREADER_H
#define AMJSONCONFIGREADER_H

// Use core library instead of Qt
#include "core/json.h"
#include "core/mutex.h"
#include "core/types.h"

#include <string>
#include <map>

class AMJsonConfigReader
{
public:

    static AMJsonConfigReader * getInstance(void);

    void readJsonDocument(const std::string& arg);

    core::JsonValue getJsonTopEntry(const std::string& entryKey);

private:

    static core::Mutex instanceMutex;

    static AMJsonConfigReader * instance;

    std::map<std::string, core::JsonValue> jsonEntriesList;

    explicit AMJsonConfigReader(void);
};

#endif // AMJSONCONFIGREADER_H
