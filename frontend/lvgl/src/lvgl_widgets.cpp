#include "lvgl_widgets.h"

static const int DISPLAY_WIDTH = 320;
static const int DISPLAY_HEIGHT = 240;

// Helper: create a transparent full-screen container, hidden by default
static lv_obj_t* createFullScreenContainer(lv_obj_t* parent)
{
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, DISPLAY_WIDTH, DISPLAY_HEIGHT);
    lv_obj_align(cont, LV_ALIGN_TOP_LEFT, 0, 0);
    lv_obj_set_style_bg_opa(cont, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(cont, 0, 0);
    lv_obj_set_style_pad_all(cont, 0, 0);
    lv_obj_set_style_radius(cont, 0, 0);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);
    return cont;
}

lv_obj_t* LvglWidgets::createDisconnectOverlay(lv_obj_t* parent)
{
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, DISPLAY_WIDTH, DISPLAY_HEIGHT);
    lv_obj_align(cont, LV_ALIGN_TOP_LEFT, 0, 0);
    lv_obj_set_style_bg_color(cont, lv_color_black(), 0);
    lv_obj_set_style_bg_opa(cont, LV_OPA_COVER, 0);
    lv_obj_set_style_border_width(cont, 0, 0);
    lv_obj_set_style_radius(cont, 0, 0);
    lv_obj_set_style_pad_all(cont, 0, 0);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);

    lv_obj_t* img = lv_image_create(cont);
    lv_image_set_src(img, "A:images/error/disconnect-alert.png");
    lv_image_set_scale(img, 192);  // ~75%
    lv_obj_align(img, LV_ALIGN_CENTER, 0, -20);

    lv_obj_t* label = lv_label_create(cont);
    lv_label_set_text(label, "Disconnected");
    lv_obj_set_style_text_font(label, &lv_font_montserrat_20, 0);
    lv_obj_set_style_text_color(label, lv_color_hex(0x111abc), 0);
    lv_obj_align(label, LV_ALIGN_CENTER, 0, 60);

    return cont;
}

lv_obj_t* LvglWidgets::createFCWAlert(lv_obj_t* parent)
{
    lv_obj_t* cont = createFullScreenContainer(parent);
    lv_obj_set_style_bg_opa(cont, LV_OPA_COVER, 0);
    lv_obj_set_style_bg_color(cont, lv_color_black(), 0);

    lv_obj_t* img = lv_image_create(cont);
    lv_image_set_src(img, "A:images/fcw/main_FCW_big.gif");
    lv_obj_align(img, LV_ALIGN_CENTER, 0, 0);

    return cont;
}

lv_obj_t* LvglWidgets::createPCWAlert(lv_obj_t* parent)
{
    lv_obj_t* cont = createFullScreenContainer(parent);
    lv_obj_set_style_bg_opa(cont, LV_OPA_COVER, 0);
    lv_obj_set_style_bg_color(cont, lv_color_black(), 0);

    lv_obj_t* img = lv_image_create(cont);
    lv_image_set_src(img, "A:images/pcw/main_PCW_big.gif");
    lv_obj_align(img, LV_ALIGN_CENTER, 0, 0);

    return cont;
}

lv_obj_t* LvglWidgets::createSpeedDisplay(lv_obj_t* parent, lv_obj_t** valueLabel)
{
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, 120, 70);
    lv_obj_align(cont, LV_ALIGN_BOTTOM_MID, 0, 0);
    lv_obj_set_style_bg_color(cont, lv_color_make(40, 40, 40), 0);
    lv_obj_set_style_bg_opa(cont, LV_OPA_COVER, 0);
    lv_obj_set_style_border_width(cont, 0, 0);
    lv_obj_set_style_radius(cont, 0, 0);
    lv_obj_set_style_pad_all(cont, 0, 0);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);

    lv_obj_t* valLabel = lv_label_create(cont);
    lv_label_set_text(valLabel, "0");
    lv_obj_set_style_text_font(valLabel, &lv_font_montserrat_32, 0);
    lv_obj_set_style_text_color(valLabel, lv_color_white(), 0);
    lv_obj_align(valLabel, LV_ALIGN_CENTER, 0, -8);

    lv_obj_t* unitLabel = lv_label_create(cont);
    lv_label_set_text(unitLabel, "km/h");
    lv_obj_set_style_text_font(unitLabel, &lv_font_montserrat_12, 0);
    lv_obj_set_style_text_color(unitLabel, lv_color_make(160, 160, 160), 0);
    lv_obj_align(unitLabel, LV_ALIGN_BOTTOM_MID, 0, -4);

    *valueLabel = valLabel;
    return cont;
}

lv_obj_t* LvglWidgets::createHMWDisplay(lv_obj_t* parent, lv_obj_t** valueLabel)
{
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, 100, 120);
    lv_obj_align(cont, LV_ALIGN_CENTER, 0, 20);
    lv_obj_set_style_bg_opa(cont, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(cont, 0, 0);
    lv_obj_set_style_pad_all(cont, 0, 0);
    lv_obj_set_style_radius(cont, 0, 0);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);

    lv_obj_t* roadImg = lv_image_create(cont);
    lv_image_set_src(roadImg, "A:images/hmw/gray_road-01-01.png");
    lv_obj_align(roadImg, LV_ALIGN_CENTER, 0, 0);

    lv_obj_t* valLabel = lv_label_create(cont);
    lv_label_set_text(valLabel, "0");
    lv_obj_set_style_text_font(valLabel, &lv_font_montserrat_20, 0);
    lv_obj_set_style_text_color(valLabel, lv_color_white(), 0);
    lv_obj_align(valLabel, LV_ALIGN_CENTER, 0, -30);

    *valueLabel = valLabel;
    return cont;
}

lv_obj_t* LvglWidgets::createLDWIndicator(lv_obj_t* parent, bool isLeft)
{
    lv_obj_t* cont = createFullScreenContainer(parent);

    lv_obj_t* img = lv_image_create(cont);
    if (isLeft)
    {
        lv_image_set_src(img, "A:images/ldw/ldw_left-01-01.png");
        lv_obj_align(img, LV_ALIGN_LEFT_MID, 10, 0);
    }
    else
    {
        lv_image_set_src(img, "A:images/ldw/ldw_right-01.png");
        lv_obj_align(img, LV_ALIGN_RIGHT_MID, -10, 0);
    }

    return cont;
}

lv_obj_t* LvglWidgets::createErrorOverlay(lv_obj_t* parent)
{
    lv_obj_t* cont = createFullScreenContainer(parent);

    lv_obj_t* img = lv_image_create(cont);
    lv_image_set_src(img, "A:images/error/error_full_display_general_yellow.png");
    lv_obj_align(img, LV_ALIGN_CENTER, 0, 0);

    return cont;
}
