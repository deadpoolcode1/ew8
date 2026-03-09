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
#include "entitytype.h"
#include "alerttypes_core.h"
#include "graphicitemsenummap.h"
#include "display_tree.h"
#include "core/core.h"
#include "core/elapsed_timer.h"

extern core::ElapsedTimer bootUpTimer;

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
    , failsafeNode_(nullptr)
    , hmwValueLabel_(nullptr)
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

    // Thread + debounce timer (same pattern as Qt MainProcess)
    itsThread_ = new core::Thread();
    updateDisplayTimeWindow_ = new core::Timer();
    updateDisplayTimeWindow_->setInterval(30);
    updateDisplayTimeWindow_->setSingleShot(true);

    itsThread_->started.connect([this]() { process(); });
    updateDisplayTimeWindow_->timeout.connect([this]() { process(); });

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
    delete updateDisplayTimeWindow_;
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
    LvglWidgets::HMWWidgets hmw = LvglWidgets::createHMWDisplay(rootWidget);

    // PDZ overlay
    lv_obj_t* pdzWidget = LvglWidgets::createPDZOverlay(rootWidget);

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

    // Right panel signs — upper slot (primary SmartADAS, mutexGroup=true)
    lv_obj_t* smartCrowdedWidget   = LvglWidgets::createRightPanelSign(rootWidget, "A:images/right-panel/SADAS/right_crowded.png", true);
    lv_obj_t* smartPedHwyWidget    = LvglWidgets::createRightPanelSign(rootWidget, "A:images/right-panel/SADAS/right_ped_highway.png", true);
    lv_obj_t* smartCycHwyWidget    = LvglWidgets::createRightPanelSign(rootWidget, "A:images/right-panel/SADAS/right_cyc_highway.png", true);
    lv_obj_t* smartWeaRoadWidget   = LvglWidgets::createRightPanelSign(rootWidget, "A:images/right-panel/SADAS/right_w_road.png", true);
    lv_obj_t* smartWeaHydroWidget  = LvglWidgets::createRightPanelSign(rootWidget, "A:images/right-panel/SADAS/right_w_hydro.png", true);
    lv_obj_t* smartWeaFgWidget     = LvglWidgets::createRightPanelSign(rootWidget, "A:images/right-panel/SADAS/right_w_fog.png", true);
    lv_obj_t* smartWeaWndWidget    = LvglWidgets::createRightPanelSign(rootWidget, "A:images/right-panel/SADAS/right_w_wind.png", true);
    lv_obj_t* smartWeaHailWidget   = LvglWidgets::createRightPanelSign(rootWidget, "A:images/right-panel/SADAS/right_w_hail.png", true);
    lv_obj_t* smartWeaTstmWidget   = LvglWidgets::createRightPanelSign(rootWidget, "A:images/right-panel/SADAS/right_w_lightening.png", true);
    lv_obj_t* smartHarshDzWidget   = LvglWidgets::createRightPanelSign(rootWidget, "A:images/right-panel/SADAS/right_harsh_break.png", true);
    lv_obj_t* smartCaWidget        = LvglWidgets::createRightPanelSign(rootWidget, "A:images/right-panel/SADAS/right_ca.png", true);

    // Right panel signs — lower slot (secondary SmartADAS, mutexGroup=false)
    lv_obj_t* smartCrowdedSecWidget   = LvglWidgets::createRightPanelSign(rootWidget, "A:images/right-panel/SADAS/right_crowded.png", false);
    lv_obj_t* smartPedHwySecWidget    = LvglWidgets::createRightPanelSign(rootWidget, "A:images/right-panel/SADAS/right_ped_highway.png", false);
    lv_obj_t* smartCycHwySecWidget    = LvglWidgets::createRightPanelSign(rootWidget, "A:images/right-panel/SADAS/right_cyc_highway.png", false);
    lv_obj_t* smartWeaRoadSecWidget   = LvglWidgets::createRightPanelSign(rootWidget, "A:images/right-panel/SADAS/right_w_road.png", false);
    lv_obj_t* smartWeaHydroSecWidget  = LvglWidgets::createRightPanelSign(rootWidget, "A:images/right-panel/SADAS/right_w_hydro.png", false);
    lv_obj_t* smartWeaFgSecWidget     = LvglWidgets::createRightPanelSign(rootWidget, "A:images/right-panel/SADAS/right_w_fog.png", false);
    lv_obj_t* smartWeaWndSecWidget    = LvglWidgets::createRightPanelSign(rootWidget, "A:images/right-panel/SADAS/right_w_wind.png", false);
    lv_obj_t* smartWeaHailSecWidget   = LvglWidgets::createRightPanelSign(rootWidget, "A:images/right-panel/SADAS/right_w_hail.png", false);
    lv_obj_t* smartWeaTstmSecWidget   = LvglWidgets::createRightPanelSign(rootWidget, "A:images/right-panel/SADAS/right_w_lightening.png", false);
    lv_obj_t* smartHarshDzSecWidget   = LvglWidgets::createRightPanelSign(rootWidget, "A:images/right-panel/SADAS/right_harsh_break.png", false);
    lv_obj_t* smartCaSecWidget        = LvglWidgets::createRightPanelSign(rootWidget, "A:images/right-panel/SADAS/right_ca.png", false);

    // 2. Status bar (QML z=1: above content, below full-screen overlays)
    LvglWidgets::StatusBarWidgets sb = LvglWidgets::createStatusBar(rootWidget);

    // 3. Full-screen overlays (created after content so they render on top)
    // Failsafe (QML z=10)
    lv_obj_t* failsafeWidget  = LvglWidgets::createFailsafeOverlay(rootWidget);
    lv_obj_t* poweroffWidget  = LvglWidgets::createOpModeOverlay(rootWidget, "Power Off");
    lv_obj_t* keeppwrWidget   = LvglWidgets::createOpModeOverlay(rootWidget, "Keep Power On");
    lv_obj_t* pilotWidget     = LvglWidgets::createOpModeOverlay(rootWidget, "Pilot Mode");

    // RTW alert (QML z=10)
    lv_obj_t* rtwAlertWidget = LvglWidgets::createRTWAlert(rootWidget);

    // Disconnect overlay (QML z=11)
    lv_obj_t* disconWidget  = LvglWidgets::createDisconnectOverlay(rootWidget);

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
    lv_obj_set_style_text_font(speedSmallLabel, &lv_font_montserrat_16, 0);
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
    lv_obj_set_style_text_font(speedBigLabel, &lv_font_montserrat_28, 0);
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

    // Error overlay (QML z=20: above everything except menus)
    LvglWidgets::ErrorOverlayWidgets err = LvglWidgets::createErrorOverlay(rootWidget);
    lv_obj_t* errorWidget = err.container;

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

    auto* errorNode = new LvglErrorDisplayNode(errorWidget, 0, ID_ALERT_ERROR, err.errorCodeLabel);
    addChild(disconPanel, errorNode);

    auto* disconNode = new LvglDisplayNode(disconWidget, 0, AlertTypes::ALERT_NOCOM);
    addChild(disconPanel, disconNode);

    auto* poweroffNode = new LvglDisplayNode(poweroffWidget, 0, ID_OM_POWEROFF);
    addChild(disconPanel, poweroffNode);

    auto* keeppwrNode = new LvglDisplayNode(keeppwrWidget, 0, ID_OM_KEEPPWR);
    addChild(disconPanel, keeppwrNode);

    auto* pilotNode = new LvglDisplayNode(pilotWidget, 0, ID_OM_PILOT);
    addChild(disconPanel, pilotNode);

    // main_panel (group, layer=2)
    auto* mainPanel = new LvglDisplayNode(nullptr, 2, false, false);
    addChild(generalPanel, mainPanel);

    // failsafe overlay (leaf, layer=2 — same as mainPanel, coexists with it)
    // QML: failsafe is transparent overlay, lanes/car visible behind it
    auto* failsafeNode = new LvglDisplayNode(failsafeWidget, 2, ID_INFO_FAILSAFE);
    failsafeNode_ = failsafeNode;
    addChild(generalPanel, failsafeNode);

    // groupCIPV (group, layer=1)
    auto* groupCIPV = new LvglDisplayNode(nullptr, 1, false, false);
    groupCIPV_ = groupCIPV;
    addChild(mainPanel, groupCIPV);

    // HMW distance (LvglValueDisplayNode, layer=0, ALERT_HMW_DISTANCE)
    // QML: (canEntityArg/10).toFixed(1) — CAN arg 12 displays as "1.2"
    hmwValueLabel_ = hmw.valueLabel;
    auto* hmwNode = new LvglValueDisplayNode(hmw.container, 0, ID_ALERT_HMW_DISTANCE, hmw.valueLabel, 10);
    addChild(groupCIPV, hmwNode);

    // HMW state nodes (layer=0, no widget — change road GIF + car position on visibility)
    // QML image: 80x61 declared, native 129x111. car_scale applied uniformly on top.
    // Alert: car closer and bigger than monitor
    auto* hmwAlertNode = new LvglHmwStateNode(0, ID_ALERT_HMW_ALERT,
                                               hmw.roadStrip, "A:images/hmw/HMW-red-new-1.gif",
                                               hmw.forwardCar, 45, 160, 145);
    addChild(groupCIPV, hmwAlertNode);

    // Monitor: car further away, smaller
    auto* hmwMonitorNode = new LvglHmwStateNode(0, ID_ALERT_HMW_MONITOR,
                                                 hmw.roadStrip, "A:images/hmw/HMW-green-new-2.gif",
                                                 hmw.forwardCar, 40, 119, 115);
    addChild(groupCIPV, hmwMonitorNode);

    // PDZ overlay (layer=0, ALERT_PDZ)
    auto* pdzNode = new LvglDisplayNode(pdzWidget, 0, ID_ALERT_PDZ);
    addChild(groupCIPV, pdzNode);

    // groupGAG (group, layer=1)
    auto* groupGAG = new LvglDisplayNode(nullptr, 1, false, false);
    groupGAG_ = groupGAG;
    addChild(mainPanel, groupGAG);

    // groupLanes (group, layer=0)
    auto* groupLanes = new LvglDisplayNode(nullptr, 0, false, false);
    addChild(groupGAG, groupLanes);

    // groupLanesLeft (group, layer=0)
    auto* groupLanesLeft = new LvglDisplayNode(nullptr, 0, false, false);
    addChild(groupLanes, groupLanesLeft);

    // Left LDW off (yellow, layer=0)
    auto* ldwOffLeftNode = new LvglDisplayNode(ldwOffLeftWidget, 0, ID_ALERT_LEFT_LDWOFF);
    addChild(groupLanesLeft, ldwOffLeftNode);

    // Left LDW active (blinking, layer=1)
    lldwNode_ = new LvglBlinkDisplayNode(ldwLeftWidget, 1, ID_ALERT_LLDW);
    addChild(groupLanesLeft, lldwNode_);

    // Left LDW on (green, layer=2)
    auto* ldwOnLeftNode = new LvglDisplayNode(ldwOnLeftWidget, 2, ID_ALERT_LEFT_LDWON);
    addChild(groupLanesLeft, ldwOnLeftNode);

    // groupLanesRight (group, layer=0)
    auto* groupLanesRight = new LvglDisplayNode(nullptr, 0, false, false);
    addChild(groupLanes, groupLanesRight);

    // Right LDW off (yellow, layer=0)
    auto* ldwOffRightNode = new LvglDisplayNode(ldwOffRightWidget, 0, ID_ALERT_RIGHT_LDWOFF);
    addChild(groupLanesRight, ldwOffRightNode);

    // Right LDW active (blinking, layer=1)
    rldwNode_ = new LvglBlinkDisplayNode(ldwRightWidget, 1, ID_ALERT_RLDW);
    addChild(groupLanesRight, rldwNode_);

    // Right LDW on (green, layer=2)
    auto* ldwOnRightNode = new LvglDisplayNode(ldwOnRightWidget, 2, ID_ALERT_RIGHT_LDWON);
    addChild(groupLanesRight, ldwOnRightNode);

    // groupFCW (group, layer=2, mutexGroup=false — QML has mutexGroup: false)
    auto* groupFCW = new LvglDisplayNode(nullptr, 2, false, false);
    groupFCW_ = groupFCW;
    addChild(generalPanel, groupFCW);

    auto* fcwNode = new LvglGifDisplayNode(fcwWidget, 1, ID_ALERT_FCW, lv_obj_get_child(fcwWidget, 0));
    addChild(groupFCW, fcwNode);

    auto* pcwNode = new LvglGifDisplayNode(pcwWidget, 0, ID_ALERT_PCW, lv_obj_get_child(pcwWidget, 0));
    addChild(groupFCW, pcwNode);

    // status_panel (group, layer=2)
    auto* statusPanel = new LvglDisplayNode(nullptr, 2, false, false);
    addChild(generalPanel, statusPanel);

    // speed (LvglSpeedDisplayNode, layer=0, INFO_VEH_SPEED — with MPH conversion support)
    auto* speedNode = new LvglSpeedDisplayNode(speedWidget, 0, ID_INFO_VEH_SPEED, speedValueLabel, speedUnitLabel);
    addChild(statusPanel, speedNode);

    // Beam group (mutexGroup=true)
    auto* beamGroup = new LvglDisplayNode(nullptr, 0, true, false);
    addChild(statusPanel, beamGroup);

    auto* hiBeamNode = new LvglDisplayNode(sb.hiBeamIcon, 1, ID_ALERT_HI_BEAM);
    addChild(beamGroup, hiBeamNode);

    auto* loBeamNode = new LvglDisplayNode(sb.loBeamIcon, 0, ID_ALERT_LOW_BEAM);
    addChild(beamGroup, loBeamNode);

    // Blinker (blink animation)
    auto* blinkerNode = new LvglBlinkDisplayNode(sb.blinkerIcon, 0, ID_ALERT_BLINKERS);
    addChild(statusPanel, blinkerNode);

    // ISA group (mutexGroup=true)
    auto* isaGroup = new LvglDisplayNode(nullptr, 0, true, false);
    addChild(statusPanel, isaGroup);

    auto* isaErrorNode = new LvglDisplayNode(sb.isaErrorIcon, 0, ID_ALERT_ISA_ERROR);
    addChild(isaGroup, isaErrorNode);

    auto* isaInactiveNode = new LvglDisplayNode(sb.isaInactiveIcon, 1, ID_INFO_ISA_INACTIVE);
    addChild(isaGroup, isaInactiveNode);

    auto* isaPartialNode = new LvglDisplayNode(sb.isaPartialIcon, 2, ID_INFO_ISA_PARTIAL);
    addChild(isaGroup, isaPartialNode);

    auto* isaActiveNode = new LvglDisplayNode(sb.isaActiveIcon, 3, ID_INFO_ISA_FULL_ACTIVE);
    addChild(isaGroup, isaActiveNode);

    // Signed group (mutexGroup=true)
    auto* signedGroup = new LvglDisplayNode(nullptr, 0, true, false);
    addChild(statusPanel, signedGroup);

    auto* signedInNode = new LvglDisplayNode(sb.signedInIcon, 0, ID_INFO_DRIVER_AUTH_IN);
    addChild(signedGroup, signedInNode);

    auto* signedOutNode = new LvglBlinkDisplayNode(sb.signedOutIcon, 0, ID_INFO_DRIVER_AUTH_OUT);
    addChild(signedGroup, signedOutNode);

    auto* signedProcessNode = new LvglDisplayNode(sb.signedProcessIcon, 0, ID_INFO_DRIVER_AUTH_PROCESS);
    addChild(signedGroup, signedProcessNode);

    // GPS, GSM, mute icons
    auto* gpsNode = new LvglDisplayNode(sb.gpsIcon, 0, ID_INFO_NO_GPS);
    addChild(statusPanel, gpsNode);

    auto* gsmNode = new LvglDisplayNode(sb.gsmIcon, 0, ID_INFO_NO_GSM);
    addChild(statusPanel, gsmNode);

    auto* muteNode = new LvglDisplayNode(sb.muteIcon, 0, ID_OM_MUTE);
    addChild(statusPanel, muteNode);

    // Dummy leaf nodes (entity registered, no visual)
    auto* showSpeedNode = new LvglDisplayNode(nullptr, 0, ID_INFO_SPEED_SHOW);
    addChild(statusPanel, showSpeedNode);
    speedNode->setSpeedShowNode(showSpeedNode);

    auto* normalModeNode = new LvglDisplayNode(nullptr, 0, ID_OM_NORMAL);
    addChild(statusPanel, normalModeNode);

    auto* gpsOkNode = new LvglDisplayNode(nullptr, 0, ID_INFO_GPS_OK);
    addChild(statusPanel, gpsOkNode);

    // --- Left panel signs (Bulk 3) ---
    // leftPanel (group, layer=1) under mainPanel — QML left_panel layer_pri=1
    auto* leftPanel = new LvglDisplayNode(nullptr, 1, false, false);
    addChild(mainPanel, leftPanel);

    // groupTop (group, layer=0, mutexGroup: RTW layer=0, SLI layer=1, ISA_SPEED layer=2, ISA_HIGHWAY layer=1)
    auto* groupTop = new LvglDisplayNode(nullptr, 0, true, false);
    addChild(leftPanel, groupTop);

    // Left panel signs: intro animation scale 256 (1.0) → 187 (0.732), 500ms OutQuad
    // QML SideIcon pause_duration = 1000ms for left panel (quadrants 2/3)
    auto* rtwWarnNode = new LvglDisplayNode(rtwWarnWidget, 0, ID_ALERT_RTW_WARN);
    rtwWarnNode->setContainerIntroAnim(256, 187, 1000);
    addChild(groupTop, rtwWarnNode);

    auto* sliNode = new LvglValueDisplayNode(sliWidget, 1, ID_ALERT_SLI, sliSpeedLabel);
    sliNode->setContainerIntroAnim(256, 187, 1000);
    addChild(groupTop, sliNode);

    auto* isaSpeedNode = new LvglValueDisplayNode(isaSpeedWidget, 2, ID_ALERT_ISA_SPEED, isaSpeedLabel);
    isaSpeedNode->setContainerIntroAnim(256, 187, 1000);
    addChild(groupTop, isaSpeedNode);

    auto* isaHighwayNode = new LvglDisplayNode(isaHighwayWidget, 1, ID_ALERT_ISA_HIGHWAY);
    isaHighwayNode->setContainerIntroAnim(256, 187, 1000);
    addChild(groupTop, isaHighwayNode);

    // groupBottom (group, layer=0, mutexGroup=true: TSR signs layer=0, supp signs layer=1)
    auto* groupBottom = new LvglDisplayNode(nullptr, 0, true, false);
    addChild(leftPanel, groupBottom);

    // TSR signs with auto-dismiss timers (QML maxduration values)
    // ALERT_END_ALL_RESTR has layer_pri=1 in QML (lower priority than base TSR signs at 0)
    auto* endAllRestrNode = new LvglTimedDisplayNode(endAllRestrWidget, 1, ID_ALERT_END_ALL_RESTR, 5000);
    endAllRestrNode->setContainerIntroAnim(256, 187, 1000);
    addChild(groupBottom, endAllRestrNode);

    auto* noPassNode = new LvglDisplayNode(noPassWidget, 0, ID_ALERT_NO_PASS);
    noPassNode->setContainerIntroAnim(256, 187, 1000);
    addChild(groupBottom, noPassNode);

    auto* noPassEndNode = new LvglDisplayNode(noPassEndWidget, 0, ID_ALERT_NO_PASS_END);
    noPassEndNode->setContainerIntroAnim(256, 187, 1000);
    addChild(groupBottom, noPassEndNode);

    auto* motorwayNode = new LvglTimedDisplayNode(motorwayWidget, 0, ID_ALERT_MOTORWAY, 15000);
    motorwayNode->setContainerIntroAnim(256, 187, 1000);
    addChild(groupBottom, motorwayNode);

    auto* motorwayEndNode = new LvglTimedDisplayNode(motorwayEndWidget, 0, ID_ALERT_MOTORWAY_END, 5000);
    motorwayEndNode->setContainerIntroAnim(256, 187, 1000);
    addChild(groupBottom, motorwayEndNode);

    auto* expresswayNode = new LvglTimedDisplayNode(expresswayWidget, 0, ID_ALERT_EXPRESSWAY, 15000);
    expresswayNode->setContainerIntroAnim(256, 187, 1000);
    addChild(groupBottom, expresswayNode);

    auto* expresswayEndNode = new LvglTimedDisplayNode(expresswayEndWidget, 0, ID_ALERT_EXPRESSWAY_END, 5000);
    expresswayEndNode->setContainerIntroAnim(256, 187, 1000);
    addChild(groupBottom, expresswayEndNode);

    auto* playgroundNode = new LvglTimedDisplayNode(playgroundWidget, 0, ID_ALERT_PLAYGROUND, 15000);
    playgroundNode->setContainerIntroAnim(256, 187, 1000);
    addChild(groupBottom, playgroundNode);

    auto* playgroundEndNode = new LvglTimedDisplayNode(playgroundEndWidget, 0, ID_ALERT_PLAYGROUND_END, 5000);
    playgroundEndNode->setContainerIntroAnim(256, 187, 1000);
    addChild(groupBottom, playgroundEndNode);

    // Supplementary signs (layer=1 in groupBottom — shown when base TSR is not active)
    // Use LvglSuppSignNode to update the supp icon image based on CAN arg value
    // QML supp intro: start_scale=0.82(210), target_scale=0.54252(139)
    // QML: bottomMargin 41→-7.7, scale 0.82→0.54, transform origin=center
    // Mapped to LVGL pivot (0,112): start visual top=97, end visual top=162
    static const int SUPP_START_Y = 60;
    static const int SUPP_TARGET_Y = 95;
    static const int SUPP_START_X = 4;
    static const int SUPP_TARGET_X = 10;

    auto* sliSuppNode = new LvglSuppSignNode(sliSuppWidget, 1, ID_ALERT_SLI_SUPP, sliSuppIcon, sliSuppSpeedLabel);
    sliSuppNode->setContainerIntroAnim(256, SUPP_SIGN_SCALE, 1000);
    sliSuppNode->setContainerIntroYAnim(SUPP_START_Y, SUPP_TARGET_Y);
    sliSuppNode->setContainerIntroXAnim(SUPP_START_X, SUPP_TARGET_X);
    addChild(groupBottom, sliSuppNode);

    auto* noPassSuppNode = new LvglSuppSignNode(noPassSuppWidget, 1, ID_ALERT_NO_PASS_SUPP, noPassSuppIcon);
    noPassSuppNode->setContainerIntroAnim(256, SUPP_SIGN_SCALE, 1000);
    noPassSuppNode->setContainerIntroYAnim(SUPP_START_Y, SUPP_TARGET_Y);
    noPassSuppNode->setContainerIntroXAnim(SUPP_START_X, SUPP_TARGET_X);
    addChild(groupBottom, noPassSuppNode);

    auto* motorwaySuppNode = new LvglSuppSignNode(motorwaySuppWidget, 1, ID_ALERT_MOTORWAY_SUPP, motorwaySuppIcon);
    motorwaySuppNode->setContainerIntroAnim(256, SUPP_SIGN_SCALE, 1000);
    motorwaySuppNode->setContainerIntroYAnim(SUPP_START_Y, SUPP_TARGET_Y);
    motorwaySuppNode->setContainerIntroXAnim(SUPP_START_X, SUPP_TARGET_X);
    addChild(groupBottom, motorwaySuppNode);

    auto* expresswaySuppNode = new LvglSuppSignNode(expresswaySuppWidget, 1, ID_ALERT_EXPRESSWAY_SUPP, expresswaySuppIcon);
    expresswaySuppNode->setContainerIntroAnim(256, SUPP_SIGN_SCALE, 1000);
    expresswaySuppNode->setContainerIntroYAnim(SUPP_START_Y, SUPP_TARGET_Y);
    expresswaySuppNode->setContainerIntroXAnim(SUPP_START_X, SUPP_TARGET_X);
    addChild(groupBottom, expresswaySuppNode);

    auto* playgroundSuppNode = new LvglSuppSignNode(playgroundSuppWidget, 1, ID_ALERT_PLAYGROUND_SUPP, playgroundSuppIcon);
    playgroundSuppNode->setContainerIntroAnim(256, SUPP_SIGN_SCALE, 1000);
    playgroundSuppNode->setContainerIntroYAnim(SUPP_START_Y, SUPP_TARGET_Y);
    playgroundSuppNode->setContainerIntroXAnim(SUPP_START_X, SUPP_TARGET_X);
    addChild(groupBottom, playgroundSuppNode);

    // RTW alert (full-screen, under mainPanel at layer=0 — QML has it inside main_panel)
    auto* rtwAlertNode = new LvglDisplayNode(rtwAlertWidget, 0, ID_ALERT_RTW_ALERT);
    addChild(mainPanel, rtwAlertNode);

    // ISA/TSR state machine nodes: notify menu controller of ISA availability
    auto* tsrNotIsaNode = new LvglTsrStateNode(0, ID_STATE_TSR_NOT_ISA, menuController_);
    addChild(leftPanel, tsrNotIsaNode);

    auto* isaNotTsrNode = new LvglIsaStateNode(0, ID_STATE_ISA_NOT_TSR, menuController_);
    addChild(leftPanel, isaNotTsrNode);

    auto* sliShowNode = new LvglDisplayNode(nullptr, 0, ID_ALERT_SLI_SHOW);
    addChild(leftPanel, sliShowNode);

    auto* isaOverspeedNode = new LvglOverspeedBlinkNode(0, ID_ALERT_ISA_OVERSPEED, sliWidget, isaSpeedWidget);
    addChild(leftPanel, isaOverspeedNode);

    // SHAPE_USA: switch SLI from circular to rectangular sign image
    // Get the image child (first child) from each SLI sign container
    lv_obj_t* sliSignImg = lv_obj_get_child(sliWidget, 0);
    lv_obj_t* sliSuppSignImg = lv_obj_get_child(sliSuppWidget, 0);
    auto* shapeUsaNode = new LvglShapeUsaNode(0, ID_SHAPE_USA, sliSignImg, sliSuppSignImg, sliSpeedLabel);
    addChild(leftPanel, shapeUsaNode);

    auto* isaVersionNode = new LvglDisplayNode(nullptr, 0, ID_INFO_ISA_VERSION);
    addChild(leftPanel, isaVersionNode);

    auto* isaBundleNode = new LvglDisplayNode(nullptr, 0, ID_INFO_ISA_BUNDLE);
    addChild(leftPanel, isaBundleNode);

    // --- Right panel SmartADAS signs (Bulk 4) ---
    // QML: IMS_SmartADAS_Restricted_Items, layer_pri=1, under mainPanel
    auto* rightPanel = new LvglDisplayNode(nullptr, 1, false, false);
    addChild(mainPanel, rightPanel);

    // groupTopSadas (mutexGroup=true): only one primary icon visible at a time
    auto* groupTopSadas = new LvglDisplayNode(nullptr, 0, true, false);
    addChild(rightPanel, groupTopSadas);

    // Right panel signs: intro animation scale 256→154, x-position from center→right
    // QML: sign center starts at screen center (160). Image is 136px, center at 68.
    // Container startX = 160 - 68 = 92, targetX = 238 (DISPLAY_WIDTH - RIGHT_PANEL_SIGN_SIZE)
    // QML SideIcon.qml: pause_duration=1500ms for Q1/Q4 (right panel) before animating
    auto mkSadas = [](lv_obj_t* w, int layer, DISPLAY_ITEM_ID id) {
        return new LvglAnimatedSignNode(w, layer, id, lv_obj_get_child(w, 0), 256, 154, 92, 238, 1500);
    };

    auto* smartCrowdedNode  = mkSadas(smartCrowdedWidget,  1, ID_SMART_CROWDED);
    addChild(groupTopSadas, smartCrowdedNode);

    auto* smartPedHwyNode   = mkSadas(smartPedHwyWidget,   2, ID_SMART_PED_HWY);
    addChild(groupTopSadas, smartPedHwyNode);

    auto* smartCycHwyNode   = mkSadas(smartCycHwyWidget,   3, ID_SMART_CYC_HWY);
    addChild(groupTopSadas, smartCycHwyNode);

    auto* smartHarshDzNode  = mkSadas(smartHarshDzWidget,  4, ID_SMART_HARSH_DZ);
    addChild(groupTopSadas, smartHarshDzNode);

    auto* smartCaNode       = mkSadas(smartCaWidget,       4, ID_SMART_CA);
    addChild(groupTopSadas, smartCaNode);

    auto* smartWeaRoadNode  = mkSadas(smartWeaRoadWidget,  5, ID_SMART_WEA_ROAD);
    addChild(groupTopSadas, smartWeaRoadNode);

    auto* smartWeaHydroNode = mkSadas(smartWeaHydroWidget, 5, ID_SMART_WEA_HYDRO);
    addChild(groupTopSadas, smartWeaHydroNode);

    auto* smartWeaFgNode    = mkSadas(smartWeaFgWidget,    6, ID_SMART_WEA_FG);
    addChild(groupTopSadas, smartWeaFgNode);

    auto* smartWeaWndNode   = mkSadas(smartWeaWndWidget,   7, ID_SMART_WEA_WND);
    addChild(groupTopSadas, smartWeaWndNode);

    auto* smartWeaHailNode  = mkSadas(smartWeaHailWidget,  7, ID_SMART_WEA_HAIL);
    addChild(groupTopSadas, smartWeaHailNode);

    auto* smartWeaTstmNode  = mkSadas(smartWeaTstmWidget,  7, ID_SMART_WEA_TSTM);
    addChild(groupTopSadas, smartWeaTstmNode);

    // groupBottomSadas (mutexGroup=false): secondary icons, multiple can be visible
    auto* groupBottomSadas = new LvglDisplayNode(nullptr, 0, false, false);
    addChild(rightPanel, groupBottomSadas);

    auto* smartCrowdedSecNode  = mkSadas(smartCrowdedSecWidget,  1, ID_SMART_CROWDED_SEC);
    addChild(groupBottomSadas, smartCrowdedSecNode);

    auto* smartPedHwySecNode   = mkSadas(smartPedHwySecWidget,   2, ID_SMART_PED_HWY_SEC);
    addChild(groupBottomSadas, smartPedHwySecNode);

    auto* smartCycHwySecNode   = mkSadas(smartCycHwySecWidget,   3, ID_SMART_CYC_HWY_SEC);
    addChild(groupBottomSadas, smartCycHwySecNode);

    auto* smartHarshDzSecNode  = mkSadas(smartHarshDzSecWidget,  4, ID_SMART_HARSH_DZ_SEC);
    addChild(groupBottomSadas, smartHarshDzSecNode);

    auto* smartCaSecNode       = mkSadas(smartCaSecWidget,       4, ID_SMART_CA_SEC);
    addChild(groupBottomSadas, smartCaSecNode);

    auto* smartWeaRoadSecNode  = mkSadas(smartWeaRoadSecWidget,  5, ID_SMART_WEA_ROAD_SEC);
    addChild(groupBottomSadas, smartWeaRoadSecNode);

    auto* smartWeaHydroSecNode = mkSadas(smartWeaHydroSecWidget, 5, ID_SMART_WEA_HYDRO_SEC);
    addChild(groupBottomSadas, smartWeaHydroSecNode);

    auto* smartWeaFgSecNode    = mkSadas(smartWeaFgSecWidget,    6, ID_SMART_WEA_FG_SEC);
    addChild(groupBottomSadas, smartWeaFgSecNode);

    auto* smartWeaWndSecNode   = mkSadas(smartWeaWndSecWidget,   7, ID_SMART_WEA_WND_SEC);
    addChild(groupBottomSadas, smartWeaWndSecNode);

    auto* smartWeaHailSecNode  = mkSadas(smartWeaHailSecWidget,  7, ID_SMART_WEA_HAIL_SEC);
    addChild(groupBottomSadas, smartWeaHailSecNode);

    auto* smartWeaTstmSecNode  = mkSadas(smartWeaTstmSecWidget,  7, ID_SMART_WEA_TSTM_SEC);
    addChild(groupBottomSadas, smartWeaTstmSecNode);

    // SMART_FATIGUE / SMART_BUMPERS: in JSON + QML but no UI in QML (placeholders)
    auto* smartFatigueNode = new LvglDisplayNode(nullptr, 0, ID_SMART_FATIGUE);
    addChild(groupTopSadas, smartFatigueNode);

    auto* smartBumpersNode = new LvglDisplayNode(nullptr, 0, ID_SMART_BUMPERS);
    addChild(groupTopSadas, smartBumpersNode);

    auto* smartFatigueSecNode = new LvglDisplayNode(nullptr, 0, ID_SMART_FATIGUE_SEC);
    addChild(groupBottomSadas, smartFatigueSecNode);

    auto* smartBumpersSecNode = new LvglDisplayNode(nullptr, 0, ID_SMART_BUMPERS_SEC);
    addChild(groupBottomSadas, smartBumpersSecNode);

    // --- Bulk 5: Menu entities (not part of display tree — handled by menu controller) ---
    // FUNC_BUTTONS: registered as dummy (keyboard events handled via SDL)
    auto* funcButtonsNode = new LvglDisplayNode(nullptr, 0, ID_FUNC_BUTTONS);
    addChild(statusPanel, funcButtonsNode);

    // VOLUME_DONE: forwards activation to menu controller
    auto* volumeDoneNode = new LvglVolumeDoneNode(0, ID_VOLUME_DONE, menuController_);
    addChild(statusPanel, volumeDoneNode);

    // VOLUME_FAIL: forwards activation to menu controller
    auto* volumeFailNode = new LvglVolumeFailNode(0, ID_VOLUME_FAIL, menuController_);
    addChild(statusPanel, volumeFailNode);

    // INFO_QRCODE: forwards activation to menu controller
    auto* qrCodeNode = new LvglQRCodeNode(0, ID_INFO_QRCODE, menuController_);
    addChild(statusPanel, qrCodeNode);

    // --- Bulk 6: Display tests (full-screen overlays, high z-order) ---
    // These are full-screen test screens at the top of the tree (under generalPanel)
    auto* rgbRedNode   = new LvglDisplayNode(rgbRedWidget,   0, ID_RGB_RED);
    addChild(generalPanel, rgbRedNode);

    auto* rgbGreenNode = new LvglDisplayNode(rgbGreenWidget, 0, ID_RGB_GREEN);
    addChild(generalPanel, rgbGreenNode);

    auto* rgbBlueNode  = new LvglDisplayNode(rgbBlueWidget,  0, ID_RGB_BLUE);
    addChild(generalPanel, rgbBlueNode);

    auto* rgbWhiteNode = new LvglDisplayNode(rgbWhiteWidget, 0, ID_RGB_WHITE);
    addChild(generalPanel, rgbWhiteNode);

    auto* tvPatternNode = new LvglDisplayNode(tvPatternWidget, 0, ID_TV_PATTERN);
    addChild(generalPanel, tvPatternNode);

    // --- Signal test screen (modeGroup: children only visible when parent active) ---
    auto* signalTestPanel = new LvglDisplayNode(signalTestWidget, 0, ID_INFO_TEST_SIGNALS, true);
    addChild(generalPanel, signalTestPanel);

    // Signal test items: each has small + big icon
    DISPLAY_ITEM_ID signalEntityIds[] = {
        ID_TEST_BRAKES, ID_TEST_WIPERS, ID_TEST_HIGH_BEAM,
        ID_TEST_BLINKER_LEFT, ID_TEST_BLINKER_RIGHT, ID_TEST_REVERSE
    };
    for (int i = 0; i < 6; i++) {
        auto* node = new LvglSignalTestItemNode(
            sigSmallImgs[i], sigBigImgs[i], 0, signalEntityIds[i],
            signalItems[i].wildcard);
        addChild(signalTestPanel, node);
    }

    // Signal test speed node
    auto* testSpeedNode = new LvglSignalTestSpeedNode(
        speedSmallImg, speedBigImg, speedSmallLabel, speedBigLabel,
        0, ID_TEST_SPEED);
    addChild(signalTestPanel, testSpeedNode);

    // TEST_SPEED_VALUE: in JSON, value-only entity used alongside TEST_SPEED
    auto* testSpeedValueNode = new LvglDisplayNode(nullptr, 0, ID_TEST_SPEED_VALUE);
    addChild(signalTestPanel, testSpeedValueNode);

    // --- Peripheral test screen (modeGroup) ---
    auto* peripheralTestPanel = new LvglDisplayNode(peripheralTestWidget, 0, ID_INFO_TEST_PERIPHERALS, true);
    addChild(generalPanel, peripheralTestPanel);

    // GSM group: Module(_left=1,_right=3), N/W(_left=4,_right=7), Upload(_left=8,_right=9)
    std::vector<PeripheralSubItem> gsmItems = {
        {gsmIcons[0], "Test_GSM_1", 1, 3},
        {gsmIcons[1], "Test_GSM_2", 4, 7},
        {gsmIcons[2], "Test_GSM_3", 8, 9},
    };
    auto* gsmTestNode = new LvglPeripheralTestGroupNode(gsmRow, 0, ID_INFO_TEST_GSM, gsmItems, gsmResult);
    addChild(peripheralTestPanel, gsmTestNode);

    // GPS group: MSGs(_left=1,_right=2), Locked(_left=3,_right=4)
    std::vector<PeripheralSubItem> gpsItems = {
        {gpsIcons[0], "Test_GPS_1", 1, 2},
        {gpsIcons[1], "Test_GPS_2", 3, 4},
    };
    auto* gpsTestNode = new LvglPeripheralTestGroupNode(gpsRow, 0, ID_INFO_TEST_GPS, gpsItems, gpsResult);
    addChild(peripheralTestPanel, gpsTestNode);

    // Gyro group: MSG(_left=1,_right=1), Range(_left=2,_right=2)
    std::vector<PeripheralSubItem> gyroItems = {
        {gyroIcons[0], "Test_Gyro_1", 1, 1},
        {gyroIcons[1], "Test_Gyro_2", 2, 2},
    };
    auto* gyroTestNode = new LvglPeripheralTestGroupNode(gyroRow, 0, ID_INFO_TEST_GYRO, gyroItems, gyroResult);
    addChild(peripheralTestPanel, gyroTestNode);
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
    if (alertController_->needsDisplayUpdate())
    {
        if (!updateDisplayTimeWindow_->isActive())
        {
            alertController_->markUpdateComplete();
            updateDisplayTimeWindow_->start();
            alertController_->mutex.lock();
            updateDisplay();
            alertController_->mutex.unlock();
        }
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
    if (displayDirty_.exchange(false))
    {
        alertController_->mutex.lock();
        updateTreeVisibility(displayRoot_, DO_NOT_FORCE_INVISIBILITY);
        alertController_->mutex.unlock();

        // Host car visibility: QML groupGAG is always visible, so host car shows
        // whenever mainPanel is active (no disconnect/error/FCW overlay hiding it).
        // QML: visible: groupGAG.visible || groupCIPV.visible
        // Since groupGAG.visible=true by default, host car is always visible
        // unless a higher-priority overlay (disconnect, FCW, error) is active.
        if (hostCar_) {
            bool disconActive = disconPanel_ && disconPanel_->getActivSem() > 0;
            bool fcwActive = groupFCW_ && groupFCW_->getActivSem() > 0;
            if (!disconActive && !fcwActive)
                lv_obj_remove_flag(hostCar_, LV_OBJ_FLAG_HIDDEN);
            else
                lv_obj_add_flag(hostCar_, LV_OBJ_FLAG_HIDDEN);
        }

        // QML: HMW text hidden when failsafe visible (is_text_hidden: vsn.visible)
        if (hmwValueLabel_ && failsafeNode_) {
            bool failsafeActive = failsafeNode_->getActivSem() > 0;
            lv_obj_t* hmwContainer = lv_obj_get_parent(hmwValueLabel_);
            if (hmwContainer) {
                // Hide the "sec" and value labels (children 2 and 3 of HMW container)
                // Child 0 = road GIF, child 1 = forward car, child 2 = sec label, child 3 = value label
                lv_obj_t* secLabel = lv_obj_get_child(hmwContainer, 2);
                if (failsafeActive) {
                    if (secLabel) lv_obj_add_flag(secLabel, LV_OBJ_FLAG_HIDDEN);
                    lv_obj_add_flag(hmwValueLabel_, LV_OBJ_FLAG_HIDDEN);
                } else {
                    if (secLabel) lv_obj_remove_flag(secLabel, LV_OBJ_FLAG_HIDDEN);
                    lv_obj_remove_flag(hmwValueLabel_, LV_OBJ_FLAG_HIDDEN);
                }
            }
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
