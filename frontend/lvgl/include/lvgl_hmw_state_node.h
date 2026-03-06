#ifndef LVGL_HMW_STATE_NODE_H
#define LVGL_HMW_STATE_NODE_H

#include "lvgl_display_node.h"

// Display node that changes the HMW road strip GIF source when it becomes visible.
// Has no widget of its own (widget_=nullptr); modifies the road strip GIF in-place.
class LvglHmwStateNode : public LvglDisplayNode {
public:
    LvglHmwStateNode(int layer, DISPLAY_ITEM_ID entityType,
                     lv_obj_t* roadStrip, const char* gifSrc);

    void onBecomeVisible() override;
    void onBecomeInvisible() override;

private:
    lv_obj_t* roadStrip_;
    const char* gifSrc_;
};

#endif // LVGL_HMW_STATE_NODE_H
