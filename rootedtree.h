#ifndef ROOTEDTREE_H
#define ROOTEDTREE_H


#include "rootedtreenode.h"

class RootedTree
{
public:
    RootedTree(QObject * qobject);
private:

    RootedTreeNode * root;

    RootedTreeNode * current;



};

#endif // ROOTEDTREE_H
