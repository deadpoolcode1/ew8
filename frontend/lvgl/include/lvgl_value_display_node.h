#ifndef LVGL_VALUE_DISPLAY_NODE_H
#define LVGL_VALUE_DISPLAY_NODE_H

#include "lvgl_display_node.h"

class LvglValueDisplayNode : public LvglDisplayNode {
public:
    LvglValueDisplayNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType,
                          lv_obj_t* valueLabel, int divideFactor = 0);

    void setShapeUsaNode(LvglDisplayNode* node) { shapeUsaNode_ = node; }
    void onBecomeVisible() override;

private:
    lv_obj_t* valueLabel_;
    int divideFactor_;  // If >0, display valueInt_/factor with 1 decimal (e.g., 12 → "1.2")
    LvglDisplayNode* shapeUsaNode_ = nullptr;
};

// Speed display node with MPH conversion support
// QML: is_mph = (unit === 1); displaySpeed = is_mph ? (speed * 0.621371) : speed
class LvglSpeedDisplayNode : public LvglDisplayNode {
public:
    LvglSpeedDisplayNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType,
                          lv_obj_t* valueLabel, lv_obj_t* unitLabel);

    void setSpeedShowNode(LvglDisplayNode* node) { speedShowNode_ = node; }
    void onBecomeVisible() override;

    // Raw vehicle speed value last received (km/h, before MPH conversion).
    // Used to reproduce the QML isDisplayOfMenusEnabled gate (speed.canEntityArg).
    int getSpeedValue() const { return valueInt_; }

private:
    lv_obj_t* valueLabel_;
    lv_obj_t* unitLabel_;
    LvglDisplayNode* speedShowNode_ = nullptr;
};

// Error overlay node — shows hex error code in label
class LvglErrorDisplayNode : public LvglDisplayNode {
public:
    LvglErrorDisplayNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType,
                          lv_obj_t* codeLabel);
    void onBecomeVisible() override;
private:
    lv_obj_t* codeLabel_;
};

#endif // LVGL_VALUE_DISPLAY_NODE_H
