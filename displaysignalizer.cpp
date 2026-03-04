#include "displaysignalizer.h"
#include "amjsongraphicitemaction.h"

DisplaySignalizer::DisplaySignalizer(RootedTreeNode * aRootedTreeNode, QQuickItem * parent) :  QQuickItem(parent)
{
  itsRootedTreeNode = aRootedTreeNode;
}

void DisplaySignalizer::setAction(AMJsonGraphicItemAction * action)
{
    itsAction = action;
}

void DisplaySignalizer::forceItemSelfDeactivation(void)
{
   itsRootedTreeNode->forceDeactivation();
}

void DisplaySignalizer::forceItemActionDeactivation(void)
{
    if (itsAction)
        itsAction->forceDeactivation();
}
