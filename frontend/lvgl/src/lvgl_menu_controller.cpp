#include "lvgl_menu_controller.h"
#include "canmanager.h"
#include "version_info.h"
#include <SDL2/SDL.h>
#include <cstdio>

LV_FONT_DECLARE(intelone_bold_18);
LV_FONT_DECLARE(intelone_bold_20);
// Menus must use the IntelOne brand font like the Qt frontend, not LVGL's
// built-in Montserrat fallback (IMS-11660).
LV_FONT_DECLARE(intelone_medium_14);
LV_FONT_DECLARE(intelone_medium_17);
LV_FONT_DECLARE(intelone_medium_28);

static const int DISPLAY_WIDTH = 320;
static const int DISPLAY_HEIGHT = 240;

// Menu colors (from QML ProgressBarMenu)
static const lv_color_t COLOR_BG    = lv_color_hex(0x191414);
static const lv_color_t COLOR_BLUE  = lv_color_hex(0x00bfff);
static const lv_color_t COLOR_WHITE = lv_color_hex(0xe1f1ff);
static const lv_color_t COLOR_GRAY  = lv_color_hex(0x3c4246);

// Progress bar layout
static const int BAR_X = 30;
static const int BAR_WIDTH = 260;
static const int BAR_Y = 122;  // value_rect top(68) + height(40) + margin(14)
static const int BAR_HEIGHT = 8;
static const int BALL_SIZE = 25;

// Footer
static const int FOOTER_DOT_SIZE = 14;
static const int FOOTER_SPACING = 14;
static const int FOOTER_Y = DISPLAY_HEIGHT - 30;

// Brightness icon image paths (1-5)
static const char* BRIGHTNESS_ICONS[] = {
    nullptr, // index 0 unused
    "A:images/brightness/brightness-1.png",
    "A:images/brightness/brightness-2.png",
    "A:images/brightness/brightness-3.png",
    "A:images/brightness/brightness-4.png",
    "A:images/brightness/brightness-5.png",
};

// ISA big icon image paths (mode 0-2)
static const char* ISA_BIG_ICONS[] = {
    "A:images/isa-menu/ISA_full_deact_big.png",
    "A:images/isa-menu/ISA_part_deact_big.png",
    "A:images/isa-menu/ISA_full_act_big.png",
};

// Volume icon paths
static const char* VOLUME_MUTE_ICON = "A:images/master-volume/m_mute.png";
static const char* VOLUME_LOW_ICON  = "A:images/master-volume/m_vol_low.png";
static const char* VOLUME_HIGH_ICON = "A:images/master-volume/m_vol_high.png";

// Helper: create a full-screen dark menu container, hidden
static lv_obj_t* createMenuScreen(lv_obj_t* parent)
{
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, DISPLAY_WIDTH, DISPLAY_HEIGHT);
    lv_obj_set_pos(cont, 0, 0);
    lv_obj_set_style_bg_color(cont, COLOR_BG, 0);
    lv_obj_set_style_bg_opa(cont, LV_OPA_COVER, 0);
    lv_obj_set_style_border_width(cont, 0, 0);
    lv_obj_set_style_radius(cont, 0, 0);
    lv_obj_set_style_pad_all(cont, 0, 0);
    lv_obj_remove_flag(cont, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);
    return cont;
}

