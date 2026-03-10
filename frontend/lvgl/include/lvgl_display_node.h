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

    // When set, this node reports activSem=0 while blockingNode is active,
    // causing the tree traversal to force-hide all children (ISA/TSR mutual exclusion).
    void setBlockingNode(LvglDisplayNode* blockingNode) { blockingNode_ = blockingNode; }
    LvglDisplayNode* getBlockingNode() const { return blockingNode_; }

    // When set, widget is moved to LVGL foreground on each show transition,
    // so the most recently shown sign renders on top of overlapping signs.
    void setMoveToFrontOnShow(bool v) { moveToFrontOnShow_ = v; }
    lv_obj_t* getWidget() const { return widget_; }
    // Replay intro animation on an already-visible widget (e.g., when shape changes)
    void replayIntroAnim();
    bool justChanged() const { return justBecameVisible_ || justArgsChanged_; }
    void clearJustChanged() { justBecameVisible_ = false; justArgsChanged_ = false; }
    void setCanEntityArgs(uint8_t valueInt, uint8_t valueFrac, uint8_t unit) override;
    void setCanEntityArg(const String& stringArg) override;
    void onBecomeVisible() override;
    void onBecomeInvisible() override;
    LayersPriorityQ* getChildren() override;

    void setParent(LvglDisplayNode* parent);
    void appendChild(LvglDisplayNode* child);

    // Set an intro animation on the image widget (scale from start to target).
    void setIntroAnim(lv_obj_t* imgWidget, int startScale, int targetScale, int delayMs = 0,
                      int targetImgX = 0, int targetImgY = 0);
    // Set a label widget that should scale/move with the intro animation
    void setIntroAnimLabel(lv_obj_t* label);

    // Set container-based intro animation: transform_scale on widget_ itself.
    // All children (image + label) scale together via LVGL render layer.
    void setContainerIntroAnim(int startScale, int targetScale, int delayMs = 0);
    // Optional Y position animation alongside container scale animation.
    void setContainerIntroYAnim(int startY, int targetY);
    // Optional X position animation alongside container scale animation.
    void setContainerIntroXAnim(int startX, int targetX);

protected:
    lv_obj_t* widget_;
    int layer_;
    int activationSemaphore_;
    bool mutexGroup_;
    bool modeGroup_;
    LvglDisplayNode* parent_;
    LvglDisplayNode* blockingNode_ = nullptr;
    LayersPriorityQ* children_;
    uint8_t valueInt_, valueFrac_, unit_;
    String stringArg_;

    // Intro animation (optional, set via setIntroAnim)
    lv_obj_t* introAnimImg_ = nullptr;
    lv_obj_t* introAnimLabel_ = nullptr;
    bool introContainerMode_ = false;  // true = animate widget_ transform_scale
    int introStartScale_ = 256;
    int introTargetScale_ = 256;
    int introDelayMs_ = 0;
    int introTargetImgX_ = 0;
    int introTargetImgY_ = 0;
    int introContainerStartY_ = 0;
    int introContainerTargetY_ = 0;
    bool introContainerYAnim_ = false;
    int introContainerStartX_ = 0;
    int introContainerTargetX_ = 0;
    bool introContainerXAnim_ = false;
    bool wasForceHidden_ = false;   // skip intro anim when transitioning from force-hidden
    bool moveToFrontOnShow_ = false; // move widget to LVGL foreground on show
    bool justBecameVisible_ = false; // set during onBecomeVisible when transitioning from hidden
    bool justArgsChanged_ = false;   // set when CAN entity args change (value update)
    static void introScaleAnimCb(void* obj, int32_t val);
    static void introImgXAnimCb(void* obj, int32_t val);
    static void introImgYAnimCb(void* obj, int32_t val);
    static void introLabelScaleAnimCb(void* obj, int32_t val);
    static void introLabelTransXAnimCb(void* obj, int32_t val);
    static void introLabelTransYAnimCb(void* obj, int32_t val);
    static void introContainerScaleAnimCb(void* obj, int32_t val);
    static void introContainerYAnimCb(void* obj, int32_t val);
    static void introContainerXAnimCb(void* obj, int32_t val);
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
// Supports two modes:
//   1. Container x-position animation (right-panel signs moving from center to edge)
//   2. Image x/y offset animation (left-panel signs: image moves from (0,0) to final offset)
class LvglAnimatedSignNode : public LvglDisplayNode {
public:
    // Right-panel style: container moves in X (startX/targetX for container position)
    LvglAnimatedSignNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType,
                          lv_obj_t* imgWidget, int startScale, int targetScale,
                          int startX, int targetX, int delayMs);

    // Left-panel style: image moves from (0,0) to (targetImgX, targetImgY) while scaling
    static LvglAnimatedSignNode* createLeftPanel(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType,
                                                  lv_obj_t* imgWidget, int startScale, int targetScale,
                                                  int delayMs, int targetImgX, int targetImgY);

    void onBecomeVisible() override;
    void onBecomeInvisible() override;

private:
    lv_obj_t* imgWidget_;
    int startScale_;
    int targetScale_;
    int startX_;      // -1 means no container position animation
    int targetX_;
    int targetImgX_;  // image offset animation target (0 = no anim)
    int targetImgY_;
    int delayMs_;     // QML pause_duration before animation starts
    static void scaleAnimCb(void* obj, int32_t val);
    static void posAnimCb(void* obj, int32_t val);
    static void imgXAnimCb(void* obj, int32_t val);
    static void imgYAnimCb(void* obj, int32_t val);
};

#endif // LVGL_DISPLAY_NODE_H
