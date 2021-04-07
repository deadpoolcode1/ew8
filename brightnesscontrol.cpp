#include "brightnesscontrol.h"

#include <QFileSystemWatcher>
#include <QDebug>
#include <QTimer>
#include "amjsonconfigreader.h"
#include <QJsonValue>
#include <QJsonObject>
#include <QJsonArray>
#include <QSettings>

//Static methods and variables
bool BrightnessControl::doCANDebugReport = false;

void BrightnessControl::setCANDebugReport(bool doReport)
{
    doCANDebugReport = doReport;
};
//end of static methods and variables

BrightnessControl::BrightnessControl(QObject *parent) : QObject(parent)
{
    itsCanManager = nullptr;

    assignMappings();

    QSettings settings;

    currentMenuLevel = settings.value("Brightness/brightness",QVariant(5)).toInt();

    qDebug() << "Selected Brightness Level:" << currentMenuLevel;

#if 0
    settingsWatcher = new QFileSystemWatcher(parent);

    qDebug()<<"Watch the Settings file:"<< settings.fileName();

    settingsWatcher->addPath(settings.fileName());

    connect (settingsWatcher, SIGNAL(fileChanged(QString)),this, SLOT(settingsChanged(void)));
#endif

    triggerTimer = new QTimer(this);
    triggerTimer->setSingleShot(false);
    triggerTimer->setInterval(1000);

    connect(triggerTimer, SIGNAL(timeout()), this, SLOT(fireIlluminanceMeasure()));

    currentOutput = 0;
#ifndef WIN32
    measureFile = new QFile(measureFileName);
    measureFile->open(QFile::ReadOnly | QFile::Text);
    outputFile = new QFile(outputFileName);
    outputFile->open(QFile::ReadWrite | QFile::Text);
    currentOutput = QString(outputFile->readLine()).toInt();
    qDebug() << "Inititial current output: " << currentOutput;
#endif

    currentMenuLevelOutputs = outputLevels.value(currentMenuLevel,nullptr);
    qDebug() << "Current Menu level outputs:" << currentMenuLevelOutputs[0] << ","<< currentMenuLevelOutputs[1] << "," << currentMenuLevelOutputs[2]
             << "," << currentMenuLevelOutputs[3] << "," << currentMenuLevelOutputs[4]  << "...";




    triggerTimer->start();
}

void BrightnessControl::setCanManager(CanManager *aCanManager)
{
    itsCanManager = aCanManager;
}

void BrightnessControl::assignMappings(void)
{
    QJsonValue illum = AMJsonConfigReader::getInstance()->getJsonTopEntry("Illuminance");
    QJsonValue bright = AMJsonConfigReader::getInstance()->getJsonTopEntry("Brightness");

    QJsonObject illum_jobj = illum.toObject();
    QJsonObject bright_jobj = bright.toObject();

    //Illuminance:
    measureFileName = illum_jobj["measure"].toString();
    QString scaleFileName = illum_jobj["scale"].toString();
    QJsonArray jarr_points = illum_jobj["points"].toArray();

    if(measureFileName.isEmpty())
    {
        measureFileName = "/sys/bus/iio/devices/iio:device0/in_voltage0_raw";
    }

    if(scaleFileName.isEmpty())
    {
        scaleFileName = "/sys/bus/iio/devices/iio:device0/in_voltage_scale";
    }

    #ifndef WIN32
    QFile scaleFile(scaleFileName);
    scaleFile.open(QFile::ReadOnly | QFile::Text);
    scale = QString(scaleFile.readLine()).toDouble();
    scaleFile.close();
    #else
    scale = 0.2014;
    #endif


    lowerPointsSize =  jarr_points.count();

    lowerPoints = new qint32[lowerPointsSize];

    quint32 pointscounter = 0;

    foreach (const QJsonValue & val, jarr_points)
    {
        lowerPoints[pointscounter++] = val.toInt() / scale;
    }


    qDebug() << "PointsArray" << lowerPoints;



    //Brightness:
    QJsonArray brightnessMap_jarr = bright_jobj["map"].toArray();

    outputFileName = bright_jobj["output"].toString();


    if(outputFileName.isEmpty())
    {
        outputFileName = "/sys/class/backlight/backlight/brightness";
    }



    foreach (const QJsonValue & val, brightnessMap_jarr)
    {

        qint32 menuEntry = val.toObject()["menu"].toInt();

        QJsonArray entryOutputs_jarr = val.toObject()["outputs"].toArray();
        qint32 entryOutputsSize =  entryOutputs_jarr.count();

        qint32 * entryOutputs = new qint32[entryOutputsSize];

        quint32 entrycounter = 0;

        foreach (const QJsonValue & val, entryOutputs_jarr)
        {
            entryOutputs[entrycounter++] = val.toInt();
        }

        if(entryOutputsSize != lowerPointsSize+1)
        {
            qDebug()<<"Brightness menu entry " << menuEntry << ": Outputs array size is not valid";
        }
        else
        {
            qDebug() << "Menu entry: " << menuEntry << "outputs: " << entryOutputs[0] << ","<< entryOutputs[1] << "," << entryOutputs[2]
                     << "," << entryOutputs[3] << "," << entryOutputs[4]  << "...";
            outputLevels.insert(menuEntry, entryOutputs);
        }
    }

}



