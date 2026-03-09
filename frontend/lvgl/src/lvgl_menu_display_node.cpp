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
    ctrl_->activateQRCode(stringArg_);
}

void LvglQRCodeNode::onBecomeInvisible()
{
    ctrl_->deactivateQRCode();
}

// --- Supplementary sign node ---
LvglSuppSignNode::LvglSuppSignNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType,
                                   lv_obj_t* suppImg, lv_obj_t* speedLabel)
    : LvglDisplayNode(widget, layer, entityType)
    , suppImg_(suppImg)
    , speedLabel_(speedLabel)
{
}

const char* LvglSuppSignNode::getSuppImagePath(int suppValue)
{
    // QML Supp.qml mapping: value → image
    switch (suppValue) {
    case 1:  return "A:images/left-panel/Supp/rain.png";
    case 2:  return "A:images/left-panel/Supp/snow.png";
    case 4:  return "A:images/left-panel/Supp/time.png";
    case 5:  return "A:images/left-panel/Supp/left_arrow.png";
    case 6:  return "A:images/left-panel/Supp/right_arrow.png";
    case 7:  return "A:images/left-panel/Supp/left_bottom_arrow.png";
    case 8:  return "A:images/left-panel/Supp/right_bottom_arrow.png";
    case 9:  return "A:images/left-panel/Supp/truck.png";
    case 11: return "A:images/left-panel/Supp/weight.png";
    case 12: return "A:images/left-panel/Supp/distance.png";
    case 13: return "A:images/left-panel/Supp/tractor.png";
    case 14: return "A:images/left-panel/Supp/snow_with_rain.png";
    case 22: return "A:images/left-panel/Supp/zone.png";
    default: return nullptr;
    }
}

void LvglSuppSignNode::onBecomeVisible()
{
    // Backend: activate(id, argInt=speed, suppType) → valueInt_=speed, valueFrac_=suppType
    // Update supplementary icon image based on supp type (valueFrac_)
    if (suppImg_) {
        const char* path = getSuppImagePath(valueFrac_);
        if (path) {
            lv_image_set_src(suppImg_, path);
        }
    }
    // Update speed label if present (SLI_SUPP shows speed inside the sign)
    if (speedLabel_) {
        char buf[8];
        snprintf(buf, sizeof(buf), "%d", valueInt_);
        lv_label_set_text(speedLabel_, buf);
    }
    LvglDisplayNode::onBecomeVisible();
}

// --- SHAPE_USA ---
LvglShapeUsaNode::LvglShapeUsaNode(int layer, DISPLAY_ITEM_ID entityType,
                                     lv_obj_t* sliSignImg, lv_obj_t* sliSuppSignImg,
                                     lv_obj_t* sliSpeedLabel)
    : LvglDisplayNode(nullptr, layer, entityType)
    , sliSignImg_(sliSignImg)
    , sliSuppSignImg_(sliSuppSignImg)
    , sliSpeedLabel_(sliSpeedLabel)
{
}

void LvglShapeUsaNode::onBecomeVisible()
{
    // Switch to rectangular sign image (98x112 vs circular 112x112)
    if (sliSignImg_) {
        lv_image_set_src(sliSignImg_, "A:images/left-panel/SLI/left_SLI_rect.png");
        // Rect image center is at (49,56), not (56,56). Adjust pivot for correct centering.
        lv_image_set_pivot(sliSignImg_, 49, 56);
    }
    if (sliSuppSignImg_) {
        lv_image_set_src(sliSuppSignImg_, "A:images/left-panel/SLI/left_SLI_rect.png");
        lv_image_set_pivot(sliSuppSignImg_, 49, 56);
    }
    // QML: USA rect shape: verticalCenterOffset=17, horizontalCenterOffset=2, font=30
    // With rect pivot (49,56), the sign visual center shifts ~5px left vs circular.
    // Compensate label position: offset -3 instead of +2 to stay centered on rect sign.
    if (sliSpeedLabel_) {
        lv_obj_align(sliSpeedLabel_, LV_ALIGN_CENTER, -3, 17);
        lv_obj_set_style_text_font(sliSpeedLabel_, &lv_font_montserrat_20, 0);
    }
}

