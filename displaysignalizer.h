#ifndef DISPLAYSIGNALIZER_H
#define DISPLAYSIGNALIZER_H

#include <QQuickItem>
#include "defs.h"

class DisplaySignalizer : public QQuickItem
{
    Q_OBJECT
public:
    DisplaySignalizer();

signals:
    void setVisibleSignal(QVariant valueInt, QVariant valueFrac, QVariant unit);
    void setInvisibleSignal(void);

public slots:
};

#endif // DISPLAYSIGNALIZER_H
