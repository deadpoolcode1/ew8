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

// Helper: create a hidden image at a given position within a parent
static lv_obj_t* createHiddenImage(lv_obj_t* parent, const char* src)
{
    lv_obj_t* img = lv_image_create(parent);
    lv_image_set_src(img, src);
    lv_obj_add_flag(img, LV_OBJ_FLAG_HIDDEN);
    return img;
}

LvglWidgets::StatusBarWidgets LvglWidgets::createStatusBar(lv_obj_t* parent)
{
    StatusBarWidgets w = {};

    // QML: status_panel height:43, anchors top:8 left:8 right:8
    lv_obj_t* bar = lv_obj_create(parent);
    lv_obj_set_size(bar, DISPLAY_WIDTH - 2 * STATUS_BAR_MARGIN, STATUS_BAR_HEIGHT);
    lv_obj_set_pos(bar, STATUS_BAR_MARGIN, STATUS_BAR_MARGIN);
    styleTransparent(bar);

    // Logo centered in status bar, topMargin 5
    lv_obj_t* logo = lv_image_create(bar);
    lv_image_set_src(logo, "A:images/logo/ME_status_logo.png");
    lv_obj_align(logo, LV_ALIGN_TOP_MID, 0, 5);

    // --- Left row (LV_FLEX_FLOW_ROW, spacing=8) ---
    lv_obj_t* leftRow = lv_obj_create(bar);
    lv_obj_set_size(leftRow, LV_SIZE_CONTENT, 42);
    lv_obj_set_pos(leftRow, 0, 0);
    styleTransparent(leftRow);
    lv_obj_set_flex_flow(leftRow, LV_FLEX_FLOW_ROW);
    lv_obj_set_style_pad_column(leftRow, 8, 0);
    lv_obj_set_flex_align(leftRow, LV_FLEX_ALIGN_START, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_START);

    // Speed placeholder — 42px wide to reserve space (actual speed widget is separate)
    lv_obj_t* speedSpacer = lv_obj_create(leftRow);
    lv_obj_set_size(speedSpacer, 42, 35);
    styleTransparent(speedSpacer);

    // High beam icon
    w.hiBeamIcon = createHiddenImage(leftRow, "A:images/status-bar/status_IHC_high.png");

    // Low beam icon (same slot position — both hidden by default, mutually exclusive)
    w.loBeamIcon = createHiddenImage(leftRow, "A:images/status-bar/status_IHC_low.png");

    // Blinker icon (will use blink animation)
    w.blinkerIcon = createHiddenImage(leftRow, "A:images/status-bar/status_blinker_yellow.png");

    // --- Right row (LV_FLEX_FLOW_ROW_REVERSE, spacing=7) ---
    lv_obj_t* rightRow = lv_obj_create(bar);
    lv_obj_set_size(rightRow, LV_SIZE_CONTENT, 42);
    styleTransparent(rightRow);
    lv_obj_set_flex_flow(rightRow, LV_FLEX_FLOW_ROW_REVERSE);
    lv_obj_set_style_pad_column(rightRow, 7, 0);
    lv_obj_set_flex_align(rightRow, LV_FLEX_ALIGN_START, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_START);
    // Anchor to right edge of status bar
    lv_obj_align(rightRow, LV_ALIGN_TOP_RIGHT, 0, 0);

    // Helper: create a fixed-size slot in the flex row, stacking icons inside
    auto createSlot = [&](int width, int height) -> lv_obj_t* {
        lv_obj_t* slot = lv_obj_create(rightRow);
        lv_obj_set_size(slot, width, height);
        styleTransparent(slot);
        return slot;
    };

    // ISA status icons (stacked in one 56x35 slot, mutually exclusive)
    // QML: isa_status rectangle holds all ISA icons
    lv_obj_t* isaSlot = createSlot(56, 35);
    w.isaErrorIcon = createHiddenImage(isaSlot, "A:images/status-bar/ISA_error.png");
    w.isaInactiveIcon = createHiddenImage(isaSlot, "A:images/status-bar/ISA_full_deact.png");
    w.isaPartialIcon = createHiddenImage(isaSlot, "A:images/status-bar/ISA_part_deact.png");
    w.isaActiveIcon = createHiddenImage(isaSlot, "A:images/status-bar/ISA_full_act.png");

    // Signed status icons (stacked in one 17x35 slot, mutually exclusive)
    // QML: SignedStatus rectangle holds all signed icons
    lv_obj_t* signedSlot = createSlot(17, 35);
    w.signedInIcon = createHiddenImage(signedSlot, "A:images/status-bar/status_Signed_in.png");
    w.signedOutIcon = createHiddenImage(signedSlot, "A:images/status-bar/status_Signed_out.png");
    w.signedProcessIcon = createHiddenImage(signedSlot, "A:images/status-bar/status_Signed_process.png");

    // Comm info icons (stacked in one 23x35 slot)
    // QML: comm_info rectangle holds GSM and GPS
    lv_obj_t* commSlot = createSlot(23, 35);
    w.gsmIcon = createHiddenImage(commSlot, "A:images/status-bar/status_no_GSM.png");
    w.gpsIcon = createHiddenImage(commSlot, "A:images/status-bar/status_no_GPS.png");

    // Mute icon (in its own 28x35 slot)
    // QML: separate rectangle with mute anchored to right
    lv_obj_t* muteSlot = createSlot(28, 35);
    w.muteIcon = createHiddenImage(muteSlot, "A:images/status-bar/status_mute.png");

    return w;
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

lv_obj_t* LvglWidgets::createSpeedDisplay(lv_obj_t* parent, lv_obj_t** valueLabel, lv_obj_t** unitLabelOut)
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
    if (unitLabelOut) *unitLabelOut = unitLabel;
    return cont;
}

