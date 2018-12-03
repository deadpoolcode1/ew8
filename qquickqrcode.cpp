#include "qquickqrcode.h"

#include <qrencode.h>

#include <QPainter>

class QPainter;

void QQuickQRCode::declareQML() {
                qmlRegisterType<QQuickQRCode>("com.mobileye.QRCode",0, 1, "QRCode");
            }

QQuickQRCode::QQuickQRCode(QQuickPaintedItem * parentQQuickItem) : QQuickPaintedItem(parentQQuickItem)
{


}

void QQuickQRCode::paint(QPainter * painter)
{
    const char * sample_sn = "2918011070900023";

    //const char * sample_sn = "Hello!";

    QRcode *qrcode = QRcode_encodeString8bit(sample_sn, 0, QR_ECLEVEL_L);

    width = (qrcode->width);
    quint8 * data = qrcode->data;

    qDebug("qrencode geometry is = %d,%d",qrcode->width,qrcode->width);


     qimage = new QImage(width*sizeof(quint8),width*sizeof(quint8),QImage::Format_RGB888);




     const QColor whiteColor(Qt::white);
     const QColor blackColor(Qt::black);

     qimage->fill(whiteColor);

#if 1
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    for (qint32 y = 0; y < width; y++)
    {
        for (qint32 x = 0; x < width; x++)
        {
                if(*(data+x+(y*width)) & (whiteBlackBitMask))
                {
                    /*Put black pixel*/
                    qimage->setPixelColor(x,y, blackColor);
                }

        }

    }
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#endif



    qDebug("QImage geometry is = %d,%d",qimage->width(),qimage->height());


    painter->setRenderHint(QPainter::Antialiasing, true);
    painter->setBrush(QBrush(Qt::white));
    painter->setPen(Qt::NoPen);

    painter->drawImage(0,0, *qimage);

    QRcode_free(qrcode);
}
