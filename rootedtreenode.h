#ifndef ROOTEDTREENODE_H
#define ROOTEDTREENODE_H

#include <QObject>
//#include <QList>
#include "defs.h"
#include "core/types.h"
#include "rootedtree.h"
#include "displaysignalizer.h"

class DisplaySignalizer;


class LayersPriorityQ;  // forward declaration
class EntityType;
class RootedTree;

class RootedTreeNode
{
public:
    RootedTreeNode();

    RootedTreeNode(QObject * qobject, RootedTree * itsRootedTree);


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

    void setCanEntityArgs(uint8_t valueInt, uint8_t valueFrac, uint8_t unit);
    void setCanEntityArg(const String& stringArg);


    DISPLAY_ERRORS_t updateVisibility(FORCE_INVISIBILITY_t layerForcedInvis);

    DisplaySignalizer * qmlSignalizer;
    void forceDeactivation(void);

private:

    void convertfromQObject(QObject * qobject);
    DISPLAY_ERRORS_t updateVisibilityByInvoke(bool visible);


    QObject * qmlItem;
    RootedTree * itsRootedTree;
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
    bool modeGroup;
//    QString qname;

    //TODO add alert type

    //Invoke arguments:
    uint8_t valueInt;
    uint8_t valueFrac;
    uint8_t unit;
    String stringArg;
};


#endif // ROOTEDTREENODE_H
