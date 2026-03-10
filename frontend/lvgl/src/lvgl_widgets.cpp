#include "lvgl_widgets.h"

LV_FONT_DECLARE(intelone_bold_18);
LV_FONT_DECLARE(intelone_bold_20);
LV_FONT_DECLARE(intelone_bold_28);
LV_FONT_DECLARE(intelone_medium_14);
LV_FONT_DECLARE(intelone_medium_17);
LV_FONT_DECLARE(intelone_medium_20);
LV_FONT_DECLARE(intelone_medium_22);
LV_FONT_DECLARE(intelone_medium_28);
LV_FONT_DECLARE(intelone_bold_26);
LV_FONT_DECLARE(intelone_bold_32);
LV_FONT_DECLARE(intelone_bold_37);
LV_FONT_DECLARE(intelone_medium_24);
LV_FONT_DECLARE(intelone_medium_26);
LV_FONT_DECLARE(intelone_medium_32);
LV_FONT_DECLARE(intelone_medium_36);
LV_FONT_DECLARE(intelone_medium_37);
LV_FONT_DECLARE(intelone_medium_44);

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

    // --- Right row (ROW, aligned to END so items pack toward right edge) ---
    // QML: layoutDirection RightToLeft, left=logo.right+8, right=parent.right
    // Items ordered left-to-right: mute(closest to logo) → comm → signed → ISA(rightmost)
    int barWidth = DISPLAY_WIDTH - 2 * STATUS_BAR_MARGIN;
    int logoRightEdge = barWidth / 2 + 20 + 8; // logo half-width(20) + margin(8)
    lv_obj_t* rightRow = lv_obj_create(bar);
    lv_obj_set_size(rightRow, barWidth - logoRightEdge, 42);
    lv_obj_set_pos(rightRow, logoRightEdge + 2, -5);
    styleTransparent(rightRow);
    lv_obj_set_flex_flow(rightRow, LV_FLEX_FLOW_ROW);
    lv_obj_set_style_pad_column(rightRow, 3, 0);
    lv_obj_set_flex_align(rightRow, LV_FLEX_ALIGN_END, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_END);

    // Helper: create a fixed-size slot in the flex row, stacking icons inside
    auto createSlot = [&](int width, int height) -> lv_obj_t* {
        lv_obj_t* slot = lv_obj_create(rightRow);
        lv_obj_set_size(slot, width, height);
        styleTransparent(slot);
        return slot;
    };

    // Items ordered left-to-right (FLEX_ALIGN_END packs them to the right edge)
    // Mute icon (leftmost, closest to logo)
    lv_obj_t* muteSlot = createSlot(28, 35);
    w.muteIcon = createHiddenImage(muteSlot, "A:images/status-bar/status_mute.png");

    // Comm info icons (stacked in one 23x35 slot)
    lv_obj_t* commSlot = createSlot(23, 35);
    w.gsmIcon = createHiddenImage(commSlot, "A:images/status-bar/status_no_GSM.png");
    w.gpsIcon = createHiddenImage(commSlot, "A:images/status-bar/status_no_GPS.png");

    // Signed status icons (stacked in one 17x35 slot, mutually exclusive)
    lv_obj_t* signedSlot = createSlot(17, 35);
    w.signedInIcon = createHiddenImage(signedSlot, "A:images/status-bar/status_Signed_in.png");
    w.signedOutIcon = createHiddenImage(signedSlot, "A:images/status-bar/status_Signed_out.png");
    w.signedProcessIcon = createHiddenImage(signedSlot, "A:images/status-bar/status_Signed_process.png");

    // ISA status icons (rightmost — stacked in one slot, mutually exclusive)
    // Native image sizes: 49-56px wide. No scaling.
    lv_obj_t* isaSlot = createSlot(56, 35);

    w.isaErrorIcon = createHiddenImage(isaSlot, "A:images/status-bar/ISA_error.png");
    lv_obj_align(w.isaErrorIcon, LV_ALIGN_CENTER, 0, 0);
    w.isaInactiveIcon = createHiddenImage(isaSlot, "A:images/status-bar/ISA_full_deact.png");
    lv_obj_align(w.isaInactiveIcon, LV_ALIGN_CENTER, 0, 0);
    w.isaPartialIcon = createHiddenImage(isaSlot, "A:images/status-bar/ISA_part_deact.png");
    lv_obj_align(w.isaPartialIcon, LV_ALIGN_CENTER, 0, 0);
    w.isaActiveIcon = createHiddenImage(isaSlot, "A:images/status-bar/ISA_full_act.png");
    lv_obj_align(w.isaActiveIcon, LV_ALIGN_CENTER, 0, 0);

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

    // QML: discon_status_panel with ME logo at top (same as status bar)
    lv_obj_t* disconLogo = lv_image_create(cont);
    lv_image_set_src(disconLogo, "A:images/logo/ME_status_logo.png");
    lv_obj_align(disconLogo, LV_ALIGN_TOP_MID, 0, STATUS_BAR_MARGIN + 5);

    // QML: discon_alert Image width:150 height:150 (stretches 181x199 to square)
    // LVGL can't stretch non-uniformly. Scale to match QML width: 150/181*256 ≈ 212
    // Rendered: 150x165 (height slightly taller than QML's 150, but width matches)
    lv_obj_t* img = lv_image_create(cont);
    lv_image_set_src(img, "A:images/error/disconnect-alert.png");
    lv_image_set_scale(img, 212);
    lv_obj_align(img, LV_ALIGN_CENTER, 0, 5);

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

    // QML: speed_value font.pixelSize:22, Font.Medium, intelFont, white
    lv_obj_t* valLabel = lv_label_create(cont);
    lv_label_set_text(valLabel, "0");
    lv_obj_set_style_text_font(valLabel, &intelone_medium_22, 0);
    lv_obj_set_style_text_color(valLabel, lv_color_white(), 0);
    lv_obj_align(valLabel, LV_ALIGN_TOP_MID, -2, 0);

    // QML: speed_units font.pixelSize:14, Font.Medium, intelFont, white
    lv_obj_t* unitLabel = lv_label_create(cont);
    lv_label_set_text(unitLabel, "km/h");
    lv_obj_set_style_text_font(unitLabel, &intelone_medium_14, 0);
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

    // Forward vehicle — QML: 80x61 at scale=1.0, image is 129x111
    // Scale set by LvglHmwStateNode::onBecomeVisible (alert=159, monitor=119)
    w.forwardCar = lv_image_create(w.container);
    lv_image_set_src(w.forwardCar, "A:images/cars/eyewatch_car_red_hmw-01.png");
    lv_image_set_pivot(w.forwardCar, 65, 0);  // pivot at top-center of 129px image
    lv_image_set_scale(w.forwardCar, 159);    // default: alert scale
    lv_obj_align(w.forwardCar, LV_ALIGN_TOP_MID, 0, 40);

    // Note: host car is created separately (always visible, not HMW-dependent)

    // Units label: "sec", QML: font.pixelSize=20, Font.Medium, intelFont
    lv_obj_t* unitsLabel = lv_label_create(w.container);
    lv_label_set_text(unitsLabel, "sec");
    lv_obj_set_style_text_font(unitsLabel, &intelone_medium_20, 0);
    lv_obj_set_style_text_color(unitsLabel, lv_color_hex(0xe1f1ff), 0);
    lv_obj_align(unitsLabel, LV_ALIGN_BOTTOM_MID, 0, -38);

    // Time value label: QML: font.pixelSize=28, intelFont, Font.Medium weight
    w.valueLabel = lv_label_create(w.container);
    lv_label_set_text(w.valueLabel, "0");
    lv_obj_set_style_text_font(w.valueLabel, &intelone_medium_28, 0);
    lv_obj_set_style_text_color(w.valueLabel, lv_color_hex(0xe1f1ff), 0);
    lv_obj_align(w.valueLabel, LV_ALIGN_BOTTOM_MID, 0, -55);

    return w;
}

