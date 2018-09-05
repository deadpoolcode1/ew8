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
        SLI_REG_10 =  0x0,
        SLI_REG_20 =  0x1,
        SLI_REG_30 =  0x2,
        SLI_REG_40 =  0x3,
        SLI_REG_50 =  0x4,
        SLI_REG_60 =  0x5,
        SLI_REG_70 =  0x6,
        SLI_REG_80 =  0x7,
        SLI_REG_90 =  0x8,
        SLI_REG_100 = 0x9,
        SLI_REG_110 = 0xA,
        SLI_REG_120 = 0xB,
        SLI_REG_130 = 0xC,
        SLI_REG_140 = 0xD,
    };
    Q_ENUMS(EnSliRegular)



    enum EnAlert
    {
        QtQG = 0,  // group
        ALERT_NONE = 1,
        ALERT_FCW = 2,
        ALERT_PDZ = 3,
        ALERT_PCW = 4,
        ALERT_LDWOFF = 5,
        ALERT_LDWON = 6,
        ALERT_LLDW = 7,
        ALERT_RLDW = 8,
        ALERT_HMW_ALERT = 9,
        ALERT_HMW_MONITOR = 10,
        ALERT_HI_BEAM = 11,
        ALERT_LOW_BEAM = 12,
        ALERT_BLINKERS = 13,
        ALERT_SLI_REGULAR = 14,
        ALERT_FORWARD = 15,
        ALERT_END_OF_TYPE = 16,
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
