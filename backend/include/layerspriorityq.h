#ifndef LAYERSPRIORITYQ_H
#define LAYERSPRIORITYQ_H

#include <vector>
#include <queue>
#include "idisplaynode.h"

class IDisplayNode;
typedef std::vector<IDisplayNode*> LayersPriorityQ_t;

struct CompareChildrenLayers {
    bool operator()(IDisplayNode * n1, IDisplayNode * n2) {
        // return "true" if layer of "n1" is ordered higher than layer of "n2" (zero is a highest)
        return n1->getLayer() < n2->getLayer();
    }
};


class LayersPriorityQ
{
public:
    LayersPriorityQ();

    LayersPriorityQ_t* getQueue() {return &queue;}
private:
    LayersPriorityQ_t queue;

};

#endif // LAYERSPRIORITYQ_H
