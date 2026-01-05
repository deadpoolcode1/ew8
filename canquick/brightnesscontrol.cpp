#include "brightnesscontrol.h"

// Use core library instead of Qt
#include "core/core.h"
#include "core/file_watcher.h"
#include "core/logger.h"
#include "core/timer.h"
#include "core/json.h"
#include "core/settings.h"

// When Qt is present, include QDebug for coreDebug() macro
#ifdef QT_CORE_LIB
#include <QDebug>
#endif

#include "amjsonconfigreader.h"
#include "candebugreport.h"

#include <sstream>
#include <cmath>

//Static methods and variables

class CANDebugReport;

bool BrightnessControl::doCANDebugReport = false;

void BrightnessControl::setCANDebugReport(bool doReport)
{
    doCANDebugReport = doReport;
};
//end of static methods and variables

BrightnessControl::BrightnessControl()
{
    itsAlertDisplay =  nullptr;

    assignMappings();

    core::Settings settings;

    currentMenuLevel = settings.valueInt("Brightness/brightness", 5);

    coreDebug() << "Selected Brightness Level:" << currentMenuLevel;

#if 0
    settingsWatcher = new core::FileSystemWatcher();

    coreDebug() << "Watch the Settings file:" << settings.fileName();

    settingsWatcher->addPath(settings.fileName());

    settingsWatcher->fileChanged.connect([this](const std::string&) {
        // settingsChanged() handler
    });
#endif

    triggerTimer = new core::Timer();
    triggerTimer->setSingleShot(false);
    triggerTimer->setInterval(1000);

    triggerTimer->timeout.connect([this]() {
        fireIlluminanceMeasure();
    });

    currentOutput = 0;
#ifndef WIN32
    measureFile = new core::File(measureFileName);
    measureFile->open(core::File::ReadOnly);
    outputFile = new core::File(outputFileName);
    outputFile->open(core::File::ReadWrite);
    std::string line = outputFile->readLine();
    currentOutput = line.empty() ? 0 : std::stoi(line);
    coreDebug() << "Initial current output: " << currentOutput;
#endif

    auto it = outputLevels.find(currentMenuLevel);
    currentMenuLevelOutputs = (it != outputLevels.end()) ? it->second : nullptr;
    if (currentMenuLevelOutputs) {
        coreDebug() << "Current Menu level outputs:" << currentMenuLevelOutputs[0] << ","<< currentMenuLevelOutputs[1] << "," << currentMenuLevelOutputs[2]
                 << "," << currentMenuLevelOutputs[3] << "," << currentMenuLevelOutputs[4]  << "...";
    }

    triggerTimer->start();
}

void BrightnessControl::setItsDisplay(IAlertDisplay * aDisplay)
{
    itsAlertDisplay = aDisplay;
}

void BrightnessControl::assignMappings(void)
{
    core::JsonValue illum = AMJsonConfigReader::getInstance()->getJsonTopEntry("Illuminance");
    core::JsonValue bright = AMJsonConfigReader::getInstance()->getJsonTopEntry("Brightness");

    core::JsonObject illum_jobj = illum.toObject();
    core::JsonObject bright_jobj = bright.toObject();

    //Illuminance:
    measureFileName = illum_jobj["measure"].toString();
    std::string scaleFileName = illum_jobj["scale"].toString();
    core::JsonArray jarr_points = illum_jobj["points"].toArray();

    if(measureFileName.empty())
    {
        measureFileName = "/sys/bus/iio/devices/iio:device0/in_voltage0_raw";
    }

    if(scaleFileName.empty())
    {
        scaleFileName = "/sys/bus/iio/devices/iio:device0/in_voltage_scale";
    }

    #ifndef WIN32
    core::File scaleFile(scaleFileName);
    scaleFile.open(core::File::ReadOnly);
    std::string scaleLine = scaleFile.readLine();
    scale = scaleLine.empty() ? 0.2014 : std::stod(scaleLine);
    scaleFile.close();
    #else
    scale = 0.2014;
    #endif


    lowerPointsSize = jarr_points.size();

    lowerPoints = new qint32[lowerPointsSize];

    quint32 pointscounter = 0;

    for (const auto& val : jarr_points)
    {
        lowerPoints[pointscounter++] = val.toInt() / scale;
    }


    coreDebug() << "PointsArray" << lowerPoints;



    //Brightness:
    core::JsonArray brightnessMap_jarr = bright_jobj["map"].toArray();

    outputFileName = bright_jobj["output"].toString();


    if(outputFileName.empty())
    {
        outputFileName = "/sys/class/backlight/backlight/brightness";
    }



    for (const auto& val : brightnessMap_jarr)
    {

        qint32 menuEntry = val.toObject()["menu"].toInt();

        core::JsonArray entryOutputs_jarr = val.toObject()["outputs"].toArray();
        qint32 entryOutputsSize = entryOutputs_jarr.size();

        qint32 * entryOutputs = new qint32[entryOutputsSize];

        quint32 entrycounter = 0;

        for (const auto& outVal : entryOutputs_jarr)
        {
            entryOutputs[entrycounter++] = outVal.toInt();
        }

        if(entryOutputsSize != lowerPointsSize+1)
        {
            coreDebug() << "Brightness menu entry " << menuEntry << ": Outputs array size is not valid";
        }
        else
        {
            coreDebug() << "Menu entry: " << menuEntry << "outputs: " << entryOutputs[0] << ","<< entryOutputs[1] << "," << entryOutputs[2]
                     << "," << entryOutputs[3] << "," << entryOutputs[4]  << "...";
            outputLevels.insert({menuEntry, entryOutputs});
        }
    }

}



