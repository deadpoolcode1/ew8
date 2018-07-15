#ifndef ROOTEDTREENODE_H
#define ROOTEDTREENODE_H

#include <QObject>
#include <QList>

class RootedTreeNode
{
public:
    RootedTreeNode();

    RootedTreeNode(QObject * qobject);

    void setParent(RootedTreeNode * rtn);
    void appendChild(RootedTreeNode * rtn);
    void addChildrenFromObject(QObject * qobject);



private:

    void convertfromQObject(QObject * qobject);


    QObject * qmlItem;
    bool is_active;
    bool visibility;
    RootedTreeNode * parent;
    QList<RootedTreeNode *> children;


    //TODO add alert type

};

#endif // ROOTEDTREENODE_H
