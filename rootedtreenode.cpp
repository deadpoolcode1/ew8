#include <QVariant>
#include "rootedtreenode.h"
#include "alerttypes.h"
#include "entitytype.h"
#include "layerspriorityq.h"
#include "amsignalsmodel.h"

#include "graphicitemsenummap.h"

// map initialization of EntityType should be done here for some magic reason...
EntityType::t_TreeNodesTypeMap EntityType::_typesMap;

RootedTreeNode::RootedTreeNode(QObject * qobject)
{
    activationSemaphore = 0;
    visibility = false;

    valueInt = 0;
    valueFrac = 0;
    unit = viu_None;
    stringArg = "";

    convertfromQObject(qobject);
}

void RootedTreeNode::setParent(RootedTreeNode * rtn)
{
    parent = rtn;
}

void RootedTreeNode::appendChild(RootedTreeNode * rtn)
{
    LayersPriorityQ_t* queue = children->getQueue();
    LayersPriorityQ_t::iterator it;
    bool appended = false;

    for (it = queue->begin(); it < queue->end(); it++ )
    {
        if ((*it)->getLayer() >= rtn->getLayer()  )
        {
            queue->insert(it, rtn);
            appended = true;
            break;
        }
    }
    if (!appended)
    {
        queue->push_back(rtn);
    }
}

void RootedTreeNode::convertfromQObject(QObject * qobject)
{
// esteblish link between atomic entityes (C++) and atomic entityes (Qt QObject)
    this->qmlItem = qobject;

    this->qmlSignalizer = new DisplaySignalizer();

    if (-1 != this->qmlItem->metaObject()->indexOfSlot(QMetaObject::normalizedSignature("setVisibleSlotStr(QVariant)")))
    {
        QObject::connect(this->qmlSignalizer, SIGNAL(setVisibleSignalStr(QVariant)),
                         this->qmlItem, SLOT(setVisibleSlotStr(QVariant)));
        qDebug("setVisibleSlotStr(QVariant) connected to %s", qPrintable(this->qmlItem->property("objectName").toString()));
    }

    if (-1 != this->qmlItem->metaObject()->indexOfSlot(QMetaObject::normalizedSignature("setVisibleSlot(void)")))
    {
        QObject::connect(this->qmlSignalizer, SIGNAL(setVisibleSignal(QVariant, QVariant, QVariant)),
                         this->qmlItem, SLOT(setVisibleSlot(void)));
         qDebug("setVisibleSlot(void) connected to %s", qPrintable(this->qmlItem->property("objectName").toString()));
    }

    if (-1 != this->qmlItem->metaObject()->indexOfSlot(QMetaObject::normalizedSignature("setVisibleSlot(QVariant)")))
    {
        QObject::connect(this->qmlSignalizer, SIGNAL(setVisibleSignal(QVariant, QVariant, QVariant)),
                         this->qmlItem, SLOT(setVisibleSlot(QVariant)));
         qDebug("setVisibleSlot(quint8) connected to %s", qPrintable(this->qmlItem->property("objectName").toString()));
    }

    if (-1 != this->qmlItem->metaObject()->indexOfSlot(QMetaObject::normalizedSignature("setVisibleSlot(QVariant, QVariant)")))
    {
        QObject::connect(this->qmlSignalizer, SIGNAL(setVisibleSignal(QVariant, QVariant, QVariant)),
                         this->qmlItem, SLOT(setVisibleSlot(QVariant, QVariant)));
         qDebug("setVisibleSlot(quint8, quint8) connected to %s", qPrintable(this->qmlItem->property("objectName").toString()));
    }

    if (-1 != this->qmlItem->metaObject()->indexOfSlot(QMetaObject::normalizedSignature("setVisibleSlot(QVariant,QVariant, QVariant)")))
    {
        QObject::connect(this->qmlSignalizer, SIGNAL(setVisibleSignal(QVariant, QVariant, QVariant)),
                         this->qmlItem, SLOT(setVisibleSlot(QVariant,QVariant, QVariant)));
         qDebug("setVisibleSlot(all arguments) connected to %s", qPrintable(this->qmlItem->property("objectName").toString()));
    }

    if (-1 != this->qmlItem->metaObject()->indexOfSlot(QMetaObject::normalizedSignature("setInvisibleSlot(void)")))
    {
        QObject::connect(this->qmlSignalizer, SIGNAL(setInvisibleSignal(void)),
                         this->qmlItem, SLOT(setInvisibleSlot(void)));
        qDebug("setInvisibleSlot(void) connected to %s", qPrintable(this->qmlItem->property("objectName").toString()));
    }


    QVariant vlayer = qobject->property("layer_pri");
    layer = vlayer.toInt(); // priority


// esteblish link between atomic entityes (C++) and Alerts by EntityType  (map)

    QVariant canEntityTypeQVar = qobject->property("canEntityType");

    if(canEntityTypeQVar.isValid())
    {

        bool isInt = false;

        DISPLAY_ITEM_ID type = (DISPLAY_ITEM_ID)(canEntityTypeQVar.toInt(&isInt));

        if(!isInt){
            type = (DISPLAY_ITEM_ID)GraphicItemsEnumMap::getId(canEntityTypeQVar.toString());
        }

        if (type != AlertTypes::QtQG) // no link between groups and alert types!
        {
            bool keyExist = EntityType::keyExist(type);
            if (!keyExist)
            {
#ifdef VERIFY_ALL_ALERTS_IMPLEMENTED
                throw std::exception(/*"Object type does not exist"*/);
                // add exception
#endif
            }

            DISPLAY_ERRORS_t res = EntityType::linkByEntityType(type, this);
            if (res == GENERAL_ERROR)
            {
#ifdef VERIFY_ALL_ALERTS_IMPLEMENTED
                throw std::exception(/*"Object link to type failed"*/);
                // add exception
#endif
            }
            else if(res == OBJECT_ALREADY_EXISTS_IN_MAP)
            {
                // add handling duplicated entries
            }
            //EntityType::getMap()[type] =  this;
            mutexGroup = false; // default value for Atomic Item
        }
        else
        {
            mutexGroup = qobject->property("mutexGroup").toBool();  // real value for group
        }

    }
    else
    {
        mutexGroup = false; //default value
    }

    addChildrenFromObject(qobject);

}

