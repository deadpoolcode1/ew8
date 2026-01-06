#ifndef CANSTRINGARGUMENTSACCUMULATOR_H
#define CANSTRINGARGUMENTSACCUMULATOR_H

#include "defs.h"
#include "core/types.h"
#include <QObject>

#include "canargumentsaccumulator.h"

class CanArgumentsAccumulator;

class CanStringArgumentsAccumulator : public CanArgumentsAccumulator
{
    Q_OBJECT
public:
    static CanStringArgumentsAccumulator * getInstance(DISPLAY_ITEM_ID graphicItem);

    void insertValueFromSignal(size_t anIndex, int8_t aChar);

    virtual const char * getArgumentsTypeName() {return argumentsTypeName;}


private:
    static const char * argumentsTypeName;

    explicit CanStringArgumentsAccumulator(CanArgumentsAccumulator *parent = nullptr);

    core::QMap<size_t,char> charactersMap;

signals:

    void argumentComplete(core::QString result);

public slots:
};

#endif // CANSTRINGARGUMENTSACCUMULATOR_H
