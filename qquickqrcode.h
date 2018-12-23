#ifndef QQUICKQRCODE_H
#define QQUICKQRCODE_H

#include <QQuickPaintedItem>

#include <QPainter>

class QPainter;

class QQuickQRCode : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QString sn  READ getSn  WRITE setSn)
#if 0
    Q_PROPERTY(quint32 margin /* READ margin  WRITE setMargin NOTIFY marginChanged*/)
#endif
    //TODO add encoded string propert
    //TODO add scale property
    //TODO add margin property
    //TODO add readonly width, height properties



public:
    QQuickQRCode(QQuickPaintedItem * parentQQuickItem = nullptr);
    void paint(QPainter * painter);

    static void declareQML();

    QString getSn(void);

    void setSn(QString aSn);

signals:


public slots:

    void snChangedArgumentSlot(QString arg)
    {
        snUpdate(arg);
    }



private:
    const quint8 whiteBlackBitMask = 0x01;

    const QString  url = "https://cloud.aftermarket.mobileye.com/qrcode?sn=";
    static QString  sn;

    qint32 margin;

    QImage * qimage;
    qint32  width;

    void snUpdate(QString arg);

};

#endif // QQUICKQRCODE_H
