#ifndef LVGL_BLINK_DISPLAY_NODE_H
#define LVGL_BLINK_DISPLAY_NODE_H

#include "lvgl_display_node.h"

class LvglBlinkDisplayNode : public LvglDisplayNode {
public:
    LvglBlinkDisplayNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType);

    void onBecomeVisible() override;
    void onBecomeInvisible() override;
};

#endif // LVGL_BLINK_DISPLAY_NODE_H
