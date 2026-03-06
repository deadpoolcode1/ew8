#include "lvgl_widgets.h"

LV_FONT_DECLARE(intelone_bold_18);
LV_FONT_DECLARE(intelone_bold_20);

static const int DISPLAY_WIDTH = 320;
static const int DISPLAY_HEIGHT = 240;
static const int STATUS_BAR_HEIGHT = 43;
static const int STATUS_BAR_MARGIN = 8;
// Main panel starts below status bar
static const int MAIN_PANEL_Y = STATUS_BAR_MARGIN + STATUS_BAR_HEIGHT;
static const int MAIN_PANEL_HEIGHT = DISPLAY_HEIGHT - MAIN_PANEL_Y;

// Helper: create a transparent full-screen container, hidden by default
static lv_obj_t* createFullScreenContainer(lv_obj_t* parent)
{
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, DISPLAY_WIDTH, DISPLAY_HEIGHT);
    lv_obj_set_pos(cont, 0, 0);
    lv_obj_set_style_bg_opa(cont, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(cont, 0, 0);
    lv_obj_set_style_pad_all(cont, 0, 0);
    lv_obj_set_style_radius(cont, 0, 0);
    lv_obj_remove_flag(cont, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);
    return cont;
}

// Helper: style a container as invisible (no bg, no border, no padding, no radius)
static void styleTransparent(lv_obj_t* obj)
{
    lv_obj_set_style_bg_opa(obj, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(obj, 0, 0);
    lv_obj_set_style_pad_all(obj, 0, 0);
    lv_obj_set_style_radius(obj, 0, 0);
    lv_obj_remove_flag(obj, LV_OBJ_FLAG_SCROLLABLE);
}

lv_obj_t* LvglWidgets::createStatusBar(lv_obj_t* parent)
{
    // QML: status_panel height:43, anchors top:8 left:8 right:8
    lv_obj_t* bar = lv_obj_create(parent);
    lv_obj_set_size(bar, DISPLAY_WIDTH - 2 * STATUS_BAR_MARGIN, STATUS_BAR_HEIGHT);
    lv_obj_set_pos(bar, STATUS_BAR_MARGIN, STATUS_BAR_MARGIN);
    styleTransparent(bar);

    // Logo centered in status bar, topMargin 5
    lv_obj_t* logo = lv_image_create(bar);
    lv_image_set_src(logo, "A:images/logo/ME_status_logo.png");
    lv_obj_align(logo, LV_ALIGN_TOP_MID, 0, 5);

    return bar;
}

lv_obj_t* LvglWidgets::createDisconnectOverlay(lv_obj_t* parent)
{
    // QML: fills parent 320x240, black background
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, DISPLAY_WIDTH, DISPLAY_HEIGHT);
    lv_obj_set_pos(cont, 0, 0);
    lv_obj_set_style_bg_color(cont, lv_color_black(), 0);
    lv_obj_set_style_bg_opa(cont, LV_OPA_COVER, 0);
    lv_obj_set_style_border_width(cont, 0, 0);
    lv_obj_set_style_radius(cont, 0, 0);
    lv_obj_set_style_pad_all(cont, 0, 0);
    lv_obj_remove_flag(cont, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);

    // QML: discon_alert Image width:150 height:150
    // anchors.horizontalCenter + verticalCenter → exactly centered at (160,120)
    // Native PNG is 181x199 — scale by height to fit 150: 150/199 * 256 ≈ 193
    lv_obj_t* img = lv_image_create(cont);
    lv_image_set_src(img, "A:images/error/disconnect-alert.png");
    lv_image_set_scale(img, 193);
    lv_obj_align(img, LV_ALIGN_CENTER, 0, 0);

    // QML: discon_label is child of discon_alert (150×150 image centered at 120)
    // anchors.top: parent.bottom → label top at image bottom (120+75=195)
    // anchors.topMargin: -20 → label top at 175, label center ≈ 185
    // offset from screen center (120) = +65
    lv_obj_t* label = lv_label_create(cont);
    lv_label_set_text(label, "Disconnected");
    lv_obj_set_style_text_font(label, &intelone_bold_20, 0);
    lv_obj_set_style_text_color(label, lv_color_hex(0x111abc), 0);
    lv_obj_align(label, LV_ALIGN_CENTER, 0, 75);

    return cont;
}

lv_obj_t* LvglWidgets::createFCWAlert(lv_obj_t* parent)
{
    // QML: transparent container, GIF is 320x240 and fills parent
    lv_obj_t* cont = createFullScreenContainer(parent);

    lv_obj_t* img = lv_gif_create(cont);
    lv_gif_set_src(img, "A:images/fcw/main_FCW_big.gif");
    lv_obj_align(img, LV_ALIGN_TOP_LEFT, 0, 0);

    return cont;
}

lv_obj_t* LvglWidgets::createPCWAlert(lv_obj_t* parent)
{
    // QML: transparent container, GIF is 320x240 and fills parent
    lv_obj_t* cont = createFullScreenContainer(parent);

    lv_obj_t* img = lv_gif_create(cont);
    lv_gif_set_src(img, "A:images/pcw/main_PCW_big.gif");
    lv_obj_align(img, LV_ALIGN_TOP_LEFT, 0, 0);

    return cont;
}

