#include "lvgl_main_process.h"
#include "lvgl_display_node.h"
#include "lvgl_value_display_node.h"
#include "lvgl_string_display_node.h"
#include "lvgl_blink_display_node.h"
#include "lvgl_hmw_state_node.h"
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

    // Status bar with all icons (created last so it renders on top)
    LvglWidgets::StatusBarWidgets sb = LvglWidgets::createStatusBar(rootWidget);

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
