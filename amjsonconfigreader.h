#ifndef AMJSONCONFIGREADER_H
#define AMJSONCONFIGREADER_H

#include <QJsonDocument>

#include <QMutex>

#include <QMap>

class AMJsonConfigReader
{
public:

    static AMJsonConfigReader * getInstance(void);

    QJsonValue getJsonTopEntry(QString entryKey);

private:

    static QMutex instanceMutex;

    void readJsonDocument(QString arg);

    static AMJsonConfigReader * instance;

    QMap <QString,QJsonValue> jsonEntriesList;

    explicit AMJsonConfigReader(void);
};

#endif // AMJSONCONFIGREADER_H