void RootedTreeNode::addChildrenFromObject(QObject * qobject)
{

   RootedTreeNode * curnode;
   children = new LayersPriorityQ();  // priority queue of children for C++ node

   //WARNING: Dirty Hack
   //TODO: check need to replace QObject-s of QtQuick to QQuickItem-s
   foreach(QObject * curchild, ((QQuickItem*)qobject)->childItems())
   {

       curnode = new RootedTreeNode(curchild);
       curnode->setParent(this);
       this->appendChild(curnode);

       //curnode->addChildrenFromObject(curnode->qmlItem);

   }

}

void RootedTreeNode::deactivateItemInMutexGroup()
{
    RootedTreeNode::activationSemaphore = 0;
}

// handle mutexGroup. Important! Current implementation assumes mutex Group only for Atomic Items
void RootedTreeNode::handleMutexGroup()
{
    LayersPriorityQ_t* childrenQueue = getChildren()->getQueue();
    if (!childrenQueue || childrenQueue->empty() )
    {
        // TBD exception
    }
    else
    {
        LayersPriorityQ_t::iterator it;
        for (it = childrenQueue->begin(); it < childrenQueue->end(); it++ )
        {
            (*it)->deactivateItemInMutexGroup();
        }
    }
}

void RootedTreeNode::setCanEntityArg(QString stringArg)
{
    this->stringArg = stringArg;
}

 void RootedTreeNode::setCanEntityArgs(quint8 valueInt, quint8 valueFrac, visual_item_unit_t unit)
 {
     this->valueInt = valueInt;
     this->valueFrac = valueFrac;
     this->unit = unit;
 }

// recursive activation
void RootedTreeNode::activate()
{
    if (parent != NULL && parent->mutexGroup)  // the item is apart of Mutex Group
    {
        parent->handleMutexGroup(); // handle mutex if the item belongs to mutexGroup. Important! Current implementation assumes mutex Group only for Atomic Items
    }

    activationSemaphore++;
    if (parent == NULL)
    {
        return;  // root is detected
    }
    parent->activate();
}

void RootedTreeNode::deactivate()
{
    if (!activationSemaphore)
    {
        // TBD exception ???
    }
    else
    {
        activationSemaphore--;
        if (parent == NULL)
        {
            return;
        }
        parent->deactivate();
    }
}

// recursive visibility update
DISPLAY_ERRORS_t RootedTreeNode::updateVisibility(FORCE_INVISIBILITY_t layerForcedInvis)
{
    LayersPriorityQ_t* queue = children->getQueue();
    LayersPriorityQ_t::iterator it;
    DISPLAY_ERRORS_t res;

    if (layerForcedInvis)
    {
        //this->qmlItem->property("visible") = false;
        res = updateVisibilityByInvoke(false); //make invisible
        if (res!= OK)
        {
            return res;
        }

        for (it = queue->begin(); it < queue->end(); it++ )
        {
            (*it)->updateVisibility(FORCE_INVISIBILITY);  // propagate invisibility to entire sub-tree.
        }
        return OK;
    }
    else
    {
        if (activationSemaphore)
        {
            //this->qmlItem->property("visible") = true;
            res = updateVisibilityByInvoke(true); //make visible
            if (res!= OK)
            {
                return res;
            }

            // manage visualization priorities in children
            int activatedLayer = -1; // priority in group
            int curLayer = 0; // priority in group
            for (it = queue->begin(); it < queue->end(); it++ )
            {
                curLayer = (*it)->getLayer();
                int curActivSem = (*it)->getActivSem();
                if (activatedLayer == -1 && curActivSem)
                {
                    activatedLayer = curLayer;
                }
                if (curLayer <= activatedLayer && curActivSem)  // manage visualization of children by layer priorities
                {
                    (*it)->updateVisibility(DO_NOT_FORCE_INVISIBILITY);  // explore sub-tree.
                }
                else
                {
                    (*it)->updateVisibility(FORCE_INVISIBILITY);  // propagate invisibility to entire sub-tree.
                }
            }
        }
        else
        {
            res = updateVisibilityByInvoke(false); //make invisible
            if (res!= OK)
            {
                return res;
            }
            for (it = queue->begin(); it < queue->end(); it++ )
            {
                (*it)->updateVisibility(FORCE_INVISIBILITY);  // propagate invisibility to entire sub-tree.
            }
        }
        return OK;
    }
}


DISPLAY_ERRORS_t RootedTreeNode::updateVisibilityByInvoke(bool visible)
{
    if (!this->qmlItem)
    {
        return GENERAL_ERROR;  // TBD add exception handling
    }

    if(visible)
    {
        QVariant qstr(stringArg);

        emit this->qmlSignalizer->setVisibleSignalStr(qstr);
        emit this->qmlSignalizer->setVisibleSignal((QVariant)valueInt,(QVariant)valueFrac,(QVariant)unit);
    }
    else
    {
        emit this->qmlSignalizer->setInvisibleSignal();
    }
    return OK;
}
