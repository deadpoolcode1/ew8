#include "lvgl_test_display_node.h"
#include <cstdio>

// --- Signal Test Item ---

static const char* signalTestColor(int test_status)
{
    switch (test_status) {
        case 0: case 1: return "blu";
        case 2: return "grn";
        case 3: return "red";
        default: return "gry";
    }
}

static lv_color_t signalTestLvColor(int test_status, bool isOn)
{
    if (isOn) return lv_color_white();
    switch (test_status) {
        case 0: case 1: return lv_color_hex(0x5392ff);
        case 2: return lv_color_hex(0x03f921);
        case 3: return lv_color_hex(0xef000c);
        default: return lv_color_hex(0x99a0a6);
    }
}

LvglSignalTestItemNode::LvglSignalTestItemNode(lv_obj_t* smallImg, lv_obj_t* bigImg,
                                               int layer, DISPLAY_ITEM_ID entityType,
                                               const char* wildcard)
    : LvglDisplayNode(nullptr, layer, entityType)
    , smallImg_(smallImg)
    , bigImg_(bigImg)
    , wildcard_(wildcard)
{
}

void LvglSignalTestItemNode::updateImages()
{
    int status = valueInt_;
    bool isOn = (valueFrac_ == 1);
    const char* color = signalTestColor(status);

    // Small icon (50x50)
    char path[128];
    if (isOn) {
        snprintf(path, sizeof(path), "A:images/signal-test/EW8_%s-%s-on.png",
                 wildcard_.c_str(), color);
    } else {
        snprintf(path, sizeof(path), "A:images/signal-test/EW8_%s-%s.png",
                 wildcard_.c_str(), color);
    }
    lv_image_set_src(smallImg_, path);
    lv_obj_remove_flag(smallImg_, LV_OBJ_FLAG_HIDDEN);

    // Big icon (120x120) — only visible when test_status == 1 (active/blue)
    if (status == 1) {
        if (isOn) {
            snprintf(path, sizeof(path), "A:images/signal-test/EW8_%s-%s-on_120x120.png",
                     wildcard_.c_str(), color);
        } else {
            snprintf(path, sizeof(path), "A:images/signal-test/EW8_%s-%s_120x120.png",
                     wildcard_.c_str(), color);
        }
        lv_image_set_src(bigImg_, path);
        lv_obj_remove_flag(bigImg_, LV_OBJ_FLAG_HIDDEN);
    } else {
        lv_obj_add_flag(bigImg_, LV_OBJ_FLAG_HIDDEN);
    }
}

void LvglSignalTestItemNode::onBecomeVisible()
{
    updateImages();
}

void LvglSignalTestItemNode::onBecomeInvisible()
{
    // Reset to gray
    char path[128];
    snprintf(path, sizeof(path), "A:images/signal-test/EW8_%s-gry.png", wildcard_.c_str());
    lv_image_set_src(smallImg_, path);
    lv_obj_add_flag(bigImg_, LV_OBJ_FLAG_HIDDEN);
}

// --- Signal Test Speed ---

LvglSignalTestSpeedNode::LvglSignalTestSpeedNode(lv_obj_t* smallImg, lv_obj_t* bigImg,
                                                 lv_obj_t* smallLabel, lv_obj_t* bigLabel,
                                                 int layer, DISPLAY_ITEM_ID entityType)
    : LvglDisplayNode(nullptr, layer, entityType)
    , smallImg_(smallImg)
    , bigImg_(bigImg)
    , smallLabel_(smallLabel)
    , bigLabel_(bigLabel)
{
}

void LvglSignalTestSpeedNode::updateImages()
{
    // For TEST_SPEED: valueInt_ = test_status (used for both status and isOn),
    // valueFrac_ = displaySpeed
    int status = valueInt_;
    const char* color = signalTestColor(status);
    lv_color_t textColor = signalTestLvColor(status, false);

    // Small icon
    char path[128];
    snprintf(path, sizeof(path), "A:images/signal-test/EW8_Empty-%s.png", color);
    lv_image_set_src(smallImg_, path);
    lv_obj_remove_flag(smallImg_, LV_OBJ_FLAG_HIDDEN);

    // Speed text on small icon
    char speedBuf[8];
    snprintf(speedBuf, sizeof(speedBuf), "%d", valueFrac_);
    lv_label_set_text(smallLabel_, speedBuf);
    lv_obj_set_style_text_color(smallLabel_, textColor, 0);
    lv_obj_remove_flag(smallLabel_, LV_OBJ_FLAG_HIDDEN);

    // Big icon — only visible when test_status == 1
    if (status == 1) {
        snprintf(path, sizeof(path), "A:images/signal-test/EW8_Empty-%s_120x120.png", color);
        lv_image_set_src(bigImg_, path);
        lv_obj_remove_flag(bigImg_, LV_OBJ_FLAG_HIDDEN);

        snprintf(speedBuf, sizeof(speedBuf), "%d", valueFrac_);
        lv_label_set_text(bigLabel_, speedBuf);
        lv_obj_set_style_text_color(bigLabel_, textColor, 0);
        lv_obj_remove_flag(bigLabel_, LV_OBJ_FLAG_HIDDEN);
    } else {
        lv_obj_add_flag(bigImg_, LV_OBJ_FLAG_HIDDEN);
        lv_obj_add_flag(bigLabel_, LV_OBJ_FLAG_HIDDEN);
    }
}