BrightnessControl::~BrightnessControl()
{
    #ifndef WIN32
    measureFile->close();
    outputFile->close();
    delete measureFile;
    delete outputFile;
    #endif
}

void BrightnessControl::brightnessLevelChanged(qint32 newLevel)
{
   //TODO select the new outputs level and force illuminanceMeasure+assignBrightness(WARNING: The hand can be over the sensor)
    qDebug()<< "Brightness control: level change notify received!" ;
    currentMenuLevel = newLevel;
    currentMenuLevelOutputs = outputLevels.value(currentMenuLevel,nullptr);
    //Threadsafe: in slots executed in the same event loop
    assignBrightness(measureIlluminanceLevel(), true);
    qDebug() << "Current Menu level outputs:" << currentMenuLevelOutputs[0] << ","<< currentMenuLevelOutputs[1] << "," << currentMenuLevelOutputs[2]
             << "," << currentMenuLevelOutputs[3] << "," << currentMenuLevelOutputs[4]  << "...";
}

qint32 BrightnessControl::measureIlluminanceLevel(void)
{
    qint32 illuminanceLevel = lowerPointsSize;
#ifndef WIN32
    measureFile->seek(0);
    qint32 currMeasure =  QString(measureFile->readLine()).toInt();
    illuminance_measure_mV = (quint32)qRound(currMeasure*scale);
    qDebug()<< "Illuminance ADC (mV): " << currMeasure*scale;



    for (qint32 i = 0; i < lowerPointsSize ; i ++)
    {
        if(currMeasure < lowerPoints[i])
        {
            illuminanceLevel = i;
            i = lowerPointsSize;
        }
    }

    qDebug()<< "illuminaceLevel: " << illuminanceLevel;
#endif
    return illuminanceLevel;
}


void BrightnessControl::fireIlluminanceMeasure(void)
{
#ifndef WIN32
    qint32 illuminanceLevel = measureIlluminanceLevel();
    assignBrightness(illuminanceLevel);
#endif
}

void BrightnessControl::assignBrightness(quint32 outputLevel, bool forceBrightness)
{
    qint32 targetOutput;
    if (nullptr != currentMenuLevelOutputs)
    {
        targetOutput = currentMenuLevelOutputs[outputLevel];

        if(targetOutput < currentOutput)
        {
            if(forceBrightness)
            {
                currentOutput = targetOutput;
            }
            else
            {
                currentOutput--;
            }
            outputFile->write((QString::number(currentOutput)+"\n").toLocal8Bit());
            outputFile->flush();
        }
        else if(targetOutput > currentOutput)
        {
            if(forceBrightness)
            {
                currentOutput = targetOutput;
            }
            else
            {
            currentOutput++;
            }

            outputFile->write((QString::number(currentOutput)+"\n").toLocal8Bit());
            outputFile->flush();
        }


        qDebug() << "Brightness output - current:" << currentOutput << " target:" << targetOutput;

        if(doCANDebugReport)
        {
            struct can_frame debugFrame;
            debugFrame.can_id = 0x7b0;
            debugFrame.can_dlc = 8;
            //Actual brightness
            debugFrame.data[0] =  (quint8)(illuminance_measure_mV & 0xff);
            debugFrame.data[1] =  (quint8)((illuminance_measure_mV & 0x1f00) >> 010);
            //Menu Level selected:
            debugFrame.data[1] = debugFrame.data[1] | (quint8)((currentMenuLevel & 0x7) << 5);
            //Output brightness
            debugFrame.data[2] = (quint8)(currentOutput & 0x3f);
            debugFrame.data[2] = debugFrame.data[2] | 0x80; //brighness debug reported indicator
            itsCanManager->write_frame(&debugFrame);
        }
    }


}