lv_obj_t* LvglWidgets::createSpeedDisplay(lv_obj_t* parent, lv_obj_t** valueLabel)
{
    // QML: speed Rectangle in status bar left_row
    // width:42, height:35, transparent, positioned top-left of status bar
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, 42, 35);
    lv_obj_set_pos(cont, STATUS_BAR_MARGIN, STATUS_BAR_MARGIN + 2);
    styleTransparent(cont);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);

    // QML: speed_value font.pixelSize:22, white, horizontalCenter
    lv_obj_t* valLabel = lv_label_create(cont);
    lv_label_set_text(valLabel, "0");
    lv_obj_set_style_text_font(valLabel, &lv_font_montserrat_22, 0);
    lv_obj_set_style_text_color(valLabel, lv_color_white(), 0);
    lv_obj_align(valLabel, LV_ALIGN_TOP_MID, -2, -4);

    // QML: speed_units font.pixelSize:14, white, below value
    lv_obj_t* unitLabel = lv_label_create(cont);
    lv_label_set_text(unitLabel, "km/h");
    lv_obj_set_style_text_font(unitLabel, &lv_font_montserrat_14, 0);
    lv_obj_set_style_text_color(unitLabel, lv_color_white(), 0);
    lv_obj_align(unitLabel, LV_ALIGN_BOTTOM_MID, 0, 0);

    *valueLabel = valLabel;
    return cont;
}

lv_obj_t* LvglWidgets::createHMWDisplay(lv_obj_t* parent, lv_obj_t** valueLabel)
{
    // QML: HMW item width:220, height:190, centered in groupCIPV
    // groupCIPV is in main_panel (below status bar)
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, 220, MAIN_PANEL_HEIGHT);
    lv_obj_set_pos(cont, (DISPLAY_WIDTH - 220) / 2, MAIN_PANEL_Y);
    styleTransparent(cont);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);

    // Road strip GIF — anchored bottom-center
    lv_obj_t* roadGif = lv_gif_create(cont);
    lv_gif_set_src(roadGif, "A:images/hmw/HMW-green-new-2.gif");
    lv_obj_align(roadGif, LV_ALIGN_BOTTOM_MID, 0, 0);

    // Forward vehicle — 80x61, top-center, topMargin ~40
    lv_obj_t* fwdCar = lv_image_create(cont);
    lv_image_set_src(fwdCar, "A:images/cars/eyewatch_car_red_hmw-01.png");
    lv_obj_set_size(fwdCar, 80, 61);
    lv_obj_set_style_image_recolor(fwdCar, lv_color_white(), 0);
    lv_obj_align(fwdCar, LV_ALIGN_TOP_MID, 0, 40);

    // Host car — 160px wide, bottom-center, bottomMargin -5
    lv_obj_t* hostCar = lv_image_create(cont);
    lv_image_set_src(hostCar, "A:images/cars/grey_car_bright.png");
    lv_obj_set_size(hostCar, 160, LV_SIZE_CONTENT);
    lv_obj_align(hostCar, LV_ALIGN_BOTTOM_MID, 0, 5);

    // Units label: "sec", 20px, #e1f1ff, bottomMargin ~38
    lv_obj_t* unitsLabel = lv_label_create(cont);
    lv_label_set_text(unitsLabel, "sec");
    lv_obj_set_style_text_font(unitsLabel, &lv_font_montserrat_20, 0);
    lv_obj_set_style_text_color(unitsLabel, lv_color_hex(0xe1f1ff), 0);
    lv_obj_align(unitsLabel, LV_ALIGN_BOTTOM_MID, 0, -38);

    // Time value label: 28px, #e1f1ff, above units
    lv_obj_t* valLabel = lv_label_create(cont);
    lv_label_set_text(valLabel, "0");
    lv_obj_set_style_text_font(valLabel, &lv_font_montserrat_28, 0);
    lv_obj_set_style_text_color(valLabel, lv_color_hex(0xe1f1ff), 0);
    lv_obj_align(valLabel, LV_ALIGN_BOTTOM_MID, 0, -55);

    *valueLabel = valLabel;
    return cont;
}

lv_obj_t* LvglWidgets::createLDWIndicator(lv_obj_t* parent, bool isLeft)
{
    // QML: groupLanes in main_panel center area
    // Lane images (56x192) anchored to left/right within center column
    // QML margins: leftMargin 32, rightMargin 32 from center column
    // Center column: between left_panel(50px) and right_panel(50px) → x=50, width=220
    // With lane margins: x=50+32=82, width=220-64=156
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, DISPLAY_WIDTH, MAIN_PANEL_HEIGHT);
    lv_obj_set_pos(cont, 0, MAIN_PANEL_Y - 5);  // QML topMargin: -5
    styleTransparent(cont);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);

    lv_obj_t* img = lv_image_create(cont);
    if (isLeft)
    {
        lv_image_set_src(img, "A:images/ldw/ldw_left-01-01.png");
        // QML: anchors.left of groupLanesLeft, which starts at left_panel.right + 32
        lv_obj_align(img, LV_ALIGN_BOTTOM_LEFT, 50 + 32, 0);
    }
    else
    {
        lv_image_set_src(img, "A:images/ldw/ldw_right-01.png");
        // QML: anchors.right of groupLanesRight, which ends at right_panel.left - 32
        lv_obj_align(img, LV_ALIGN_BOTTOM_RIGHT, -(50 + 32), 0);
    }

    return cont;
}

lv_obj_t* LvglWidgets::createErrorOverlay(lv_obj_t* parent)
{
    // QML: width:324, height:240, anchors.bottom, bottomMargin:-20, leftMargin:-2
    lv_obj_t* cont = createFullScreenContainer(parent);

    // Image is 641x481 native → scale to ~324x240
    // Scale factor: 324/641 * 256 ≈ 129, or 240/481 * 256 ≈ 128
    lv_obj_t* img = lv_image_create(cont);
    lv_image_set_src(img, "A:images/error/error_full_display_general_yellow.png");
    lv_image_set_scale(img, 129);
    lv_obj_align(img, LV_ALIGN_BOTTOM_LEFT, -2, 20);

    return cont;
}
