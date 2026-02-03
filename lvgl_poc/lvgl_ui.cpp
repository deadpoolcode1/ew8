#include "lvgl_ui.h"
#include <cstdio>

LvglUI::LvglUI()
    : speedValueLabel_(nullptr)
    , speedUnitLabel_(nullptr)
    , fcwContainer_(nullptr)
    , fcwLabel_(nullptr)
    , disconnectedOverlay_(nullptr)
    , disconnectedLabel_(nullptr)
    , pendingSpeed_(0)
    , pendingFCW_(false)
    , pendingDisconnected_(true)  // Start as disconnected until first heartbeat
    , speedDirty_(false)
    , fcwDirty_(false)
    , disconnectedDirty_(true)    // Trigger initial state display
{
}

LvglUI::~LvglUI()
{
    // LVGL handles widget cleanup
}

void LvglUI::init()
{
    // Get active screen
    lv_obj_t* screen = lv_screen_active();

    // Set black background
    lv_obj_set_style_bg_color(screen, lv_color_black(), 0);
    lv_obj_set_style_bg_opa(screen, LV_OPA_COVER, 0);

    createSpeedDisplay();
    createFCWAlert();
    createDisconnectedOverlay();

    printf("LVGL UI initialized\n");
}

void LvglUI::createSpeedDisplay()
{
    lv_obj_t* screen = lv_screen_active();

    // Speed container - bottom center (sized for 320x240)
    lv_obj_t* speedContainer = lv_obj_create(screen);
    lv_obj_set_size(speedContainer, 120, 70);
    lv_obj_align(speedContainer, LV_ALIGN_BOTTOM_MID, 0, -10);
    lv_obj_set_style_bg_color(speedContainer, lv_color_make(40, 40, 40), 0);
    lv_obj_set_style_bg_opa(speedContainer, LV_OPA_COVER, 0);
    lv_obj_set_style_border_width(speedContainer, 2, 0);
    lv_obj_set_style_border_color(speedContainer, lv_color_white(), 0);
    lv_obj_set_style_radius(speedContainer, 8, 0);
    lv_obj_set_style_pad_all(speedContainer, 5, 0);

    // Speed value label (medium font for small screen)
    speedValueLabel_ = lv_label_create(speedContainer);
    lv_label_set_text(speedValueLabel_, "---");
    lv_obj_set_style_text_font(speedValueLabel_, &lv_font_montserrat_32, 0);
    lv_obj_set_style_text_color(speedValueLabel_, lv_color_white(), 0);
    lv_obj_align(speedValueLabel_, LV_ALIGN_CENTER, 0, -8);

    // "km/h" unit label
    speedUnitLabel_ = lv_label_create(speedContainer);
    lv_label_set_text(speedUnitLabel_, "km/h");
    lv_obj_set_style_text_font(speedUnitLabel_, &lv_font_montserrat_12, 0);
    lv_obj_set_style_text_color(speedUnitLabel_, lv_color_make(150, 150, 150), 0);
    lv_obj_align(speedUnitLabel_, LV_ALIGN_CENTER, 0, 20);
}

void LvglUI::createFCWAlert()
{
    lv_obj_t* screen = lv_screen_active();

    // FCW alert container - top center (sized for 320x240, initially hidden)
    fcwContainer_ = lv_obj_create(screen);
    lv_obj_set_size(fcwContainer_, 100, 50);
    lv_obj_align(fcwContainer_, LV_ALIGN_TOP_MID, 0, 20);
    lv_obj_set_style_bg_color(fcwContainer_, lv_color_make(200, 0, 0), 0);
    lv_obj_set_style_bg_opa(fcwContainer_, LV_OPA_COVER, 0);
    lv_obj_set_style_border_width(fcwContainer_, 2, 0);
    lv_obj_set_style_border_color(fcwContainer_, lv_color_white(), 0);
    lv_obj_set_style_radius(fcwContainer_, 6, 0);
    lv_obj_add_flag(fcwContainer_, LV_OBJ_FLAG_HIDDEN);

    // FCW warning text
    fcwLabel_ = lv_label_create(fcwContainer_);
    lv_label_set_text(fcwLabel_, "FCW!");
    lv_obj_set_style_text_font(fcwLabel_, &lv_font_montserrat_16, 0);
    lv_obj_set_style_text_color(fcwLabel_, lv_color_white(), 0);
    lv_obj_align(fcwLabel_, LV_ALIGN_CENTER, 0, 0);
}

