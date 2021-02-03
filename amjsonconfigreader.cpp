#include "amjsonconfigreader.h"

#include <QJsonDocument>

#include <QFile>

#include <QString>

AMJsonConfigReader * AMJsonConfigReader::instance = nullptr;

QMutex AMJsonConfigReader::instanceMutex;

AMJsonConfigReader * AMJsonConfigReader::getInstance(void)
{
    if(nullptr == instance){
        instanceMutex.lock();
        if(nullptr == instance)
        {
            instance = new AMJsonConfigReader(readJsonDocument());

        }
        instanceMutex.unlock();
    }

    return instance;
}

AMJsonConfigReader::AMJsonConfigReader(QJsonDocument parent): QJsonDocument(parent)
{


}

QJsonDocument AMJsonConfigReader::readJsonDocument(void)
{

    QJsonDocument ret;

    QFile jsonFile(QStringLiteral(BASE_TARGET_DIR)+QStringLiteral("signals/EW8_Signals.json"));

    if(jsonFile.exists())
    {
        qDebug ("JSON file exists");
        if(jsonFile.open(QIODevice::ReadOnly))
        {
            qDebug("signals JSON scheme  successfully found and open.");

            //TODO: evaluate json consistency


            ret = fromJson(jsonFile.readAll());

            jsonFile.close();

            //End of file usage

        }

    }
    else
    {
        qDebug("signals JSON scheme file read failed.");
        //TODO use some default scheme
        //TODO Error Alert
    }

    return ret;
}
