#include "lvgl_hmw_state_node.h"

LvglHmwStateNode::LvglHmwStateNode(int layer, DISPLAY_ITEM_ID entityType,
                                     lv_obj_t* roadStrip, const char* gifSrc,
                                     lv_obj_t* forwardCar, int carMargin, int carScale)
    : LvglDisplayNode(nullptr, layer, entityType)
    , roadStrip_(roadStrip)
    , gifSrc_(gifSrc)
    , forwardCar_(forwardCar)
    , carMargin_(carMargin)
    , carScale_(carScale)
{
}

void LvglHmwStateNode::onBecomeVisible()
{
    if (roadStrip_)
    {
        lv_gif_set_src(roadStrip_, gifSrc_);
    }

    if (forwardCar_)
    {
        lv_obj_align(forwardCar_, LV_ALIGN_TOP_MID, 0, carMargin_);
        lv_image_set_scale(forwardCar_, carScale_);
    }
}

void LvglHmwStateNode::onBecomeInvisible()
{
    // No-op: the other state node will set the correct GIF/position when it activates
}
