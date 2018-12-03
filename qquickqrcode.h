#ifndef QQUICKQRCODE_H
#define QQUICKQRCODE_H

#include <QQuickPaintedItem>

#include <QPainter>

class QPainter;

class QQuickQRCode : public QQuickPaintedItem
{
    Q_OBJECT

public:
    QQuickQRCode(QQuickPaintedItem * parentQQuickItem = nullptr);
    void paint(QPainter * painter);

    static void declareQML();

private:
    const quint8 whiteBlackBitMask = 0x01;

    QImage * qimage;
    qint32  width;
};

#endif // QQUICKQRCODE_H
