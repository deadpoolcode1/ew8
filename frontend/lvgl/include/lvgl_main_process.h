#ifndef LVGL_MAIN_PROCESS_H
#define LVGL_MAIN_PROCESS_H

#include "alertcontroller.h"
#include "canmanager.h"
#include "core/thread.h"
#include "core/timer.h"
#include "lvgl.h"

#include <atomic>

class LvglDisplayNode;
class LvglMenuController;

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

private:
    void buildDisplayTree(lv_obj_t* screen);

    AlertController* alertController_;
    CanManager* canmgr_;
    core::Timer* updateDisplayTimeWindow_;
    core::Thread* itsThread_;
    LvglDisplayNode* displayRoot_;
    std::atomic<bool> displayDirty_;

    // Host car widget and LDW nodes for shift animation
    lv_obj_t* hostCar_;
    LvglDisplayNode* lldwNode_;
    LvglDisplayNode* rldwNode_;

    // Menu controller
    LvglMenuController* menuController_;
};

#endif // LVGL_MAIN_PROCESS_H
