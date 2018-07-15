#include "rootedtreenode.h"




RootedTreeNode::RootedTreeNode()
{
     is_active =  false;
}

RootedTreeNode::RootedTreeNode(QObject * qobject)
{
    convertfromQObject(qobject);
}


void RootedTreeNode::setParent(RootedTreeNode * rtn)
{
    parent = rtn;
}




void RootedTreeNode::appendChild(RootedTreeNode *rtn)
{
  children.append(rtn);
}


void RootedTreeNode::convertfromQObject(QObject * qobject)
{
    this->qmlItem = qobject;

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
