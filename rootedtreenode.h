#ifndef ROOTEDTREENODE_H
#define ROOTEDTREENODE_H

#include <QObject>
//#include <QList>
#include "defs.h"



class LayersPriorityQ;  // forward declaration
class EntityType;

class RootedTreeNode
{
public:
    RootedTreeNode();

    RootedTreeNode(QObject * qobject);

    void setParent(RootedTreeNode * rtn);
    void appendChild(RootedTreeNode * rtn);
    void addChildrenFromObject(QObject * qobject);

//    bool operator<(const RootedTreeNode& lhs, const RootedTreeNode& rhs);
    int getLayer() {return layer;}
    QObject* getQmlItem() {return qmlItem;}
    int getActivSem() {return activationSemaphore;}
    LayersPriorityQ* getChildren() {return children;}

    bool getMutexGroup() {return mutexGroup;}

    void activate();
    void deactivate();
    void deactivateItemInMutexGroup();
    void handleMutexGroup();

    void setCanEntityArg(quint8 arg);


    DISPLAY_ERRORS_t updateVisibility(FORCE_INVISIBILITY_t layerForcedInvis);

private:

    void convertfromQObject(QObject * qobject);
    DISPLAY_ERRORS_t updateVisibilityByInvoke(bool visible);


    QObject * qmlItem;
    RootedTreeNode * parent;
    //   QList<RootedTreeNode *> children;
    LayersPriorityQ * children;
//    std::priority_queue<RootedTreeNode, std::vector<RootedTreeNode>, CompareChildrenLayers> children;

//    bool is_active;
    EntityType* entityType;
    int layer; // defines visualization priority in the "children" priority queue of parent
    int activationSemaphore;  // if higher than 0 - active
    bool visibility; // needed?

    bool mutexGroup;
//    QString qname;

    //TODO add alert type

};


#endif // ROOTEDTREENODE_H