LvglWidgets::HMWWidgets LvglWidgets::createHMWDisplay(lv_obj_t* parent)
{
    HMWWidgets w = {};

    // QML: HMW item width:220, height:190, centered in groupCIPV
    // groupCIPV is in main_panel (below status bar)
    w.container = lv_obj_create(parent);
    lv_obj_set_size(w.container, 220, MAIN_PANEL_HEIGHT);
    lv_obj_set_pos(w.container, (DISPLAY_WIDTH - 220) / 2, MAIN_PANEL_Y);
    styleTransparent(w.container);
    lv_obj_add_flag(w.container, LV_OBJ_FLAG_HIDDEN);

    // Road strip GIF — anchored bottom-center (default: green/monitor state)
    w.roadStrip = lv_gif_create(w.container);
    lv_gif_set_src(w.roadStrip, "A:images/hmw/HMW-green-new-2.gif");
    lv_obj_align(w.roadStrip, LV_ALIGN_BOTTOM_MID, 0, 0);

    // Forward vehicle — 80x61, top-center, topMargin ~40
    w.forwardCar = lv_image_create(w.container);
    lv_image_set_src(w.forwardCar, "A:images/cars/eyewatch_car_red_hmw-01.png");
    lv_obj_set_size(w.forwardCar, 80, 61);
    lv_obj_set_style_image_recolor(w.forwardCar, lv_color_white(), 0);
    lv_obj_align(w.forwardCar, LV_ALIGN_TOP_MID, 0, 40);

    // Note: host car is created separately (always visible, not HMW-dependent)

    // Units label: "sec", 20px, #e1f1ff, bottomMargin ~38
    lv_obj_t* unitsLabel = lv_label_create(w.container);
    lv_label_set_text(unitsLabel, "sec");
    lv_obj_set_style_text_font(unitsLabel, &lv_font_montserrat_20, 0);
    lv_obj_set_style_text_color(unitsLabel, lv_color_hex(0xe1f1ff), 0);
    lv_obj_align(unitsLabel, LV_ALIGN_BOTTOM_MID, 0, -38);

    // Time value label: 28px, #e1f1ff, above units
    w.valueLabel = lv_label_create(w.container);
    lv_label_set_text(w.valueLabel, "0");
    lv_obj_set_style_text_font(w.valueLabel, &lv_font_montserrat_28, 0);
    lv_obj_set_style_text_color(w.valueLabel, lv_color_hex(0xe1f1ff), 0);
    lv_obj_align(w.valueLabel, LV_ALIGN_BOTTOM_MID, 0, -55);

    return w;
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

lv_obj_t* LvglWidgets::createFailsafeOverlay(lv_obj_t* parent)
{
    lv_obj_t* cont = createFullScreenContainer(parent);

    // Eye icon: scaled 0.6 (0.6 * 256 = 154), centered horizontally, top=135
    lv_obj_t* img = lv_image_create(cont);
    lv_image_set_src(img, "A:images/error/icon_eye.png");
    lv_image_set_scale(img, 154);
    lv_obj_align(img, LV_ALIGN_TOP_MID, 0, 135);

    // "Low Visibility" label, yellow #fed500, centered, below icon
    lv_obj_t* label = lv_label_create(cont);
    lv_label_set_text(label, "Low Visibility");
    lv_obj_set_style_text_font(label, &intelone_bold_18, 0);
    lv_obj_set_style_text_color(label, lv_color_hex(0xfed500), 0);
    lv_obj_align(label, LV_ALIGN_TOP_MID, 0, 195);

    return cont;
}

lv_obj_t* LvglWidgets::createOpModeOverlay(lv_obj_t* parent, const char* text)
{
    lv_obj_t* cont = createFullScreenContainer(parent);

    lv_obj_t* label = lv_label_create(cont);
    lv_label_set_text(label, text);
    lv_obj_set_style_text_font(label, &intelone_bold_20, 0);
    lv_obj_set_style_text_color(label, lv_color_hex(0x111abc), 0);
    lv_obj_align(label, LV_ALIGN_CENTER, 0, 75);

    return cont;
}

lv_obj_t* LvglWidgets::createLDWOffIndicator(lv_obj_t* parent, bool isLeft)
{
    // QML: yellow lane indicator (lane not available)
    // source: "images/ldw/left_lane_yellow-01.png" (mirrored for right side)
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, DISPLAY_WIDTH, MAIN_PANEL_HEIGHT);
    lv_obj_set_pos(cont, 0, MAIN_PANEL_Y - 5);
    styleTransparent(cont);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);

    lv_obj_t* img = lv_image_create(cont);
    if (isLeft)
    {
        lv_image_set_src(img, "A:images/ldw/left_lane_yellow-01.png");
        lv_obj_align(img, LV_ALIGN_BOTTOM_LEFT, 50 + 32, 0);
    }
    else
    {
        // QML uses left_lane_yellow-01.png with mirror:true; right_lane-01.png is pre-mirrored
        lv_image_set_src(img, "A:images/ldw/right_lane-01.png");
        lv_obj_align(img, LV_ALIGN_BOTTOM_RIGHT, -(50 + 32), 0);
    }

    return cont;
}

