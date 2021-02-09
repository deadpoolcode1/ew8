#include "amjsonconfigreader.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>

#include <QFile>
#include <QMap>
#include <QString>

AMJsonConfigReader * AMJsonConfigReader::instance = nullptr;
QMutex AMJsonConfigReader::instanceMutex;

QJsonValue AMJsonConfigReader::getJsonTopEntry(QString entryKey)
{
   QJsonValue ret;
   if(jsonEntriesList.contains(entryKey))
   {
       ret = jsonEntriesList.value(entryKey);
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
    readJsonDocument("signals/EW8_Signals.json");
    readJsonDocument("configs/EW8_Brightness.json");
}

void AMJsonConfigReader::readJsonDocument(QString arg)
{

    QJsonDocument jdoc;

    QFile jsonFile(QStringLiteral(BASE_TARGET_DIR)+arg);

    if(jsonFile.exists())
    {
        qDebug ("JSON file exists");
        if(jsonFile.open(QIODevice::ReadOnly))
        {
            //TODO evaluate json cosnsistency

            QJsonParseError errStatus;

            jdoc = QJsonDocument::fromJson(jsonFile.readAll(), &errStatus);

            if(QJsonParseError::NoError != errStatus.error)
            {
                qDebug() << "Json reader reading file:" << arg << " Error status:"<< errStatus.errorString();
            }

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

    QJsonObject jobj = jdoc.object();

    for (QJsonObject::const_iterator it = jobj.constBegin() ; it !=  jobj.constEnd(); it++)
    {
        jsonEntriesList.insert(it.key(),it.value());
    }
}