lv_obj_t* LvglWidgets::createLDWIndicator(lv_obj_t* parent, bool isLeft)
{
    // QML: groupLanes fills main_panel with topMargin:-5, bottom at screen edge
    // Lane images anchored bottom within container
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, DISPLAY_WIDTH, DISPLAY_HEIGHT - (MAIN_PANEL_Y - 5));
    lv_obj_set_pos(cont, 0, MAIN_PANEL_Y - 5);
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
        // QML: groupLanes has rightMargin:32 from groupGAG, which ends at right_panel.left(270)
        // lane right edge = 270 - 32 = 238 from left = -(DISPLAY_WIDTH - 238) = -82 from right
        lv_obj_align(img, LV_ALIGN_BOTTOM_RIGHT, -(50 + 30), 0);
    }

    return cont;
}

LvglWidgets::ErrorOverlayWidgets LvglWidgets::createErrorOverlay(lv_obj_t* parent)
{
    ErrorOverlayWidgets w = {};

    // QML: width:324, height:240, anchors.bottom, bottomMargin:-20, leftMargin:-2
    w.container = lv_obj_create(parent);
    lv_obj_set_size(w.container, DISPLAY_WIDTH, DISPLAY_HEIGHT);
    lv_obj_set_pos(w.container, 0, 0);
    lv_obj_set_style_bg_opa(w.container, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(w.container, 0, 0);
    lv_obj_set_style_pad_all(w.container, 0, 0);
    lv_obj_set_style_radius(w.container, 0, 0);
    lv_obj_remove_flag(w.container, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_add_flag(w.container, LV_OBJ_FLAG_HIDDEN);

    // QML: alert_err image — fillMode: PreserveAspectCrop, width:324, height:240
    // Pre-resized to 324x240 (from 641x481) to avoid large image decode issues.
    // QML position: leftMargin:-2, bottom of parent with bottomMargin:-20
    w.errorImg = lv_image_create(w.container);
    lv_image_set_src(w.errorImg, "A:images/error/error_full_display_324x240.png");
    lv_obj_set_pos(w.errorImg, -2, 20);

    // QML: ME logo at top center (discon_status_panel has logo during error too)
    lv_obj_t* errLogo = lv_image_create(w.container);
    lv_image_set_src(errLogo, "A:images/logo/ME_status_logo.png");
    lv_obj_align(errLogo, LV_ALIGN_TOP_MID, 0, STATUS_BAR_MARGIN + 5);

    // QML: err_code text — hex value of error arg, displayed in status bar area
    // Font: IntelOne Display Medium 24px (closest: intelone_medium_26)
    // QML layout: discon_right_row (RTL), status_err_right_pad(71) + 7px spacing + status_error(28)
    // status_error center x ≈ 8 + 304 - 71 - 7 - 14 = 220, y = 8 (topMargin) + 4 (topPadding) = 12
    w.errorCodeLabel = lv_label_create(w.container);
    lv_label_set_text(w.errorCodeLabel, "");
    lv_obj_set_style_text_font(w.errorCodeLabel, &intelone_medium_24, 0);
    lv_obj_set_style_text_color(w.errorCodeLabel, lv_color_white(), 0);
    lv_obj_set_pos(w.errorCodeLabel, 205, 16);

    return w;
}

lv_obj_t* LvglWidgets::createFailsafeOverlay(lv_obj_t* parent)
{
    lv_obj_t* cont = createFullScreenContainer(parent);

    // Eye icon: scaled 0.6 (0.6 * 256 = 154), centered horizontally
    // QML: anchors.top: parent.top, topMargin: 135, scale: 0.6
    // Image is 89x53. At scale 0.6 with pivot(0,0): visual size = 53x32.
    // Place icon so its visual bottom is just above the text (at y=178).
    // With pivot(0,0): visual bottom = y + 53*0.6 = y + 32. Need y+32 < 178 → y ≤ 145.
    lv_obj_t* img = lv_image_create(cont);
    lv_image_set_src(img, "A:images/error/icon_eye.png");
    lv_image_set_scale(img, 154);
    lv_image_set_pivot(img, 44, 26);  // center pivot so scaling keeps visual centered
    lv_obj_align(img, LV_ALIGN_TOP_MID, 0, 130);

    // "Low Visibility" label, yellow #fed500, centered, below icon
    // QML: font.pixelSize: 17, intelFont (bold). anchors.top: icon.bottom, topMargin: -12
    // Text at y=178 (user confirmed this position is good)
    lv_obj_t* label = lv_label_create(cont);
    lv_label_set_text(label, "Low Visibility");
    lv_obj_set_style_text_font(label, &intelone_medium_17, 0);
    lv_obj_set_style_text_color(label, lv_color_hex(0xfed500), 0);
    lv_obj_align(label, LV_ALIGN_TOP_MID, 0, 178);

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
    // QML: yellow lane indicator, fills main_panel with topMargin:-5, bottom at screen edge
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, DISPLAY_WIDTH, DISPLAY_HEIGHT - (MAIN_PANEL_Y - 5));
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
        lv_obj_align(img, LV_ALIGN_BOTTOM_RIGHT, -(50 + 30), 0);
    }

    return cont;
}

