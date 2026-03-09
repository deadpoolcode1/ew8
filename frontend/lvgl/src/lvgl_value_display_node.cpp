#include "lvgl_value_display_node.h"
#include <cstdio>
#include <cstring>

LV_FONT_DECLARE(intelone_medium_36);
LV_FONT_DECLARE(intelone_medium_44);

// QML: IntelOne Display Medium, pixelSize 36, scale 1.6-(len*0.2), SideIcon 0.732
// Container transform at 0.732 scales all children.
// QML effective on-screen: 1-digit ~37px, 2-digit ~32px, 3-digit ~26px
// Strategy: switch font + transform_scale per digit count to match QML.
//   1-digit: 44px font, scale 294 (1.15x) → 44*0.732*1.15 = 37px
//   2-digit: 44px font, scale 256 (1.0x)  → 44*0.732 = 32px
//   3-digit: 36px font, scale 256 (1.0x)  → 36*0.732 = 26px
static void applySpeedTextStyle(lv_obj_t* label, int textLen)
{
    if (textLen <= 1) {
        lv_obj_set_style_text_font(label, &intelone_medium_44, 0);
        lv_obj_set_style_transform_scale_x(label, 294, 0);
        lv_obj_set_style_transform_scale_y(label, 294, 0);
    } else if (textLen == 2) {
        lv_obj_set_style_text_font(label, &intelone_medium_44, 0);
        lv_obj_set_style_transform_scale_x(label, 256, 0);
        lv_obj_set_style_transform_scale_y(label, 256, 0);
    } else {
        lv_obj_set_style_text_font(label, &intelone_medium_36, 0);
        lv_obj_set_style_transform_scale_x(label, 256, 0);
        lv_obj_set_style_transform_scale_y(label, 256, 0);
    }
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
                if (introContainerYAnim_) {
                    lv_obj_set_y(widget_, introContainerStartY_);
                }
                if (introContainerXAnim_) {
                    lv_obj_set_x(widget_, introContainerStartX_);
                }
                playIntroAnim();
            } else if (!wasHidden && introAnimImg_) {
                lv_image_set_scale(introAnimImg_, introStartScale_);
                if (introTargetImgX_ != 0 || introTargetImgY_ != 0) {
                    lv_obj_set_pos(introAnimImg_, 0, 0);
                }
                playIntroAnim();
            }
            lv_label_set_text(valueLabel_, buf);
            if (divideFactor_ == 0) {
                applySpeedTextStyle(valueLabel_, strlen(buf));
                lv_obj_align(valueLabel_, LV_ALIGN_CENTER, 0, 2);
            }
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
