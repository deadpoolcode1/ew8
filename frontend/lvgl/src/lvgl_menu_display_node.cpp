#include "lvgl_menu_display_node.h"
#include "lvgl_menu_controller.h"
#include <cstring>

LV_FONT_DECLARE(intelone_medium_44);

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

// QML: IntelOne Display Medium, pixelSize 36, scale 1.6-(len*0.2), SideIcon 0.732
// Container transform at 0.732 scales all children.
//   1-digit: 44px font, scale 294 → 37px on screen
//   2-digit: 44px font, scale 256 → 32px on screen
//   3-digit: 36px font, scale 256 → 26px on screen
LV_FONT_DECLARE(intelone_medium_36);
static void applySpeedTextStyle(lv_obj_t* label, int textLen)
{
    if (textLen <= 1) {
        lv_obj_set_style_text_font(label, &intelone_medium_44, 0);
        lv_obj_set_style_transform_scale_x(label, 294, 0);
        lv_obj_set_style_transform_scale_y(label, 294, 0);
    } else if (textLen == 2) {
        lv_obj_set_style_text_font(label, &intelone_medium_44, 0);
        lv_obj_set_style_transform_scale_x(label, 256, 0);
        lv_obj_set_style_transform_scale_y(label, 256, 0);
    } else {
        lv_obj_set_style_text_font(label, &intelone_medium_36, 0);
        lv_obj_set_style_transform_scale_x(label, 256, 0);
        lv_obj_set_style_transform_scale_y(label, 256, 0);
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
        applySpeedTextStyle(speedLabel_, strlen(buf));
        // Container is 160px tall for supp (to fit icon below), but sign image is 112px.
        // Sign center is at y=56, container center at y=80. Offset: 56-80+2 = -22.
        lv_obj_align(speedLabel_, LV_ALIGN_CENTER, 0, -22);
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
    wasUsaActive_ = true;
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
        lv_obj_align(sliSpeedLabel_, LV_ALIGN_CENTER, -8, 22);
    }
    // Replay SLI intro animation when shape changes
    if (sliNode_) {
        sliNode_->replayIntroAnim();
    }
}

void LvglShapeUsaNode::onBecomeInvisible()
{
    // Only act on actual visible→invisible transitions
    if (!wasUsaActive_) return;
    wasUsaActive_ = false;

    // Restore circular sign image and pivot
    if (sliSignImg_) {
        lv_image_set_src(sliSignImg_, "A:images/left-panel/SLI/left_SLI_circ.png");
        lv_image_set_pivot(sliSignImg_, 56, 56);
    }
    if (sliSuppSignImg_) {
        lv_image_set_src(sliSuppSignImg_, "A:images/left-panel/SLI/left_SLI_circ.png");
        lv_image_set_pivot(sliSuppSignImg_, 56, 56);
    }
    // Restore circular sign text position and font
    if (sliSpeedLabel_) {
        lv_obj_align(sliSpeedLabel_, LV_ALIGN_CENTER, 0, 2);
        lv_obj_set_style_text_font(sliSpeedLabel_, &intelone_medium_44, 0);
    }
    // Replay SLI intro animation when shape changes back
    if (sliNode_) {
        sliNode_->replayIntroAnim();
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
    lv_anim_set_duration(&anim, 180);
    lv_anim_set_playback_duration(&anim, 180);
    lv_anim_set_playback_delay(&anim, 550);   // pause after fade-out (at transparent)
    lv_anim_set_repeat_delay(&anim, 550);      // pause after fade-in (at opaque) before next cycle
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

void LvglIsaStateNode::initTimerCb(lv_timer_t* timer)
{
    auto* node = static_cast<LvglIsaStateNode*>(lv_timer_get_user_data(timer));
    node->isaInitPhase_ = false;
    node->initTimer_ = nullptr;
    // End forced display — hide error widget and restore the inactive widget
    if (node->isaErrorWidget_) {
        lv_obj_add_flag(node->isaErrorWidget_, LV_OBJ_FLAG_HIDDEN);
    }
    if (node->isaInactiveWidget_) {
        lv_obj_remove_flag(node->isaInactiveWidget_, LV_OBJ_FLAG_HIDDEN);
    }
}

bool LvglIsaStateNode::shouldShowInitPhase() const
{
    // Condition 1: No ISA sign image is currently visible in the left panel
    bool isaSignVisible = (isaSpeedNode_ && isaSpeedNode_->getActivSem() > 0)
                       || (isaHighwayNode_ && isaHighwayNode_->getActivSem() > 0);
    if (isaSignVisible) return false;

    // Condition 2: ISA_INACTIVE was requested from CAN
    if (!isaInactiveNode_ || isaInactiveNode_->getActivSem() <= 0) return false;

    return true;
}

void LvglIsaStateNode::onBecomeVisible()
{
    bool firstShow = !wasIsaActive_;
    wasIsaActive_ = true;

    ctrl_->setIsaAvailable(true);

    // QML: "isa_init" state — force ALERT_ISA_ERROR widget visible for 700ms
    // Only on hidden→visible transition, when no ISA sign is showing and inactive was requested
    if (isaErrorWidget_ && firstShow && shouldShowInitPhase()) {
        isaInitPhase_ = true;
        lv_obj_remove_flag(isaErrorWidget_, LV_OBJ_FLAG_HIDDEN);
        if (isaInactiveWidget_) {
            lv_obj_add_flag(isaInactiveWidget_, LV_OBJ_FLAG_HIDDEN);
        }
        if (initTimer_) {
            lv_timer_delete(initTimer_);
        }
        initTimer_ = lv_timer_create(initTimerCb, 700, this);
        lv_timer_set_repeat_count(initTimer_, 1);
    }
}

void LvglIsaStateNode::onBecomeInvisible()
{
    wasIsaActive_ = false;
    ctrl_->setIsaAvailable(false);

    // Cancel init timer if still running
    if (initTimer_) {
        lv_timer_delete(initTimer_);
        initTimer_ = nullptr;
    }
    if (isaInitPhase_) {
        isaInitPhase_ = false;
        if (isaErrorWidget_) {
            lv_obj_add_flag(isaErrorWidget_, LV_OBJ_FLAG_HIDDEN);
        }
    }
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
