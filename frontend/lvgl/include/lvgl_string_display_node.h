#ifndef LVGL_STRING_DISPLAY_NODE_H
#define LVGL_STRING_DISPLAY_NODE_H

#include "lvgl_display_node.h"

class LvglStringDisplayNode : public LvglDisplayNode {
public:
    LvglStringDisplayNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType, lv_obj_t* textLabel);

    void onBecomeVisible() override;

private:
    lv_obj_t* textLabel_;
};

#endif // LVGL_STRING_DISPLAY_NODE_H
