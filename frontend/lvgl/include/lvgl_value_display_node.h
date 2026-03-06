#ifndef LVGL_VALUE_DISPLAY_NODE_H
#define LVGL_VALUE_DISPLAY_NODE_H

#include "lvgl_display_node.h"

class LvglValueDisplayNode : public LvglDisplayNode {
public:
    LvglValueDisplayNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType, lv_obj_t* valueLabel);

    void onBecomeVisible() override;

private:
    lv_obj_t* valueLabel_;
};

// Speed display node with MPH conversion support
// QML: is_mph = (unit === 1); displaySpeed = is_mph ? (speed * 0.621371) : speed
class LvglSpeedDisplayNode : public LvglDisplayNode {
public:
    LvglSpeedDisplayNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType,
                          lv_obj_t* valueLabel, lv_obj_t* unitLabel);

    void onBecomeVisible() override;

private:
    lv_obj_t* valueLabel_;
    lv_obj_t* unitLabel_;
};

#endif // LVGL_VALUE_DISPLAY_NODE_H
