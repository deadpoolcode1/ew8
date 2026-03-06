#include "lvgl_menu_display_node.h"
#include "lvgl_menu_controller.h"

// --- VOLUME_DONE ---
LvglVolumeDoneNode::LvglVolumeDoneNode(int layer, DISPLAY_ITEM_ID entityType, LvglMenuController* ctrl)
    : LvglDisplayNode(nullptr, layer, entityType)
    , ctrl_(ctrl)
{
}

void LvglVolumeDoneNode::onBecomeVisible()
{
    // valueInt_ = volume, valueFrac_ = min, unit_ = max
    ctrl_->showVolumeMenu(valueInt_, valueFrac_, unit_);
}

void LvglVolumeDoneNode::onBecomeInvisible()
{
    ctrl_->hideVolumeMenu();
}

// --- VOLUME_FAIL ---
LvglVolumeFailNode::LvglVolumeFailNode(int layer, DISPLAY_ITEM_ID entityType, LvglMenuController* ctrl)
    : LvglDisplayNode(nullptr, layer, entityType)
    , ctrl_(ctrl)
{
}

void LvglVolumeFailNode::onBecomeVisible()
{
    ctrl_->showVolumeFail();
}

void LvglVolumeFailNode::onBecomeInvisible()
{
    ctrl_->hideVolumeMenu();
}

// --- INFO_QRCODE ---
LvglQRCodeNode::LvglQRCodeNode(int layer, DISPLAY_ITEM_ID entityType, LvglMenuController* ctrl)
    : LvglDisplayNode(nullptr, layer, entityType)
    , ctrl_(ctrl)
{
}

void LvglQRCodeNode::onBecomeVisible()
{
    ctrl_->showQRCode(stringArg_);
}

void LvglQRCodeNode::onBecomeInvisible()
{
    ctrl_->hideQRCode();
}
