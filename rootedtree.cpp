#include "rootedtree.h"

RootedTree::RootedTree()
{
    root = new RootedTreeNode();
    root->setParent(NULL);
}



