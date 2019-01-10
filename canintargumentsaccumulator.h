#ifndef CANINTARGUMENTSACCUMULATOR_H
#define CANINTARGUMENTSACCUMULATOR_H

#include "canargumentsaccumulator.h"

#include <QObject>

class CanArgumentsAccumulator;

class CanIntArgumentsAccumulator : public CanArgumentsAccumulator
{
    Q_OBJECT
public:


    static CanIntArgumentsAccumulator * getInstance(DISPLAY_ITEM_ID graphicItem);

    virtual const char * getArgumentsTypeName() {return argumentsTypeName;}

    void insertValueFromSignal(size_t anIndex, qint8 anArg);


private:
    static const char * argumentsTypeName;

     explicit CanIntArgumentsAccumulator(CanArgumentsAccumulator *parent = nullptr);

    quint8 intValue[3];
    bool flagValue[3];

signals:

    void argumentComplete(quint8 intValue, quint8 fracValue, quint8 unitValue);

public slots:
};

#endif // CANINTARGUMENTSACCUMULATOR_H
