#ifndef QQUICKQRCODE_H
#define QQUICKQRCODE_H

#include <QQuickPaintedItem>

#include <QPainter>

class QPainter;

class QQuickQRCode : public QQuickPaintedItem
{
    Q_OBJECT

#if 0
    Q_PROPERTY(QString sn  /* READ sn  WRITE setSn NOTIFY snChanged*/);
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


private:
    const quint8 whiteBlackBitMask = 0x01;

    QString  url = "https://cloud.aftermarket.mobileye.com/qrcode?sn=";
    QString  sn = "2918011070900023";

    QString m_sn = url + sn;

    QImage * qimage;
    qint32  width;


};

#endif // QQUICKQRCODE_H
