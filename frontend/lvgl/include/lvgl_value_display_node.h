#ifndef LVGL_VALUE_DISPLAY_NODE_H
#define LVGL_VALUE_DISPLAY_NODE_H

#include "lvgl_display_node.h"

class LvglValueDisplayNode : public LvglDisplayNode {
public:
    LvglValueDisplayNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType, lv_obj_t* valueLabel);

    void onBecomeVisible() override;

private:
    lv_obj_t* valueLabel_;
};

#endif // LVGL_VALUE_DISPLAY_NODE_H
