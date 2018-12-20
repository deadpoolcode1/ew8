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
    static CanStringArgumentsAccumulator * getInstance(QString action);

    void growTriggeringSize(ssize_t index);

    void insertCharFromSignal(size_t anIndex, char aChar);

private:
    explicit CanStringArgumentsAccumulator(QObject *parent = nullptr);
    static QMap<QString,CanStringArgumentsAccumulator*> objectsMap;
    QMap<size_t,char> charactersMap;
    ssize_t maxIndex;

signals:

    void argumentComplete(QString result);

public slots:
};

#endif // CANSTRINGARGUMENTSACCUMULATOR_H
