#ifndef ALERTTYPES_H
#define ALERTTYPES_H

#include <QtGlobal>

#include <QObject>

#include <QQmlEngine>

class AlertTypes : public QObject
{

    Q_OBJECT

public:
    explicit AlertTypes(QObject *parent = nullptr): QObject(parent){}

#if 0
    //WARNING used in ticks protocol 
    enum EnHMW
    {
        HMW_01 = 0x0,
        HMW_02 = 0x1,
        HMW_03 = 0x2,
        HMW_04 = 0x3,
        HMW_05 = 0x4,
        HMW_06 = 0x5,
        HMW_07 = 0x6,
        HMW_08 = 0x7,
        HMW_09 = 0x8,
        HMW_10 = 0x9,
        HMW_12 = 0xA,
        HMW_14 = 0xB,
        HMW_16 = 0xC,
        HMW_18 = 0xD,
        HMW_20 = 0xE,
        HMW_25 = 0xF,
        HMW_GR = 0x10,
    };
    Q_ENUMS(EnHMW)
#endif

    enum EnSliRegular
    {
        SLI_10 =  0x0,
        SLI_20 =  0x1,
        SLI_30 =  0x2,
        SLI_40 =  0x3,
        SLI_50 =  0x4,
        SLI_60 =  0x5,
        SLI_70 =  0x6,
        SLI_80 =  0x7,
        SLI_90 =  0x8,
        SLI_100 = 0x9,
        SLI_110 = 0xA,
        SLI_120 = 0xB,
        SLI_130 = 0xC,
        SLI_140 = 0xD,
    };
    Q_ENUMS(EnSliRegular)



    enum EnAlert
    {
        QtQG = 0,  // group


        //Alert Items:
        ALERT_NONE = 1,
        ALERT_PDZ = 2,
        ALERT_PCW = 3,
        ALERT_HMW_ALERT = 4,
        ALERT_HMW_MONITOR = 5,
        ALERT_HI_BEAM = 6,
        ALERT_LOW_BEAM = 7,
        ALERT_SLI = 8,
        ALERT_FORWARD = 9,
        ALERT_MOTORWAY = 10,
        ALERT_PLAYGROUND = 11,
        ALERT_END_ALL_RESTR = 12,
        ALERT_NO_PASS = 13,

        //Smart Items:
        SMART_BASE   = 14,
        SMART_ANIMAL = SMART_BASE + 1,
        SMART_SEV_WEATHER = SMART_BASE + 2,
        SMART_SLIPPERY = SMART_BASE + 3,

        //Special Item:
         ALERT_END_OF_TYPE,
    };
    Q_ENUMS(EnAlert)


    // Do not forget to declare your class to the QML system.

    static void declareQML() {
                qmlRegisterType<AlertTypes>("MyQMLenums",0, 1, "Alert");
            }

signals:

public slots:
};

#endif // ALERTTYPES_H
