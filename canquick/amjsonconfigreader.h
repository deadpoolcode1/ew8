#ifndef AMJSONCONFIGREADER_H
#define AMJSONCONFIGREADER_H

#include <QJsonDocument>

#include <QMutex>

#include <QMap>

class AMJsonConfigReader
{
public:

    static AMJsonConfigReader * getInstance(void);

    void readJsonDocument(QString arg);

    QJsonValue getJsonTopEntry(QString entryKey);

private:

    static QMutex instanceMutex;

    static AMJsonConfigReader * instance;

    QMap <QString,QJsonValue> jsonEntriesList;

    explicit AMJsonConfigReader(void);
};

#endif // AMJSONCONFIGREADER_H
