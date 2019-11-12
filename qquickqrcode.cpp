#include "qquickqrcode.h"
#include "canstringargumentsaccumulator.h"
#include "amsignalsmodel.h"

#include <qrencode.h>

#include <QPainter>

class CanStringArgumentsAccumulator;

class AMSignalsModel;

class QPainter;

QString QQuickQRCode::sn = "";

void QQuickQRCode::declareQML() {
                qmlRegisterType<QQuickQRCode>("builtin.mobileye.QRCode",0, 1, "QRCode");
            }

QQuickQRCode::QQuickQRCode(QQuickPaintedItem * parentQQuickItem) : QQuickPaintedItem(parentQQuickItem)
{
    margin = 3;
}


void QQuickQRCode::paint(QPainter * painter)
{

    QString m_sn = url + sn;

    QRcode *qrcode = QRcode_encodeString8bit(m_sn.toLatin1(), 4, QR_ECLEVEL_L);

    width = (qrcode->width);
    quint8 * data = qrcode->data;

    qDebug("qrencode geometry is = %d,%d",qrcode->width,qrcode->width);


     qimage = new QImage(width+(margin*2),width+(margin*2),QImage::Format_RGB888);




     const QColor whiteColor(Qt::white);
     const QColor blackColor(Qt::black);

     qimage->fill(whiteColor);


    for (qint32 y = 0; y < width; y++)
    {
        for (qint32 x = 0; x < width; x++)
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

QString QQuickQRCode::getSn(void){return sn;}

void QQuickQRCode::setSn(QString aSn)
{
    snUpdate(aSn);
}

void QQuickQRCode::snUpdate(QString arg)
{
    if(sn != arg)
    {
        sn =  arg;
        qDebug("New sn: %s", qPrintable(arg));
        update();
    }
}
