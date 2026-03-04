#include "rootedtree.h"


RootedTree::RootedTree(QObject * qobject, TreeChangedCallback aOnTreeChanged)
    : onTreeChanged(std::move(aOnTreeChanged))
{
    root = new RootedTreeNode(qobject, this);
    root->setParent(NULL);
}

void RootedTree::setChanged(void)
{
    if (onTreeChanged) onTreeChanged();
}

void RootedTree::updateVisibility()
{
    if (!root)
    {
        return;  // TBD exception
    }
    root->updateVisibility(DO_NOT_FORCE_INVISIBILITY);  // no forced invisibility
}
