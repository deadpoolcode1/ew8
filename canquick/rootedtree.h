#ifndef ROOTEDTREE_H
#define ROOTEDTREE_H


#include "rootedtreenode.h"

class RootedTreeNode;
class IAlertDisplay;

class RootedTree
{
public:
    RootedTree(QObject * qobject, bool * a_flag_is_changed, IAlertDisplay * itsDisplay);

    //WARNING: Following method used inside a tree node,
    //when it changed by direct signal from QML
    void setChanged(void);

    void updateVisibility();

private:
    RootedTreeNode * root;
    bool * is_changed;
    IAlertDisplay * itsDisplay;


};

#endif // ROOTEDTREE_H
