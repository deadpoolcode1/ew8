#include "lvgl_value_display_node.h"
#include <cstdio>
#include <cstring>

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
        if (strcmp(lv_label_get_text(valueLabel_), buf) != 0) {
            lv_label_set_text(valueLabel_, buf);
        }
    }
}

// --- Speed display with MPH conversion ---
LvglSpeedDisplayNode::LvglSpeedDisplayNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType,
                                            lv_obj_t* valueLabel, lv_obj_t* unitLabel)
    : LvglDisplayNode(widget, layer, entityType)
    , valueLabel_(valueLabel)
    , unitLabel_(unitLabel)
{
}

void LvglSpeedDisplayNode::onBecomeVisible()
{
    LvglDisplayNode::onBecomeVisible();

    // QML: is_mph = (is_mph_arg === 1); valueFrac_ carries the is_mph flag
    bool isMph = (valueFrac_ == 1);
    int displaySpeed = isMph ? (int)(valueInt_ * 0.621371) : valueInt_;

    if (valueLabel_)
    {
        char buf[16];
        snprintf(buf, sizeof(buf), "%d", displaySpeed);
        if (strcmp(lv_label_get_text(valueLabel_), buf) != 0) {
            lv_label_set_text(valueLabel_, buf);
        }
    }

    if (unitLabel_)
    {
        const char* unitText = isMph ? "MPH" : "km/h";
        if (strcmp(lv_label_get_text(unitLabel_), unitText) != 0) {
            lv_label_set_text(unitLabel_, unitText);
        }
    }
}
