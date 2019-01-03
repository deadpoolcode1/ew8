#ifndef CANSTRINGARGUMENTSACCUMULATOR_H
#define CANSTRINGARGUMENTSACCUMULATOR_H

#include "defs.h"
#include <QMap>
#include <QStringBuilder>
#include <QObject>
#include <QVector>

class CanStringArgumentsAccumulator : public QObject
{
    Q_OBJECT
public:
    static CanStringArgumentsAccumulator * getInstance(DISPLAY_ITEM_ID graphicItem);

    void growTriggeringSize(ssize_t index);

    void insertCharFromSignal(size_t anIndex, char aChar);

private:
    explicit CanStringArgumentsAccumulator(QObject *parent = nullptr);
    static QMap<DISPLAY_ITEM_ID,CanStringArgumentsAccumulator*> objectsMap;
    QMap<size_t,char> charactersMap;
    ssize_t maxIndex;

signals:

    void argumentComplete(QString result);

public slots:
};

#endif // CANSTRINGARGUMENTSACCUMULATOR_H
