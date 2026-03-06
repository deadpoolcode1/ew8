#ifndef LVGL_HMW_STATE_NODE_H
#define LVGL_HMW_STATE_NODE_H

#include "lvgl_display_node.h"

// Display node that changes the HMW road strip GIF source when it becomes visible.
// Also repositions the forward car based on state-specific car_margin and car_scale.
// Has no widget of its own (widget_=nullptr); modifies the road strip GIF in-place.
class LvglHmwStateNode : public LvglDisplayNode {
public:
    LvglHmwStateNode(int layer, DISPLAY_ITEM_ID entityType,
                     lv_obj_t* roadStrip, const char* gifSrc,
                     lv_obj_t* forwardCar = nullptr, int carMargin = 40, int carScale = 192);

    void onBecomeVisible() override;
    void onBecomeInvisible() override;

private:
    lv_obj_t* roadStrip_;
    const char* gifSrc_;
    lv_obj_t* forwardCar_;
    int carMargin_;     // QML: car_margin (top margin for forward car)
    int carScale_;      // LVGL scale factor (256 = 1.0)
};

#endif // LVGL_HMW_STATE_NODE_H
