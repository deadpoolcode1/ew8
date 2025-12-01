#include "ialertdisplay.h"

#include "rootedtree.h"

class IAlertDisplay;


RootedTree::RootedTree(QObject * qobject, bool * a_flag_is_changed, IAlertDisplay * aDisplay)
{
    is_changed = a_flag_is_changed;
    itsDisplay = aDisplay;
    root = new RootedTreeNode(qobject, this);
    root->setParent(NULL);
}

void RootedTree::setChanged(void)
{
    * is_changed = true;
    itsDisplay->forceUpdate();
}

void RootedTree::updateVisibility()
{
    if (!root)
    {
        return;  // TBD exception
    }
    root->updateVisibility(DO_NOT_FORCE_INVISIBILITY);  // no forced invisibility
}
