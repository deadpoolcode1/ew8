#ifndef QQUICKQRCODE_H
#define QQUICKQRCODE_H

#include <QQuickPaintedItem>

#include <QPainter>

class QPainter;

class QQuickQRCode : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QString sn  READ getSn  WRITE setSn  NOTIFY snChanged)
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

    QString getSn(void){return sn;}

    static void setSn(QString aSn){sn = aSn;}

signals:

    void snChanged(void);

public slots:

    void snChangedSlot(void){}

    void snChangedArgumentSlot(QString arg)
    {
        sn =  arg;
        qDebug("New sn: %s", qPrintable(arg));
        this->setVisible(true);
        update();

    }



private:
    const quint8 whiteBlackBitMask = 0x01;

    const QString  url = "https://cloud.aftermarket.mobileye.com/qrcode?sn=";
    static QString  sn;

    QImage * qimage;
    qint32  width;


};

#endif // QQUICKQRCODE_H