lv_obj_t* LvglWidgets::createLDWOnIndicator(lv_obj_t* parent, bool isLeft)
{
    // QML: green lane indicator, fills main_panel with topMargin:-5, bottom at screen edge
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, DISPLAY_WIDTH, DISPLAY_HEIGHT - (MAIN_PANEL_Y - 5));
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
        lv_obj_align(img, LV_ALIGN_BOTTOM_RIGHT, -(50 + 30), 0);
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
static const int LEFT_PANEL_SIGN_SIZE = 82;   // 112 * 0.732 (visual size at target scale)
static const int LEFT_PANEL_SIGN_NATIVE = 112; // native image size (container size for anim)
// Bottom-slot containers need extra height for supp icon (112x62, positioned at y=97)
static const int LEFT_PANEL_SUPP_HEIGHT = 160; // 112 sign + 62 icon - 14 overlap

// Right panel sign constants
// Signs are 136x136 native. QML SideIcon quadrant 1/4: target_scale=0.6028 → ~82x82 rendered.
static const int RIGHT_PANEL_SIGN_SCALE = 154;  // 0.6028 * 256
static const int RIGHT_PANEL_SIGN_SIZE = 82;    // 136 * 0.6028
// QML: right_panel width=50, rightMargin=0, topMargin=12, bottomMargin=12
static const int RIGHT_PANEL_MARGIN = 12;

