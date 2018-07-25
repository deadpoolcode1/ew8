#ifndef ROOTEDTREE_H
#define ROOTEDTREE_H


#include "rootedtreenode.h"

class RootedTree
{
public:
    RootedTree(QObject * qobject);

    void updateVisibility();

private:
    RootedTreeNode * root;

};

#endif // ROOTEDTREE_H
