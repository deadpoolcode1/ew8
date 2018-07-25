#include "rootedtree.h"

RootedTree::RootedTree(QObject * qobject)
{
    root = new RootedTreeNode(qobject);
    root->setParent(NULL);
}



void RootedTree::updateVisibility()
{
    if (!root)
    {
        return;  // TBD exception
    }
    root->updateVisibility(false);  // no forced invisibility
}
