#include "qquickqrcode.h"
#include "canstringargumentsaccumulator.h"
#include "amsignalsmodel.h"
#include "core/logger.h"

#include <qrencode.h>

#include <QPainter>

class CanStringArgumentsAccumulator;

class AMSignalsModel;

class QPainter;

String QQuickQRCode::baseurl = "";
String QQuickQRCode::request = "";


void QQuickQRCode::declareQML() {
                qmlRegisterType<QQuickQRCode>("builtin.mobileye.QRCode",0, 1, "QRCode");
            }

QQuickQRCode::QQuickQRCode(QQuickPaintedItem * parentQQuickItem) : QQuickPaintedItem(parentQQuickItem)
{
    margin = 3;
}


void QQuickQRCode::paint(QPainter * painter)
{

    String m_encoded = baseurl + request;

    QRcode *qrcode = QRcode_encodeString8bit(m_encoded.c_str(), 4, QR_ECLEVEL_L);

    width = (qrcode->width);
    uint8_t * data = qrcode->data;

    LOG_DEBUG("qrencode geometry is = %d,%d", qrcode->width, qrcode->width);


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

    LOG_DEBUG("QImage geometry is = %d,%d", qimage->width(), qimage->height());

    //QImage scaledImage = * qimage->scaled(156, 156, Qt::KeepAspectRatio);

    painter->setRenderHint(QPainter::Antialiasing, true);
    painter->setBrush(QBrush(Qt::white));
    painter->setPen(Qt::NoPen);

    painter->drawImage(0,0, * qimage);

    QRcode_free(qrcode);
}

void QQuickQRCode::setRequest(String aRequest)
{
   reqUpdate(aRequest);
}

void QQuickQRCode::setBaseUrl(String aUrl)
{
   baseurl = aUrl;
}


void QQuickQRCode::reqUpdate(String arg)
{
    if(request != arg)
    {
        request =  arg;
        LOG_DEBUG("New qr request: %s", arg.c_str());
        update();
    }
}
