#ifndef LVGL_MAIN_PROCESS_H
#define LVGL_MAIN_PROCESS_H

#include "alertcontroller.h"
#include "canmanager.h"
#include "core/thread.h"
#include "core/timer.h"

class LvglMainProcess {
public:
    LvglMainProcess();
    ~LvglMainProcess();

    void launch();
    void process();
    void updateDisplay();

    AlertController* getAlertController() { return alertController_; }

private:
    AlertController* alertController_;
    CanManager* canmgr_;
    core::Timer* updateDisplayTimeWindow_;
    core::Thread* itsThread_;
};

#endif // LVGL_MAIN_PROCESS_H
