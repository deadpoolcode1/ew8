#include <QVariant>
#include "rootedtreenode.h"
#include "alerttypes.h"
#include "entitytype.h"
#include "layerspriorityq.h"

// map initialization of EntityType should be done here for some magic reason...
EntityType::t_TreeNodesTypeMap EntityType::_typesMap;

RootedTreeNode::RootedTreeNode(QObject * qobject)
{
    activationSemaphore = 0;
    visibility = false;
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
        if ((*it)->getLayer() >= (*it)->getLayer()  )
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

#if 0
void findEntityType1(void)
{
    return;
}
#endif

void RootedTreeNode::convertfromQObject(QObject * qobject)
{
// esteblish link between atomic entityes (C++) and atomic entityes (Qt QObject)
    this->qmlItem = qobject;

//    qname = qobject->objectName();

    QVariant vlayer = qobject->property("layer_pri");
    layer = vlayer.toInt(); // priority


// esteblish link between atomic entityes (C++) and Alerts by EntityType  (map)
    AlertTypes::EnAlert type = (AlertTypes::EnAlert)(qobject->property("canEntityType").toInt());
    if (type != AlertTypes::QtQG) // no link between groups and alert types!
    {
        RootedTreeNode* typeObj = EntityType::findByEntityType(type);
        if (typeObj == NULL)
        {
            // add exception
        }

        DISPLAY_ERRORS_t res = EntityType::linkByEntityType(type, this);
        if (res == GENERAL_ERROR)
        {
            // add exception
        }
        //EntityType::getMap()[type] =  this;
    }

    addChildrenFromObject(qobject);


//    this->entityType->_type = qobject->property("canEntityType");//.toString();
}

void RootedTreeNode::addChildrenFromObject(QObject * qobject)
{

   RootedTreeNode * curnode;
   children = new LayersPriorityQ();  // priority queue of children for C++ node

   foreach(QObject * curchild, qobject->children())
   {

       curnode = new RootedTreeNode(curchild);
       curnode->setParent(this);
       this->appendChild(curnode);

       //curnode->addChildrenFromObject(curnode->qmlItem);

   }

}

// recursive activation
void RootedTreeNode::activate()
{
    activationSemaphore++;
    if (parent == NULL)
    {
        return;
    }
    parent->activate();
}

void RootedTreeNode::deactivate()
{
    if (!activationSemaphore)
    {
        // TBD exception
    }
    activationSemaphore--;
    if (parent == NULL)
    {
        return;
    }
    parent->deactivate();
}

// recursive visibility update
DISPLAY_ERRORS_t RootedTreeNode::updateVisibility(bool layerForcedInvis)
{
    LayersPriorityQ_t* queue = children->getQueue();
    LayersPriorityQ_t::iterator it;
    DISPLAY_ERRORS_t res;

    if (layerForcedInvis)
    {
        this->qmlItem->property("visible") = false;
        res = updateVisibilityByInvoke(false); //make invisible
        if (res!= OK)
        {
            return res;
        }

        for (it = queue->begin(); it < queue->end(); it++ )
        {
            (*it)->updateVisibility(true);  // propagate invisibility to entire sub-tree.
        }
        return OK;
    }
    else
    {
        if (activationSemaphore)
        {
            this->qmlItem->property("visible") = true;
            res = updateVisibilityByInvoke(true); //make visible
            if (res!= OK)
            {
                return res;
            }
            for (it = queue->begin(); it < queue->end(); it++ )
            {
                (*it)->updateVisibility(false);  // propagate invisibility to entire sub-tree.
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
                (*it)->updateVisibility(true);  // propagate invisibility to entire sub-tree.
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
    QMetaObject::invokeMethod(this->qmlItem,"setVisible",Q_ARG(QVariant, visible));
    return OK;
}
