#ifndef BRIGHTNESSCONTROL_H
#define BRIGHTNESSCONTROL_H

// Use core library instead of Qt
#include "core/core.h"
#include "core/file_utils.h"
#include "core/timer.h"
#include "core/signal.h"
#include "core/settings.h"

#include <string>
#include <map>

#include "canmanager.h"

class CanManager;

class BrightnessControl
{
public:
    explicit BrightnessControl();
    ~BrightnessControl();

     static void setCANDebugReport(bool doReport);

     void setItsDisplay(IAlertDisplay * aDisplay);

    // Signal replacement for Qt signal
    core::Signal<quint32, qint32, qint32> sendBrightness;

    // Slot replacements - now just regular methods
    void fireIlluminanceMeasure(void);
    void brightnessLevelChanged(qint32 newLevel);

private:

    void assignMappings(void);
    void assignBrightness(quint32 outputLevel, bool forceBrightness = false);
    qint32 measureIlluminanceLevel(void);



    core::Timer * triggerTimer;
    core::File * measureFile;
    std::string measureFileName;
    core::File * outputFile;
    std::string outputFileName;
    qint32 currentOutput;
    qint32 currentMenuLevel;
    double scale;

    qint32 * lowerPoints;
    qint32 lowerPointsSize;
    //CONTAINS: menuLevel,Size,PtrToValuesArray
    std::map<qint32, qint32 *> outputLevels;
    qint32 * currentMenuLevelOutputs;
    static bool doCANDebugReport;
    quint32 illuminance_measure_mV;
    IAlertDisplay * itsAlertDisplay;

#if 0
    core::FileSystemWatcher * settingsWatcher;
#endif
};

#endif // BRIGHTNESSCONTROL_H
