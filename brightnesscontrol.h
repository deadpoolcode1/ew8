#ifndef BRIGHTNESSCONTROL_H
#define BRIGHTNESSCONTROL_H

#include <QObject>
#include <QFile>
#include <QTimer>
#include <QMap>
#include <QFileSystemWatcher>
#include <QSettings>

class BrightnessControl : public QObject
{
    Q_OBJECT
public:
    explicit BrightnessControl(QObject *parent = nullptr);
    ~BrightnessControl();

signals:


public slots:
    void illuminanceMeasure(void);
    void assignBrightness(quint32 outputLevel, bool force = false);
    void assignMappings(void);
    void brightnessLevelChanged(qint32 newLevel);

private:
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
#if 0
    QFileSystemWatcher * settingsWatcher;
#endif
};

#endif // BRIGHTNESSCONTROL_H
