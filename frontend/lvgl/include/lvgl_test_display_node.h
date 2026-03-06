#ifndef LVGL_TEST_DISPLAY_NODE_H
#define LVGL_TEST_DISPLAY_NODE_H

#include "lvgl_display_node.h"
#include <string>
#include <vector>

// Signal test item node: manages a small grid icon + big centered icon
// that change image based on test_status (valueInt_) and isOn (valueFrac_)
class LvglSignalTestItemNode : public LvglDisplayNode {
public:
    LvglSignalTestItemNode(lv_obj_t* smallImg, lv_obj_t* bigImg,
                           int layer, DISPLAY_ITEM_ID entityType,
                           const char* wildcard);

    void onBecomeVisible() override;
    void onBecomeInvisible() override;

private:
    void updateImages();
    lv_obj_t* smallImg_;
    lv_obj_t* bigImg_;
    std::string wildcard_;
};

// Signal test speed node: like SignalTestItemNode but with text labels for speed
class LvglSignalTestSpeedNode : public LvglDisplayNode {
public:
    LvglSignalTestSpeedNode(lv_obj_t* smallImg, lv_obj_t* bigImg,
                            lv_obj_t* smallLabel, lv_obj_t* bigLabel,
                            int layer, DISPLAY_ITEM_ID entityType);

    void onBecomeVisible() override;
    void onBecomeInvisible() override;

private:
    void updateImages();
    lv_obj_t* smallImg_;
    lv_obj_t* bigImg_;
    lv_obj_t* smallLabel_;
    lv_obj_t* bigLabel_;
};

// Peripheral test group sub-item descriptor
struct PeripheralSubItem {
    lv_obj_t* icon;
    std::string wildcard;
    int rangeLeft;
    int rangeRight;
};

// Peripheral test group node: manages a row of sub-items + result icon
// Updates sub-item images based on curr_test_state (valueInt_) and curr_test_index (valueFrac_)
class LvglPeripheralTestGroupNode : public LvglDisplayNode {
public:
    LvglPeripheralTestGroupNode(lv_obj_t* container, int layer,
                                DISPLAY_ITEM_ID entityType,
                                std::vector<PeripheralSubItem> items,
                                lv_obj_t* resultIcon);

    void onBecomeVisible() override;
    void onBecomeInvisible() override;

private:
    void updateItems();
    std::vector<PeripheralSubItem> items_;
    lv_obj_t* resultIcon_;
};

#endif // LVGL_TEST_DISPLAY_NODE_H
