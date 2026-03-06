#include "lvgl_blink_display_node.h"

static void blinkAnimCb(void* obj, int32_t val)
{
    lv_obj_set_style_opa(static_cast<lv_obj_t*>(obj), val, 0);
}

LvglBlinkDisplayNode::LvglBlinkDisplayNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType)
    : LvglDisplayNode(widget, layer, entityType)
{
}

void LvglBlinkDisplayNode::onBecomeVisible()
{
    if (widget_)
    {
        lv_obj_set_style_opa(widget_, LV_OPA_COVER, 0);
        lv_obj_remove_flag(widget_, LV_OBJ_FLAG_HIDDEN);

        // QML LDW blink: 300ms fade-out, 500ms pause, 300ms fade-in, 500ms pause (InOutQuad)
        lv_anim_t anim;
        lv_anim_init(&anim);
        lv_anim_set_var(&anim, widget_);
        lv_anim_set_values(&anim, LV_OPA_COVER, LV_OPA_TRANSP);
        lv_anim_set_duration(&anim, 300);
        lv_anim_set_playback_duration(&anim, 300);
        lv_anim_set_playback_delay(&anim, 500);   // pause at transparent before fade-in
        lv_anim_set_repeat_delay(&anim, 500);      // pause at opaque before next fade-out
        lv_anim_set_repeat_count(&anim, LV_ANIM_REPEAT_INFINITE);
        lv_anim_set_exec_cb(&anim, blinkAnimCb);
        lv_anim_start(&anim);
    }
}

void LvglBlinkDisplayNode::onBecomeInvisible()
{
    if (widget_)
    {
        lv_anim_delete(widget_, blinkAnimCb);
        lv_obj_set_style_opa(widget_, LV_OPA_COVER, 0);
        lv_obj_add_flag(widget_, LV_OBJ_FLAG_HIDDEN);
    }
}
