#include <QVariant>
#include "rootedtreenode.h"
#include "alerttypes.h"
#include "entitytype.h"
#include "layerspriorityq.h"

EntityType::t_TreeNodesTypeMap EntityType::_typesMap;


RootedTreeNode::RootedTreeNode()
{

}

RootedTreeNode::RootedTreeNode(QObject * qobject)
{
    convertfromQObject(qobject);
}


void RootedTreeNode::setParent(RootedTreeNode * rtn)
{
    parent = rtn;
}

void RootedTreeNode::appendChild(RootedTreeNode * rtn)
{
  children->getQueue()->push(*rtn);
}

#if 0
void findEntityType1(void)
{
    return;
}
#endif

void RootedTreeNode::convertfromQObject(QObject * qobject)
{
    this->qmlItem = qobject;

    QVariant vlayer = qobject->property("layer");
    layer = vlayer.toInt(); // priority

    AlertTypes::EnAlert type = (AlertTypes::EnAlert)(qobject->property("canEntityType").toInt());
#if 0
    RootedTreeNode* typeObj = EntityType::findEntityType(type);
#endif
    EntityType::getMap()[type] =  this;

    addChildrenFromObject(qobject);


//    this->entityType->_type = qobject->property("canEntityType");//.toString();
}

void RootedTreeNode::addChildrenFromObject(QObject * qobject)
{

   RootedTreeNode * curnode;

   foreach(QObject * curchild, qobject->children())
   {

       curnode = new RootedTreeNode(curchild);
       curnode->setParent(this);
       this->appendChild(curnode);

       //curnode->addChildrenFromObject(curnode->qmlItem);

   }

}
