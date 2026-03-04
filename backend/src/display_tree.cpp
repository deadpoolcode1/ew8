#include "display_tree.h"
#include "idisplaynode.h"
#include "layerspriorityq.h"

DISPLAY_ERRORS_t updateTreeVisibility(IDisplayNode* node, FORCE_INVISIBILITY_t layerForcedInvis)
{
    LayersPriorityQ_t* queue = node->getChildren()->getQueue();
    LayersPriorityQ_t::iterator it;
    DISPLAY_ERRORS_t res;

    if (layerForcedInvis)
    {
        node->onBecomeInvisible();

        for (it = queue->begin(); it < queue->end(); it++)
        {
            updateTreeVisibility(*it, FORCE_INVISIBILITY);
        }
        return OK;
    }
    else
    {
        if (node->getActivSem())
        {
            node->onBecomeVisible();

            // manage visualization priorities in children
            int activatedLayer = -1;
            int curLayer = 0;
            for (it = queue->begin(); it < queue->end(); it++)
            {
                curLayer = (*it)->getLayer();
                int curActivSem = (*it)->getActivSem();
                if (activatedLayer == -1 && curActivSem)
                {
                    activatedLayer = curLayer;
                }
                if (curLayer <= activatedLayer && curActivSem)
                {
                    updateTreeVisibility(*it, DO_NOT_FORCE_INVISIBILITY);
                }
                else
                {
                    updateTreeVisibility(*it, FORCE_INVISIBILITY);
                }
            }
        }
        else
        {
            node->onBecomeInvisible();

            for (it = queue->begin(); it < queue->end(); it++)
            {
                updateTreeVisibility(*it, FORCE_INVISIBILITY);
            }
        }
        return OK;
    }
}