lv_obj_t* LvglWidgets::createLDWOnIndicator(lv_obj_t* parent, bool isLeft)
{
    // QML: green normal lane indicator (lane available, no departure)
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, DISPLAY_WIDTH, MAIN_PANEL_HEIGHT);
    lv_obj_set_pos(cont, 0, MAIN_PANEL_Y - 5);
    styleTransparent(cont);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);

    lv_obj_t* img = lv_image_create(cont);
    if (isLeft)
    {
        lv_image_set_src(img, "A:images/ldw/normal_lane_left-01.png");
        lv_obj_align(img, LV_ALIGN_BOTTOM_LEFT, 50 + 32, 0);
    }
    else
    {
        lv_image_set_src(img, "A:images/ldw/normal_lane_right-01.png");
        lv_obj_align(img, LV_ALIGN_BOTTOM_RIGHT, -(50 + 32), 0);
    }

    return cont;
}

lv_obj_t* LvglWidgets::createPDZOverlay(lv_obj_t* parent)
{
    // QML: alert_pdz — pedestrian image centered in groupCIPV, topMargin: -8
    // Container starts 8px higher to avoid LVGL clipping (QML allows overflow)
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, DISPLAY_WIDTH, MAIN_PANEL_HEIGHT + 8);
    lv_obj_set_pos(cont, 0, MAIN_PANEL_Y - 8);
    styleTransparent(cont);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);

    lv_obj_t* img = lv_image_create(cont);
    lv_image_set_src(img, "A:images/pdz/main_ped_yellow_old.png");
    lv_obj_align(img, LV_ALIGN_TOP_MID, 0, 0);

    return cont;
}

