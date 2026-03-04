#ifndef QQUICKHALFCIRCLETRAY_H
#define QQUICKHALFCIRCLETRAY_H

#include <QQuickItem>
#include "../../core/types.h"

class QQuickHalfCircleTray : public QQuickItem
{
    Q_OBJECT
    Q_DISABLE_COPY(QQuickHalfCircleTray)
    Q_PROPERTY(String side READ getSide WRITE setSide NOTIFY setSideSignal)

public:
    QQuickHalfCircleTray(QQuickItem *parent = nullptr);
    ~QQuickHalfCircleTray();

    String getSide(void);

    void componentComplete();

    void setSide(const String& aSide);

signals:
    void setSideSignal(const String& aSide);
	
public slots:
    void childrenPositionsUpdate();





private:

    QQuickItem * bgItem;
    bool is_left;
};

#endif // QQUICKHALFCIRCLETRAY_H
