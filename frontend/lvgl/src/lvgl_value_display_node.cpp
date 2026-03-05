#include "lvgl_value_display_node.h"
#include <cstdio>

LvglValueDisplayNode::LvglValueDisplayNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType, lv_obj_t* valueLabel)
    : LvglDisplayNode(widget, layer, entityType)
    , valueLabel_(valueLabel)
{
}

void LvglValueDisplayNode::onBecomeVisible()
{
    LvglDisplayNode::onBecomeVisible();

    if (valueLabel_)
    {
        char buf[16];
        snprintf(buf, sizeof(buf), "%d", valueInt_);
        lv_label_set_text(valueLabel_, buf);
    }
}