// Left panel sign constants
// Signs are 112x112 native. QML target_scale=0.732 → 82x82 rendered.
// LVGL scale: 0.732 * 256 = 187
static const int LEFT_PANEL_SIGN_SCALE = 187;
static const int LEFT_PANEL_SIGN_SIZE = 82;  // 112 * 0.732

// Right panel sign constants
// Signs are 136x136 native. QML SideIcon quadrant 1/4: target_scale=0.6028 → ~82x82 rendered.
static const int RIGHT_PANEL_SIGN_SCALE = 154;  // 0.6028 * 256
static const int RIGHT_PANEL_SIGN_SIZE = 82;    // 136 * 0.6028
// QML: right_panel width=50, rightMargin=0, topMargin=12, bottomMargin=12
static const int RIGHT_PANEL_MARGIN = 12;

lv_obj_t* LvglWidgets::createLeftPanelSign(lv_obj_t* parent, const char* imageSrc, bool upperSlot)
{
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, LEFT_PANEL_SIGN_SIZE, LEFT_PANEL_SIGN_SIZE);
    int y = upperSlot ? (MAIN_PANEL_Y + 12) : (DISPLAY_HEIGHT - 12 - LEFT_PANEL_SIGN_SIZE);
    lv_obj_set_pos(cont, 0, y);
    styleTransparent(cont);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_OVERFLOW_VISIBLE);

    lv_obj_t* img = lv_image_create(cont);
    lv_image_set_src(img, imageSrc);
    lv_image_set_pivot(img, 0, 0);
    lv_image_set_scale(img, LEFT_PANEL_SIGN_SCALE);
    lv_obj_set_pos(img, 0, 0);

    return cont;
}

lv_obj_t* LvglWidgets::createSpeedLimitSign(lv_obj_t* parent, const char* signImgSrc,
                                              bool upperSlot, lv_obj_t** speedLabel)
{
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, LEFT_PANEL_SIGN_SIZE, LEFT_PANEL_SIGN_SIZE);
    int y = upperSlot ? (MAIN_PANEL_Y + 12) : (DISPLAY_HEIGHT - 12 - LEFT_PANEL_SIGN_SIZE);
    lv_obj_set_pos(cont, 0, y);
    styleTransparent(cont);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_OVERFLOW_VISIBLE);

    lv_obj_t* img = lv_image_create(cont);
    lv_image_set_src(img, signImgSrc);
    lv_image_set_pivot(img, 0, 0);
    lv_image_set_scale(img, LEFT_PANEL_SIGN_SCALE);
    lv_obj_set_pos(img, 0, 0);

    // Speed number text centered on the sign
    // QML: font.pixelSize 36, scale varies. Effective ~26px at sign scale.
    lv_obj_t* label = lv_label_create(cont);
    lv_label_set_text(label, "");
    lv_obj_set_style_text_font(label, &lv_font_montserrat_22, 0);
    lv_obj_set_style_text_color(label, lv_color_black(), 0);
    lv_obj_align(label, LV_ALIGN_CENTER, 1, 0);

    *speedLabel = label;
    return cont;
}

lv_obj_t* LvglWidgets::createRTWAlert(lv_obj_t* parent)
{
    // QML: full-screen black rectangle with large traffic light centered
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

    lv_obj_t* img = lv_image_create(cont);
    lv_image_set_src(img, "A:images/traffic-violation/left_TV_RL_big.png");
    // QML: centered within main_panel (y: 50..240), offset = (50/2) = 25px down from screen center
    lv_obj_align(img, LV_ALIGN_CENTER, 0, 25);

    return cont;
}

