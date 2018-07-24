#include "rootedtree.h"

RootedTree::RootedTree(QObject * qobject)
{
    root = new RootedTreeNode(qobject);
    root->setParent(NULL);
}



