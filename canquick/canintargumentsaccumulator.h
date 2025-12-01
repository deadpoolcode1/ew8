#ifndef CANINTARGUMENTSACCUMULATOR_H
#define CANINTARGUMENTSACCUMULATOR_H

#include "canargumentsaccumulator.h"
#include "ismoother.h"

#include <QObject>

class CanArgumentsAccumulator;

class CanIntArgumentsAccumulator : public CanArgumentsAccumulator
{
    Q_OBJECT
public:


    static CanIntArgumentsAccumulator * getInstance(DISPLAY_ITEM_ID graphicItem);

    virtual const char * getArgumentsTypeName() {return argumentsTypeName;}

    void insertValueFromSignal(size_t anIndex, qint8 anArg);

    void addSmoothingAlgorithm(ISmoother * aSmoother);


private:
    static const char * argumentsTypeName;
    ISmoother * smoother;

     explicit CanIntArgumentsAccumulator(CanArgumentsAccumulator *parent = nullptr);

    quint8 intValue[3];
    bool flagValue[3];
    bool doArgSmoothing;

    //TODO replace with circular buffer
    quint32 speedSmoothingBufferLength;
    QList<quint8> smoothedArgBuffer;


signals:

    void argumentComplete(quint8 intValue, quint8 fracValue, quint8 unitValue);

public slots:
};

#endif // CANINTARGUMENTSACCUMULATOR_H
