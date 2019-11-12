#include "qquickhalfcircletray.h"

QQuickHalfCircleTray::QQuickHalfCircleTray(QQuickItem *parent):
    QQuickItem(parent)
{
    connect(this, SIGNAL(visibleChildrenChanged()),
            SLOT(childrenPositionsUpdate()));
    bgItem = nullptr;

    // By default, QQuickItem does not draw anything. If you subclass
    // QQuickItem to create a visual item, you will need to uncomment the
    // following line and re-implement updatePaintNode()

    // setFlag(ItemHasContents, true);
}

QQuickHalfCircleTray::~QQuickHalfCircleTray()
{
}


void QQuickHalfCircleTray::childrenPositionsUpdate()
{

    size_t vis_count = 0;


    if(bgItem == nullptr)
    {
        foreach(QQuickItem * qi, childItems())
        {
            if(qi->objectName() == "background")
            {
                bgItem = qi;
            }
        }
    }


    foreach(QQuickItem * qi, childItems())
    {

        if(bgItem == nullptr)
        {qDebug("background not found");}
        else
        {


            if(qi != bgItem && qi->isVisible())
            {
                qreal itemHeight = 50;
                qreal itemWidth = 50;

                qi->setSize(QSizeF(itemWidth,itemHeight));

                qreal yCenterItem = bgItem->boundingRect().center().y()-itemHeight/2;
                switch (vis_count) {
                case 0:
                    qi->setPosition(QPointF(0,yCenterItem));

                    break;
                case 1:
                    qi->setPosition(QPointF(itemWidth,yCenterItem));

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
