#include "lvgl_main_process.h"
#include "entitytype.h"
#include "core/core.h"
#include "core/elapsed_timer.h"

extern core::ElapsedTimer bootUpTimer;

LvglMainProcess::LvglMainProcess()
{
    coreDebug() << "LvglMainProcess init begin, time:" << bootUpTimer.elapsed();

    alertController_ = new AlertController();
    canmgr_ = new CanManager(alertController_);

    coreDebug() << "CanManager init complete, time:" << bootUpTimer.elapsed();

    // Generate the alert type map (required before linking display nodes)
    EntityType::generateTypes();

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
    // Stage 2: no display tree yet — the disconnect overlay is handled
    // directly via the atomic flag in LvglUI (temporary shortcut).
    // Stage 3 will add: displayTree_->updateVisibility();
}
