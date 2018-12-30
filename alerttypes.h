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
        ALERT_SLI = 2,
        ALERT_FORWARD = 3,
        ALERT_MOTORWAY = 4,
        ALERT_PLAYGROUND = 5,
        ALERT_END_ALL_RESTR = 6,
        ALERT_NO_PASS = 7,

        //Smart Items:
        SMART_BASE   = 8,
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
