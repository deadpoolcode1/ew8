#include "lvgl_main_process.h"
#include "lvgl_display_node.h"
#include "lvgl_value_display_node.h"
#include "lvgl_string_display_node.h"
#include "lvgl_blink_display_node.h"
#include "lvgl_hmw_state_node.h"
#include "lvgl_menu_controller.h"
#include "lvgl_menu_display_node.h"
#include "lvgl_test_display_node.h"
#include "lvgl_widgets.h"
#include "lvgl_notice_loader.h"
#include "lvgl_scene_loader.h"
#include "entitytype.h"

#include <map>
#include "alerttypes_core.h"
#include "graphicitemsenummap.h"
#include "display_tree.h"
#include "core/core.h"
#include "core/elapsed_timer.h"

extern core::ElapsedTimer bootUpTimer;

// Signal-test screen text uses the IntelOne brand font (Qt's SignalTestSpeed
// uses IntelOne), not LVGL's built-in Montserrat fallback (IMS-11660).
LV_FONT_DECLARE(intelone_medium_17);
LV_FONT_DECLARE(intelone_medium_28);

static const int DISPLAY_WIDTH = 320;
static const int DISPLAY_HEIGHT = 240;

LvglMainProcess::LvglMainProcess(lv_obj_t* screen)
    : displayRoot_(nullptr)
    , displayDirty_(false)
    , hostCar_(nullptr)
    , lastCarOffset_(0)
    , lldwNode_(nullptr)
    , rldwNode_(nullptr)
    , groupGAG_(nullptr)
    , groupCIPV_(nullptr)
    , groupFCW_(nullptr)
    , disconPanel_(nullptr)
    , mainPanel_(nullptr)
    , failsafeNode_(nullptr)
    , hmwValueLabel_(nullptr)
    , hmwDistanceNode_(nullptr)
    , hmwAlertNode_(nullptr)
    , hmwMonitorNode_(nullptr)
    , pdzNode_(nullptr)
    , speedNode_(nullptr)
    , errorNode_(nullptr)
    , menuController_(nullptr)
{
    coreDebug() << "LvglMainProcess init begin, time:" << bootUpTimer.elapsed();

    alertController_ = new AlertController();
    canmgr_ = new CanManager(alertController_);

    coreDebug() << "CanManager init complete, time:" << bootUpTimer.elapsed();

    // Generate the alert type map (required before linking display nodes)
    EntityType::generateTypes();

    // Build the display tree (registers leaf nodes with EntityType)
    buildDisplayTree(screen);

    // Worker thread kicks the (now event-driven) display pipeline once at start.
    // Display commits are coalesced in applyPendingDisplayUpdate() on the main
    // thread; the previous per-frame core::Timer debounce was removed because
    // under continuous real-CAN traffic it never expired and froze the display.
    itsThread_ = new core::Thread();
    itsThread_->started.connect([this]() { process(); });

    alertController_->setMessageCallback([](const std::string& msg) {
        coreDebug() << "Message:" << msg;
    });

    alertController_->setProcessCallback([this]() { process(); });

    coreDebug() << "LvglMainProcess init complete, time:" << bootUpTimer.elapsed();
}

LvglMainProcess::~LvglMainProcess()
{
    delete canmgr_;
    delete alertController_;
    delete itsThread_;
}

