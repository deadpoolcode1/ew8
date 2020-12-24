#include "displaysignalizer.h"

DisplaySignalizer::DisplaySignalizer(RootedTreeNode * aRootedTreeNode, QQuickItem * parent) :  QQuickItem(parent)
{
  itsRootedTreeNode = aRootedTreeNode;
}

void DisplaySignalizer::forceItemSelfDeactivation(void)
{
   itsRootedTreeNode->forceDeactivation();
}
