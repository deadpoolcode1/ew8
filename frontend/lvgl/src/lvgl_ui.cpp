#include "lvgl_ui.h"
#include <cstdio>

LvglUI::LvglUI()
    : disconnectedOverlay_(nullptr)
    , pendingDisconnected_(false)  // Start hidden; ALERT_NOCOM will show it when timeout fires
    , disconnectedDirty_(false)
{
}

void LvglUI::init()
{
    lv_obj_t* screen = lv_screen_active();
    lv_obj_set_style_bg_color(screen, lv_color_black(), 0);
    lv_obj_set_style_bg_opa(screen, LV_OPA_COVER, 0);

    createDisconnectedOverlay();
}

void LvglUI::createDisconnectedOverlay()
{
    lv_obj_t* screen = lv_screen_active();

    // Full-screen overlay (covers everything when disconnected)
    disconnectedOverlay_ = lv_obj_create(screen);
    lv_obj_set_size(disconnectedOverlay_, DISPLAY_WIDTH, DISPLAY_HEIGHT);
    lv_obj_align(disconnectedOverlay_, LV_ALIGN_CENTER, 0, 0);
    lv_obj_set_style_bg_color(disconnectedOverlay_, lv_color_black(), 0);
    lv_obj_set_style_bg_opa(disconnectedOverlay_, LV_OPA_COVER, 0);
    lv_obj_set_style_border_width(disconnectedOverlay_, 0, 0);
    lv_obj_set_style_radius(disconnectedOverlay_, 0, 0);
    lv_obj_set_style_pad_all(disconnectedOverlay_, 0, 0);
    lv_obj_add_flag(disconnectedOverlay_, LV_OBJ_FLAG_HIDDEN);  // Hidden until ALERT_NOCOM fires

    // Warning triangle image
    lv_obj_t* alertImage = lv_image_create(disconnectedOverlay_);
    lv_image_set_src(alertImage, "A:images/error/disconnect-alert.png");
    lv_image_set_scale(alertImage, 192);  // ~75% to match Qt's 150x150
    lv_obj_align(alertImage, LV_ALIGN_CENTER, 0, -20);

    // "Disconnected" label
    lv_obj_t* label = lv_label_create(disconnectedOverlay_);
    lv_label_set_text(label, "Disconnected");
    lv_obj_set_style_text_font(label, &lv_font_montserrat_20, 0);
    lv_obj_set_style_text_color(label, lv_color_hex(0x111abc), 0);
    lv_obj_align(label, LV_ALIGN_CENTER, 0, 60);
}

void LvglUI::setDisconnected(bool disconnected)
{
    pendingDisconnected_.store(disconnected);
    disconnectedDirty_.store(true);
}

void LvglUI::processUpdates()
{
    if (disconnectedDirty_.exchange(false)) {
        bool disconnected = pendingDisconnected_.load();
        if (disconnectedOverlay_) {
            if (disconnected) {
                lv_obj_remove_flag(disconnectedOverlay_, LV_OBJ_FLAG_HIDDEN);
            } else {
                lv_obj_add_flag(disconnectedOverlay_, LV_OBJ_FLAG_HIDDEN);
            }
        }
    }
}
