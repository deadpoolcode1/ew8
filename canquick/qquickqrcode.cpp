#include "qquickqrcode.h"
#include "canstringargumentsaccumulator.h"
#include "amsignalsmodel.h"

#include <qrencode.h>

#include <QPainter>

class CanStringArgumentsAccumulator;

class AMSignalsModel;

class QPainter;

QString QQuickQRCode::baseurl = "";
QString QQuickQRCode::request = "";


void QQuickQRCode::declareQML() {
                qmlRegisterType<QQuickQRCode>("builtin.mobileye.QRCode",0, 1, "QRCode");
            }

QQuickQRCode::QQuickQRCode(QQuickPaintedItem * parentQQuickItem) : QQuickPaintedItem(parentQQuickItem)
{
    margin = 3;
}


void QQuickQRCode::paint(QPainter * painter)
{

    QString m_encoded = baseurl + request;

    QRcode *qrcode = QRcode_encodeString8bit(m_encoded.toLatin1(), 4, QR_ECLEVEL_L);

    width = (qrcode->width);
    uint8_t * data = qrcode->data;

    qDebug("qrencode geometry is = %d,%d",qrcode->width,qrcode->width);


     qimage = new QImage(width+(margin*2),width+(margin*2),QImage::Format_RGB888);




     const QColor whiteColor(Qt::white);
     const QColor blackColor(Qt::black);

     qimage->fill(whiteColor);


    for (int32_t y = 0; y < width; y++)
    {
        for (int32_t x = 0; x < width; x++)
        {
                if(*(data+x+(y*width)) & (whiteBlackBitMask))
                {
                    /*Put black pixel*/
                    qimage->setPixelColor(margin+x,margin+y, blackColor);

                }

        }

    }

    qDebug("QImage geometry is = %d,%d",qimage->width(),qimage->height());

    //QImage scaledImage = * qimage->scaled(156, 156, Qt::KeepAspectRatio);

    painter->setRenderHint(QPainter::Antialiasing, true);
    painter->setBrush(QBrush(Qt::white));
    painter->setPen(Qt::NoPen);

    painter->drawImage(0,0, * qimage);

    QRcode_free(qrcode);
}

void QQuickQRCode::setRequest(QString aRequest)
{
   reqUpdate(aRequest);
}

void QQuickQRCode::setBaseUrl(QString aUrl)
{
   baseurl = aUrl;
}


void QQuickQRCode::reqUpdate(QString arg)
{
    if(request != arg)
    {
        request =  arg;
        qDebug("New qr request: %s", qPrintable(arg));
        update();
    }
}