BrightnessControl::~BrightnessControl()
{
    #ifndef WIN32
    if (measureFile) {
        measureFile->close();
        delete measureFile;
    }
    if (outputFile) {
        outputFile->close();
        delete outputFile;
    }
    #endif
    if (triggerTimer) {
        triggerTimer->stop();
        delete triggerTimer;
    }
}

void BrightnessControl::brightnessLevelChanged(qint32 newLevel)
{
   //TODO select the new outputs level and force illuminanceMeasure+assignBrightness(WARNING: The hand can be over the sensor)
    coreDebug() << "Brightness control: level change notify received!" ;
    currentMenuLevel = newLevel;
    auto it = outputLevels.find(currentMenuLevel);
    currentMenuLevelOutputs = (it != outputLevels.end()) ? it->second : nullptr;
    //Threadsafe: in slots executed in the same event loop
    assignBrightness(measureIlluminanceLevel(), true);
    if (currentMenuLevelOutputs) {
        coreDebug() << "Current Menu level outputs:" << currentMenuLevelOutputs[0] << ","<< currentMenuLevelOutputs[1] << "," << currentMenuLevelOutputs[2]
                 << "," << currentMenuLevelOutputs[3] << "," << currentMenuLevelOutputs[4]  << "...";
    }
}

qint32 BrightnessControl::measureIlluminanceLevel(void)
{
    qint32 illuminanceLevel = lowerPointsSize;
#ifndef WIN32
    measureFile->seek(0);
    std::string line = measureFile->readLine();
    qint32 currMeasure = line.empty() ? 0 : std::stoi(line);
    illuminance_measure_mV = (quint32)std::round(currMeasure*scale);
    coreDebug() << "Illuminance ADC (mV): " << currMeasure*scale;



    for (qint32 i = 0; i < lowerPointsSize ; i ++)
    {
        if(currMeasure < lowerPoints[i])
        {
            illuminanceLevel = i;
            i = lowerPointsSize;
        }
    }

    coreDebug() << "illuminaceLevel: " << illuminanceLevel;
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

#ifndef WIN32
            std::string outStr = std::to_string(currentOutput) + "\n";
            outputFile->write(outStr);
            // flush by close/reopen or use direct write
#endif
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

#ifndef WIN32
            std::string outStr = std::to_string(currentOutput) + "\n";
            outputFile->write(outStr);
#endif
        }


        coreDebug() << "Brightness output - current:" << currentOutput << " target:" << targetOutput;

        if(doCANDebugReport)
        {
            sendBrightness.fire(illuminance_measure_mV, currentMenuLevel, currentOutput);
        }

        if (nullptr != itsAlertDisplay)
        {
            std::ostringstream oss;
            oss << "ill:" << illuminance_measure_mV << "  brt:" << currentOutput;
            itsAlertDisplay->message(oss.str());
        }
    }


}