lv_obj_t* LvglWidgets::createLeftPanelSign(lv_obj_t* parent, const char* imageSrc, bool upperSlot)
{
    lv_obj_t* cont = lv_obj_create(parent);
    int contH = upperSlot ? LEFT_PANEL_SIGN_NATIVE : LEFT_PANEL_SUPP_HEIGHT;
    lv_obj_set_size(cont, LEFT_PANEL_SIGN_NATIVE, contH);
    int x = upperSlot ? 0 : 10;
    int y = upperSlot ? (MAIN_PANEL_Y + 12) : 95;
    lv_obj_set_pos(cont, x, y);
    styleTransparent(cont);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_OVERFLOW_VISIBLE);

    // Container transform scales all children (image + label) together
    // Upper slot: pivot top-left (shrinks upward). Lower slot: pivot bottom-left (shrinks downward).
    lv_obj_set_style_transform_pivot_x(cont, 0, 0);
    lv_obj_set_style_transform_pivot_y(cont, upperSlot ? 0 : LEFT_PANEL_SIGN_NATIVE, 0);
    lv_obj_set_style_transform_scale_x(cont, LEFT_PANEL_SIGN_SCALE, 0);
    lv_obj_set_style_transform_scale_y(cont, LEFT_PANEL_SIGN_SCALE, 0);

    lv_obj_t* img = lv_image_create(cont);
    lv_image_set_src(img, imageSrc);
    lv_obj_set_pos(img, 0, 0);

    return cont;
}

