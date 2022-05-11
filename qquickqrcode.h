#ifndef QQUICKQRCODE_H
#define QQUICKQRCODE_H

#include <QQuickPaintedItem>

#include <QPainter>

#include "defs.h"

class QPainter;

class QQuickQRCode : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QString sn  READ getSn  WRITE setSn)
    Q_PROPERTY(QString baseurl  WRITE setBaseUrl)
    Q_PROPERTY(QString request  WRITE setRequest)
#if 0
    Q_PROPERTY(quint32 margin /* READ margin  WRITE setMargin NOTIFY marginChanged*/)
#endif
    //TODO add encoded string propert
    //TODO add scale property
    //TODO add margin property
    //TODO add readonly width, height properties



public:
    explicit QQuickQRCode(QQuickPaintedItem * parentQQuickItem = nullptr);
    void paint(QPainter * painter);

    static void declareQML();

    QString getSn(void);

    void setSn(QString aSn);

    void setRequest(QString aRequest);

    void setBaseUrl(QString aUrl);

signals:


public slots:

    void snChangedArgumentSlot(QString arg)
    {
        snUpdate(arg);
    }



private:
    const quint8 whiteBlackBitMask = 0x01;


    static QString  baseurl;
    static QString  request;
    static QString  sn;

    qint32 margin;

    QImage * qimage;
    qint32  width;

    DISPLAY_ITEM_ID type;

    void snUpdate(QString arg);
    void reqUpdate(QString arg);
};

#endif // QQUICKQRCODE_H
