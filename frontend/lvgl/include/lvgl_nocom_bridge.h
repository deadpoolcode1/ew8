#ifndef LVGL_NOCOM_BRIDGE_H
#define LVGL_NOCOM_BRIDGE_H

#include "idisplaynode.h"
#include "layerspriorityq.h"
#include "lvgl_ui.h"

/**
 * Temporary Stage 2 bridge: a minimal IDisplayNode registered for ALERT_NOCOM
 * that drives LvglUI's disconnect overlay via activate/deactivate.
 * Will be replaced by the proper display tree in Stage 3.
 */
class LvglNocomBridge : public IDisplayNode {
public:
    explicit LvglNocomBridge(LvglUI* ui)
        : ui_(ui), activSem_(0), children_(new LayersPriorityQ()) {}

    void activate() override {
        activSem_++;
        ui_->setDisconnected(true);
    }

    void deactivate() override {
        if (activSem_ > 0) activSem_--;
        if (activSem_ == 0) ui_->setDisconnected(false);
    }

    int getActivSem() override { return activSem_; }
    int getLayer() const override { return 0; }
    void setCanEntityArgs(uint8_t, uint8_t, uint8_t) override {}
    void setCanEntityArg(const String&) override {}
    void onBecomeVisible() override {}
    void onBecomeInvisible() override {}
    LayersPriorityQ* getChildren() override { return children_; }

private:
    LvglUI* ui_;
    int activSem_;
    LayersPriorityQ* children_;
};

#endif // LVGL_NOCOM_BRIDGE_H