// Helper: create a transparent full-screen container for the tree root
static lv_obj_t* createRootContainer(lv_obj_t* screen)
{
    lv_obj_t* w = lv_obj_create(screen);
    lv_obj_set_size(w, DISPLAY_WIDTH, DISPLAY_HEIGHT);
    lv_obj_set_style_bg_opa(w, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(w, 0, 0);
    lv_obj_set_style_pad_all(w, 0, 0);
    lv_obj_set_style_radius(w, 0, 0);
    lv_obj_align(w, LV_ALIGN_TOP_LEFT, 0, 0);
    lv_obj_remove_flag(w, LV_OBJ_FLAG_SCROLLABLE);
    return w;
}

// Helper: link parent ↔ child in the display tree
static void addChild(LvglDisplayNode* parent, LvglDisplayNode* child)
{
    child->setParent(parent);
    parent->appendChild(child);
}

void LvglMainProcess::buildDisplayTree(lv_obj_t* screen)
{
    // --- Resolve entity type IDs from string names ---
    DISPLAY_ITEM_ID ID_ALERT_FCW          = GraphicItemsEnumMap::getId("ALERT_FCW");
    DISPLAY_ITEM_ID ID_ALERT_PCW          = GraphicItemsEnumMap::getId("ALERT_PCW");
    DISPLAY_ITEM_ID ID_INFO_VEH_SPEED     = GraphicItemsEnumMap::getId("INFO_VEH_SPEED");
    DISPLAY_ITEM_ID ID_ALERT_HMW_DISTANCE = GraphicItemsEnumMap::getId("ALERT_HMW_DISTANCE");
    DISPLAY_ITEM_ID ID_ALERT_LLDW         = GraphicItemsEnumMap::getId("ALERT_LLDW");
    DISPLAY_ITEM_ID ID_ALERT_RLDW         = GraphicItemsEnumMap::getId("ALERT_RLDW");
    DISPLAY_ITEM_ID ID_ALERT_ERROR        = GraphicItemsEnumMap::getId("ALERT_ERROR");

    // Bulk 1: Status bar + op modes
    DISPLAY_ITEM_ID ID_ALERT_HI_BEAM          = GraphicItemsEnumMap::getId("ALERT_HI_BEAM");
    DISPLAY_ITEM_ID ID_ALERT_LOW_BEAM         = GraphicItemsEnumMap::getId("ALERT_LOW_BEAM");
    DISPLAY_ITEM_ID ID_ALERT_BLINKERS         = GraphicItemsEnumMap::getId("ALERT_BLINKERS");
    DISPLAY_ITEM_ID ID_INFO_NO_GPS            = GraphicItemsEnumMap::getId("INFO_NO_GPS");
    DISPLAY_ITEM_ID ID_INFO_NO_GSM            = GraphicItemsEnumMap::getId("INFO_NO_GSM");
    DISPLAY_ITEM_ID ID_INFO_DRIVER_AUTH_IN     = GraphicItemsEnumMap::getId("INFO_DRIVER_AUTH_IN");
    DISPLAY_ITEM_ID ID_INFO_DRIVER_AUTH_OUT    = GraphicItemsEnumMap::getId("INFO_DRIVER_AUTH_OUT");
    DISPLAY_ITEM_ID ID_INFO_DRIVER_AUTH_PROCESS = GraphicItemsEnumMap::getId("INFO_DRIVER_AUTH_PROCESS");
    DISPLAY_ITEM_ID ID_ALERT_ISA_ERROR        = GraphicItemsEnumMap::getId("ALERT_ISA_ERROR");
    DISPLAY_ITEM_ID ID_INFO_ISA_INACTIVE      = GraphicItemsEnumMap::getId("INFO_ISA_INACTIVE");
    DISPLAY_ITEM_ID ID_INFO_ISA_PARTIAL       = GraphicItemsEnumMap::getId("INFO_ISA_PARTIAL");
    DISPLAY_ITEM_ID ID_INFO_ISA_FULL_ACTIVE   = GraphicItemsEnumMap::getId("INFO_ISA_FULL_ACTIVE");
    DISPLAY_ITEM_ID ID_OM_MUTE                = GraphicItemsEnumMap::getId("OM_MUTE");
    DISPLAY_ITEM_ID ID_INFO_FAILSAFE          = GraphicItemsEnumMap::getId("INFO_FAILSAFE");
    DISPLAY_ITEM_ID ID_OM_POWEROFF            = GraphicItemsEnumMap::getId("OM_POWEROFF");
    DISPLAY_ITEM_ID ID_OM_KEEPPWR             = GraphicItemsEnumMap::getId("OM_KEEPPWR");
    DISPLAY_ITEM_ID ID_OM_PILOT               = GraphicItemsEnumMap::getId("OM_PILOT");
    DISPLAY_ITEM_ID ID_INFO_SPEED_SHOW        = GraphicItemsEnumMap::getId("INFO_SPEED_SHOW");
    DISPLAY_ITEM_ID ID_OM_NORMAL              = GraphicItemsEnumMap::getId("OM_NORMAL");
    DISPLAY_ITEM_ID ID_INFO_GPS_OK            = GraphicItemsEnumMap::getId("INFO_GPS_OK");

    // Bulk 2: HMW states + PDZ + LDW on/off
    DISPLAY_ITEM_ID ID_ALERT_HMW_ALERT        = GraphicItemsEnumMap::getId("ALERT_HMW_ALERT");
    DISPLAY_ITEM_ID ID_ALERT_HMW_MONITOR      = GraphicItemsEnumMap::getId("ALERT_HMW_MONITOR");
    DISPLAY_ITEM_ID ID_ALERT_PDZ              = GraphicItemsEnumMap::getId("ALERT_PDZ");
    DISPLAY_ITEM_ID ID_ALERT_LEFT_LDWOFF      = GraphicItemsEnumMap::getId("ALERT_LEFT_LDWOFF");
    DISPLAY_ITEM_ID ID_ALERT_RIGHT_LDWOFF     = GraphicItemsEnumMap::getId("ALERT_RIGHT_LDWOFF");
    DISPLAY_ITEM_ID ID_ALERT_LEFT_LDWON       = GraphicItemsEnumMap::getId("ALERT_LEFT_LDWON");
    DISPLAY_ITEM_ID ID_ALERT_RIGHT_LDWON      = GraphicItemsEnumMap::getId("ALERT_RIGHT_LDWON");

    // Bulk 3: TSR/SLI left panel signs
    DISPLAY_ITEM_ID ID_ALERT_RTW_WARN         = GraphicItemsEnumMap::getId("ALERT_RTW_WARN");
    DISPLAY_ITEM_ID ID_ALERT_RTW_ALERT        = GraphicItemsEnumMap::getId("ALERT_RTW_ALERT");
    DISPLAY_ITEM_ID ID_ALERT_SLI              = GraphicItemsEnumMap::getId("ALERT_SLI");
    DISPLAY_ITEM_ID ID_ALERT_SLI_SHOW         = GraphicItemsEnumMap::getId("ALERT_SLI_SHOW");
    DISPLAY_ITEM_ID ID_ALERT_SLI_SUPP         = GraphicItemsEnumMap::getId("ALERT_SLI_SUPP");
    DISPLAY_ITEM_ID ID_ALERT_END_ALL_RESTR    = GraphicItemsEnumMap::getId("ALERT_END_ALL_RESTR");
    DISPLAY_ITEM_ID ID_ALERT_NO_PASS          = GraphicItemsEnumMap::getId("ALERT_NO_PASS");
    DISPLAY_ITEM_ID ID_ALERT_NO_PASS_END      = GraphicItemsEnumMap::getId("ALERT_NO_PASS_END");
    DISPLAY_ITEM_ID ID_ALERT_NO_PASS_SUPP     = GraphicItemsEnumMap::getId("ALERT_NO_PASS_SUPP");
    DISPLAY_ITEM_ID ID_ALERT_MOTORWAY         = GraphicItemsEnumMap::getId("ALERT_MOTORWAY");
    DISPLAY_ITEM_ID ID_ALERT_MOTORWAY_END     = GraphicItemsEnumMap::getId("ALERT_MOTORWAY_END");
    DISPLAY_ITEM_ID ID_ALERT_MOTORWAY_SUPP    = GraphicItemsEnumMap::getId("ALERT_MOTORWAY_SUPP");
    DISPLAY_ITEM_ID ID_ALERT_EXPRESSWAY       = GraphicItemsEnumMap::getId("ALERT_EXPRESSWAY");
    DISPLAY_ITEM_ID ID_ALERT_EXPRESSWAY_END   = GraphicItemsEnumMap::getId("ALERT_EXPRESSWAY_END");
    DISPLAY_ITEM_ID ID_ALERT_EXPRESSWAY_SUPP  = GraphicItemsEnumMap::getId("ALERT_EXPRESSWAY_SUPP");
    DISPLAY_ITEM_ID ID_ALERT_PLAYGROUND       = GraphicItemsEnumMap::getId("ALERT_PLAYGROUND");
    DISPLAY_ITEM_ID ID_ALERT_PLAYGROUND_END   = GraphicItemsEnumMap::getId("ALERT_PLAYGROUND_END");
    DISPLAY_ITEM_ID ID_ALERT_PLAYGROUND_SUPP  = GraphicItemsEnumMap::getId("ALERT_PLAYGROUND_SUPP");
    DISPLAY_ITEM_ID ID_ALERT_ISA_SPEED        = GraphicItemsEnumMap::getId("ALERT_ISA_SPEED");
    DISPLAY_ITEM_ID ID_ALERT_ISA_OVERSPEED    = GraphicItemsEnumMap::getId("ALERT_ISA_OVERSPEED");
    DISPLAY_ITEM_ID ID_ALERT_ISA_HIGHWAY      = GraphicItemsEnumMap::getId("ALERT_ISA_HIGHWAY");
    DISPLAY_ITEM_ID ID_STATE_TSR_NOT_ISA      = GraphicItemsEnumMap::getId("STATE_TSR_NOT_ISA");
    DISPLAY_ITEM_ID ID_STATE_ISA_NOT_TSR      = GraphicItemsEnumMap::getId("STATE_ISA_NOT_TSR");
    DISPLAY_ITEM_ID ID_SHAPE_USA              = GraphicItemsEnumMap::getId("SHAPE_USA");
    DISPLAY_ITEM_ID ID_INFO_ISA_VERSION       = GraphicItemsEnumMap::getId("INFO_ISA_VERSION");
    DISPLAY_ITEM_ID ID_INFO_ISA_BUNDLE        = GraphicItemsEnumMap::getId("INFO_ISA_BUNDLE");

    // Bulk 4: SmartADAS right panel (11 primary + 11 secondary)
    DISPLAY_ITEM_ID ID_SMART_CROWDED          = GraphicItemsEnumMap::getId("SMART_CROWDED");
    DISPLAY_ITEM_ID ID_SMART_PED_HWY          = GraphicItemsEnumMap::getId("SMART_PED_HWY");
    DISPLAY_ITEM_ID ID_SMART_CYC_HWY          = GraphicItemsEnumMap::getId("SMART_CYC_HWY");
    DISPLAY_ITEM_ID ID_SMART_WEA_ROAD         = GraphicItemsEnumMap::getId("SMART_WEA_ROAD");
    DISPLAY_ITEM_ID ID_SMART_WEA_HYDRO        = GraphicItemsEnumMap::getId("SMART_WEA_HYDRO");
    DISPLAY_ITEM_ID ID_SMART_WEA_FG           = GraphicItemsEnumMap::getId("SMART_WEA_FG");
    DISPLAY_ITEM_ID ID_SMART_WEA_WND          = GraphicItemsEnumMap::getId("SMART_WEA_WND");
    DISPLAY_ITEM_ID ID_SMART_WEA_HAIL         = GraphicItemsEnumMap::getId("SMART_WEA_HAIL");
    DISPLAY_ITEM_ID ID_SMART_WEA_TSTM         = GraphicItemsEnumMap::getId("SMART_WEA_TSTM");
    DISPLAY_ITEM_ID ID_SMART_HARSH_DZ         = GraphicItemsEnumMap::getId("SMART_HARSH_DZ");
    DISPLAY_ITEM_ID ID_SMART_CA               = GraphicItemsEnumMap::getId("SMART_CA");
    DISPLAY_ITEM_ID ID_SMART_CROWDED_SEC      = GraphicItemsEnumMap::getId("SMART_CROWDED_SEC");
    DISPLAY_ITEM_ID ID_SMART_PED_HWY_SEC      = GraphicItemsEnumMap::getId("SMART_PED_HWY_SEC");
    DISPLAY_ITEM_ID ID_SMART_CYC_HWY_SEC      = GraphicItemsEnumMap::getId("SMART_CYC_HWY_SEC");
    DISPLAY_ITEM_ID ID_SMART_WEA_ROAD_SEC     = GraphicItemsEnumMap::getId("SMART_WEA_ROAD_SEC");
    DISPLAY_ITEM_ID ID_SMART_WEA_HYDRO_SEC    = GraphicItemsEnumMap::getId("SMART_WEA_HYDRO_SEC");
    DISPLAY_ITEM_ID ID_SMART_WEA_FG_SEC       = GraphicItemsEnumMap::getId("SMART_WEA_FG_SEC");
    DISPLAY_ITEM_ID ID_SMART_WEA_WND_SEC      = GraphicItemsEnumMap::getId("SMART_WEA_WND_SEC");
    DISPLAY_ITEM_ID ID_SMART_WEA_HAIL_SEC     = GraphicItemsEnumMap::getId("SMART_WEA_HAIL_SEC");
    DISPLAY_ITEM_ID ID_SMART_WEA_TSTM_SEC     = GraphicItemsEnumMap::getId("SMART_WEA_TSTM_SEC");
    DISPLAY_ITEM_ID ID_SMART_HARSH_DZ_SEC     = GraphicItemsEnumMap::getId("SMART_HARSH_DZ_SEC");
    DISPLAY_ITEM_ID ID_SMART_CA_SEC           = GraphicItemsEnumMap::getId("SMART_CA_SEC");

    // Bulk 5: Menus + QR code
    DISPLAY_ITEM_ID ID_FUNC_BUTTONS           = GraphicItemsEnumMap::getId("FUNC_BUTTONS");
    DISPLAY_ITEM_ID ID_VOLUME_DONE            = GraphicItemsEnumMap::getId("VOLUME_DONE");
    DISPLAY_ITEM_ID ID_VOLUME_FAIL            = GraphicItemsEnumMap::getId("VOLUME_FAIL");
    DISPLAY_ITEM_ID ID_INFO_QRCODE            = GraphicItemsEnumMap::getId("INFO_QRCODE");

    // Missing entities: registered as dummy nodes to prevent silent ALERT_NONE fallback
    DISPLAY_ITEM_ID ID_TEST_SPEED_VALUE       = GraphicItemsEnumMap::getId("TEST_SPEED_VALUE");
    DISPLAY_ITEM_ID ID_SMART_FATIGUE          = GraphicItemsEnumMap::getId("SMART_FATIGUE");
    DISPLAY_ITEM_ID ID_SMART_BUMPERS          = GraphicItemsEnumMap::getId("SMART_BUMPERS");
    DISPLAY_ITEM_ID ID_SMART_FATIGUE_SEC      = GraphicItemsEnumMap::getId("SMART_FATIGUE_SEC");
    DISPLAY_ITEM_ID ID_SMART_BUMPERS_SEC      = GraphicItemsEnumMap::getId("SMART_BUMPERS_SEC");

    // Bulk 6: Diagnostics / Tests
    DISPLAY_ITEM_ID ID_RGB_RED                = GraphicItemsEnumMap::getId("RGB_RED");
    DISPLAY_ITEM_ID ID_RGB_GREEN              = GraphicItemsEnumMap::getId("RGB_GREEN");
    DISPLAY_ITEM_ID ID_RGB_BLUE               = GraphicItemsEnumMap::getId("RGB_BLUE");
    DISPLAY_ITEM_ID ID_RGB_WHITE              = GraphicItemsEnumMap::getId("RGB_WHITE");
    DISPLAY_ITEM_ID ID_TV_PATTERN             = GraphicItemsEnumMap::getId("TV_PATTERN");
    DISPLAY_ITEM_ID ID_INFO_TEST_SIGNALS      = GraphicItemsEnumMap::getId("INFO_TEST_SIGNALS");
    DISPLAY_ITEM_ID ID_TEST_BRAKES            = GraphicItemsEnumMap::getId("TEST_BRAKES");
    DISPLAY_ITEM_ID ID_TEST_WIPERS            = GraphicItemsEnumMap::getId("TEST_WIPERS");
    DISPLAY_ITEM_ID ID_TEST_HIGH_BEAM         = GraphicItemsEnumMap::getId("TEST_HIGH_BEAM");
    DISPLAY_ITEM_ID ID_TEST_BLINKER_LEFT      = GraphicItemsEnumMap::getId("TEST_BLINKER_LEFT");
    DISPLAY_ITEM_ID ID_TEST_BLINKER_RIGHT     = GraphicItemsEnumMap::getId("TEST_BLINKER_RIGHT");
    DISPLAY_ITEM_ID ID_TEST_REVERSE           = GraphicItemsEnumMap::getId("TEST_REVERSE");
    DISPLAY_ITEM_ID ID_TEST_SPEED             = GraphicItemsEnumMap::getId("TEST_SPEED");
    DISPLAY_ITEM_ID ID_INFO_TEST_PERIPHERALS  = GraphicItemsEnumMap::getId("INFO_TEST_PERIPHERALS");
    DISPLAY_ITEM_ID ID_INFO_TEST_GSM          = GraphicItemsEnumMap::getId("INFO_TEST_GSM");
    DISPLAY_ITEM_ID ID_INFO_TEST_GPS          = GraphicItemsEnumMap::getId("INFO_TEST_GPS");
    DISPLAY_ITEM_ID ID_INFO_TEST_GYRO         = GraphicItemsEnumMap::getId("INFO_TEST_GYRO");

    // --- Create LVGL widgets ---
    // Widget creation order determines LVGL visual stacking (later = on top).
    // Ordered to match QML z-values: content(1-6) < status(1) < failsafe(10) <
    // disconnect(11) < tests(12) < FCW/PCW(15) < error(20) < menus(20+)
    lv_obj_t* rootWidget = createRootContainer(screen);
    // Allow children to overflow for sign intro animations (image at start scale
    // extends beyond its container bounds)
    lv_obj_add_flag(screen, LV_OBJ_FLAG_OVERFLOW_VISIBLE);
    lv_obj_add_flag(rootWidget, LV_OBJ_FLAG_OVERFLOW_VISIBLE);

    // 1. Content widgets (lowest visual layer)
    // Creation order = LVGL visual z-order (later = on top).
    // QML z-values: HMW(1) < lanes(4) < forward_car(5) < host_car(6)
    // PDZ (pedestrian danger-zone) overlay — created FIRST so the HMW road strip
    // and forward car render on top of it (QML: alert_pdz z:1 < forward_car z:5,
    // so the CIPV/forward car draws over the pedestrian — fixes PED_DZ/CIPV overlap).
    lv_obj_t* pdzWidget = LvglWidgets::createPDZOverlay(rootWidget);

    // HMW display (road strip + forward car) — above PDZ.
    LvglWidgets::HMWWidgets hmw = LvglWidgets::createHMWDisplay(rootWidget);

    // LDW indicators: created after HMW so they render on top (QML z:4)
    lv_obj_t* ldwOffLeftWidget  = LvglWidgets::createLDWOffIndicator(rootWidget, true);
    lv_obj_t* ldwOffRightWidget = LvglWidgets::createLDWOffIndicator(rootWidget, false);
    lv_obj_t* ldwLeftWidget     = LvglWidgets::createLDWIndicator(rootWidget, true);
    lv_obj_t* ldwRightWidget    = LvglWidgets::createLDWIndicator(rootWidget, false);
    lv_obj_t* ldwOnLeftWidget   = LvglWidgets::createLDWOnIndicator(rootWidget, true);
    lv_obj_t* ldwOnRightWidget  = LvglWidgets::createLDWOnIndicator(rootWidget, false);

    // Host car — created after lanes so it renders on top (QML z:6 > lanes z:4)
    // QML: anchors.bottom: parent.bottom, bottomMargin: -5, width: 160
    // Push further down so less of the car is visible (more realistic)
    hostCar_ = lv_image_create(rootWidget);
    lv_image_set_src(hostCar_, "A:images/cars/grey_car_bright.png");
    lv_image_set_scale(hostCar_, 208);  // 197→160px (160/197*256)
    lv_obj_align(hostCar_, LV_ALIGN_BOTTOM_MID, 0, 13);
    lv_obj_add_flag(hostCar_, LV_OBJ_FLAG_HIDDEN);  // QML: visible only when groupGAG || groupCIPV

    lv_obj_t* speedValueLabel = nullptr;
    lv_obj_t* speedUnitLabel = nullptr;
    lv_obj_t* speedWidget     = LvglWidgets::createSpeedDisplay(rootWidget, &speedValueLabel, &speedUnitLabel);

    // Left panel signs — upper slot (RTW, SLI, ISA)
    lv_obj_t* rtwWarnWidget = LvglWidgets::createLeftPanelSign(rootWidget,
        "A:images/traffic-violation/left_TV_RL_small.png", true);

    lv_obj_t* sliSpeedLabel = nullptr;
    lv_obj_t* sliWidget = LvglWidgets::createSpeedLimitSign(rootWidget,
        "A:images/left-panel/SLI/left_SLI_circ.png", true, &sliSpeedLabel);

    lv_obj_t* isaSpeedLabel = nullptr;
    lv_obj_t* isaSpeedWidget = LvglWidgets::createSpeedLimitSign(rootWidget,
        "A:images/left-panel/ISA/bellow_speed.png", true, &isaSpeedLabel);

    lv_obj_t* isaHighwayWidget = LvglWidgets::createLeftPanelSign(rootWidget,
        "A:images/left-panel/TSR/left_expressway_beg.png", true);

    // Left panel signs — lower slot (TSR signs, all mutually exclusive)
    lv_obj_t* endAllRestrWidget = LvglWidgets::createLeftPanelSign(rootWidget,
        "A:images/left-panel/TSR/black_stripes.png", false);
    lv_obj_t* noPassWidget = LvglWidgets::createLeftPanelSign(rootWidget,
        "A:images/left-panel/TSR/left_nopass_red.png", false);
    lv_obj_t* noPassEndWidget = LvglWidgets::createLeftPanelSign(rootWidget,
        "A:images/left-panel/TSR/left_nopass_end.png", false);
    lv_obj_t* motorwayWidget = LvglWidgets::createLeftPanelSign(rootWidget,
        "A:images/left-panel/TSR/left_motorway_beg.png", false);
    lv_obj_t* motorwayEndWidget = LvglWidgets::createLeftPanelSign(rootWidget,
        "A:images/left-panel/TSR/left_motorway_end.png", false);
    lv_obj_t* expresswayWidget = LvglWidgets::createLeftPanelSign(rootWidget,
        "A:images/left-panel/TSR/left_expressway_beg.png", false);
    lv_obj_t* expresswayEndWidget = LvglWidgets::createLeftPanelSign(rootWidget,
        "A:images/left-panel/TSR/left_expressway_end.png", false);
    lv_obj_t* playgroundWidget = LvglWidgets::createLeftPanelSign(rootWidget,
        "A:images/left-panel/TSR/left_playgrond_blue.png", false);
    lv_obj_t* playgroundEndWidget = LvglWidgets::createLeftPanelSign(rootWidget,
        "A:images/left-panel/TSR/left_playgrond_blue_end.png", false);

    // Supplementary signs — lower slot (base sign + supp icon overlay)
    lv_obj_t* sliSuppSpeedLabel = nullptr;
    lv_obj_t* sliSuppWidget = LvglWidgets::createSpeedLimitSign(rootWidget,
        "A:images/left-panel/SLI/left_SLI_circ.png", false, &sliSuppSpeedLabel);
    lv_obj_t* noPassSuppWidget = LvglWidgets::createLeftPanelSign(rootWidget,
        "A:images/left-panel/TSR/left_nopass_red.png", false);
    lv_obj_t* motorwaySuppWidget = LvglWidgets::createLeftPanelSign(rootWidget,
        "A:images/left-panel/TSR/left_motorway_beg.png", false);
    lv_obj_t* expresswaySuppWidget = LvglWidgets::createLeftPanelSign(rootWidget,
        "A:images/left-panel/TSR/left_expressway_beg.png", false);
    lv_obj_t* playgroundSuppWidget = LvglWidgets::createLeftPanelSign(rootWidget,
        "A:images/left-panel/TSR/left_playgrond_blue.png", false);

    // QML supp signs use smaller scale: target_scale = 0.6028 * 0.9 = 0.54252 → 139/256
    // Override container transform_scale from standard 187 to 139
    static const int SUPP_SIGN_SCALE = 139;
    auto rescaleSupp = [](lv_obj_t* signWidget) {
        lv_obj_set_style_transform_scale_x(signWidget, SUPP_SIGN_SCALE, 0);
        lv_obj_set_style_transform_scale_y(signWidget, SUPP_SIGN_SCALE, 0);
    };
    rescaleSupp(sliSuppWidget);
    rescaleSupp(noPassSuppWidget);
    rescaleSupp(motorwaySuppWidget);
    rescaleSupp(expresswaySuppWidget);
    rescaleSupp(playgroundSuppWidget);

    // Add supplementary icon overlays to each supp sign (small icon below the sign)
    // QML: Supp anchors.top=parent.bottom, topMargin=-15 → y=112-15=97 in container coords
    // Icons are 112x62 native, same width as container. Container transform scales everything.
    auto addSuppIcon = [](lv_obj_t* signWidget) -> lv_obj_t* {
        lv_obj_t* suppImg = lv_image_create(signWidget);
        lv_image_set_src(suppImg, "A:images/left-panel/Supp/snow.png"); // default
        lv_obj_set_pos(suppImg, 0, 102);
        return suppImg;
    };
    lv_obj_t* sliSuppIcon = addSuppIcon(sliSuppWidget);
    lv_obj_t* noPassSuppIcon = addSuppIcon(noPassSuppWidget);
    lv_obj_t* motorwaySuppIcon = addSuppIcon(motorwaySuppWidget);
    lv_obj_t* expresswaySuppIcon = addSuppIcon(expresswaySuppWidget);
    lv_obj_t* playgroundSuppIcon = addSuppIcon(playgroundSuppWidget);

    // Right panel SmartADAS sign widgets + nodes are now created by the scene
    // loader from configs/scene.json (migrated out of buildDisplayTree). See the
    // "rightPanel" subtree there.

    // 2. Status bar (QML z=1: above content, below full-screen overlays)
    LvglWidgets::StatusBarWidgets sb = LvglWidgets::createStatusBar(rootWidget);

    // 3. Full-screen overlays (created after content so they render on top)
    // Failsafe + op-mode notices: layout/text loaded from configs/notices.json
    // (editable without recompiling). See lvgl_notice_loader.cpp. (QML z=10)
    lv_obj_t* failsafeWidget  = LvglNotice::createNoticeFromConfig(rootWidget, "failsafe");
    lv_obj_t* poweroffWidget  = LvglNotice::createNoticeFromConfig(rootWidget, "opmode_poweroff");
    lv_obj_t* keeppwrWidget   = LvglNotice::createNoticeFromConfig(rootWidget, "opmode_keeppwr");
    lv_obj_t* pilotWidget     = LvglNotice::createNoticeFromConfig(rootWidget, "opmode_pilot");

    // RTW alert (QML z=10)
    lv_obj_t* rtwAlertWidget = LvglWidgets::createRTWAlert(rootWidget);

    // Disconnect overlay (QML z=11) — layout from configs/notices.json
    lv_obj_t* disconWidget  = LvglNotice::createNoticeFromConfig(rootWidget, "disconnect");

    // --- Bulk 6: Display test overlays (QML z=12) ---
    lv_obj_t* rgbRedWidget   = LvglWidgets::createColorOverlay(rootWidget, lv_color_make(255, 0, 0));
    lv_obj_t* rgbGreenWidget = LvglWidgets::createColorOverlay(rootWidget, lv_color_make(0, 128, 0));
    lv_obj_t* rgbBlueWidget  = LvglWidgets::createColorOverlay(rootWidget, lv_color_make(0, 0, 255));
    lv_obj_t* rgbWhiteWidget = LvglWidgets::createColorOverlay(rootWidget, lv_color_white());
    lv_obj_t* tvPatternWidget = LvglWidgets::createTVPatternOverlay(rootWidget);

    // Signal test screen (modeGroup container with background)
    lv_obj_t* signalTestWidget = LvglWidgets::createSignalTestScreen(rootWidget);

    // Signal test small icons in grid (2x5 grid at x=40, y=12 within signalTestWidget)
    // Grid: row 0 cols 0-4, row 1 cols 0-1. Each cell 50x50, spacing 0.
    struct { const char* wildcard; int gridX; int gridY; } signalItems[] = {
        {"Brake",  40,  12},   // row 0, col 0
        {"Whip",   90,  12},   // row 0, col 1
        {"Lights", 140, 12},   // row 0, col 2
        {"Left",   190, 12},   // row 0, col 3
        {"Right",  240, 12},   // row 0, col 4
        {"R",      40,  62},   // row 1, col 0
    };

    lv_obj_t* sigSmallImgs[6];
    lv_obj_t* sigBigImgs[6];
    for (int i = 0; i < 6; i++) {
        // Small icon (50x50 in grid)
        sigSmallImgs[i] = lv_image_create(signalTestWidget);
        char defaultPath[128];
        snprintf(defaultPath, sizeof(defaultPath), "A:images/signal-test/EW8_%s-gry.png",
                 signalItems[i].wildcard);
        lv_image_set_src(sigSmallImgs[i], defaultPath);
        lv_obj_set_pos(sigSmallImgs[i], signalItems[i].gridX, signalItems[i].gridY);
        lv_obj_set_size(sigSmallImgs[i], 50, 50);

        // Big icon (120x120 centered, verticalCenterOffset=49)
        sigBigImgs[i] = lv_image_create(signalTestWidget);
        lv_image_set_src(sigBigImgs[i], defaultPath);
        lv_obj_align(sigBigImgs[i], LV_ALIGN_CENTER, 0, 49);
        lv_obj_set_size(sigBigImgs[i], 120, 120);
        lv_obj_add_flag(sigBigImgs[i], LV_OBJ_FLAG_HIDDEN);
    }

    // Speed small + big icons with text labels
    lv_obj_t* speedSmallImg = lv_image_create(signalTestWidget);
    lv_image_set_src(speedSmallImg, "A:images/signal-test/EW8_Empty-gry.png");
    lv_obj_set_pos(speedSmallImg, 90, 62);  // row 1, col 1
    lv_obj_set_size(speedSmallImg, 50, 50);

    lv_obj_t* speedSmallLabel = lv_label_create(signalTestWidget);
    lv_label_set_text(speedSmallLabel, "X");
    lv_obj_set_style_text_font(speedSmallLabel, &intelone_medium_17, 0);
    lv_obj_set_style_text_color(speedSmallLabel, lv_color_hex(0x99a0a6), 0);
    lv_obj_set_pos(speedSmallLabel, 90 + 25, 62 + 25);
    lv_obj_align(speedSmallLabel, LV_ALIGN_DEFAULT, 0, 0);
    lv_obj_set_pos(speedSmallLabel, 90, 62);
    lv_obj_set_size(speedSmallLabel, 50, 50);
    lv_obj_set_style_text_align(speedSmallLabel, LV_TEXT_ALIGN_CENTER, 0);
    lv_obj_align(speedSmallLabel, LV_ALIGN_DEFAULT, 0, 0);
    // Center the text within the 50x50 area
    lv_obj_set_pos(speedSmallLabel, 90, 62 + 15);

    lv_obj_t* speedBigImg = lv_image_create(signalTestWidget);
    lv_image_set_src(speedBigImg, "A:images/signal-test/EW8_Empty-gry.png");
    lv_obj_align(speedBigImg, LV_ALIGN_CENTER, 0, 49);
    lv_obj_set_size(speedBigImg, 120, 120);
    lv_obj_add_flag(speedBigImg, LV_OBJ_FLAG_HIDDEN);

    lv_obj_t* speedBigLabel = lv_label_create(signalTestWidget);
    lv_label_set_text(speedBigLabel, "X");
    lv_obj_set_style_text_font(speedBigLabel, &intelone_medium_28, 0);
    lv_obj_set_style_text_color(speedBigLabel, lv_color_hex(0x99a0a6), 0);
    lv_obj_align(speedBigLabel, LV_ALIGN_CENTER, 0, 49);
    lv_obj_add_flag(speedBigLabel, LV_OBJ_FLAG_HIDDEN);

    // Peripheral test screen (modeGroup container with background)
    lv_obj_t* peripheralTestWidget = LvglWidgets::createPeripheralTestScreen(rootWidget);

    // GSM group row (y=0, top)
    lv_obj_t* gsmRow = LvglWidgets::createPeripheralTestGroupRow(peripheralTestWidget, "GSM", 0);
    lv_obj_t* gsmIcons[3];
    for (int i = 0; i < 3; i++) {
        gsmIcons[i] = lv_image_create(gsmRow);
        char path[128];
        snprintf(path, sizeof(path), "A:images/peripheral-test/Peripherals_Test_GSM_%d_blu.png", i + 1);
        lv_image_set_src(gsmIcons[i], path);
        lv_obj_set_size(gsmIcons[i], 60, 60);
        lv_obj_set_pos(gsmIcons[i], 70 + i * 65, 10);
        lv_obj_add_flag(gsmIcons[i], LV_OBJ_FLAG_HIDDEN);
    }
    lv_obj_t* gsmResult = lv_image_create(gsmRow);
    lv_image_set_src(gsmResult, "A:images/peripheral-test/Peripherals_Result_blu.png");
    lv_obj_set_size(gsmResult, 39, 39);
    lv_obj_align(gsmResult, LV_ALIGN_RIGHT_MID, -15, 0);
    lv_obj_add_flag(gsmResult, LV_OBJ_FLAG_HIDDEN);

    // GPS group row (y=80, middle)
    lv_obj_t* gpsRow = LvglWidgets::createPeripheralTestGroupRow(peripheralTestWidget, "GPS", 80);
    lv_obj_t* gpsIcons[2];
    for (int i = 0; i < 2; i++) {
        gpsIcons[i] = lv_image_create(gpsRow);
        char path[128];
        snprintf(path, sizeof(path), "A:images/peripheral-test/Peripherals_Test_GPS_%d_blu.png", i + 1);
        lv_image_set_src(gpsIcons[i], path);
        lv_obj_set_size(gpsIcons[i], 60, 60);
        lv_obj_set_pos(gpsIcons[i], 70 + i * 65, 10);
        lv_obj_add_flag(gpsIcons[i], LV_OBJ_FLAG_HIDDEN);
    }
    lv_obj_t* gpsResult = lv_image_create(gpsRow);
    lv_image_set_src(gpsResult, "A:images/peripheral-test/Peripherals_Result_blu.png");
    lv_obj_set_size(gpsResult, 39, 39);
    lv_obj_align(gpsResult, LV_ALIGN_RIGHT_MID, -15, 0);
    lv_obj_add_flag(gpsResult, LV_OBJ_FLAG_HIDDEN);

    // Gyro group row (y=160, bottom)
    lv_obj_t* gyroRow = LvglWidgets::createPeripheralTestGroupRow(peripheralTestWidget, "Gyro", 160);
    lv_obj_t* gyroIcons[2];
    for (int i = 0; i < 2; i++) {
        gyroIcons[i] = lv_image_create(gyroRow);
        char path[128];
        snprintf(path, sizeof(path), "A:images/peripheral-test/Peripherals_Test_Gyro_%d_blu.png", i + 1);
        lv_image_set_src(gyroIcons[i], path);
        lv_obj_set_size(gyroIcons[i], 60, 60);
        lv_obj_set_pos(gyroIcons[i], 70 + i * 65, 10);
        lv_obj_add_flag(gyroIcons[i], LV_OBJ_FLAG_HIDDEN);
    }
    lv_obj_t* gyroResult = lv_image_create(gyroRow);
    lv_image_set_src(gyroResult, "A:images/peripheral-test/Peripherals_Result_blu.png");
    lv_obj_set_size(gyroResult, 39, 39);
    lv_obj_align(gyroResult, LV_ALIGN_RIGHT_MID, -15, 0);
    lv_obj_add_flag(gyroResult, LV_OBJ_FLAG_HIDDEN);

    // FCW/PCW (QML z=15: above all content, status bar, and test overlays)
    lv_obj_t* fcwWidget     = LvglWidgets::createFCWAlert(rootWidget);
    lv_obj_t* pcwWidget     = LvglWidgets::createPCWAlert(rootWidget);

    // Error overlay (QML z=20: above everything except menus) — layout from
    // configs/notices.json; the dynamic error-code label is tagged id "error_code".
    std::map<std::string, lv_obj_t*> errorEls;
    lv_obj_t* errorWidget = LvglNotice::createNoticeFromConfig(rootWidget, "error", &errorEls);
    lv_obj_t* errorCodeLabel = errorEls.count("error_code") ? errorEls["error_code"] : nullptr;

    // Menu controller (QML z=20+: highest z-order)
    menuController_ = new LvglMenuController(rootWidget, canmgr_);

    // --- Build display tree ---
    // root (group, layer=0)
    displayRoot_ = new LvglDisplayNode(rootWidget, 0, false, false);

    // general_panel (group, layer=0)
    auto* generalPanel = new LvglDisplayNode(nullptr, 0, false, false);
    addChild(displayRoot_, generalPanel);

    // discon_panel (group, layer=0)
    auto* disconPanel = new LvglDisplayNode(nullptr, 0, false, false);
    disconPanel_ = disconPanel;
    addChild(generalPanel, disconPanel);

    // disconPanel children (error/disconnect/op-mode overlays) → scene.json.
    // errorNode_ is fetched from the scene result below (menu/host-car gating).

    // main_panel (group, layer=2)
    auto* mainPanel = new LvglDisplayNode(nullptr, 2, false, false);
    mainPanel_ = mainPanel;
    addChild(generalPanel, mainPanel);

    // failsafe overlay node → scene.json (under generalPanel). failsafeNode_
    // fetched from the scene result below (HMW text gating).

    // groupCIPV (group, layer=1)
    auto* groupCIPV = new LvglDisplayNode(nullptr, 1, false, false);
    groupCIPV_ = groupCIPV;
    addChild(mainPanel, groupCIPV);

    // HMW distance value + HMW alert/monitor state nodes → scene.json (under
    // groupCIPV). hmwValueLabel_ is a widget the glue needs (HMW text gating);
    // hmwDistanceNode_/hmwAlertNode_/hmwMonitorNode_ fetched from scene result.
    hmwValueLabel_ = hmw.valueLabel;

    // PDZ overlay node → scene.json ("pdzNode", widget_id "pdz").

    // groupGAG (group, layer=1)
    auto* groupGAG = new LvglDisplayNode(nullptr, 1, false, false);
    groupGAG_ = groupGAG;
    addChild(mainPanel, groupGAG);

    // groupLanes/groupLanesLeft/groupLanesRight + LDW off/active/on nodes →
    // scene.json (under groupGAG). lldwNode_/rldwNode_ are fetched from the
    // scene result below for the host-car-shift glue.

    // groupFCW (group, layer=2 — SAME layer as mainPanel/statusPanel, matching
    // QML main.qml groupFCW layer_pri:2 "Decreased from 1 to prevent reinit of
    // SLI and TSR". At equal layer the tree does NOT force-hide the panels; the
    // full-screen opaque FCW/PCW GIF (raised to the front after the scene loads,
    // see below) occludes them by z-order instead. This keeps the left/right-
    // panel signs and the SADAS panel CAN-active (their intro animations do not
    // replay when the alert clears — fixes "ReINIT SADAS/TSR-supp after Focus").
    auto* groupFCW = new LvglDisplayNode(nullptr, 2, false, false);
    groupFCW_ = groupFCW;
    addChild(generalPanel, groupFCW);

    // FCW/PCW gif nodes → scene.json (under groupFCW, widget_id fcw/pcw + gif_id).

    // status_panel (group, layer=2)
    auto* statusPanel = new LvglDisplayNode(nullptr, 2, false, false);
    addChild(generalPanel, statusPanel);

    // speed node → scene.json (widget_id speed + value/unit labels). speedNode_
    // fetched from the scene result below (menu gating / speed value).

    // Beam group + blinker nodes → scene.json (widget_id hi_beam/lo_beam/blinker).

    // ISA group (mutexGroup=true)
    // ISA status-bar group (error/inactive/partial/active) → scene.json
    // ("isaGroup" under statusPanel); isaInactiveNode referenced by isa_state.

    // Signed-driver group + GPS/GSM/mute icons + OM_NORMAL/INFO_GPS_OK dummies
    // → scene.json (widget_id signed_*/gps/gsm/mute).

    // INFO_SPEED_SHOW dummy → scene.json; speedNode->setSpeedShowNode wired
    // there via "speed_show_node".

    // --- Left panel signs (Bulk 3) ---
    // leftPanel (group, layer=1) under mainPanel — QML left_panel layer_pri=1
    auto* leftPanel = new LvglDisplayNode(nullptr, 1, false, false);
    addChild(mainPanel, leftPanel);
    // groupTop/groupBottom (TSR/SLI/ISA signs + supp signs), ISA/TSR state
    // machines, overspeed, shape-USA, and the ISA-version/bundle dummies are
    // built by the scene loader from the scene.json "leftPanel" subtree.
    // groupTop_/groupBottom_ are fetched from the scene result below.

    // SmartADAS right-panel widgets + nodes are built by the scene loader from
    // the scene.json "rightPanel" subtree (migrated out of buildDisplayTree).

    // Menu entities (FUNC_BUTTONS dummy + VOLUME_DONE/FAIL + INFO_QRCODE) and
    // the signal/peripheral test screens (modeGroup panels + their item nodes)
    // are built by the scene loader from scene.json (widget_id refs into the
    // test-screen widgets registered above).

    // --- Data-driven scene extension (configs/scene.json) ---
    // Attach any config-defined nodes under the named parent groups below. This
    // is what makes a whole new alert/indicator addable by configuration alone
    // (graphic item + CAN binding + image + placement), with no recompile —
    // matching the Qt/QML frontend's "feature by config" capability. The
    // hand-built tree above is untouched, so existing behaviour is unchanged.
    std::map<std::string, LvglDisplayNode*> sceneParents = {
        {"root", displayRoot_},
        {"generalPanel", generalPanel},
        {"mainPanel", mainPanel},
        {"disconPanel", disconPanel},
        {"groupCIPV", groupCIPV},
        {"groupGAG", groupGAG},
        {"groupFCW", groupFCW},
        {"statusPanel", statusPanel},
        {"leftPanel", leftPanel},
    };
    // Widgets created above and registered here by id can be referenced from
    // scene.json via "widget_id", so a node's assembly can move to config while
    // its widget stays created in C++ (preserving creation order / z-order).
    std::map<std::string, lv_obj_t*> sceneWidgets = {
        {"pdz", pdzWidget},
        {"rtw_alert", rtwAlertWidget},
        {"rgb_red", rgbRedWidget},
        {"rgb_green", rgbGreenWidget},
        {"rgb_blue", rgbBlueWidget},
        {"rgb_white", rgbWhiteWidget},
        {"tv_pattern", tvPatternWidget},
        {"ldw_off_left", ldwOffLeftWidget},
        {"ldw_off_right", ldwOffRightWidget},
        {"ldw_left", ldwLeftWidget},
        {"ldw_right", ldwRightWidget},
        {"ldw_on_left", ldwOnLeftWidget},
        {"ldw_on_right", ldwOnRightWidget},
        {"sb_hi_beam", sb.hiBeamIcon},
        {"sb_lo_beam", sb.loBeamIcon},
        {"sb_blinker", sb.blinkerIcon},
        {"sb_signed_in", sb.signedInIcon},
        {"sb_signed_out", sb.signedOutIcon},
        {"sb_signed_process", sb.signedProcessIcon},
        {"sb_gps", sb.gpsIcon},
        {"sb_gsm", sb.gsmIcon},
        {"sb_mute", sb.muteIcon},
        {"hmw_container", hmw.container},
        {"hmw_value_label", hmw.valueLabel},
        {"hmw_road_strip", hmw.roadStrip},
        {"hmw_forward_car", hmw.forwardCar},
        {"fcw", fcwWidget},
        {"fcw_gif", lv_obj_get_child(fcwWidget, 0)},
        {"pcw", pcwWidget},
        {"pcw_gif", lv_obj_get_child(pcwWidget, 0)},
        {"speed", speedWidget},
        {"speed_value_label", speedValueLabel},
        {"speed_unit_label", speedUnitLabel},
        {"error_overlay", errorWidget},
        {"error_code_label", errorCodeLabel},
        {"discon", disconWidget},
        {"poweroff", poweroffWidget},
        {"keeppwr", keeppwrWidget},
        {"pilot", pilotWidget},
        {"failsafe", failsafeWidget},
        {"sb_isa_error", sb.isaErrorIcon},
        {"sb_isa_inactive", sb.isaInactiveIcon},
        {"sb_isa_partial", sb.isaPartialIcon},
        {"sb_isa_active", sb.isaActiveIcon},
        {"rtw_warn", rtwWarnWidget},
        {"sli", sliWidget},
        {"sli_speed_label", sliSpeedLabel},
        {"sli_sign_img", lv_obj_get_child(sliWidget, 0)},
        {"isa_speed", isaSpeedWidget},
        {"isa_speed_label", isaSpeedLabel},
        {"isa_highway", isaHighwayWidget},
        {"end_all_restr", endAllRestrWidget},
        {"no_pass", noPassWidget},
        {"no_pass_end", noPassEndWidget},
        {"motorway", motorwayWidget},
        {"motorway_end", motorwayEndWidget},
        {"expressway", expresswayWidget},
        {"expressway_end", expresswayEndWidget},
        {"playground", playgroundWidget},
        {"playground_end", playgroundEndWidget},
        {"sli_supp", sliSuppWidget},
        {"sli_supp_speed_label", sliSuppSpeedLabel},
        {"sli_supp_icon", sliSuppIcon},
        {"sli_supp_sign_img", lv_obj_get_child(sliSuppWidget, 0)},
        {"no_pass_supp", noPassSuppWidget},
        {"no_pass_supp_icon", noPassSuppIcon},
        {"motorway_supp", motorwaySuppWidget},
        {"motorway_supp_icon", motorwaySuppIcon},
        {"expressway_supp", expresswaySuppWidget},
        {"expressway_supp_icon", expresswaySuppIcon},
        {"playground_supp", playgroundSuppWidget},
        {"playground_supp_icon", playgroundSuppIcon},
        {"signal_test_bg", signalTestWidget},
        {"speed_small_img", speedSmallImg},
        {"speed_big_img", speedBigImg},
        {"speed_small_label", speedSmallLabel},
        {"speed_big_label", speedBigLabel},
        {"peripheral_bg", peripheralTestWidget},
        {"gsm_row", gsmRow}, {"gsm_0", gsmIcons[0]}, {"gsm_1", gsmIcons[1]}, {"gsm_2", gsmIcons[2]}, {"gsm_result", gsmResult},
        {"gps_row", gpsRow}, {"gps_0", gpsIcons[0]}, {"gps_1", gpsIcons[1]}, {"gps_result", gpsResult},
        {"gyro_row", gyroRow}, {"gyro_0", gyroIcons[0]}, {"gyro_1", gyroIcons[1]}, {"gyro_result", gyroResult},
    };
    // Signal-test icon arrays (registered by index for scene.json widget_id refs).
    for (int i = 0; i < 6; ++i) {
        char k[24];
        snprintf(k, sizeof(k), "sig_small_%d", i); sceneWidgets[k] = sigSmallImgs[i];
        snprintf(k, sizeof(k), "sig_big_%d", i);   sceneWidgets[k] = sigBigImgs[i];
    }
    LvglScene::Result sceneResult =
        LvglScene::loadInto(rootWidget, sceneParents, sceneWidgets, menuController_);

    // The scene loader creates the SADAS right-panel (and other) widgets last, so
    // they sit above the FCW/PCW GIFs in z-order. Now that groupFCW shares the
    // panels' layer (no tree force-hide), the full-screen FCW/PCW alert must
    // occlude those panels by z-order — lift the GIFs above the loader widgets.
    // They stay HIDDEN until activated, and the disconnect/error/op-mode overlays
    // (disconPanel) still cover FCW because they force-hide generalPanel (which
    // contains groupFCW) via the tree, independent of z-order.
    if (fcwWidget) lv_obj_move_foreground(fcwWidget);
    if (pcwWidget) lv_obj_move_foreground(pcwWidget);

    // Bind migrated nodes that the post-traversal glue needs by id.
    auto sceneNode = [&](const char* id) -> LvglDisplayNode* {
        auto it = sceneResult.nodes.find(id);
        return it != sceneResult.nodes.end() ? it->second : nullptr;
    };
    lldwNode_ = sceneNode("lldwNode");
    rldwNode_ = sceneNode("rldwNode");
    errorNode_ = sceneNode("errorNode");
    failsafeNode_ = sceneNode("failsafeNode");
    hmwDistanceNode_ = sceneNode("hmwDistanceNode");
    hmwAlertNode_ = sceneNode("hmwAlertNode");
    hmwMonitorNode_ = sceneNode("hmwMonitorNode");
    pdzNode_ = sceneNode("pdzNode");
    isaErrorNode_    = sceneNode("isaErrorNode");
    isaInactiveNode_ = sceneNode("isaInactiveNode");
    isaPartialNode_  = sceneNode("isaPartialNode");
    isaActiveNode_   = sceneNode("isaActiveNode");
    speedNode_ = dynamic_cast<LvglSpeedDisplayNode*>(sceneNode("speedNode"));
    groupTop_ = sceneNode("groupTop");
    groupBottom_ = sceneNode("groupBottom");
}

void LvglMainProcess::handleKeyEvent(int sdlKey)
{
    if (menuController_) {
        menuController_->handleKeyEvent(sdlKey);
    }
}

void LvglMainProcess::handleDualKeyPress()
{
    if (menuController_) {
        menuController_->handleDualKeyPress();
    }
}

void LvglMainProcess::launch()
{
    canmgr_->launch();
    itsThread_->start();
}

void LvglMainProcess::process()
{
    // Runs on the CAN reader thread, once per tree-changing frame. Do NOT touch
    // LVGL or render here (wrong thread): just flag that an update is pending
    // and timestamp it. applyPendingDisplayUpdate(), on the main/LVGL thread,
    // decides when to actually render — see the timing policy in the header.
    //
    // The previous implementation restarted a 10 ms single-shot timer on every
    // frame and only rendered once that timer expired with no new frame in
    // between. A real CAN bus streams frames continuously, so that quiet gap
    // never arrives: the timer kept resetting and the display froze for seconds
    // until traffic happened to lull. (UDP virtual CAN in testing sends one
    // frame at a time, so a gap always exists and the bug stayed hidden.)
    if (alertController_->needsDisplayUpdate())
    {
        alertController_->markUpdateComplete();
        const int64_t now = core::ElapsedTimer::currentMSecsSinceEpoch();
        if (!pendingDisplayUpdate_.exchange(true))
        {
            firstPendingMs_.store(now);
        }
        lastChangeMs_.store(now);
    }
}

void LvglMainProcess::updateDisplay()
{
    displayDirty_.store(true);
}

void LvglMainProcess::carShiftAnimCb(void* obj, int32_t val)
{
    lv_obj_align(static_cast<lv_obj_t*>(obj), LV_ALIGN_BOTTOM_MID, val, 13);
}

void LvglMainProcess::applyPendingDisplayUpdate()
{
    // Promote a pending CAN update to a render once EITHER the bus has been
    // quiet briefly (coalesce a multi-frame burst into a single render) OR the
    // update has been deferred for too long. The latency cap is what makes this
    // robust on a real, continuously-busy bus: traffic that never goes quiet can
    // no longer defer the display indefinitely — worst-case latency is bounded
    // to DISPLAY_UPDATE_MAX_DEFER_MS. Runs on the main/LVGL thread, polled every
    // loop iteration (~1 ms), so no timer thread is spawned per frame.
    if (pendingDisplayUpdate_.load())
    {
        const int64_t now = core::ElapsedTimer::currentMSecsSinceEpoch();
        // Leading-edge like Qt (mainprocess.cpp onCanReceived): render the first
        // frame of a burst immediately (0ms added latency), then coalesce the
        // trailing frames. On the leading frame process() stamps first==last, so
        // this fires exactly once per burst; later frames only bump lastChangeMs_
        // and fall back to the quiet-gap / hard-cap window.
        const bool leadingEdge = (firstPendingMs_.load() == lastChangeMs_.load());
        const bool quietGap = (now - lastChangeMs_.load())   >= DISPLAY_UPDATE_QUIET_MS;
        const bool capped   = (now - firstPendingMs_.load()) >= DISPLAY_UPDATE_MAX_DEFER_MS;
        if (leadingEdge || quietGap || capped)
        {
            pendingDisplayUpdate_.store(false);
            updateDisplay();
        }
    }

    if (displayDirty_.exchange(false))
    {
        alertController_->mutex.lock();
        updateTreeVisibility(displayRoot_, DO_NOT_FORCE_INVISIBILITY);
        alertController_->mutex.unlock();

        // QML isDisplayOfMenusEnabled:
        //   ((!speed.speed_available) || (0 === speed.canEntityArg)) && !status_error.is_in_err
        // Block the brightness/ISA/about menus while the vehicle speed is being
        // shown (available and non-zero) or an error overlay is up. IMS-11648.
        if (menuController_) {
            bool errorActive = errorNode_ && errorNode_->getActivSem() > 0;
            bool speedActive = speedNode_ && speedNode_->getActivSem() > 0
                            && speedNode_->getSpeedValue() != 0;
            menuController_->setMenusEnabled(!speedActive && !errorActive);

            // QML is_remote_menu_request_enabled:
            //   !(discon_panel.visible || alert_err.visible || groupFCW.visible)
            // Gates the idle-screen master-volume Up/Down shortcut (IMS-11656).
            bool disconActive = disconPanel_ && disconPanel_->getActivSem() > 0;
            bool fcwActive    = groupFCW_ && groupFCW_->getActivSem() > 0;
            menuController_->setVolumeEnabled(!disconActive && !errorActive && !fcwActive);

            // QML isa_menu.displayedValue: derive the ISA menu's shown mode from
            // which status-bar ISA icon is active (inactive/error->0, partial->1,
            // active->2) so the menu always opens in the correct state.
            bool isaErr   = isaErrorNode_    && isaErrorNode_->getActivSem()    > 0;
            bool isaInact = isaInactiveNode_ && isaInactiveNode_->getActivSem() > 0;
            bool isaPart  = isaPartialNode_  && isaPartialNode_->getActivSem()  > 0;
            bool isaAct   = isaActiveNode_   && isaActiveNode_->getActivSem()   > 0;
            if (isaErr || isaInact || isaPart || isaAct) {
                menuController_->setIsaMode((isaErr || isaInact) ? 0 : (isaPart ? 1 : 2));
            }
        }

        // QML: HostCar visible: groupGAG.visible || groupCIPV.visible
        // In QML, these groups become invisible when mainPanel is hidden
        // (e.g., by disconPanel activating OM_POWEROFF/OM_KEEPPWR/OM_PILOT).
        // Check both: mainPanel must be tree-visible AND groups must be active.
        if (hostCar_) {
            bool mainPanelVisible = mainPanel_ && mainPanel_->getActivSem() > 0
                                 && !(disconPanel_ && disconPanel_->getActivSem() > 0);
            bool gagActive = mainPanelVisible && groupGAG_ && groupGAG_->getActivSem() > 0;
            bool cipvActive = mainPanelVisible && groupCIPV_ && groupCIPV_->getActivSem() > 0;
            if (gagActive || cipvActive)
                lv_obj_remove_flag(hostCar_, LV_OBJ_FLAG_HIDDEN);
            else
                lv_obj_add_flag(hostCar_, LV_OBJ_FLAG_HIDDEN);
        }

        // HMW road strip + lead car (CIPV): the container is owned by the
        // ALERT_HMW_DISTANCE node, so the tree only shows it when a valid headway
        // distance is present. But the strip and the lead car must appear whenever
        // HMW monitor/alert is active — even with no valid distance — matching Qt
        // (the strip follows the monitor/alert state, the forward car follows the
        // group). Without this the green/red road and the lead car vanish when the
        // distance is invalid (IMS-11659). The active monitor/alert state node has
        // already set the correct GIF + car scale during the traversal above.
        if (hmwValueLabel_) {
            lv_obj_t* hmwContainer = lv_obj_get_parent(hmwValueLabel_);
            bool mainPanelVisible = mainPanel_ && mainPanel_->getActivSem() > 0
                                 && !(disconPanel_ && disconPanel_->getActivSem() > 0);
            bool cipvVisible = mainPanelVisible && groupCIPV_ && groupCIPV_->getActivSem() > 0;
            bool distActive    = hmwDistanceNode_ && hmwDistanceNode_->getActivSem() > 0;
            bool monitorActive = hmwMonitorNode_  && hmwMonitorNode_->getActivSem()  > 0;
            bool alertActive   = hmwAlertNode_    && hmwAlertNode_->getActivSem()    > 0;
            bool hmwShown = cipvVisible && (distActive || monitorActive || alertActive);

            if (hmwContainer) {
                if (hmwShown)
                    lv_obj_remove_flag(hmwContainer, LV_OBJ_FLAG_HIDDEN);
                else
                    lv_obj_add_flag(hmwContainer, LV_OBJ_FLAG_HIDDEN);

                // QML main.qml:818 — the scrolling road strip plays only when NOT
                // (LDW or PED) active; otherwise it freezes on the current frame.
                // The strip is child 0 of the HMW container (an lv_gif).
                lv_obj_t* roadStrip = lv_obj_get_child(hmwContainer, 0);
                if (roadStrip) {
                    bool pedActive = pdzNode_  && pdzNode_->getActivSem()  > 0;
                    bool ldwActive = (lldwNode_ && lldwNode_->getActivSem() > 0)
                                  || (rldwNode_ && rldwNode_->getActivSem() > 0);
                    if (hmwShown && !pedActive && !ldwActive)
                        lv_gif_resume(roadStrip);
                    else
                        lv_gif_pause(roadStrip);
                }

                // QML: units/time text blank unless a valid headway distance is
                // present (canEntityArg != 0), and hidden entirely under failsafe.
                bool failsafeActive = failsafeNode_ && failsafeNode_->getActivSem() > 0;
                bool showText = hmwShown && distActive && !failsafeActive;
                lv_obj_t* secLabel = lv_obj_get_child(hmwContainer, 2);
                if (showText) {
                    if (secLabel) lv_obj_remove_flag(secLabel, LV_OBJ_FLAG_HIDDEN);
                    lv_obj_remove_flag(hmwValueLabel_, LV_OBJ_FLAG_HIDDEN);
                } else {
                    if (secLabel) lv_obj_add_flag(secLabel, LV_OBJ_FLAG_HIDDEN);
                    lv_obj_add_flag(hmwValueLabel_, LV_OBJ_FLAG_HIDDEN);
                }
            }
        }

        // Left panel z-ordering: the most recently changed sign renders on top.
        // When both groupTop and groupBottom signs change in the same frame, groupTop wins.
        if (groupBottom_ && groupTop_) {
            bool bottomChanged = false, topChanged = false;
            lv_obj_t* bottomWidget = nullptr;
            lv_obj_t* topWidget = nullptr;

            auto* bottomQ = groupBottom_->getChildren()->getQueue();
            for (auto it = bottomQ->begin(); it != bottomQ->end(); ++it) {
                auto* node = static_cast<LvglDisplayNode*>(*it);
                if (node->justChanged()) {
                    lv_obj_t* w = node->getWidget();
                    if (w && !lv_obj_has_flag(w, LV_OBJ_FLAG_HIDDEN)) {
                        bottomChanged = true;
                        bottomWidget = w;
                    }
                }
                node->clearJustChanged();
            }
            auto* topQ = groupTop_->getChildren()->getQueue();
            for (auto it = topQ->begin(); it != topQ->end(); ++it) {
                auto* node = static_cast<LvglDisplayNode*>(*it);
                if (node->justChanged()) {
                    lv_obj_t* w = node->getWidget();
                    if (w && !lv_obj_has_flag(w, LV_OBJ_FLAG_HIDDEN)) {
                        topChanged = true;
                        topWidget = w;
                    }
                }
                node->clearJustChanged();
            }

            // Move changed signs to foreground. Process the one that should
            // be BEHIND first, so the last move_foreground wins.
            // Rule: latest changed sign on top; if both changed, top wins.
            if (bottomChanged && topChanged) {
                // Both changed: bottom first, then top (top wins)
                lv_obj_move_foreground(bottomWidget);
                lv_obj_move_foreground(topWidget);
            } else if (bottomChanged && bottomWidget) {
                lv_obj_move_foreground(bottomWidget);
            } else if (topChanged && topWidget) {
                lv_obj_move_foreground(topWidget);
            }
        }

        // The sign move_foreground calls above can lift a left-panel sign above
        // an open menu/QR overlay (signs and menus are all siblings under root),
        // leaving e.g. the TSR/ISA speed sign drawn on top of the ISA/About menu
        // (IMS-11654). Re-assert the overlays' top z-order after the reordering.
        if (menuController_) {
            menuController_->raiseActiveScreenIfVisible();
        }

        // Host car shift based on LDW activation (QML: 200ms shift, 600ms return)
        if (hostCar_ && lldwNode_ && rldwNode_)
        {
            bool leftActive = lldwNode_->getActivSem() > 0;
            bool rightActive = rldwNode_->getActivSem() > 0;
            int targetOffset = 0;
            if (leftActive && !rightActive)
                targetOffset = -41;
            else if (rightActive && !leftActive)
                targetOffset = 41;

            if (targetOffset != lastCarOffset_) {
                int duration = (targetOffset == 0) ? 600 : 200;
                lv_anim_t anim;
                lv_anim_init(&anim);
                lv_anim_set_var(&anim, hostCar_);
                lv_anim_set_values(&anim, lastCarOffset_, targetOffset);
                lv_anim_set_duration(&anim, duration);
                lv_anim_set_path_cb(&anim, lv_anim_path_ease_in_out);
                lv_anim_set_exec_cb(&anim, carShiftAnimCb);
                lv_anim_start(&anim);
                lastCarOffset_ = targetOffset;
            }
        }
    }
}
