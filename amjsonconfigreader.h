#ifndef AMJSONCONFIGREADER_H
#define AMJSONCONFIGREADER_H

#include <QJsonDocument>

#include <QMutex>

class AMJsonConfigReader: public QJsonDocument
{
public:

    static AMJsonConfigReader * getInstance(void);

private:

    static QMutex instanceMutex;

    static QJsonDocument readJsonDocument(void);

    static AMJsonConfigReader * instance;

    explicit AMJsonConfigReader(QJsonDocument parent);
};

#endif // AMJSONCONFIGREADER_H
