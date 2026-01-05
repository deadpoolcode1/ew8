#include "qquickhalfcircletray.h"
#include "core/logger.h"

QQuickHalfCircleTray::QQuickHalfCircleTray(QQuickItem *parent):
    QQuickItem(parent)
{
    bgItem = nullptr;
    is_left = true;


    // By default, QQuickItem does not draw anything. If you subclass
    // QQuickItem to create a visual item, you will need to uncomment the
    // following line and re-implement updatePaintNode()

    // setFlag(ItemHasContents, true);
}

QString QQuickHalfCircleTray::getSide(void)
{
    QString ret;
    ret = is_left ? "left":"right";
    return ret;
}

void QQuickHalfCircleTray::setSide(QString aSide)
{
    is_left = (aSide == "left");
    if(!is_left) LOG_DEBUG("it is right!");
}

void QQuickHalfCircleTray::componentComplete()
{
    QQuickItem::componentComplete();

    LOG_DEBUG("QQuickHalfCircleTray component completed");

    foreach(QQuickItem * qi, childItems())
    {
        if(qi->objectName() == "background")
        {
            bgItem = qi;
        }
        else
        {
            connect(qi, SIGNAL(visibleChanged()), this,
                    SLOT(childrenPositionsUpdate()));
        }
    }
}

QQuickHalfCircleTray::~QQuickHalfCircleTray()
{
}


void QQuickHalfCircleTray::childrenPositionsUpdate()
{

    size_t vis_count = 0;

    foreach(QQuickItem * qi, childItems())
    {

        if(bgItem == nullptr)
        {LOG_DEBUG("background not found");}
        else
        {


            if(qi != bgItem && qi->isVisible())
            {
                qreal itemHeight = 50;
                qreal itemWidth = 50;
                qreal space = 5;

                qi->setSize(QSizeF(itemWidth,itemHeight));

                qreal yCenterItem = bgItem->boundingRect().center().y()-itemHeight/2;


                qreal firstX;
                qreal secondX;

                if(is_left)
                {
                   firstX = 0;
                   secondX = itemWidth+space;
                }
                else
                {
                    firstX = bgItem->boundingRect().center().x();
                    secondX = 0; //firstX - itemWidth+space;
                }

                switch (vis_count) {
                case 0:
                    qi->setPosition(QPointF(firstX,yCenterItem));
                    break;
                case 1:
                    qi->setPosition(QPointF(secondX,yCenterItem));
                    break;
                case 2:
                    qi->setPosition(QPointF(itemWidth/2,yCenterItem - itemHeight));
                    break;
                case 3:
                    qi->setPosition(QPointF(itemWidth/2,yCenterItem + itemHeight));

                    break;

                default:
                    break;
                }

                vis_count++;
            }
        }
    }
}