void LvglUI::createDisconnectedOverlay()
{
    lv_obj_t* screen = lv_screen_active();

    // Full-screen overlay container (covers everything when disconnected)
    disconnectedOverlay_ = lv_obj_create(screen);
    lv_obj_set_size(disconnectedOverlay_, DISPLAY_WIDTH, DISPLAY_HEIGHT);
    lv_obj_align(disconnectedOverlay_, LV_ALIGN_CENTER, 0, 0);
    lv_obj_set_style_bg_color(disconnectedOverlay_, lv_color_black(), 0);
    lv_obj_set_style_bg_opa(disconnectedOverlay_, LV_OPA_COVER, 0);
    lv_obj_set_style_border_width(disconnectedOverlay_, 0, 0);
    lv_obj_set_style_radius(disconnectedOverlay_, 0, 0);
    lv_obj_set_style_pad_all(disconnectedOverlay_, 0, 0);

    // Warning triangle image from PNG file (same as Qt project)
    // PNG is 181x199, Qt displays at 150x150 (scaled down)
    // Scale factor: 150/199 = ~0.75 => 256 * 0.75 = 192 (LVGL scale units)
    lv_obj_t* alertImage = lv_image_create(disconnectedOverlay_);
    lv_image_set_src(alertImage, "A:images/disconnect-alert.png");
    lv_image_set_scale(alertImage, 192);  // Scale to ~75% to match Qt's 150x150
    lv_obj_align(alertImage, LV_ALIGN_CENTER, 0, -20);

    // "Disconnected" label below the triangle
    // Qt version uses blue color #111abc, bold, 20px
    disconnectedLabel_ = lv_label_create(disconnectedOverlay_);
    lv_label_set_text(disconnectedLabel_, "Disconnected");
    lv_obj_set_style_text_font(disconnectedLabel_, &lv_font_montserrat_20, 0);
    lv_obj_set_style_text_color(disconnectedLabel_, lv_color_hex(0x111abc), 0);  // Blue from Qt
    lv_obj_align(disconnectedLabel_, LV_ALIGN_CENTER, 0, 60);

    // Initially visible (will be hidden when first heartbeat received)
    // The visibility is controlled by processUpdates()
}

void LvglUI::setSpeed(int speed)
{
    pendingSpeed_.store(speed);
    speedDirty_.store(true);
}

void LvglUI::setFCWActive(bool active)
{
    pendingFCW_.store(active);
    fcwDirty_.store(true);
}

void LvglUI::setDisconnected(bool disconnected)
{
    pendingDisconnected_.store(disconnected);
    disconnectedDirty_.store(true);
}

void LvglUI::processUpdates()
{
    // Process speed update
    if (speedDirty_.exchange(false)) {
        int speed = pendingSpeed_.load();
        printf("processUpdates: updating speed to %d\n", speed);
        fflush(stdout);
        if (speedValueLabel_) {
            char buf[16];
            snprintf(buf, sizeof(buf), "%d", speed);
            printf("processUpdates: calling lv_label_set_text\n");
            fflush(stdout);
            lv_label_set_text(speedValueLabel_, buf);
            printf("processUpdates: speed label updated\n");
            fflush(stdout);
        }
    }

    // Process FCW update
    if (fcwDirty_.exchange(false)) {
        bool active = pendingFCW_.load();
        printf("processUpdates: updating FCW to %d\n", active);
        fflush(stdout);
        if (fcwContainer_) {
            if (active) {
                lv_obj_remove_flag(fcwContainer_, LV_OBJ_FLAG_HIDDEN);
            } else {
                lv_obj_add_flag(fcwContainer_, LV_OBJ_FLAG_HIDDEN);
            }
            printf("processUpdates: FCW updated\n");
            fflush(stdout);
        }
    }

    // Process disconnected update
    if (disconnectedDirty_.exchange(false)) {
        bool disconnected = pendingDisconnected_.load();
        printf("processUpdates: updating disconnected to %d\n", disconnected);
        fflush(stdout);
        if (disconnectedOverlay_) {
            if (disconnected) {
                lv_obj_remove_flag(disconnectedOverlay_, LV_OBJ_FLAG_HIDDEN);
            } else {
                lv_obj_add_flag(disconnectedOverlay_, LV_OBJ_FLAG_HIDDEN);
            }
            printf("processUpdates: disconnected updated\n");
            fflush(stdout);
        }
    }
}
