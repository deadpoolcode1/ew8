#ifndef LAYERSPRIORITYQ_H
#define LAYERSPRIORITYQ_H

#include <vector>
#include <queue>
#include "rootedtreenode.h"

// forward declaration
class RootedTreeNode;
typedef std::vector<RootedTreeNode*> LayersPriorityQ_t;

struct CompareChildrenLayers {
    bool operator()(RootedTreeNode * n1, RootedTreeNode * n2) {
        // return "true" if layer of "n1" is ordered higher than layer of "n2" (zero is a highest)
        return n1->getLayer() < n2->getLayer();
    }
};


class LayersPriorityQ
{
public:
    LayersPriorityQ();

    LayersPriorityQ_t* getQueue() {return &queue;}
//    std::priority_queue<RootedTreeNode*, std::vector<RootedTreeNode*>, CompareChildrenLayers>* getQueue() {return &pqueue;}
private:
    LayersPriorityQ_t queue;
//    std::priority_queue<RootedTreeNode*, std::vector<RootedTreeNode*>, CompareChildrenLayers> pqueue;

};

#endif // LAYERSPRIORITYQ_H
