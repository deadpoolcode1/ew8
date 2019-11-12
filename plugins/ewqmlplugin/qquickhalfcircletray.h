#ifndef QQUICKHALFCIRCLETRAY_H
#define QQUICKHALFCIRCLETRAY_H

#include <QQuickItem>

class QQuickHalfCircleTray : public QQuickItem
{
    Q_OBJECT
    Q_DISABLE_COPY(QQuickHalfCircleTray)

public:
    QQuickHalfCircleTray(QQuickItem *parent = nullptr);
    ~QQuickHalfCircleTray();
	
public slots:
    void childrenPositionsUpdate();

private:

    QQuickItem * bgItem;
};

#endif // QQUICKHALFCIRCLETRAY_H
