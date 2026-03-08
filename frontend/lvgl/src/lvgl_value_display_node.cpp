#include "lvgl_value_display_node.h"
#include <cstdio>
#include <cstring>

LvglValueDisplayNode::LvglValueDisplayNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType,
                                             lv_obj_t* valueLabel, int divideFactor)
    : LvglDisplayNode(widget, layer, entityType)
    , valueLabel_(valueLabel)
    , divideFactor_(divideFactor)
{
}

void LvglValueDisplayNode::onBecomeVisible()
{
    LvglDisplayNode::onBecomeVisible();

    if (valueLabel_)
    {
        char buf[16];
        if (divideFactor_ > 0) {
            // QML: (canEntityArg/10).toFixed(1) → e.g., 12 → "1.2"
            int whole = valueInt_ / divideFactor_;
            int frac = valueInt_ % divideFactor_;
            snprintf(buf, sizeof(buf), "%d.%d", whole, frac);
        } else {
            snprintf(buf, sizeof(buf), "%d", valueInt_);
        }
        if (strcmp(lv_label_get_text(valueLabel_), buf) != 0) {
            lv_label_set_text(valueLabel_, buf);
        }
    }
}

// --- Error display with hex code ---
LvglErrorDisplayNode::LvglErrorDisplayNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType,
                                             lv_obj_t* codeLabel)
    : LvglDisplayNode(widget, layer, entityType)
    , codeLabel_(codeLabel)
{
}

void LvglErrorDisplayNode::onBecomeVisible()
{
    LvglDisplayNode::onBecomeVisible();
    if (codeLabel_) {
        char buf[8];
        snprintf(buf, sizeof(buf), "%X", valueInt_);
        lv_label_set_text(codeLabel_, buf);
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
    // QML: opacity = speed_available && show_speed.visible
    // Speed only shows when both INFO_VEH_SPEED and INFO_SPEED_SHOW are active
    if (speedShowNode_ && speedShowNode_->getActivSem() <= 0) {
        // INFO_SPEED_SHOW not active — hide speed display
        if (widget_ && !lv_obj_has_flag(widget_, LV_OBJ_FLAG_HIDDEN)) {
            lv_obj_add_flag(widget_, LV_OBJ_FLAG_HIDDEN);
        }
        return;
    }

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