lv_obj_t* LvglWidgets::createColorOverlay(lv_obj_t* parent, lv_color_t color)
{
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, DISPLAY_WIDTH, DISPLAY_HEIGHT);
    lv_obj_set_pos(cont, 0, 0);
    lv_obj_set_style_bg_color(cont, color, 0);
    lv_obj_set_style_bg_opa(cont, LV_OPA_COVER, 0);
    lv_obj_set_style_border_width(cont, 0, 0);
    lv_obj_set_style_radius(cont, 0, 0);
    lv_obj_set_style_pad_all(cont, 0, 0);
    lv_obj_remove_flag(cont, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);
    return cont;
}

lv_obj_t* LvglWidgets::createTVPatternOverlay(lv_obj_t* parent)
{
    lv_obj_t* cont = createFullScreenContainer(parent);

    lv_obj_t* img = lv_image_create(cont);
    lv_image_set_src(img, "A:images/test/SMPTE.png");
    lv_obj_align(img, LV_ALIGN_TOP_LEFT, 0, 0);

    return cont;
}

lv_obj_t* LvglWidgets::createSignalTestScreen(lv_obj_t* parent)
{
    // Full-screen container with Background.png
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, DISPLAY_WIDTH, DISPLAY_HEIGHT);
    lv_obj_set_pos(cont, 0, 0);
    styleTransparent(cont);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_OVERFLOW_VISIBLE);

    lv_obj_t* bg = lv_image_create(cont);
    lv_image_set_src(bg, "A:images/signal-test/Background.png");
    lv_obj_align(bg, LV_ALIGN_TOP_LEFT, 0, 0);

    return cont;
}

lv_obj_t* LvglWidgets::createPeripheralTestScreen(lv_obj_t* parent)
{
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, DISPLAY_WIDTH, DISPLAY_HEIGHT);
    lv_obj_set_pos(cont, 0, 0);
    styleTransparent(cont);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_OVERFLOW_VISIBLE);

    lv_obj_t* bg = lv_image_create(cont);
    lv_image_set_src(bg, "A:images/peripheral-test/Peripherals_Test_Background.png");
    lv_obj_align(bg, LV_ALIGN_TOP_LEFT, 0, 0);

    return cont;
}

lv_obj_t* LvglWidgets::createPeripheralTestGroupRow(lv_obj_t* parent, const char* title, int yPos)
{
    // 320x80 transparent row
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, 320, 80);
    lv_obj_set_pos(cont, 0, yPos);
    styleTransparent(cont);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);

    // Title text at left
    lv_obj_t* label = lv_label_create(cont);
    lv_label_set_text(label, title);
    lv_obj_set_style_text_font(label, &intelone_bold_18, 0);
    lv_obj_set_style_text_color(label, lv_color_white(), 0);
    lv_obj_set_pos(label, 15, 0);
    lv_obj_align(label, LV_ALIGN_LEFT_MID, 15, 0);

    return cont;
}

lv_obj_t* LvglWidgets::createRightPanelSign(lv_obj_t* parent, const char* imageSrc, bool upperSlot)
{
    // QML: SideIcon quadrant 1 (upper-right) / quadrant 4 (lower-right)
    // right_panel: width=50, x=270, topMargin=12, bottomMargin=12
    // Icon position: x = parentWidth - scaledSize = 50 - 100 = -50 relative to right panel
    // Global: x = 270 - 50 = 220
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, RIGHT_PANEL_SIGN_SIZE, RIGHT_PANEL_SIGN_SIZE);
    int x = DISPLAY_WIDTH - RIGHT_PANEL_SIGN_SIZE;
    int y = upperSlot ? (MAIN_PANEL_Y + RIGHT_PANEL_MARGIN)
                      : (DISPLAY_HEIGHT - RIGHT_PANEL_MARGIN - RIGHT_PANEL_SIGN_SIZE);
    lv_obj_set_pos(cont, x, y);
    styleTransparent(cont);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_OVERFLOW_VISIBLE);

    lv_obj_t* img = lv_image_create(cont);
    lv_image_set_src(img, imageSrc);
    lv_image_set_pivot(img, 0, 0);
    lv_image_set_scale(img, RIGHT_PANEL_SIGN_SCALE);
    lv_obj_set_pos(img, 0, 0);

    return cont;
}
