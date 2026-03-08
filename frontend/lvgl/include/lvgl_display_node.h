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

    // Set an intro animation image widget + scale targets. When set, onBecomeVisible()
    // will animate scale from startScale to targetScale over 500ms OutQuad.
    void setIntroAnim(lv_obj_t* imgWidget, int startScale, int targetScale);

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

    // Intro animation (optional, set via setIntroAnim)
    lv_obj_t* introAnimImg_ = nullptr;
    int introStartScale_ = 256;
    int introTargetScale_ = 256;
    static void introScaleAnimCb(void* obj, int32_t val);
    void playIntroAnim();

private:
    void handleMutexGroup();
};

// Display node with auto-dismiss timer (max_duration_timer from QML)
class LvglTimedDisplayNode : public LvglDisplayNode {
public:
    LvglTimedDisplayNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType, int maxDurationMs);

    void onBecomeVisible() override;
    void onBecomeInvisible() override;

private:
    static void timerCb(lv_timer_t* timer);
    int maxDurationMs_;
    lv_timer_t* timer_;
};

// Display node that pauses/resumes a child GIF widget on visibility changes
class LvglGifDisplayNode : public LvglDisplayNode {
public:
    LvglGifDisplayNode(lv_obj_t* container, int layer, DISPLAY_ITEM_ID entityType, lv_obj_t* gifWidget);

    void onBecomeVisible() override;
    void onBecomeInvisible() override;

private:
    lv_obj_t* gifWidget_;
};

// Display node with sign intro animation (scale from start to target over 500ms)
// Optionally also animates x-position (for right-panel signs moving from center to edge)
class LvglAnimatedSignNode : public LvglDisplayNode {
public:
    LvglAnimatedSignNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType,
                          lv_obj_t* imgWidget, int startScale, int targetScale,
                          int startX = -1, int targetX = -1, int delayMs = 0);

    void onBecomeVisible() override;
    void onBecomeInvisible() override;

private:
    lv_obj_t* imgWidget_;
    int startScale_;
    int targetScale_;
    int startX_;   // -1 means no position animation
    int targetX_;
    int delayMs_;  // QML pause_duration before animation starts
    static void scaleAnimCb(void* obj, int32_t val);
    static void posAnimCb(void* obj, int32_t val);
};

#endif // LVGL_DISPLAY_NODE_H