void LvglSignalTestSpeedNode::onBecomeVisible()
{
    updateImages();
}

void LvglSignalTestSpeedNode::onBecomeInvisible()
{
    char path[128];
    snprintf(path, sizeof(path), "A:images/signal-test/EW8_Empty-gry.png");
    lv_image_set_src(smallImg_, path);
    lv_label_set_text(smallLabel_, "X");
    lv_obj_set_style_text_color(smallLabel_, lv_color_hex(0x99a0a6), 0);
    lv_obj_add_flag(bigImg_, LV_OBJ_FLAG_HIDDEN);
    lv_obj_add_flag(bigLabel_, LV_OBJ_FLAG_HIDDEN);
}

// --- Peripheral Test Group ---

LvglPeripheralTestGroupNode::LvglPeripheralTestGroupNode(lv_obj_t* container, int layer,
                                                         DISPLAY_ITEM_ID entityType,
                                                         std::vector<PeripheralSubItem> items,
                                                         lv_obj_t* resultIcon)
    : LvglDisplayNode(container, layer, entityType)
    , items_(std::move(items))
    , resultIcon_(resultIcon)
{
}

void LvglPeripheralTestGroupNode::updateItems()
{
    int testState = valueInt_;   // curr_test_state (0=green, 1=red, 2=blue, 3=hidden)
    int testIndex = valueFrac_;  // curr_test_index

    for (auto& item : items_) {
        // Visibility: _left <= curr_test_index && curr_test_state < 3
        bool visible = (item.rangeLeft <= testIndex) && (testState < 3);

        if (visible) {
            // Status: (_right == testIndex) ? testState : (_right < testIndex ? 0 : (testState==1 ? 1 : 2))
            int itemStatus;
            if (item.rangeRight == testIndex) {
                itemStatus = testState;
            } else if (item.rangeRight < testIndex) {
                itemStatus = 0;  // passed → green
            } else {
                itemStatus = (testState == 1) ? 1 : 2;  // red if failing, blue otherwise
            }

            // Update image based on status
            char path[128];
            const char* suffix;
            switch (itemStatus) {
                case 0: suffix = "grn"; break;
                case 1: suffix = "red"; break;
                default: suffix = "blu"; break;
            }
            snprintf(path, sizeof(path), "A:images/peripheral-test/Peripherals_%s_%s.png",
                     item.wildcard.c_str(), suffix);
            lv_image_set_src(item.icon, path);
            lv_obj_remove_flag(item.icon, LV_OBJ_FLAG_HIDDEN);
        } else {
            lv_obj_add_flag(item.icon, LV_OBJ_FLAG_HIDDEN);
        }
    }

    // Result icon: visible when testState < 2
    if (resultIcon_) {
        if (testState < 2) {
            char path[128];
            snprintf(path, sizeof(path), "A:images/peripheral-test/Peripherals_Result_%s.png",
                     (testState == 0) ? "grn" : "red");
            lv_image_set_src(resultIcon_, path);
            lv_obj_remove_flag(resultIcon_, LV_OBJ_FLAG_HIDDEN);
        } else {
            lv_obj_add_flag(resultIcon_, LV_OBJ_FLAG_HIDDEN);
        }
    }
}

void LvglPeripheralTestGroupNode::onBecomeVisible()
{
    if (widget_) {
        lv_obj_remove_flag(widget_, LV_OBJ_FLAG_HIDDEN);
    }
    updateItems();
}

void LvglPeripheralTestGroupNode::onBecomeInvisible()
{
    if (widget_) {
        lv_obj_add_flag(widget_, LV_OBJ_FLAG_HIDDEN);
    }
    for (auto& item : items_) {
        lv_obj_add_flag(item.icon, LV_OBJ_FLAG_HIDDEN);
    }
    if (resultIcon_) {
        lv_obj_add_flag(resultIcon_, LV_OBJ_FLAG_HIDDEN);
    }
}
