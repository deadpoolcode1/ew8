#ifndef ROOTEDTREE_H
#define ROOTEDTREE_H

#include <functional>

#include "rootedtreenode.h"

class RootedTreeNode;

class RootedTree
{
public:
    using TreeChangedCallback = std::function<void()>;

    RootedTree(QObject * qobject, TreeChangedCallback onTreeChanged);

    //WARNING: Following method used inside a tree node,
    //when it changed by direct signal from QML
    void setChanged(void);

    void updateVisibility();

private:
    RootedTreeNode * root;
    TreeChangedCallback onTreeChanged;
};

#endif // ROOTEDTREE_H
