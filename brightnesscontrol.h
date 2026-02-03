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
    core::Signal<uint32_t, int32_t, int32_t> sendBrightness;

    // Slot replacements - now just regular methods
    void fireIlluminanceMeasure(void);
    void brightnessLevelChanged(int32_t newLevel);

private:

    void assignMappings(void);
    void assignBrightness(uint32_t outputLevel, bool forceBrightness = false);
    int32_t measureIlluminanceLevel(void);



    core::Timer * triggerTimer;
    core::File * measureFile;
    std::string measureFileName;
    core::File * outputFile;
    std::string outputFileName;
    int32_t currentOutput;
    int32_t currentMenuLevel;
    double scale;

    int32_t * lowerPoints;
    int32_t lowerPointsSize;
    //CONTAINS: menuLevel,Size,PtrToValuesArray
    std::map<int32_t, int32_t *> outputLevels;
    int32_t * currentMenuLevelOutputs;
    static bool doCANDebugReport;
    uint32_t illuminance_measure_mV;
    IAlertDisplay * itsAlertDisplay;

#if 0
    core::FileSystemWatcher * settingsWatcher;
#endif
};

#endif // BRIGHTNESSCONTROL_H