void LvglShapeUsaNode::onBecomeInvisible()
{
    // Restore circular sign image and pivot
    if (sliSignImg_) {
        lv_image_set_src(sliSignImg_, "A:images/left-panel/SLI/left_SLI_circ.png");
        lv_image_set_pivot(sliSignImg_, 56, 56);
    }
    if (sliSuppSignImg_) {
        lv_image_set_src(sliSuppSignImg_, "A:images/left-panel/SLI/left_SLI_circ.png");
        lv_image_set_pivot(sliSuppSignImg_, 56, 56);
    }
    // Restore circular sign text position and font (QML: horizontalCenterOffset=2)
    if (sliSpeedLabel_) {
        lv_obj_align(sliSpeedLabel_, LV_ALIGN_CENTER, 0, 0);
        lv_obj_set_style_text_font(sliSpeedLabel_, &lv_font_montserrat_22, 0);
    }
}

// --- ALERT_ISA_OVERSPEED ---
LvglOverspeedBlinkNode::LvglOverspeedBlinkNode(int layer, DISPLAY_ITEM_ID entityType,
                                                lv_obj_t* sliWidget, lv_obj_t* isaSpeedWidget)
    : LvglDisplayNode(nullptr, layer, entityType)
    , sliWidget_(sliWidget)
    , isaSpeedWidget_(isaSpeedWidget)
{
}

void LvglOverspeedBlinkNode::blinkAnimCb(void* obj, int32_t val)
{
    lv_obj_set_style_opa(static_cast<lv_obj_t*>(obj), val, 0);
}

void LvglOverspeedBlinkNode::startBlink(lv_obj_t* widget)
{
    if (!widget) return;
    // QML pattern: 300ms fade 1→0, 500ms pause, 300ms fade 0→1, 500ms pause
    // LVGL anim: values 255→0, duration 300ms, playback 300ms, delay 500ms (pause after fade-out)
    // playback_delay for pause after fade-in
    lv_anim_t anim;
    lv_anim_init(&anim);
    lv_anim_set_var(&anim, widget);
    lv_anim_set_values(&anim, LV_OPA_COVER, LV_OPA_TRANSP);
    lv_anim_set_duration(&anim, 300);
    lv_anim_set_playback_duration(&anim, 300);
    lv_anim_set_playback_delay(&anim, 500);   // pause after fade-out (at transparent)
    lv_anim_set_repeat_delay(&anim, 500);      // pause after fade-in (at opaque) before next cycle
    lv_anim_set_repeat_count(&anim, LV_ANIM_REPEAT_INFINITE);
    lv_anim_set_exec_cb(&anim, blinkAnimCb);
    lv_anim_start(&anim);
}

void LvglOverspeedBlinkNode::stopBlink(lv_obj_t* widget)
{
    if (!widget) return;
    lv_anim_delete(widget, blinkAnimCb);
    lv_obj_set_style_opa(widget, LV_OPA_COVER, 0);
}

void LvglOverspeedBlinkNode::onBecomeVisible()
{
    if (!blinking_) {
        blinking_ = true;
        startBlink(sliWidget_);
        startBlink(isaSpeedWidget_);
    }
}

void LvglOverspeedBlinkNode::onBecomeInvisible()
{
    if (blinking_) {
        blinking_ = false;
        stopBlink(sliWidget_);
        stopBlink(isaSpeedWidget_);
    }
}

// --- STATE_ISA_NOT_TSR ---
LvglIsaStateNode::LvglIsaStateNode(int layer, DISPLAY_ITEM_ID entityType, LvglMenuController* ctrl)
    : LvglDisplayNode(nullptr, layer, entityType)
    , ctrl_(ctrl)
{
}

void LvglIsaStateNode::onBecomeVisible()
{
    ctrl_->setIsaAvailable(true);
}

void LvglIsaStateNode::onBecomeInvisible()
{
    ctrl_->setIsaAvailable(false);
}

// --- STATE_TSR_NOT_ISA ---
LvglTsrStateNode::LvglTsrStateNode(int layer, DISPLAY_ITEM_ID entityType, LvglMenuController* ctrl)
    : LvglDisplayNode(nullptr, layer, entityType)
    , ctrl_(ctrl)
{
}

void LvglTsrStateNode::onBecomeVisible()
{
    ctrl_->setIsaAvailable(false);
}

void LvglTsrStateNode::onBecomeInvisible()
{
    // TSR deactivation doesn't change ISA state
}
