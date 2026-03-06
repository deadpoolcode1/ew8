#include "lvgl_main_process.h"
#include "lvgl_display_node.h"
#include "lvgl_value_display_node.h"
#include "lvgl_string_display_node.h"
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
    // Resolve entity type IDs from string names
    DISPLAY_ITEM_ID ID_ALERT_FCW          = GraphicItemsEnumMap::getId("ALERT_FCW");
    DISPLAY_ITEM_ID ID_ALERT_PCW          = GraphicItemsEnumMap::getId("ALERT_PCW");
    DISPLAY_ITEM_ID ID_INFO_VEH_SPEED     = GraphicItemsEnumMap::getId("INFO_VEH_SPEED");
    DISPLAY_ITEM_ID ID_ALERT_HMW_DISTANCE = GraphicItemsEnumMap::getId("ALERT_HMW_DISTANCE");
    DISPLAY_ITEM_ID ID_ALERT_LLDW         = GraphicItemsEnumMap::getId("ALERT_LLDW");
    DISPLAY_ITEM_ID ID_ALERT_RLDW         = GraphicItemsEnumMap::getId("ALERT_RLDW");
    DISPLAY_ITEM_ID ID_ALERT_ERROR        = GraphicItemsEnumMap::getId("ALERT_ERROR");

    // --- Create LVGL widgets ---
    lv_obj_t* rootWidget = createRootContainer(screen);

    lv_obj_t* disconWidget  = LvglWidgets::createDisconnectOverlay(rootWidget);
    lv_obj_t* errorWidget   = LvglWidgets::createErrorOverlay(rootWidget);
    lv_obj_t* fcwWidget     = LvglWidgets::createFCWAlert(rootWidget);
    lv_obj_t* pcwWidget     = LvglWidgets::createPCWAlert(rootWidget);
    lv_obj_t* ldwLeftWidget = LvglWidgets::createLDWIndicator(rootWidget, true);
    lv_obj_t* ldwRightWidget = LvglWidgets::createLDWIndicator(rootWidget, false);

    lv_obj_t* hmwValueLabel = nullptr;
    lv_obj_t* hmwWidget     = LvglWidgets::createHMWDisplay(rootWidget, &hmwValueLabel);

    lv_obj_t* speedValueLabel = nullptr;
    lv_obj_t* speedWidget     = LvglWidgets::createSpeedDisplay(rootWidget, &speedValueLabel);

    // --- Build display tree ---
    // root (group, layer=0)
    displayRoot_ = new LvglDisplayNode(rootWidget, 0, false, false);

    // general_panel (group, layer=0)
    auto* generalPanel = new LvglDisplayNode(nullptr, 0, false, false);
    addChild(displayRoot_, generalPanel);

    // discon_panel (group, layer=0) — low layer, covers everything when active
    auto* disconPanel = new LvglDisplayNode(nullptr, 0, false, false);
    addChild(generalPanel, disconPanel);

    // alert_err (leaf, layer=0, ALERT_ERROR)
    auto* errorNode = new LvglDisplayNode(errorWidget, 0, ID_ALERT_ERROR);
    addChild(disconPanel, errorNode);

    // discon_alert (leaf, layer=0, ALERT_NOCOM)
    auto* disconNode = new LvglDisplayNode(disconWidget, 0, AlertTypes::ALERT_NOCOM);
    addChild(disconPanel, disconNode);

    // main_panel (group, layer=2)
    auto* mainPanel = new LvglDisplayNode(nullptr, 2, false, false);
    addChild(generalPanel, mainPanel);

    // groupCIPV (group, layer=1)
    auto* groupCIPV = new LvglDisplayNode(nullptr, 1, false, false);
    addChild(mainPanel, groupCIPV);

    // alert_hmw_distance (LvglValueDisplayNode, layer=0, ALERT_HMW_DISTANCE)
    auto* hmwNode = new LvglValueDisplayNode(hmwWidget, 0, ID_ALERT_HMW_DISTANCE, hmwValueLabel);
    addChild(groupCIPV, hmwNode);

    // groupGAG (group, layer=1)
    auto* groupGAG = new LvglDisplayNode(nullptr, 1, false, false);
    addChild(mainPanel, groupGAG);

    // groupLanes (group, layer=0)
    auto* groupLanes = new LvglDisplayNode(nullptr, 0, false, false);
    addChild(groupGAG, groupLanes);

    // groupLanesLeft (group, layer=0)
    auto* groupLanesLeft = new LvglDisplayNode(nullptr, 0, false, false);
    addChild(groupLanes, groupLanesLeft);

    // alert_lldw (leaf, layer=1, ALERT_LLDW)
    auto* lldwNode = new LvglDisplayNode(ldwLeftWidget, 1, ID_ALERT_LLDW);
    addChild(groupLanesLeft, lldwNode);

    // groupLanesRight (group, layer=0)
    auto* groupLanesRight = new LvglDisplayNode(nullptr, 0, false, false);
    addChild(groupLanes, groupLanesRight);

    // alert_rldw (leaf, layer=1, ALERT_RLDW)
    auto* rldwNode = new LvglDisplayNode(ldwRightWidget, 1, ID_ALERT_RLDW);
    addChild(groupLanesRight, rldwNode);

    // groupFCW (group, layer=2, mutexGroup=true)
    auto* groupFCW = new LvglDisplayNode(nullptr, 2, true, false);
    addChild(generalPanel, groupFCW);

    // alert_fcw (leaf, layer=1, ALERT_FCW)
    auto* fcwNode = new LvglDisplayNode(fcwWidget, 1, ID_ALERT_FCW);
    addChild(groupFCW, fcwNode);

    // alert_pcw (leaf, layer=0, ALERT_PCW)
    auto* pcwNode = new LvglDisplayNode(pcwWidget, 0, ID_ALERT_PCW);
    addChild(groupFCW, pcwNode);

    // status_panel (group, layer=2)
    auto* statusPanel = new LvglDisplayNode(nullptr, 2, false, false);
    addChild(generalPanel, statusPanel);

    // speed (LvglValueDisplayNode, layer=0, INFO_VEH_SPEED)
    auto* speedNode = new LvglValueDisplayNode(speedWidget, 0, ID_INFO_VEH_SPEED, speedValueLabel);
    addChild(statusPanel, speedNode);

    // Always-visible status bar — created last so it renders on top of everything
    LvglWidgets::createStatusBar(rootWidget);
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
    }
}
