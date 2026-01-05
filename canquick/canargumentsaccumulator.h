#ifndef CANARGUMENTSACCUMULATOR_H
#define CANARGUMENTSACCUMULATOR_H

#include "defs.h"
#include "core/types.h"
#include <QObject>

class CanArgumentsAccumulator : public QObject
{
    Q_OBJECT
public:
    static CanArgumentsAccumulator * getExistingInstance(DISPLAY_ITEM_ID graphicItem);

    void growTriggeringSize(ssize_t index);

    virtual const char * getArgumentsTypeName() = 0;

    virtual void insertValueFromSignal(size_t anIndex, qint8 anArg) = 0;

protected:
    explicit CanArgumentsAccumulator(QObject *parent = nullptr);
    static QMap<DISPLAY_ITEM_ID,CanArgumentsAccumulator*> objectsMap;

    ssize_t maxIndex;

signals:

public slots:
};

#endif // CANARGUMENTSACCUMULATOR_H
