#ifndef CANINTARGUMENTSACCUMULATOR_H
#define CANINTARGUMENTSACCUMULATOR_H

#include <QObject>

class CanIntArgumentsAccumulator : public QObject
{
    Q_OBJECT
public:
    explicit CanIntArgumentsAccumulator(QObject *parent = nullptr);

signals:

public slots:
};

#endif // CANINTARGUMENTSACCUMULATOR_H