#ifndef LVGL_MAIN_PROCESS_H
#define LVGL_MAIN_PROCESS_H

#include "alertcontroller.h"
#include "canmanager.h"
#include "core/thread.h"
#include "core/timer.h"
#include "lvgl.h"

#include <atomic>
#include <cstdint>

class LvglDisplayNode;
class LvglMenuController;
class LvglSpeedDisplayNode;

class LvglMainProcess {
public:
    LvglMainProcess(lv_obj_t* screen);
    ~LvglMainProcess();

    void launch();
    void process();
    void updateDisplay();
    void applyPendingDisplayUpdate();

    AlertController* getAlertController() { return alertController_; }
    LvglMenuController* getMenuController() { return menuController_; }

    void handleKeyEvent(int sdlKey);
    void handleDualKeyPress();

private:
    void buildDisplayTree(lv_obj_t* screen);

    AlertController* alertController_;
    CanManager* canmgr_;
    core::Thread* itsThread_;
    LvglDisplayNode* displayRoot_;
    std::atomic<bool> displayDirty_;

    // CAN -> display update coalescing. process() (CAN reader thread) only flags
    // that an update is pending and timestamps it; applyPendingDisplayUpdate()
    // (main/LVGL thread) renders once the bus has been quiet for
    // DISPLAY_UPDATE_QUIET_MS (batches a burst) or the update has been deferred
    // for DISPLAY_UPDATE_MAX_DEFER_MS (hard latency cap so continuous real-bus
    // traffic, which never goes quiet, can't stall the display).
    std::atomic<bool> pendingDisplayUpdate_{false};
    std::atomic<int64_t> firstPendingMs_{0};
    std::atomic<int64_t> lastChangeMs_{0};
    static constexpr int64_t DISPLAY_UPDATE_QUIET_MS     = 10;
    static constexpr int64_t DISPLAY_UPDATE_MAX_DEFER_MS = 50;

    // Host car widget and LDW nodes for shift animation
    lv_obj_t* hostCar_;
    LvglDisplayNode* lldwNode_;
    LvglDisplayNode* rldwNode_;
    LvglDisplayNode* groupGAG_;
    LvglDisplayNode* groupCIPV_;
    LvglDisplayNode* groupFCW_;
    LvglDisplayNode* disconPanel_;
    LvglDisplayNode* mainPanel_;
    LvglDisplayNode* failsafeNode_;
    lv_obj_t* hmwValueLabel_;
    // Speed + error nodes, used to gate the user menus (QML isDisplayOfMenusEnabled).
    LvglSpeedDisplayNode* speedNode_;
    LvglDisplayNode* errorNode_;
    int lastCarOffset_;
    static void carShiftAnimCb(void* obj, int32_t val);

    // Left panel sign groups for z-order management
    LvglDisplayNode* groupTop_;
    LvglDisplayNode* groupBottom_;

    // Menu controller
    LvglMenuController* menuController_;
};

#endif // LVGL_MAIN_PROCESS_H
