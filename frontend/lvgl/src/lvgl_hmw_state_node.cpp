#include "lvgl_hmw_state_node.h"

bool LvglHmwStateNode::carInitialized_ = false;
int  LvglHmwStateNode::carTargetScale_ = 0;
const char* LvglHmwStateNode::currentGifSrc_ = nullptr;

LvglHmwStateNode::LvglHmwStateNode(int layer, DISPLAY_ITEM_ID entityType,
                                     lv_obj_t* roadStrip, const char* gifSrc,
                                     lv_obj_t* forwardCar, int carMargin,
                                     int carScaleX, int carScaleY)
    : LvglDisplayNode(nullptr, layer, entityType)
    , roadStrip_(roadStrip)
    , gifSrc_(gifSrc)
    , forwardCar_(forwardCar)
    , carMargin_(carMargin)
    , carScaleX_(carScaleX)
    , carScaleY_(carScaleY)
{
}

// Animation callbacks for forward car transitions
static void hmwCarMarginAnimCb(void* obj, int32_t val)
{
    lv_obj_align(static_cast<lv_obj_t*>(obj), LV_ALIGN_TOP_MID, 0, val);
}

static void hmwCarScaleXAnimCb(void* obj, int32_t val)
{
    lv_image_set_scale_x(static_cast<lv_obj_t*>(obj), val);
}

static void hmwCarScaleYAnimCb(void* obj, int32_t val)
{
    lv_image_set_scale_y(static_cast<lv_obj_t*>(obj), val);
}

void LvglHmwStateNode::onBecomeVisible()
{
    if (roadStrip_ && currentGifSrc_ != gifSrc_)
    {
        lv_gif_set_src(roadStrip_, gifSrc_);
        currentGifSrc_ = gifSrc_;
    }

    if (forwardCar_)
    {
        // Skip if we're already targeting this state (avoids restarting animation each frame)
        if (carTargetScale_ == carScaleX_) return;

        if (carInitialized_) {
            // QML: 700ms InOutQuad transition on car_margin and car_scale
            int currentMargin = lv_obj_get_y(forwardCar_);
            int currentScaleX = lv_image_get_scale_x(forwardCar_);
            int currentScaleY = lv_image_get_scale_y(forwardCar_);

            // Cancel any running animations before starting new ones
            lv_anim_delete(forwardCar_, hmwCarMarginAnimCb);
            lv_anim_delete(forwardCar_, hmwCarScaleXAnimCb);
            lv_anim_delete(forwardCar_, hmwCarScaleYAnimCb);

            // Animate margin (y position)
            lv_anim_t marginAnim;
            lv_anim_init(&marginAnim);
            lv_anim_set_var(&marginAnim, forwardCar_);
            lv_anim_set_values(&marginAnim, currentMargin, carMargin_);
            lv_anim_set_duration(&marginAnim, 700);
            lv_anim_set_path_cb(&marginAnim, lv_anim_path_ease_in_out);
            lv_anim_set_exec_cb(&marginAnim, hmwCarMarginAnimCb);
            lv_anim_start(&marginAnim);

            // Animate X scale
            lv_anim_t scaleXAnim;
            lv_anim_init(&scaleXAnim);
            lv_anim_set_var(&scaleXAnim, forwardCar_);
            lv_anim_set_values(&scaleXAnim, currentScaleX, carScaleX_);
            lv_anim_set_duration(&scaleXAnim, 700);
            lv_anim_set_path_cb(&scaleXAnim, lv_anim_path_ease_in_out);
            lv_anim_set_exec_cb(&scaleXAnim, hmwCarScaleXAnimCb);
            lv_anim_start(&scaleXAnim);

            // Animate Y scale
            lv_anim_t scaleYAnim;
            lv_anim_init(&scaleYAnim);
            lv_anim_set_var(&scaleYAnim, forwardCar_);
            lv_anim_set_values(&scaleYAnim, currentScaleY, carScaleY_);
            lv_anim_set_duration(&scaleYAnim, 700);
            lv_anim_set_path_cb(&scaleYAnim, lv_anim_path_ease_in_out);
            lv_anim_set_exec_cb(&scaleYAnim, hmwCarScaleYAnimCb);
            lv_anim_start(&scaleYAnim);
        } else {
            // First activation — snap to position
            lv_obj_align(forwardCar_, LV_ALIGN_TOP_MID, 0, carMargin_);
            lv_image_set_scale_x(forwardCar_, carScaleX_);
            lv_image_set_scale_y(forwardCar_, carScaleY_);
            carInitialized_ = true;
        }
        carTargetScale_ = carScaleX_;
    }
}

void LvglHmwStateNode::onBecomeInvisible()
{
    // Reset target so next onBecomeVisible will trigger animation
    if (carTargetScale_ == carScaleX_) {
        carTargetScale_ = 0;
    }
    if (currentGifSrc_ == gifSrc_) {
        currentGifSrc_ = nullptr;
    }
}
