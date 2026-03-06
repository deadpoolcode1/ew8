#include "lvgl_main_process.h"
#include "lvgl_display_node.h"
#include "lvgl_value_display_node.h"
#include "lvgl_string_display_node.h"
#include "lvgl_blink_display_node.h"
#include "lvgl_hmw_state_node.h"
#include "lvgl_menu_controller.h"
#include "lvgl_menu_display_node.h"
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
    , lldwNode_(nullptr)
    , rldwNode_(nullptr)
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

    // --- Create LVGL widgets ---
    lv_obj_t* rootWidget = createRootContainer(screen);

    lv_obj_t* disconWidget  = LvglWidgets::createDisconnectOverlay(rootWidget);
    lv_obj_t* errorWidget   = LvglWidgets::createErrorOverlay(rootWidget);
    lv_obj_t* fcwWidget     = LvglWidgets::createFCWAlert(rootWidget);
    lv_obj_t* pcwWidget     = LvglWidgets::createPCWAlert(rootWidget);

    // LDW indicators: off (yellow), active (blinking), on (green)
    lv_obj_t* ldwOffLeftWidget  = LvglWidgets::createLDWOffIndicator(rootWidget, true);
    lv_obj_t* ldwOffRightWidget = LvglWidgets::createLDWOffIndicator(rootWidget, false);
    lv_obj_t* ldwLeftWidget     = LvglWidgets::createLDWIndicator(rootWidget, true);
    lv_obj_t* ldwRightWidget    = LvglWidgets::createLDWIndicator(rootWidget, false);
    lv_obj_t* ldwOnLeftWidget   = LvglWidgets::createLDWOnIndicator(rootWidget, true);
    lv_obj_t* ldwOnRightWidget  = LvglWidgets::createLDWOnIndicator(rootWidget, false);

    // HMW display (returns struct with sub-widget pointers)
    LvglWidgets::HMWWidgets hmw = LvglWidgets::createHMWDisplay(rootWidget);
    hostCar_ = hmw.hostCar;

    // PDZ overlay
    lv_obj_t* pdzWidget = LvglWidgets::createPDZOverlay(rootWidget);

    lv_obj_t* speedValueLabel = nullptr;
    lv_obj_t* speedWidget     = LvglWidgets::createSpeedDisplay(rootWidget, &speedValueLabel);

    // Overlay widgets
    lv_obj_t* failsafeWidget  = LvglWidgets::createFailsafeOverlay(rootWidget);
    lv_obj_t* poweroffWidget  = LvglWidgets::createOpModeOverlay(rootWidget, "Power Off");
    lv_obj_t* keeppwrWidget   = LvglWidgets::createOpModeOverlay(rootWidget, "Keep Power");
    lv_obj_t* pilotWidget     = LvglWidgets::createOpModeOverlay(rootWidget, "Pilot Mode");

    // Left panel signs — upper slot (RTW, SLI, ISA)
    lv_obj_t* rtwWarnWidget = LvglWidgets::createLeftPanelSign(rootWidget,
        "A:images/traffic-violation/left_TV_RL_small.png", true);
    lv_obj_t* rtwAlertWidget = LvglWidgets::createRTWAlert(rootWidget);

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

    // Supplementary signs — lower slot (same images as base signs, supp icon skipped for v1)
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

    // Status bar with all icons (created last so it renders on top)
    LvglWidgets::StatusBarWidgets sb = LvglWidgets::createStatusBar(rootWidget);

    // Menu controller (created after everything so menus render on top)
    menuController_ = new LvglMenuController(rootWidget);

    // --- Build display tree ---
    // root (group, layer=0)
    displayRoot_ = new LvglDisplayNode(rootWidget, 0, false, false);

    // general_panel (group, layer=0)
    auto* generalPanel = new LvglDisplayNode(nullptr, 0, false, false);
    addChild(displayRoot_, generalPanel);

    // discon_panel (group, layer=0)
    auto* disconPanel = new LvglDisplayNode(nullptr, 0, false, false);
    addChild(generalPanel, disconPanel);

    auto* errorNode = new LvglDisplayNode(errorWidget, 0, ID_ALERT_ERROR);
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

    // failsafe overlay (leaf, layer=1, INFO_FAILSAFE)
    auto* failsafeNode = new LvglDisplayNode(failsafeWidget, 1, ID_INFO_FAILSAFE);
    addChild(generalPanel, failsafeNode);

    // groupCIPV (group, layer=1)
    auto* groupCIPV = new LvglDisplayNode(nullptr, 1, false, false);
    addChild(mainPanel, groupCIPV);

    // HMW distance (LvglValueDisplayNode, layer=0, ALERT_HMW_DISTANCE)
    auto* hmwNode = new LvglValueDisplayNode(hmw.container, 0, ID_ALERT_HMW_DISTANCE, hmw.valueLabel);
    addChild(groupCIPV, hmwNode);

    // HMW state nodes (layer=0, no widget — change road GIF on visibility)
    auto* hmwAlertNode = new LvglHmwStateNode(0, ID_ALERT_HMW_ALERT,
                                               hmw.roadStrip, "A:images/hmw/HMW-red-new-1.gif");
    addChild(groupCIPV, hmwAlertNode);

    auto* hmwMonitorNode = new LvglHmwStateNode(0, ID_ALERT_HMW_MONITOR,
                                                 hmw.roadStrip, "A:images/hmw/HMW-green-new-2.gif");
    addChild(groupCIPV, hmwMonitorNode);

    // PDZ overlay (layer=0, ALERT_PDZ)
    auto* pdzNode = new LvglDisplayNode(pdzWidget, 0, ID_ALERT_PDZ);
    addChild(groupCIPV, pdzNode);

    // groupGAG (group, layer=1)
    auto* groupGAG = new LvglDisplayNode(nullptr, 1, false, false);
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

    // groupFCW (group, layer=2, mutexGroup=true)
    auto* groupFCW = new LvglDisplayNode(nullptr, 2, true, false);
    addChild(generalPanel, groupFCW);

    auto* fcwNode = new LvglDisplayNode(fcwWidget, 1, ID_ALERT_FCW);
    addChild(groupFCW, fcwNode);

    auto* pcwNode = new LvglDisplayNode(pcwWidget, 0, ID_ALERT_PCW);
    addChild(groupFCW, pcwNode);

    // status_panel (group, layer=2)
    auto* statusPanel = new LvglDisplayNode(nullptr, 2, false, false);
    addChild(generalPanel, statusPanel);

    // speed (LvglValueDisplayNode, layer=0, INFO_VEH_SPEED)
    auto* speedNode = new LvglValueDisplayNode(speedWidget, 0, ID_INFO_VEH_SPEED, speedValueLabel);
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

    auto* normalModeNode = new LvglDisplayNode(nullptr, 0, ID_OM_NORMAL);
    addChild(statusPanel, normalModeNode);

    auto* gpsOkNode = new LvglDisplayNode(nullptr, 0, ID_INFO_GPS_OK);
    addChild(statusPanel, gpsOkNode);

    // --- Left panel signs (Bulk 3) ---
    // leftPanel (group, layer=0) under mainPanel
    auto* leftPanel = new LvglDisplayNode(nullptr, 0, false, false);
    addChild(mainPanel, leftPanel);

    // groupTop (group, layer=0, non-mutex: RTW layer=0, SLI layer=1, ISA_SPEED layer=2, ISA_HIGHWAY layer=1)
    auto* groupTop = new LvglDisplayNode(nullptr, 0, false, false);
    addChild(leftPanel, groupTop);

    auto* rtwWarnNode = new LvglDisplayNode(rtwWarnWidget, 0, ID_ALERT_RTW_WARN);
    addChild(groupTop, rtwWarnNode);

    auto* sliNode = new LvglValueDisplayNode(sliWidget, 1, ID_ALERT_SLI, sliSpeedLabel);
    addChild(groupTop, sliNode);

    auto* isaSpeedNode = new LvglValueDisplayNode(isaSpeedWidget, 2, ID_ALERT_ISA_SPEED, isaSpeedLabel);
    addChild(groupTop, isaSpeedNode);

    auto* isaHighwayNode = new LvglDisplayNode(isaHighwayWidget, 1, ID_ALERT_ISA_HIGHWAY);
    addChild(groupTop, isaHighwayNode);

    // groupBottom (group, layer=0, mutexGroup=true: TSR signs layer=0, supp signs layer=1)
    auto* groupBottom = new LvglDisplayNode(nullptr, 0, true, false);
    addChild(leftPanel, groupBottom);

    auto* endAllRestrNode = new LvglDisplayNode(endAllRestrWidget, 0, ID_ALERT_END_ALL_RESTR);
    addChild(groupBottom, endAllRestrNode);

    auto* noPassNode = new LvglDisplayNode(noPassWidget, 0, ID_ALERT_NO_PASS);
    addChild(groupBottom, noPassNode);

    auto* noPassEndNode = new LvglDisplayNode(noPassEndWidget, 0, ID_ALERT_NO_PASS_END);
    addChild(groupBottom, noPassEndNode);

    auto* motorwayNode = new LvglDisplayNode(motorwayWidget, 0, ID_ALERT_MOTORWAY);
    addChild(groupBottom, motorwayNode);

    auto* motorwayEndNode = new LvglDisplayNode(motorwayEndWidget, 0, ID_ALERT_MOTORWAY_END);
    addChild(groupBottom, motorwayEndNode);

    auto* expresswayNode = new LvglDisplayNode(expresswayWidget, 0, ID_ALERT_EXPRESSWAY);
    addChild(groupBottom, expresswayNode);

    auto* expresswayEndNode = new LvglDisplayNode(expresswayEndWidget, 0, ID_ALERT_EXPRESSWAY_END);
    addChild(groupBottom, expresswayEndNode);

    auto* playgroundNode = new LvglDisplayNode(playgroundWidget, 0, ID_ALERT_PLAYGROUND);
    addChild(groupBottom, playgroundNode);

    auto* playgroundEndNode = new LvglDisplayNode(playgroundEndWidget, 0, ID_ALERT_PLAYGROUND_END);
    addChild(groupBottom, playgroundEndNode);

    // Supplementary signs (layer=1 in groupBottom — shown when base TSR is not active)
    auto* sliSuppNode = new LvglValueDisplayNode(sliSuppWidget, 1, ID_ALERT_SLI_SUPP, sliSuppSpeedLabel);
    addChild(groupBottom, sliSuppNode);

    auto* noPassSuppNode = new LvglDisplayNode(noPassSuppWidget, 1, ID_ALERT_NO_PASS_SUPP);
    addChild(groupBottom, noPassSuppNode);

    auto* motorwaySuppNode = new LvglDisplayNode(motorwaySuppWidget, 1, ID_ALERT_MOTORWAY_SUPP);
    addChild(groupBottom, motorwaySuppNode);

    auto* expresswaySuppNode = new LvglDisplayNode(expresswaySuppWidget, 1, ID_ALERT_EXPRESSWAY_SUPP);
    addChild(groupBottom, expresswaySuppNode);

    auto* playgroundSuppNode = new LvglDisplayNode(playgroundSuppWidget, 1, ID_ALERT_PLAYGROUND_SUPP);
    addChild(groupBottom, playgroundSuppNode);

    // RTW alert (full-screen, under generalPanel at layer=0 so it overlays like discon)
    auto* rtwAlertNode = new LvglDisplayNode(rtwAlertWidget, 0, ID_ALERT_RTW_ALERT);
    addChild(generalPanel, rtwAlertNode);

    // Dummy nodes for Bulk 3 entities (registered but no visual effect)
    auto* tsrNotIsaNode = new LvglDisplayNode(nullptr, 0, ID_STATE_TSR_NOT_ISA);
    addChild(leftPanel, tsrNotIsaNode);

    auto* isaNotTsrNode = new LvglDisplayNode(nullptr, 0, ID_STATE_ISA_NOT_TSR);
    addChild(leftPanel, isaNotTsrNode);

    auto* sliShowNode = new LvglDisplayNode(nullptr, 0, ID_ALERT_SLI_SHOW);
    addChild(leftPanel, sliShowNode);

    auto* isaOverspeedNode = new LvglDisplayNode(nullptr, 0, ID_ALERT_ISA_OVERSPEED);
    addChild(leftPanel, isaOverspeedNode);

    auto* shapeUsaNode = new LvglDisplayNode(nullptr, 0, ID_SHAPE_USA);
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

    auto* smartCrowdedNode  = new LvglDisplayNode(smartCrowdedWidget,  1, ID_SMART_CROWDED);
    addChild(groupTopSadas, smartCrowdedNode);

    auto* smartPedHwyNode   = new LvglDisplayNode(smartPedHwyWidget,   2, ID_SMART_PED_HWY);
    addChild(groupTopSadas, smartPedHwyNode);

    auto* smartCycHwyNode   = new LvglDisplayNode(smartCycHwyWidget,   3, ID_SMART_CYC_HWY);
    addChild(groupTopSadas, smartCycHwyNode);

    auto* smartHarshDzNode  = new LvglDisplayNode(smartHarshDzWidget,  4, ID_SMART_HARSH_DZ);
    addChild(groupTopSadas, smartHarshDzNode);

    auto* smartCaNode       = new LvglDisplayNode(smartCaWidget,       4, ID_SMART_CA);
    addChild(groupTopSadas, smartCaNode);

    auto* smartWeaRoadNode  = new LvglDisplayNode(smartWeaRoadWidget,  5, ID_SMART_WEA_ROAD);
    addChild(groupTopSadas, smartWeaRoadNode);

    auto* smartWeaHydroNode = new LvglDisplayNode(smartWeaHydroWidget, 5, ID_SMART_WEA_HYDRO);
    addChild(groupTopSadas, smartWeaHydroNode);

    auto* smartWeaFgNode    = new LvglDisplayNode(smartWeaFgWidget,    6, ID_SMART_WEA_FG);
    addChild(groupTopSadas, smartWeaFgNode);

    auto* smartWeaWndNode   = new LvglDisplayNode(smartWeaWndWidget,   7, ID_SMART_WEA_WND);
    addChild(groupTopSadas, smartWeaWndNode);

    auto* smartWeaHailNode  = new LvglDisplayNode(smartWeaHailWidget,  7, ID_SMART_WEA_HAIL);
    addChild(groupTopSadas, smartWeaHailNode);

    auto* smartWeaTstmNode  = new LvglDisplayNode(smartWeaTstmWidget,  7, ID_SMART_WEA_TSTM);
    addChild(groupTopSadas, smartWeaTstmNode);

    // groupBottomSadas (mutexGroup=false): secondary icons, multiple can be visible
    auto* groupBottomSadas = new LvglDisplayNode(nullptr, 0, false, false);
    addChild(rightPanel, groupBottomSadas);

    auto* smartCrowdedSecNode  = new LvglDisplayNode(smartCrowdedSecWidget,  1, ID_SMART_CROWDED_SEC);
    addChild(groupBottomSadas, smartCrowdedSecNode);

    auto* smartPedHwySecNode   = new LvglDisplayNode(smartPedHwySecWidget,   2, ID_SMART_PED_HWY_SEC);
    addChild(groupBottomSadas, smartPedHwySecNode);

    auto* smartCycHwySecNode   = new LvglDisplayNode(smartCycHwySecWidget,   3, ID_SMART_CYC_HWY_SEC);
    addChild(groupBottomSadas, smartCycHwySecNode);

    auto* smartHarshDzSecNode  = new LvglDisplayNode(smartHarshDzSecWidget,  4, ID_SMART_HARSH_DZ_SEC);
    addChild(groupBottomSadas, smartHarshDzSecNode);

    auto* smartCaSecNode       = new LvglDisplayNode(smartCaSecWidget,       4, ID_SMART_CA_SEC);
    addChild(groupBottomSadas, smartCaSecNode);

    auto* smartWeaRoadSecNode  = new LvglDisplayNode(smartWeaRoadSecWidget,  5, ID_SMART_WEA_ROAD_SEC);
    addChild(groupBottomSadas, smartWeaRoadSecNode);

    auto* smartWeaHydroSecNode = new LvglDisplayNode(smartWeaHydroSecWidget, 5, ID_SMART_WEA_HYDRO_SEC);
    addChild(groupBottomSadas, smartWeaHydroSecNode);

    auto* smartWeaFgSecNode    = new LvglDisplayNode(smartWeaFgSecWidget,    6, ID_SMART_WEA_FG_SEC);
    addChild(groupBottomSadas, smartWeaFgSecNode);

    auto* smartWeaWndSecNode   = new LvglDisplayNode(smartWeaWndSecWidget,   7, ID_SMART_WEA_WND_SEC);
    addChild(groupBottomSadas, smartWeaWndSecNode);

    auto* smartWeaHailSecNode  = new LvglDisplayNode(smartWeaHailSecWidget,  7, ID_SMART_WEA_HAIL_SEC);
    addChild(groupBottomSadas, smartWeaHailSecNode);

    auto* smartWeaTstmSecNode  = new LvglDisplayNode(smartWeaTstmSecWidget,  7, ID_SMART_WEA_TSTM_SEC);
    addChild(groupBottomSadas, smartWeaTstmSecNode);

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
}

void LvglMainProcess::handleKeyEvent(int sdlKey)
{
    if (menuController_) {
        menuController_->handleKeyEvent(sdlKey);
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

void LvglMainProcess::applyPendingDisplayUpdate()
{
    if (displayDirty_.exchange(false))
    {
        alertController_->mutex.lock();
        updateTreeVisibility(displayRoot_, DO_NOT_FORCE_INVISIBILITY);
        alertController_->mutex.unlock();

        // Host car shift based on LDW activation
        if (hostCar_ && lldwNode_ && rldwNode_)
        {
            bool leftActive = lldwNode_->getActivSem() > 0;
            bool rightActive = rldwNode_->getActivSem() > 0;
            int offset = 0;
            if (leftActive && !rightActive)
                offset = -41;
            else if (rightActive && !leftActive)
                offset = 41;
            lv_obj_align(hostCar_, LV_ALIGN_BOTTOM_MID, offset, 5);
        }
    }
}
