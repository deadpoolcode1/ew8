#include "alertcontroller.h"

#include "rootedtree.h"


RootedTree::RootedTree(QObject * qobject, AlertController * aAlertController)
{
    itsAlertController = aAlertController;
    root = new RootedTreeNode(qobject, this);
    root->setParent(NULL);
}

void RootedTree::setChanged(void)
{
    itsAlertController->setTreeChanged();
    itsAlertController->forceUpdate();
}

void RootedTree::updateVisibility()
{
    if (!root)
    {
        return;  // TBD exception
    }
    root->updateVisibility(DO_NOT_FORCE_INVISIBILITY);  // no forced invisibility
}
