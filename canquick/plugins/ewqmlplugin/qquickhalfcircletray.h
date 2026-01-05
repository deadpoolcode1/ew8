#ifndef QQUICKHALFCIRCLETRAY_H
#define QQUICKHALFCIRCLETRAY_H

#include <QQuickItem>
#include "../../core/types.h"

class QQuickHalfCircleTray : public QQuickItem
{
    Q_OBJECT
    Q_DISABLE_COPY(QQuickHalfCircleTray)
    Q_PROPERTY(QString side READ getSide WRITE setSide NOTIFY setSideSignal)

public:
    QQuickHalfCircleTray(QQuickItem *parent = nullptr);
    ~QQuickHalfCircleTray();

    QString getSide(void);

    void componentComplete();

    void setSide(QString aSide);

signals:
    void setSideSignal(QString aSide);
	
public slots:
    void childrenPositionsUpdate();





private:

    QQuickItem * bgItem;
    bool is_left;
};

#endif // QQUICKHALFCIRCLETRAY_H
