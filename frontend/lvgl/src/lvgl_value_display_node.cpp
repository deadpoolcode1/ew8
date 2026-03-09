#include "lvgl_value_display_node.h"
#include <cstdio>
#include <cstring>

// QML: IntelOne Display Medium, pixelSize 36, scale 1.6-(len*0.2), SideIcon 0.732
// Base font: 44px. Container transform scales at 0.732 → 44*0.732 = 32.2px (2-digit target).
// QML effective on-screen: 1-digit ~37px, 2-digit ~32px, 3-digit ~26px
// Label transform_scale adjusts for digit count:
//   1-digit: 37/32.2 = 1.15 → 294
//   2-digit: 32/32.2 = 1.0  → 256 (no transform)
//   3-digit: 26/32.2 = 0.81 → 207
static int speedSignTextScale(int textLen)
{
    if (textLen <= 1) return 294;
    if (textLen == 2) return 256;
    return 207;
}

LvglValueDisplayNode::LvglValueDisplayNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType,
                                             lv_obj_t* valueLabel, int divideFactor)
    : LvglDisplayNode(widget, layer, entityType)
    , valueLabel_(valueLabel)
    , divideFactor_(divideFactor)
{
}

void LvglValueDisplayNode::onBecomeVisible()
{
    bool wasHidden = widget_ && lv_obj_has_flag(widget_, LV_OBJ_FLAG_HIDDEN);

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
            // Value changed while already visible — replay intro animation
            if (!wasHidden && introContainerMode_ && widget_) {
                lv_obj_set_style_transform_scale_x(widget_, introStartScale_, 0);
                lv_obj_set_style_transform_scale_y(widget_, introStartScale_, 0);
                playIntroAnim();
            } else if (!wasHidden && introAnimImg_) {
                lv_image_set_scale(introAnimImg_, introStartScale_);
                if (introTargetImgX_ != 0 || introTargetImgY_ != 0) {
                    lv_obj_set_pos(introAnimImg_, 0, 0);
                }
                playIntroAnim();
            }
            lv_label_set_text(valueLabel_, buf);
            int ts = speedSignTextScale(strlen(buf));
            lv_obj_set_style_transform_scale_x(valueLabel_, ts, 0);
            lv_obj_set_style_transform_scale_y(valueLabel_, ts, 0);
            lv_obj_align(valueLabel_, LV_ALIGN_CENTER, 0, 0);
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
        // QML: isTamperAlert → canEntityArg = 0xDA, else show error code in hex
        // Backend passes: valueInt_=errorCode, valueFrac_=isTamperAlert
        if (valueFrac_) {
            snprintf(buf, sizeof(buf), "DA");
        } else {
            snprintf(buf, sizeof(buf), "%X", valueInt_);
        }
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
