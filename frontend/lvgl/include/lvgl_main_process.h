#ifndef LVGL_MAIN_PROCESS_H
#define LVGL_MAIN_PROCESS_H

#include "alertcontroller.h"
#include "canmanager.h"
#include "core/thread.h"
#include "core/timer.h"
#include "lvgl.h"

#include <atomic>

class LvglDisplayNode;

class LvglMainProcess {
public:
    LvglMainProcess(lv_obj_t* screen);
    ~LvglMainProcess();

    void launch();
    void process();
    void updateDisplay();
    void applyPendingDisplayUpdate();

    AlertController* getAlertController() { return alertController_; }

private:
    void buildDisplayTree(lv_obj_t* screen);

    AlertController* alertController_;
    CanManager* canmgr_;
    core::Timer* updateDisplayTimeWindow_;
    core::Thread* itsThread_;
    LvglDisplayNode* displayRoot_;
    std::atomic<bool> displayDirty_;
};

#endif // LVGL_MAIN_PROCESS_H
