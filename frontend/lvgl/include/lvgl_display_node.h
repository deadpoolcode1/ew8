#ifndef LVGL_DISPLAY_NODE_H
#define LVGL_DISPLAY_NODE_H

#include "idisplaynode.h"
#include "layerspriorityq.h"
#include "lvgl.h"

class LvglDisplayNode : public IDisplayNode {
public:
    // Group node (no entity type registration, may have mutexGroup/modeGroup)
    LvglDisplayNode(lv_obj_t* widget, int layer, bool mutexGroup, bool modeGroup);

    // Leaf node (registers with EntityType via linkByEntityType)
    LvglDisplayNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType);

    // Mode group leaf node (registers entity AND supports modeGroup children)
    LvglDisplayNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType, bool modeGroup);

    // IDisplayNode interface
    void activate() override;
    void deactivate() override;
    int getActivSem() override;
    int getLayer() const override;
    void setCanEntityArgs(uint8_t valueInt, uint8_t valueFrac, uint8_t unit) override;
    void setCanEntityArg(const String& stringArg) override;
    void onBecomeVisible() override;
    void onBecomeInvisible() override;
    LayersPriorityQ* getChildren() override;

    void setParent(LvglDisplayNode* parent);
    void appendChild(LvglDisplayNode* child);

protected:
    lv_obj_t* widget_;
    int layer_;
    int activationSemaphore_;
    bool mutexGroup_;
    bool modeGroup_;
    LvglDisplayNode* parent_;
    LayersPriorityQ* children_;
    uint8_t valueInt_, valueFrac_, unit_;
    String stringArg_;

private:
    void handleMutexGroup();
};

#endif // LVGL_DISPLAY_NODE_H
