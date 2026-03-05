#include "lvgl_string_display_node.h"

LvglStringDisplayNode::LvglStringDisplayNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType, lv_obj_t* textLabel)
    : LvglDisplayNode(widget, layer, entityType)
    , textLabel_(textLabel)
{
}

void LvglStringDisplayNode::onBecomeVisible()
{
    LvglDisplayNode::onBecomeVisible();

    if (textLabel_)
    {
        lv_label_set_text(textLabel_, stringArg_.c_str());
    }
}
