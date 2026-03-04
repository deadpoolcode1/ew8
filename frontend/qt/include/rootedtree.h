#ifndef ROOTEDTREE_H
#define ROOTEDTREE_H


#include "rootedtreenode.h"

class RootedTreeNode;
class AlertController;

class RootedTree
{
public:
    RootedTree(QObject * qobject, AlertController * aAlertController);

    //WARNING: Following method used inside a tree node,
    //when it changed by direct signal from QML
    void setChanged(void);

    void updateVisibility();

private:
    RootedTreeNode * root;
    AlertController * itsAlertController;


};

#endif // ROOTEDTREE_H
