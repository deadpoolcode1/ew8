#ifndef DISPLAY_TREE_H
#define DISPLAY_TREE_H

#include "defs.h"

class IDisplayNode;

DISPLAY_ERRORS_t updateTreeVisibility(IDisplayNode* node, FORCE_INVISIBILITY_t layerForcedInvis);

#endif // DISPLAY_TREE_H