LvglMenuController::LvglMenuController(lv_obj_t* parent, CanManager* canmgr)
    : parent_(parent)
    , canmgr_(canmgr)
    , currentMenu_(MENU_NONE)
    , brightnessLevel_(5)
    , volumeValue_(0), volumeMin_(0), volumeMax_(5)
    , isaMode_(0)
    , isaAvailable_(false)
    , menusEnabled_(true)
    , volumeEnabled_(true)
    , autoHideTimer_(nullptr)
    , qrActive_(false)
    , qrActivateTimer_(nullptr)
    , qrDeactivateTimer_(nullptr)
{
    // --- Brightness menu ---
    brightnessScreen_ = createMenuScreen(parent);

    brightnessIcon_ = lv_image_create(brightnessScreen_);
    lv_image_set_src(brightnessIcon_, BRIGHTNESS_ICONS[5]);
    lv_obj_align(brightnessIcon_, LV_ALIGN_TOP_MID, 0, 13);

    brightnessValueLabel_ = lv_label_create(brightnessScreen_);
    lv_label_set_text(brightnessValueLabel_, "5");
    lv_obj_set_style_text_font(brightnessValueLabel_, &intelone_medium_28, 0);
    lv_obj_set_style_text_color(brightnessValueLabel_, COLOR_BLUE, 0);
    lv_obj_align(brightnessValueLabel_, LV_ALIGN_TOP_MID, 0, 68);

    brightnessBar_ = createProgressBar(brightnessScreen_, BAR_Y, 5, 1);
    brightnessFooter_ = createFooterDots(brightnessScreen_, 3, 0);

    // --- Volume menu ---
    volumeScreen_ = createMenuScreen(parent);

    volumeIcon_ = lv_image_create(volumeScreen_);
    lv_image_set_src(volumeIcon_, VOLUME_MUTE_ICON);
    lv_obj_align(volumeIcon_, LV_ALIGN_TOP_MID, 0, 13);

    volumeValueLabel_ = lv_label_create(volumeScreen_);
    lv_label_set_text(volumeValueLabel_, "0");
    lv_obj_set_style_text_font(volumeValueLabel_, &intelone_medium_28, 0);
    lv_obj_set_style_text_color(volumeValueLabel_, COLOR_BLUE, 0);
    lv_obj_align(volumeValueLabel_, LV_ALIGN_TOP_MID, 0, 68);

    volumeBar_ = createProgressBar(volumeScreen_, BAR_Y, 6, 0);

    // --- ISA menu ---
    isaScreen_ = createMenuScreen(parent);

    // ISA title logo at the top, mirroring the QML ISAIndicator (ISA.png). The
    // LVGL ISA menu had no title — only the big mode icon — so the menu header
    // was missing (IMS-11655). The big mode icon moves down to the value slot
    // (y=68), matching the QML value_rectangle and the brightness/volume menus.
    isaTitle_ = lv_image_create(isaScreen_);
    lv_image_set_src(isaTitle_, "A:images/isa-menu/ISA.png");
    lv_obj_align(isaTitle_, LV_ALIGN_TOP_MID, 0, 13);

    isaIcon_ = lv_image_create(isaScreen_);
    lv_image_set_src(isaIcon_, ISA_BIG_ICONS[0]);
    lv_obj_align(isaIcon_, LV_ALIGN_TOP_MID, 0, 68);

    isaBar_ = createProgressBar(isaScreen_, BAR_Y, 3, 0);
    createFooterDots(isaScreen_, 3, 1);

    // --- About menu ---
    aboutScreen_ = createMenuScreen(parent);

    lv_obj_t* infoLogo = lv_image_create(aboutScreen_);
    lv_image_set_src(infoLogo, "A:images/about/info-logo.png");
    lv_obj_align(infoLogo, LV_ALIGN_TOP_MID, 0, 13);

    // Info rows: column layout
    lv_obj_t* infoContainer = lv_obj_create(aboutScreen_);
    lv_obj_set_size(infoContainer, 260, LV_SIZE_CONTENT);
    lv_obj_set_pos(infoContainer, 30, 80);
    lv_obj_set_style_bg_opa(infoContainer, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(infoContainer, 0, 0);
    lv_obj_set_style_pad_all(infoContainer, 0, 0);
    lv_obj_set_style_pad_row(infoContainer, 3, 0);
    lv_obj_remove_flag(infoContainer, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_flex_flow(infoContainer, LV_FLEX_FLOW_COLUMN);

    // Info rows (label: value). The version values come from the backend —
    // engine from the MAJOR/MINOR/OTA build macros, config from ConfigVersion
    // in configs/EW8_Config.json — instead of the old hardcoded "1.0.0", which
    // made the About menu always show the wrong values (IMS-11649).
    VersionInfo version = buildVersionInfo();

    // ME8 SN row — top row, matching Qt AboutMenu ("ME8 SN", value=mesn, shown
    // only when is_available_mesn). The serial arrives live on the INFO_QRCODE
    // string argument; hidden until then (IMS: missing ME8 SN on INFO menu).
    me8SnRow_ = lv_obj_create(infoContainer);
    lv_obj_set_size(me8SnRow_, 260, 20);
    lv_obj_set_style_bg_opa(me8SnRow_, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(me8SnRow_, 0, 0);
    lv_obj_set_style_pad_all(me8SnRow_, 0, 0);
    lv_obj_remove_flag(me8SnRow_, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_add_flag(me8SnRow_, LV_OBJ_FLAG_HIDDEN);
    {
        lv_obj_t* lbl = lv_label_create(me8SnRow_);
        lv_label_set_text(lbl, "ME8 SN:");
        lv_obj_set_style_text_font(lbl, &intelone_medium_17, 0);
        lv_obj_set_style_text_color(lbl, COLOR_WHITE, 0);
        lv_obj_set_pos(lbl, 0, 0);

        me8SnValueLabel_ = lv_label_create(me8SnRow_);
        lv_label_set_text(me8SnValueLabel_, "");
        lv_obj_set_style_text_font(me8SnValueLabel_, &intelone_medium_17, 0);
        lv_obj_set_style_text_color(me8SnValueLabel_, COLOR_WHITE, 0);
        lv_obj_set_pos(me8SnValueLabel_, 110, 0);
    }

    // Qt AboutMenu hides the "EW8 SN" row when the serial is "NA"; mirror that by
    // skipping any row whose value is "N/A" (so the menu matches Qt's 3 rows).
    const char* infoLabels[] = { "EW8 App:", "EW8 Config:", "EW8 SN:" };
    const std::string infoValues[] = { version.engine, version.config, "N/A" };
    for (int i = 0; i < 3; i++) {
        if (infoValues[i] == "N/A") continue;
        lv_obj_t* row = lv_obj_create(infoContainer);
        lv_obj_set_size(row, 260, 20);
        lv_obj_set_style_bg_opa(row, LV_OPA_TRANSP, 0);
        lv_obj_set_style_border_width(row, 0, 0);
        lv_obj_set_style_pad_all(row, 0, 0);
        lv_obj_remove_flag(row, LV_OBJ_FLAG_SCROLLABLE);

        lv_obj_t* lbl = lv_label_create(row);
        lv_label_set_text(lbl, infoLabels[i]);
        lv_obj_set_style_text_font(lbl, &intelone_medium_17, 0);
        lv_obj_set_style_text_color(lbl, COLOR_WHITE, 0);
        lv_obj_set_pos(lbl, 0, 0);

        lv_obj_t* val = lv_label_create(row);
        lv_label_set_text(val, infoValues[i].c_str());
        lv_obj_set_style_text_font(val, &intelone_medium_17, 0);
        lv_obj_set_style_text_color(val, COLOR_WHITE, 0);
        lv_obj_set_pos(val, 110, 0);
    }

    aboutFooter_ = createFooterDots(aboutScreen_, 3, 2);

    // --- QR Code screen ---
    qrScreen_ = createMenuScreen(parent);

    // Top bar with logo
    lv_obj_t* qrBar = lv_obj_create(qrScreen_);
    lv_obj_set_size(qrBar, DISPLAY_WIDTH, 43);
    lv_obj_set_pos(qrBar, 0, 0);
    lv_obj_set_style_bg_color(qrBar, lv_color_black(), 0);
    lv_obj_set_style_bg_opa(qrBar, LV_OPA_COVER, 0);
    lv_obj_set_style_border_width(qrBar, 0, 0);
    lv_obj_set_style_pad_all(qrBar, 0, 0);
    lv_obj_set_style_radius(qrBar, 0, 0);
    lv_obj_remove_flag(qrBar, LV_OBJ_FLAG_SCROLLABLE);

    lv_obj_t* qrLogo = lv_image_create(qrBar);
    lv_image_set_src(qrLogo, "A:images/logo/ME_status_logo.png");
    lv_obj_align(qrLogo, LV_ALIGN_TOP_MID, 0, 5);

    // QR code widget (real QR rendering via LVGL lv_qrcode)
    qrCode_ = lv_qrcode_create(qrScreen_);
    lv_qrcode_set_size(qrCode_, 150);
    lv_qrcode_set_dark_color(qrCode_, lv_color_black());
    lv_qrcode_set_light_color(qrCode_, lv_color_white());
    lv_obj_align(qrCode_, LV_ALIGN_CENTER, 0, 15);
    // Default placeholder text
    lv_qrcode_update(qrCode_, "https://mobileye.com", 20);

    // Fallback label (shown below QR code for URL text)
    qrLabel_ = lv_label_create(qrScreen_);
    lv_label_set_text(qrLabel_, "");
    lv_obj_set_style_text_font(qrLabel_, &intelone_medium_14, 0);
    lv_obj_set_style_text_color(qrLabel_, COLOR_WHITE, 0);
    lv_obj_align(qrLabel_, LV_ALIGN_BOTTOM_MID, 0, -10);
}

LvglMenuController::ProgressBar LvglMenuController::createProgressBar(
    lv_obj_t* parent, int y, int numSegments, int lowerLimit, bool /*useImages*/)
{
    ProgressBar pb = {};
    pb.barWidth = BAR_WIDTH;
    pb.barX = BAR_X;

    // Background bar (gray)
    lv_obj_t* bgBar = lv_obj_create(parent);
    lv_obj_set_size(bgBar, BAR_WIDTH, BAR_HEIGHT);
    lv_obj_set_pos(bgBar, BAR_X, y);
    lv_obj_set_style_bg_color(bgBar, COLOR_GRAY, 0);
    lv_obj_set_style_bg_opa(bgBar, LV_OPA_COVER, 0);
    lv_obj_set_style_border_width(bgBar, 0, 0);
    lv_obj_set_style_radius(bgBar, 4, 0);
    lv_obj_set_style_pad_all(bgBar, 0, 0);
    lv_obj_remove_flag(bgBar, LV_OBJ_FLAG_SCROLLABLE);

    // Fill bar (blue, starts at 0 width)
    pb.fillBar = lv_obj_create(parent);
    lv_obj_set_size(pb.fillBar, 0, BAR_HEIGHT);
    lv_obj_set_pos(pb.fillBar, BAR_X, y);
    lv_obj_set_style_bg_color(pb.fillBar, COLOR_BLUE, 0);
    lv_obj_set_style_bg_opa(pb.fillBar, LV_OPA_COVER, 0);
    lv_obj_set_style_border_width(pb.fillBar, 0, 0);
    lv_obj_set_style_radius(pb.fillBar, 4, 0);
    lv_obj_set_style_pad_all(pb.fillBar, 0, 0);
    lv_obj_remove_flag(pb.fillBar, LV_OBJ_FLAG_SCROLLABLE);

    // Ball indicator
    pb.ball = lv_obj_create(parent);
    lv_obj_set_size(pb.ball, BALL_SIZE, BALL_SIZE);
    lv_obj_set_pos(pb.ball, BAR_X - BALL_SIZE / 2, y - (BALL_SIZE - BAR_HEIGHT) / 2);
    lv_obj_set_style_bg_color(pb.ball, COLOR_WHITE, 0);
    lv_obj_set_style_bg_opa(pb.ball, LV_OPA_COVER, 0);
    lv_obj_set_style_border_color(pb.ball, COLOR_BLUE, 0);
    lv_obj_set_style_border_width(pb.ball, 3, 0);
    lv_obj_set_style_radius(pb.ball, BALL_SIZE, 0);
    lv_obj_set_style_pad_all(pb.ball, 0, 0);
    lv_obj_remove_flag(pb.ball, LV_OBJ_FLAG_SCROLLABLE);

    // Segment tick marks and labels
    for (int i = 0; i < numSegments; i++) {
        int segX = (numSegments > 1) ? BAR_X + (i * BAR_WIDTH / (numSegments - 1)) : BAR_X;

        // Tick mark
        lv_obj_t* tick = lv_obj_create(parent);
        lv_obj_set_size(tick, 2, 8);
        lv_obj_set_pos(tick, segX - 1, y + BAR_HEIGHT);
        lv_obj_set_style_bg_color(tick, COLOR_GRAY, 0);
        lv_obj_set_style_bg_opa(tick, LV_OPA_COVER, 0);
        lv_obj_set_style_border_width(tick, 0, 0);
        lv_obj_set_style_radius(tick, 0, 0);
        lv_obj_set_style_pad_all(tick, 0, 0);
        lv_obj_remove_flag(tick, LV_OBJ_FLAG_SCROLLABLE);

        // Label
        lv_obj_t* lbl = lv_label_create(parent);
        char buf[8];
        snprintf(buf, sizeof(buf), "%d", i + lowerLimit);
        lv_label_set_text(lbl, buf);
        lv_obj_set_style_text_font(lbl, &intelone_medium_17, 0);
        lv_obj_set_style_text_color(lbl, COLOR_GRAY, 0);
        lv_obj_align(lbl, LV_ALIGN_TOP_LEFT, segX - 5, y + BAR_HEIGHT + 12);
    }

    return pb;
}

void LvglMenuController::updateProgressBar(ProgressBar& pb, int value, int lowerLimit, int numSegments)
{
    if (numSegments <= 1) return;

    int fillWidth = (value - lowerLimit) * pb.barWidth / (numSegments - 1);
    if (fillWidth < 0) fillWidth = 0;
    if (fillWidth > pb.barWidth) fillWidth = pb.barWidth;

    lv_obj_set_width(pb.fillBar, fillWidth);

    int ballX = pb.barX + fillWidth - BALL_SIZE / 2;
    lv_obj_set_pos(pb.ball, ballX, lv_obj_get_y(pb.ball));
}

lv_obj_t* LvglMenuController::createFooterDots(lv_obj_t* parent, int numDots, int activeDot)
{
    // Transparent full-width container holding the dots, so the count can be
    // rebuilt when ISA presence changes the number of carousel pages. Dots sit
    // at y=0 inside a container at FOOTER_Y, so absolute positions are unchanged.
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, DISPLAY_WIDTH, FOOTER_DOT_SIZE + 6);
    lv_obj_set_pos(cont, 0, FOOTER_Y);
    lv_obj_set_style_bg_opa(cont, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(cont, 0, 0);
    lv_obj_set_style_pad_all(cont, 0, 0);
    lv_obj_set_style_radius(cont, 0, 0);
    lv_obj_remove_flag(cont, LV_OBJ_FLAG_SCROLLABLE);
    rebuildFooterDots(cont, numDots, activeDot);
    return cont;
}

void LvglMenuController::rebuildFooterDots(lv_obj_t* cont, int numDots, int activeDot)
{
    if (!cont) return;
    lv_obj_clean(cont);
    int totalWidth = numDots * FOOTER_DOT_SIZE + (numDots - 1) * FOOTER_SPACING;
    int startX = (DISPLAY_WIDTH - totalWidth) / 2;

    for (int i = 0; i < numDots; i++) {
        lv_obj_t* dot = lv_obj_create(cont);
        lv_obj_set_size(dot, FOOTER_DOT_SIZE, FOOTER_DOT_SIZE);
        lv_obj_set_pos(dot, startX + i * (FOOTER_DOT_SIZE + FOOTER_SPACING), 0);
        lv_obj_set_style_bg_color(dot, (i == activeDot) ? COLOR_BLUE : COLOR_GRAY, 0);
        lv_obj_set_style_bg_opa(dot, LV_OPA_COVER, 0);
        lv_obj_set_style_border_width(dot, 0, 0);
        lv_obj_set_style_radius(dot, FOOTER_DOT_SIZE, 0);
        lv_obj_set_style_pad_all(dot, 0, 0);
        lv_obj_remove_flag(dot, LV_OBJ_FLAG_SCROLLABLE);
    }
}

void LvglMenuController::autoHideTimerCb(lv_timer_t* timer)
{
    auto* ctrl = static_cast<LvglMenuController*>(lv_timer_get_user_data(timer));
    ctrl->hideAllMenus();
}

void LvglMenuController::restartAutoHide(int intervalMs)
{
    if (autoHideTimer_) {
        lv_timer_delete(autoHideTimer_);
    }
    autoHideTimer_ = lv_timer_create(autoHideTimerCb, intervalMs, this);
    lv_timer_set_repeat_count(autoHideTimer_, 1);
}

void LvglMenuController::showMenu(MenuPage page)
{
    hideAllMenus();
    currentMenu_ = page;

    switch (page) {
    case MENU_BRIGHTNESS:
        // QML pages binding: carousel is 3 pages with ISA, 2 without.
        rebuildFooterDots(brightnessFooter_, isaAvailable_ ? 3 : 2, 0);
        lv_obj_remove_flag(brightnessScreen_, LV_OBJ_FLAG_HIDDEN);
        updateBrightnessDisplay();
        restartAutoHide(5000);
        break;
    case MENU_ISA:
        lv_obj_remove_flag(isaScreen_, LV_OBJ_FLAG_HIDDEN);
        updateISADisplay();
        restartAutoHide(5000);
        break;
    case MENU_ABOUT:
        // About is the last page: dot index 2 of 3 (with ISA) or 1 of 2 (without).
        rebuildFooterDots(aboutFooter_, isaAvailable_ ? 3 : 2, isaAvailable_ ? 2 : 1);
        lv_obj_remove_flag(aboutScreen_, LV_OBJ_FLAG_HIDDEN);
        restartAutoHide(120000);
        break;
    default:
        break;
    }

    // A left-panel sign may have been lifted above the menu screens by
    // lv_obj_move_foreground() during a prior display update; re-assert the
    // opaque menu on top so signs (e.g. TSR/ISA speed) don't show over it
    // (IMS-11654 follow-up: cover the key-press open path, not just CAN updates).
    raiseActiveScreenIfVisible();
}

void LvglMenuController::hideAllMenus()
{
    currentMenu_ = MENU_NONE;
    lv_obj_add_flag(brightnessScreen_, LV_OBJ_FLAG_HIDDEN);
    lv_obj_add_flag(volumeScreen_, LV_OBJ_FLAG_HIDDEN);
    lv_obj_add_flag(isaScreen_, LV_OBJ_FLAG_HIDDEN);
    lv_obj_add_flag(aboutScreen_, LV_OBJ_FLAG_HIDDEN);

    if (autoHideTimer_) {
        lv_timer_delete(autoHideTimer_);
        autoHideTimer_ = nullptr;
    }
}

void LvglMenuController::updateBrightnessDisplay()
{
    if (brightnessLevel_ < 1) brightnessLevel_ = 1;
    if (brightnessLevel_ > 5) brightnessLevel_ = 5;

    lv_image_set_src(brightnessIcon_, BRIGHTNESS_ICONS[brightnessLevel_]);

    char buf[4];
    snprintf(buf, sizeof(buf), "%d", brightnessLevel_);
    lv_label_set_text(brightnessValueLabel_, buf);

    updateProgressBar(brightnessBar_, brightnessLevel_, 1, 5);
}

void LvglMenuController::updateISADisplay()
{
    if (isaMode_ < 0) isaMode_ = 0;
    if (isaMode_ > 2) isaMode_ = 2;

    lv_image_set_src(isaIcon_, ISA_BIG_ICONS[isaMode_]);
    updateProgressBar(isaBar_, isaMode_, 0, 3);
}

void LvglMenuController::updateVolumeDisplay()
{
    // Update icon based on value
    if (volumeValue_ == 0) {
        lv_image_set_src(volumeIcon_, VOLUME_MUTE_ICON);
    } else if (volumeValue_ < 3) {
        lv_image_set_src(volumeIcon_, VOLUME_LOW_ICON);
    } else {
        lv_image_set_src(volumeIcon_, VOLUME_HIGH_ICON);
    }

    char buf[4];
    snprintf(buf, sizeof(buf), "%d", volumeValue_);
    lv_label_set_text(volumeValueLabel_, buf);

    int numSegments = volumeMax_ - volumeMin_ + 1;
    if (numSegments < 2) numSegments = 2;
    updateProgressBar(volumeBar_, volumeValue_, volumeMin_, numSegments);
}

void LvglMenuController::handleKeyEvent(int sdlKey)
{
    switch (sdlKey) {
    case SDLK_RETURN:
        // Cycle menus: none → brightness → [ISA if available] → about → none
        // Volume menu is entered externally via VOLUME_DONE CAN; Return sends mute
        //
        // QML isDisplayOfMenusEnabled gate: while the speed display is up (or an
        // error overlay is showing) the brightness/ISA/about menus must not be
        // accessible. Return then just clears any of them (it never opens one).
        // The volume menu is exempt — it is CAN-driven and handles its own keys.
        if (!menusEnabled_ && currentMenu_ != MENU_VOLUME) {
            hideAllMenus();
            break;
        }
        switch (currentMenu_) {
        case MENU_NONE:
            showMenu(MENU_BRIGHTNESS);
            break;
        case MENU_BRIGHTNESS:
            if (isaAvailable_)
                showMenu(MENU_ISA);
            else
                showMenu(MENU_ABOUT);
            break;
        case MENU_ISA:
            showMenu(MENU_ABOUT);
            break;
        case MENU_ABOUT:
            hideAllMenus();
            break;
        case MENU_VOLUME:
            // QML: Return in volume menu → sendVolumeGet() (mute toggle)
            if (canmgr_) canmgr_->sendVolumeGet();
            restartAutoHide(5000);
            break;
        }
        break;

    case SDLK_UP:
        switch (currentMenu_) {
        case MENU_BRIGHTNESS:
            if (brightnessLevel_ < 5) {
                brightnessLevel_++;
                updateBrightnessDisplay();
            }
            restartAutoHide(5000);
            break;
        case MENU_ISA:
            // QML isa_menu.up() is request-only: it sends the CAN command based
            // on the CURRENT (real) ISA state; the menu icon updates when the ECU
            // reports the new state back via setIsaMode(). No optimistic local
            // increment (that fought the real state — IMS: ISA menu wrong state).
            if (canmgr_) {
                if (isaMode_ == 0) canmgr_->sendISAPartDeact();
                else if (isaMode_ == 1) canmgr_->sendISAFullActivate();
            }
            restartAutoHide(5000);
            break;
        case MENU_VOLUME:
            if (canmgr_) canmgr_->sendVolumeUp();
            restartAutoHide(5000);
            break;
        case MENU_NONE:
            // QML is_volume_enabled: on the idle screen (no menu open) Up/Down
            // drive the master volume. The volume menu is opened by the reply
            // (VOLUME_DONE) to this request — without sending it here the volume
            // menu was unreachable (IMS-11656). Gated like is_remote_menu_
            // request_enabled (no disconnect/error/FCW overlay up).
            if (volumeEnabled_ && canmgr_) canmgr_->sendVolumeUp();
            break;
        default:
            break;
        }
        break;

    case SDLK_DOWN:
        switch (currentMenu_) {
        case MENU_BRIGHTNESS:
            if (brightnessLevel_ > 1) {
                brightnessLevel_--;
                updateBrightnessDisplay();
            }
            restartAutoHide(5000);
            break;
        case MENU_ISA:
            // QML isa_menu.down(): request-only, based on the current real state.
            if (canmgr_) {
                if (isaMode_ == 1) canmgr_->sendISAFullDeact();
                else if (isaMode_ == 2) canmgr_->sendISAPartDeact();
            }
            restartAutoHide(5000);
            break;
        case MENU_VOLUME:
            if (canmgr_) canmgr_->sendVolumeDown();
            restartAutoHide(5000);
            break;
        case MENU_NONE:
            // Idle-screen master-volume shortcut — see SDLK_UP/MENU_NONE above
            // (IMS-11656).
            if (volumeEnabled_ && canmgr_) canmgr_->sendVolumeDown();
            break;
        default:
            break;
        }
        break;
    }
}

void LvglMenuController::showVolumeMenu(uint8_t value, uint8_t min, uint8_t max)
{
    volumeValue_ = value;
    volumeMin_ = min;
    volumeMax_ = max;

    hideAllMenus();
    currentMenu_ = MENU_VOLUME;
    lv_obj_remove_flag(volumeScreen_, LV_OBJ_FLAG_HIDDEN);
    updateVolumeDisplay();
    restartAutoHide(5000);
    raiseActiveScreenIfVisible();
}

void LvglMenuController::hideVolumeMenu()
{
    lv_obj_add_flag(volumeScreen_, LV_OBJ_FLAG_HIDDEN);
}

void LvglMenuController::showVolumeFail()
{
    // Show volume menu with red alert icon briefly
    lv_image_set_src(volumeIcon_, "A:images/master-volume/m_red alert.png");
    lv_obj_remove_flag(volumeScreen_, LV_OBJ_FLAG_HIDDEN);
    restartAutoHide(5000);
    raiseActiveScreenIfVisible();
}

void LvglMenuController::activateQRCode(const std::string& data)
{
    // QML: setVisibleSlotStr stores data and sets is_active = true, but does NOT show QR
    qrData_ = data;
    qrActive_ = true;
    // The INFO_QRCODE string arg is the ME8 serial number (Qt: about_menu.mesn);
    // surface it on the About menu's ME8 SN row.
    setMe8Sn(data);
}

void LvglMenuController::setMe8Sn(const std::string& sn)
{
    if (sn.empty() || !me8SnRow_ || !me8SnValueLabel_) return;
    lv_label_set_text(me8SnValueLabel_, sn.c_str());
    lv_obj_remove_flag(me8SnRow_, LV_OBJ_FLAG_HIDDEN);
}

void LvglMenuController::setIsaMode(int mode)
{
    if (mode < 0) mode = 0;
    if (mode > 2) mode = 2;
    if (mode == isaMode_) return;
    isaMode_ = mode;
    if (currentMenu_ == MENU_ISA) updateISADisplay();   // live-refresh if open
}

void LvglMenuController::deactivateQRCode()
{
    // QML: setInvisibleSlot — hide QR, clear active, stop timers
    qrActive_ = false;
    lv_obj_add_flag(qrScreen_, LV_OBJ_FLAG_HIDDEN);
    if (qrActivateTimer_) {
        lv_timer_delete(qrActivateTimer_);
        qrActivateTimer_ = nullptr;
    }
    if (qrDeactivateTimer_) {
        lv_timer_delete(qrDeactivateTimer_);
        qrDeactivateTimer_ = nullptr;
    }
}

void LvglMenuController::handleDualKeyPress()
{
    // QML: Up+Down simultaneous press while is_active starts 5-second timer
    if (!qrActive_) return;
    if (qrActivateTimer_) return; // already counting down

    qrActivateTimer_ = lv_timer_create(qrActivateTimerCb, 5000, this);
    lv_timer_set_repeat_count(qrActivateTimer_, 1);
}

void LvglMenuController::qrActivateTimerCb(lv_timer_t* timer)
{
    auto* ctrl = static_cast<LvglMenuController*>(lv_timer_get_user_data(timer));
    ctrl->qrActivateTimer_ = nullptr;

    // Show QR code
    if (!ctrl->qrData_.empty()) {
        lv_qrcode_update(ctrl->qrCode_, ctrl->qrData_.c_str(), ctrl->qrData_.size());
        lv_label_set_text(ctrl->qrLabel_, ctrl->qrData_.c_str());
    }
    lv_obj_remove_flag(ctrl->qrScreen_, LV_OBJ_FLAG_HIDDEN);

    // Start 20-second auto-hide timer
    if (ctrl->qrDeactivateTimer_) {
        lv_timer_delete(ctrl->qrDeactivateTimer_);
    }
    ctrl->qrDeactivateTimer_ = lv_timer_create(qrDeactivateTimerCb, 20000, ctrl);
    lv_timer_set_repeat_count(ctrl->qrDeactivateTimer_, 1);
}

void LvglMenuController::qrDeactivateTimerCb(lv_timer_t* timer)
{
    auto* ctrl = static_cast<LvglMenuController*>(lv_timer_get_user_data(timer));
    ctrl->qrDeactivateTimer_ = nullptr;
    lv_obj_add_flag(ctrl->qrScreen_, LV_OBJ_FLAG_HIDDEN);
}

void LvglMenuController::setIsaAvailable(bool available)
{
    isaAvailable_ = available;
    // If ISA just became unavailable while ISA menu is showing, skip to about
    if (!available && currentMenu_ == MENU_ISA) {
        showMenu(MENU_ABOUT);
    }
}

void LvglMenuController::setMenusEnabled(bool enabled)
{
    if (enabled == menusEnabled_) {
        return;
    }
    menusEnabled_ = enabled;

    // QML onIsDisplayOfMenusEnabledChanged: when the speed display takes over
    // (or an error appears), any open speed-gated menu is dismissed at once.
    // The volume menu and QR overlay are driven by CAN / dual-key, not this
    // gate, so they are left untouched.
    if (!enabled &&
        (currentMenu_ == MENU_BRIGHTNESS || currentMenu_ == MENU_ISA ||
         currentMenu_ == MENU_ABOUT)) {
        hideAllMenus();
    }
}

void LvglMenuController::setVolumeEnabled(bool enabled)
{
    volumeEnabled_ = enabled;
}

void LvglMenuController::raiseActiveScreenIfVisible()
{
    // Menus/QR are full-screen opaque overlays that must sit above the
    // left-panel signs (QML z>=20). The main process lifts changed signs with
    // lv_obj_move_foreground(), which can put a sign above an open menu; move
    // the visible screen(s) back to the front to cover it again. Order matters
    // only if several are visible at once (QR ends up on top, as in QML).
    lv_obj_t* screens[] = { brightnessScreen_, volumeScreen_, isaScreen_,
                            aboutScreen_, qrScreen_ };
    for (lv_obj_t* s : screens) {
        if (s && !lv_obj_has_flag(s, LV_OBJ_FLAG_HIDDEN)) {
            lv_obj_move_foreground(s);
        }
    }
}
