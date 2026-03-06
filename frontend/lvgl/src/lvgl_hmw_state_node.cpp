#include "lvgl_hmw_state_node.h"

LvglHmwStateNode::LvglHmwStateNode(int layer, DISPLAY_ITEM_ID entityType,
                                     lv_obj_t* roadStrip, const char* gifSrc)
    : LvglDisplayNode(nullptr, layer, entityType)
    , roadStrip_(roadStrip)
    , gifSrc_(gifSrc)
{
}

void LvglHmwStateNode::onBecomeVisible()
{
    if (roadStrip_)
    {
        lv_gif_set_src(roadStrip_, gifSrc_);
    }
}

void LvglHmwStateNode::onBecomeInvisible()
{
    // No-op: the other state node will set the correct GIF when it activates
}
