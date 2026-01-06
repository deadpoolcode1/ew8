#ifndef QQUICKQRCODE_H
#define QQUICKQRCODE_H

#include <QQuickPaintedItem>

#include <QPainter>

#include "defs.h"
#include "core/types.h"

class QPainter;

class QQuickQRCode : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(String baseurl  WRITE setBaseUrl)
    Q_PROPERTY(String request  WRITE setRequest)
#if 0
    Q_PROPERTY(uint32_t margin /* READ margin  WRITE setMargin NOTIFY marginChanged*/)
#endif
    //TODO add encoded string propert
    //TODO add scale property
    //TODO add margin property
    //TODO add readonly width, height properties



public:
    explicit QQuickQRCode(QQuickPaintedItem * parentQQuickItem = nullptr);
    void paint(QPainter * painter);

    static void declareQML();

    void setRequest(const String& aRequest);

    void setBaseUrl(const String& aUrl);

signals:


public slots:

private:
    const uint8_t whiteBlackBitMask = 0x01;


    static String  baseurl;
    static String  request;

    int32_t margin;

    QImage * qimage;
    int32_t  width;

    DISPLAY_ITEM_ID type;

    void snUpdate(const String& arg);
    void reqUpdate(const String& arg);
};

#endif // QQUICKQRCODE_H