lv_obj_t* LvglWidgets::createSpeedLimitSign(lv_obj_t* parent, const char* signImgSrc,
                                              bool upperSlot, lv_obj_t** speedLabel)
{
    lv_obj_t* cont = lv_obj_create(parent);
    int contH = upperSlot ? LEFT_PANEL_SIGN_NATIVE : LEFT_PANEL_SUPP_HEIGHT;
    lv_obj_set_size(cont, LEFT_PANEL_SIGN_NATIVE, contH);
    int x = upperSlot ? 0 : 10;
    int y = upperSlot ? (MAIN_PANEL_Y + 12) : 95;
    lv_obj_set_pos(cont, x, y);
    styleTransparent(cont);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_OVERFLOW_VISIBLE);

    // Container transform scales all children (image + label) together
    // Upper slot: pivot top-left (shrinks upward). Lower slot: pivot bottom-left (shrinks downward).
    lv_obj_set_style_transform_pivot_x(cont, 0, 0);
    lv_obj_set_style_transform_pivot_y(cont, upperSlot ? 0 : LEFT_PANEL_SIGN_NATIVE, 0);
    lv_obj_set_style_transform_scale_x(cont, LEFT_PANEL_SIGN_SCALE, 0);
    lv_obj_set_style_transform_scale_y(cont, LEFT_PANEL_SIGN_SCALE, 0);

    lv_obj_t* img = lv_image_create(cont);
    lv_image_set_src(img, signImgSrc);
    lv_obj_set_pos(img, 0, 0);

    // QML: IntelOne Display Medium, pixelSize 36, scale 1.6-(len*0.2)
    // Container transform at 0.732 brings native sizes to final on-screen size.
    // Font selected at runtime by LvglValueDisplayNode based on text length.
    lv_obj_t* label = lv_label_create(cont);
    lv_label_set_text(label, "");
    lv_obj_set_style_text_font(label, &intelone_medium_44, 0);
    lv_obj_set_style_text_color(label, lv_color_black(), 0);
    lv_obj_align(label, LV_ALIGN_CENTER, 0, 2);

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

    // QML: RTW alert is inside main_panel, status bar (with ME logo) remains visible above it.
    // Since LVGL RTW is full-screen black, add a logo at top to replicate the status bar look.
    lv_obj_t* rtwLogo = lv_image_create(cont);
    lv_image_set_src(rtwLogo, "A:images/logo/ME_status_logo.png");
    lv_obj_align(rtwLogo, LV_ALIGN_TOP_MID, 0, STATUS_BAR_MARGIN + 5);

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

static const int RIGHT_PANEL_SIGN_NATIVE = 136; // native image size

lv_obj_t* LvglWidgets::createRightPanelSign(lv_obj_t* parent, const char* imageSrc, bool upperSlot)
{
    // QML: SideIcon quadrant 1 (upper-right) / quadrant 4 (lower-right)
    // Container is native image size (136x136) to prevent clipping during intro animation.
    // Container transform_scale shrinks to final size. Pivot top-right so sign anchors to right edge.
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, RIGHT_PANEL_SIGN_NATIVE, RIGHT_PANEL_SIGN_NATIVE);
    // Final position: right edge at screen edge → x = 320 - 136 = 184
    // y: align visual top/bottom with margins
    int x = DISPLAY_WIDTH - RIGHT_PANEL_SIGN_NATIVE;
    int y = upperSlot ? (MAIN_PANEL_Y + RIGHT_PANEL_MARGIN)
                      : (DISPLAY_HEIGHT - RIGHT_PANEL_MARGIN - RIGHT_PANEL_SIGN_NATIVE);
    lv_obj_set_pos(cont, x, y);
    styleTransparent(cont);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_OVERFLOW_VISIBLE);

    // Pivot top-right: sign scales toward the right edge of screen
    lv_obj_set_style_transform_pivot_x(cont, RIGHT_PANEL_SIGN_NATIVE, 0);
    lv_obj_set_style_transform_pivot_y(cont, upperSlot ? 0 : RIGHT_PANEL_SIGN_NATIVE, 0);
    lv_obj_set_style_transform_scale_x(cont, RIGHT_PANEL_SIGN_SCALE, 0);
    lv_obj_set_style_transform_scale_y(cont, RIGHT_PANEL_SIGN_SCALE, 0);

    lv_obj_t* img = lv_image_create(cont);
    lv_image_set_src(img, imageSrc);
    lv_obj_set_pos(img, 0, 0);

    return cont;
}
