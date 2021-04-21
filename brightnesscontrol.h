#ifndef BRIGHTNESSCONTROL_H
#define BRIGHTNESSCONTROL_H

#include <QObject>
#include <QFile>
#include <QTimer>
#include <QMap>
#include <QFileSystemWatcher>
#include <QSettings>
#include "canmanager.h"

class CanManager;

class BrightnessControl : public QObject
{
    Q_OBJECT
public:
    explicit BrightnessControl(QObject *parent = nullptr);
    ~BrightnessControl();

     static void setCANDebugReport(bool doReport);

signals:

   void sendBrightness(quint32 illuminance_measure_mV, qint32 currentMenuLevel, qint32 currentOutput);

public slots:
    void fireIlluminanceMeasure(void);
    void brightnessLevelChanged(qint32 newLevel);

private:

    void assignMappings(void);
    void assignBrightness(quint32 outputLevel, bool forceBrightness = false);
    qint32 measureIlluminanceLevel(void);



    QTimer * triggerTimer;
    QFile * measureFile;
    QString measureFileName;
    QFile * outputFile;
    QString outputFileName;
    qint32 currentOutput;
    qint32 currentMenuLevel;
    double scale;

    qint32 * lowerPoints;
    qint32 lowerPointsSize;
    //COONTAINS: menuLevel,Size,PtrToValuesArray
    QMap<qint32, qint32 *> outputLevels;
    qint32 * currentMenuLevelOutputs;
    static bool doCANDebugReport;
    quint32 illuminance_measure_mV;

#if 0
    QFileSystemWatcher * settingsWatcher;
#endif
};

#endif // BRIGHTNESSCONTROL_H
