#include "qquickqrcode.h"
#include "canstringargumentsaccumulator.h"

//TODO add win32 support: libqrencode-win32.dll
#include <qrencode.h>

#include <QPainter>

class CanStringArgumentsAccumulator;

class QPainter;

QString QQuickQRCode::sn = "2918011070900023";

void QQuickQRCode::declareQML() {
                qmlRegisterType<QQuickQRCode>("com.mobileye.QRCode",0, 1, "QRCode");
            }

QQuickQRCode::QQuickQRCode(QQuickPaintedItem * parentQQuickItem) : QQuickPaintedItem(parentQQuickItem)
{
    connect(this, SIGNAL(snChanged()), SLOT(snChangedSlot()));
    connect(CanStringArgumentsAccumulator::getInstance("INFO_QRCODE"),SIGNAL(argumentComplete(QString)),
            this, SLOT(snChangedArgumentSlot(QString)));
}


void QQuickQRCode::paint(QPainter * painter)
{

    QString m_sn = url + sn;

    QRcode *qrcode = QRcode_encodeString8bit(m_sn.toLatin1(), 4, QR_ECLEVEL_L);

    width = (qrcode->width);
    quint8 * data = qrcode->data;

    qint32 margin = 3;

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
