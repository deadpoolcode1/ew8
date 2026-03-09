#include "lvgl_display_node.h"
#include "entitytype.h"
#include "core/core.h"

// Group node constructor
LvglDisplayNode::LvglDisplayNode(lv_obj_t* widget, int layer, bool mutexGroup, bool modeGroup)
    : widget_(widget)
    , layer_(layer)
    , activationSemaphore_(0)
    , mutexGroup_(mutexGroup)
    , modeGroup_(modeGroup)
    , parent_(nullptr)
    , children_(new LayersPriorityQ())
    , valueInt_(0)
    , valueFrac_(0)
    , unit_(0)
{
}

// Leaf node constructor — registers with EntityType
LvglDisplayNode::LvglDisplayNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType)
    : widget_(widget)
    , layer_(layer)
    , activationSemaphore_(0)
    , mutexGroup_(false)
    , modeGroup_(false)
    , parent_(nullptr)
    , children_(new LayersPriorityQ())
    , valueInt_(0)
    , valueFrac_(0)
    , unit_(0)
{
    EntityType::linkByEntityType(entityType, this);
}

// Mode group leaf node constructor — registers entity AND supports modeGroup
LvglDisplayNode::LvglDisplayNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType, bool modeGroup)
    : widget_(widget)
    , layer_(layer)
    , activationSemaphore_(0)
    , mutexGroup_(false)
    , modeGroup_(modeGroup)
    , parent_(nullptr)
    , children_(new LayersPriorityQ())
    , valueInt_(0)
    , valueFrac_(0)
    , unit_(0)
{
    EntityType::linkByEntityType(entityType, this);
}

void LvglDisplayNode::activate()
{
    if (parent_ != nullptr && parent_->mutexGroup_)
    {
        parent_->handleMutexGroup();
    }

    activationSemaphore_++;

    if (parent_ == nullptr)
    {
        return;  // root
    }

    if (!parent_->modeGroup_)
    {
        parent_->activate();
    }
}

void LvglDisplayNode::deactivate()
{
    if (!activationSemaphore_)
    {
        return;
    }

    activationSemaphore_--;

    if (parent_ == nullptr)
    {
        return;  // root
    }

    if (!parent_->modeGroup_)
    {
        parent_->deactivate();
    }
}

int LvglDisplayNode::getActivSem()
{
    return activationSemaphore_;
}

int LvglDisplayNode::getLayer() const
{
    return layer_;
}

void LvglDisplayNode::setCanEntityArgs(uint8_t valueInt, uint8_t valueFrac, uint8_t unit)
{
    valueInt_ = valueInt;
    valueFrac_ = valueFrac;
    unit_ = unit;
}

void LvglDisplayNode::setCanEntityArg(const String& stringArg)
{
    stringArg_ = stringArg;
}

void LvglDisplayNode::setIntroAnim(lv_obj_t* imgWidget, int startScale, int targetScale, int delayMs,
                                    int targetImgX, int targetImgY)
{
    introAnimImg_ = imgWidget;
    introStartScale_ = startScale;
    introTargetScale_ = targetScale;
    introDelayMs_ = delayMs;
    introTargetImgX_ = targetImgX;
    introTargetImgY_ = targetImgY;
}

void LvglDisplayNode::introScaleAnimCb(void* obj, int32_t val)
{
    lv_image_set_scale(static_cast<lv_obj_t*>(obj), val);
}

void LvglDisplayNode::introImgXAnimCb(void* obj, int32_t val)
{
    lv_obj_set_x(static_cast<lv_obj_t*>(obj), val);
}

void LvglDisplayNode::introImgYAnimCb(void* obj, int32_t val)
{
    lv_obj_set_y(static_cast<lv_obj_t*>(obj), val);
}

void LvglDisplayNode::introLabelScaleAnimCb(void* obj, int32_t val)
{
    lv_obj_t* label = static_cast<lv_obj_t*>(obj);
    lv_obj_set_style_transform_scale_x(label, val, 0);
    lv_obj_set_style_transform_scale_y(label, val, 0);
}

void LvglDisplayNode::introLabelTransXAnimCb(void* obj, int32_t val)
{
    lv_obj_set_style_translate_x(static_cast<lv_obj_t*>(obj), val, 0);
}

void LvglDisplayNode::introLabelTransYAnimCb(void* obj, int32_t val)
{
    lv_obj_set_style_translate_y(static_cast<lv_obj_t*>(obj), val, 0);
}

void LvglDisplayNode::setIntroAnimLabel(lv_obj_t* label)
{
    introAnimLabel_ = label;
}

void LvglDisplayNode::setContainerIntroAnim(int startScale, int targetScale, int delayMs)
{
    introContainerMode_ = true;
    introStartScale_ = startScale;
    introTargetScale_ = targetScale;
    introDelayMs_ = delayMs;
}

void LvglDisplayNode::setContainerIntroYAnim(int startY, int targetY)
{
    introContainerYAnim_ = true;
    introContainerStartY_ = startY;
    introContainerTargetY_ = targetY;
}

void LvglDisplayNode::introContainerScaleAnimCb(void* obj, int32_t val)
{
    lv_obj_t* cont = static_cast<lv_obj_t*>(obj);
    lv_obj_set_style_transform_scale_x(cont, val, 0);
    lv_obj_set_style_transform_scale_y(cont, val, 0);
}

void LvglDisplayNode::introContainerYAnimCb(void* obj, int32_t val)
{
    lv_obj_set_y(static_cast<lv_obj_t*>(obj), val);
}

void LvglDisplayNode::setContainerIntroXAnim(int startX, int targetX)
{
    introContainerXAnim_ = true;
    introContainerStartX_ = startX;
    introContainerTargetX_ = targetX;
}

void LvglDisplayNode::introContainerXAnimCb(void* obj, int32_t val)
{
    lv_obj_set_x(static_cast<lv_obj_t*>(obj), val);
}

void LvglDisplayNode::playIntroAnim()
{
    if (introContainerMode_ && widget_) {
        // Container mode: single animation on container transform_scale
        // Children (image + label) scale together via LVGL render layer
        lv_anim_t anim;
        lv_anim_init(&anim);
        lv_anim_set_var(&anim, widget_);
        lv_anim_set_values(&anim, introStartScale_, introTargetScale_);
        lv_anim_set_duration(&anim, 500);
        lv_anim_set_delay(&anim, introDelayMs_);
        lv_anim_set_path_cb(&anim, lv_anim_path_ease_out);
        lv_anim_set_exec_cb(&anim, introContainerScaleAnimCb);
        lv_anim_start(&anim);

        // Optional Y position animation (for bottom-slot signs)
        if (introContainerYAnim_) {
            lv_anim_t yAnim;
            lv_anim_init(&yAnim);
            lv_anim_set_var(&yAnim, widget_);
            lv_anim_set_values(&yAnim, introContainerStartY_, introContainerTargetY_);
            lv_anim_set_duration(&yAnim, 500);
            lv_anim_set_delay(&yAnim, introDelayMs_);
            lv_anim_set_path_cb(&yAnim, lv_anim_path_ease_out);
            lv_anim_set_exec_cb(&yAnim, introContainerYAnimCb);
            lv_anim_start(&yAnim);
        }

        // Optional X position animation (for bottom-slot signs)
        if (introContainerXAnim_) {
            lv_anim_t xAnim;
            lv_anim_init(&xAnim);
            lv_anim_set_var(&xAnim, widget_);
            lv_anim_set_values(&xAnim, introContainerStartX_, introContainerTargetX_);
            lv_anim_set_duration(&xAnim, 500);
            lv_anim_set_delay(&xAnim, introDelayMs_);
            lv_anim_set_path_cb(&xAnim, lv_anim_path_ease_out);
            lv_anim_set_exec_cb(&xAnim, introContainerXAnimCb);
            lv_anim_start(&xAnim);
        }
        return;
    }

    if (!introAnimImg_) return;
    // Image scale animation
    lv_anim_t anim;
    lv_anim_init(&anim);
    lv_anim_set_var(&anim, introAnimImg_);
    lv_anim_set_values(&anim, introStartScale_, introTargetScale_);
    lv_anim_set_duration(&anim, 500);
    lv_anim_set_delay(&anim, introDelayMs_);
    lv_anim_set_path_cb(&anim, lv_anim_path_ease_out);
    lv_anim_set_exec_cb(&anim, introScaleAnimCb);
    lv_anim_start(&anim);

    // Image position X animation
    if (introTargetImgX_ != 0) {
        lv_anim_t xAnim;
        lv_anim_init(&xAnim);
        lv_anim_set_var(&xAnim, introAnimImg_);
        lv_anim_set_values(&xAnim, 0, introTargetImgX_);
        lv_anim_set_duration(&xAnim, 500);
        lv_anim_set_delay(&xAnim, introDelayMs_);
        lv_anim_set_path_cb(&xAnim, lv_anim_path_ease_out);
        lv_anim_set_exec_cb(&xAnim, introImgXAnimCb);
        lv_anim_start(&xAnim);
    }
    // Image position Y animation
    if (introTargetImgY_ != 0) {
        lv_anim_t yAnim;
        lv_anim_init(&yAnim);
        lv_anim_set_var(&yAnim, introAnimImg_);
        lv_anim_set_values(&yAnim, 0, introTargetImgY_);
        lv_anim_set_duration(&yAnim, 500);
        lv_anim_set_delay(&yAnim, introDelayMs_);
        lv_anim_set_path_cb(&yAnim, lv_anim_path_ease_out);
        lv_anim_set_exec_cb(&yAnim, introImgYAnimCb);
        lv_anim_start(&yAnim);
    }
}

void LvglDisplayNode::onBecomeVisible()
{
    bool wasHidden = widget_ && lv_obj_has_flag(widget_, LV_OBJ_FLAG_HIDDEN);

    if (wasHidden && introContainerMode_ && widget_) {
        // Container mode: set container to start scale
        lv_obj_set_style_transform_scale_x(widget_, introStartScale_, 0);
        lv_obj_set_style_transform_scale_y(widget_, introStartScale_, 0);
        if (introContainerYAnim_) {
            lv_obj_set_y(widget_, introContainerStartY_);
        }
        if (introContainerXAnim_) {
            lv_obj_set_x(widget_, introContainerStartX_);
        }
    } else if (wasHidden && introAnimImg_) {
        lv_image_set_scale(introAnimImg_, introStartScale_);
        if (introTargetImgX_ != 0 || introTargetImgY_ != 0) {
            lv_obj_set_pos(introAnimImg_, 0, 0);
        }
        if (introAnimLabel_) {
            int labelStartScale = introStartScale_ * 256 / introTargetScale_;
            lv_obj_set_style_transform_scale_x(introAnimLabel_, labelStartScale, 0);
            lv_obj_set_style_transform_scale_y(introAnimLabel_, labelStartScale, 0);
            lv_obj_set_style_translate_x(introAnimLabel_, 0, 0);
            lv_obj_set_style_translate_y(introAnimLabel_, 0, 0);
        }
    }

    if (widget_ && lv_obj_has_flag(widget_, LV_OBJ_FLAG_HIDDEN))
    {
        lv_obj_remove_flag(widget_, LV_OBJ_FLAG_HIDDEN);
    }

    if (wasHidden && (introContainerMode_ || introAnimImg_)) {
        playIntroAnim();
    }
}

void LvglDisplayNode::onBecomeInvisible()
{
    if (introContainerMode_ && widget_) {
        lv_anim_delete(widget_, introContainerScaleAnimCb);
        lv_obj_set_style_transform_scale_x(widget_, introTargetScale_, 0);
        lv_obj_set_style_transform_scale_y(widget_, introTargetScale_, 0);
        if (introContainerYAnim_) {
            lv_anim_delete(widget_, introContainerYAnimCb);
            lv_obj_set_y(widget_, introContainerTargetY_);
        }
        if (introContainerXAnim_) {
            lv_anim_delete(widget_, introContainerXAnimCb);
            lv_obj_set_x(widget_, introContainerTargetX_);
        }
    } else if (introAnimImg_) {
        lv_anim_delete(introAnimImg_, introScaleAnimCb);
        lv_image_set_scale(introAnimImg_, introTargetScale_);
        lv_anim_delete(introAnimImg_, introImgXAnimCb);
        lv_anim_delete(introAnimImg_, introImgYAnimCb);
        if (introTargetImgX_ != 0) lv_obj_set_x(introAnimImg_, introTargetImgX_);
        if (introTargetImgY_ != 0) lv_obj_set_y(introAnimImg_, introTargetImgY_);
    }
    if (widget_ && !lv_obj_has_flag(widget_, LV_OBJ_FLAG_HIDDEN))
    {
        lv_obj_add_flag(widget_, LV_OBJ_FLAG_HIDDEN);
    }
}

LayersPriorityQ* LvglDisplayNode::getChildren()
{
    return children_;
}

void LvglDisplayNode::setParent(LvglDisplayNode* parent)
{
    parent_ = parent;
}

void LvglDisplayNode::appendChild(LvglDisplayNode* child)
{
    LayersPriorityQ_t* queue = children_->getQueue();

    bool appended = false;
    for (auto it = queue->begin(); it < queue->end(); it++)
    {
        if ((*it)->getLayer() >= child->getLayer())
        {
            queue->insert(it, child);
            appended = true;
            break;
        }
    }
    if (!appended)
    {
        queue->push_back(child);
    }
}

void LvglDisplayNode::handleMutexGroup()
{
    LayersPriorityQ_t* childrenQueue = children_->getQueue();
    if (!childrenQueue || childrenQueue->empty())
    {
        return;
    }

    for (auto it = childrenQueue->begin(); it < childrenQueue->end(); it++)
    {
        static_cast<LvglDisplayNode*>(*it)->activationSemaphore_ = 0;
    }
}

// --- LvglTimedDisplayNode ---
LvglTimedDisplayNode::LvglTimedDisplayNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType, int maxDurationMs)
    : LvglDisplayNode(widget, layer, entityType)
    , maxDurationMs_(maxDurationMs)
    , timer_(nullptr)
{
}

void LvglTimedDisplayNode::timerCb(lv_timer_t* timer)
{
    auto* node = static_cast<LvglTimedDisplayNode*>(lv_timer_get_user_data(timer));
    // Auto-dismiss: deactivate the node (QML: itemActionDeactivate)
    node->deactivate();
    node->onBecomeInvisible();
    node->timer_ = nullptr;
}

void LvglTimedDisplayNode::onBecomeVisible()
{
    bool wasHidden = widget_ && lv_obj_has_flag(widget_, LV_OBJ_FLAG_HIDDEN);
    LvglDisplayNode::onBecomeVisible();

    // Start auto-dismiss timer only on actual visibility change
    if (wasHidden && maxDurationMs_ > 0) {
        if (timer_) {
            lv_timer_delete(timer_);
        }
        timer_ = lv_timer_create(timerCb, maxDurationMs_, this);
        lv_timer_set_repeat_count(timer_, 1);
    }
}

void LvglTimedDisplayNode::onBecomeInvisible()
{
    LvglDisplayNode::onBecomeInvisible();

    if (timer_) {
        lv_timer_delete(timer_);
        timer_ = nullptr;
    }
}

// --- LvglGifDisplayNode ---
LvglGifDisplayNode::LvglGifDisplayNode(lv_obj_t* container, int layer, DISPLAY_ITEM_ID entityType, lv_obj_t* gifWidget)
    : LvglDisplayNode(container, layer, entityType)
    , gifWidget_(gifWidget)
{
    // GIF starts hidden, so pause its timer immediately
    if (gifWidget_) {
        lv_gif_pause(gifWidget_);
    }
}

void LvglGifDisplayNode::onBecomeVisible()
{
    bool wasHidden = widget_ && lv_obj_has_flag(widget_, LV_OBJ_FLAG_HIDDEN);
    LvglDisplayNode::onBecomeVisible();
    if (wasHidden && gifWidget_) {
        lv_gif_resume(gifWidget_);
    }
}

void LvglGifDisplayNode::onBecomeInvisible()
{
    bool wasVisible = widget_ && !lv_obj_has_flag(widget_, LV_OBJ_FLAG_HIDDEN);
    if (wasVisible && gifWidget_) {
        lv_gif_pause(gifWidget_);
    }
    LvglDisplayNode::onBecomeInvisible();
}

// --- LvglAnimatedSignNode ---
// Right-panel constructor: container moves in X
LvglAnimatedSignNode::LvglAnimatedSignNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType,
                                             lv_obj_t* imgWidget, int startScale, int targetScale,
                                             int startX, int targetX, int delayMs)
    : LvglDisplayNode(widget, layer, entityType)
    , imgWidget_(imgWidget)
    , startScale_(startScale)
    , targetScale_(targetScale)
    , startX_(startX)
    , targetX_(targetX)
    , targetImgX_(0)
    , targetImgY_(0)
    , delayMs_(delayMs)
{
}

// Left-panel factory: image moves from (0,0) to (targetImgX, targetImgY) while scaling
LvglAnimatedSignNode* LvglAnimatedSignNode::createLeftPanel(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType,
                                                             lv_obj_t* imgWidget, int startScale, int targetScale,
                                                             int delayMs, int targetImgX, int targetImgY)
{
    auto* node = new LvglAnimatedSignNode(widget, layer, entityType, imgWidget, startScale, targetScale, -1, -1, delayMs);
    node->targetImgX_ = targetImgX;
    node->targetImgY_ = targetImgY;
    return node;
}

void LvglAnimatedSignNode::scaleAnimCb(void* obj, int32_t val)
{
    lv_image_set_scale(static_cast<lv_obj_t*>(obj), val);
}

void LvglAnimatedSignNode::posAnimCb(void* obj, int32_t val)
{
    lv_obj_set_x(static_cast<lv_obj_t*>(obj), val);
}

void LvglAnimatedSignNode::imgXAnimCb(void* obj, int32_t val)
{
    lv_obj_set_x(static_cast<lv_obj_t*>(obj), val);
}

void LvglAnimatedSignNode::imgYAnimCb(void* obj, int32_t val)
{
    lv_obj_set_y(static_cast<lv_obj_t*>(obj), val);
}

void LvglAnimatedSignNode::onBecomeVisible()
{
    bool wasHidden = widget_ && lv_obj_has_flag(widget_, LV_OBJ_FLAG_HIDDEN);

    if (wasHidden && imgWidget_) {
        lv_image_set_scale(imgWidget_, startScale_);
    }
    if (wasHidden && startX_ >= 0 && widget_) {
        lv_obj_set_x(widget_, startX_);
    }
    // Left-panel mode: set image to start position (0,0)
    if (wasHidden && (targetImgX_ != 0 || targetImgY_ != 0) && imgWidget_) {
        lv_obj_set_pos(imgWidget_, 0, 0);
    }

    LvglDisplayNode::onBecomeVisible();

    if (wasHidden && imgWidget_) {
        // Scale animation
        lv_anim_t anim;
        lv_anim_init(&anim);
        lv_anim_set_var(&anim, imgWidget_);
        lv_anim_set_values(&anim, startScale_, targetScale_);
        lv_anim_set_duration(&anim, 500);
        lv_anim_set_delay(&anim, delayMs_);
        lv_anim_set_path_cb(&anim, lv_anim_path_ease_out);
        lv_anim_set_exec_cb(&anim, scaleAnimCb);
        lv_anim_start(&anim);
    }
    // Right-panel mode: container X animation
    if (wasHidden && startX_ >= 0 && targetX_ >= 0 && widget_) {
        lv_anim_t posAnim;
        lv_anim_init(&posAnim);
        lv_anim_set_var(&posAnim, widget_);
        lv_anim_set_values(&posAnim, startX_, targetX_);
        lv_anim_set_duration(&posAnim, 500);
        lv_anim_set_delay(&posAnim, delayMs_);
        lv_anim_set_path_cb(&posAnim, lv_anim_path_ease_out);
        lv_anim_set_exec_cb(&posAnim, posAnimCb);
        lv_anim_start(&posAnim);
    }
    // Left-panel mode: image X/Y offset animation
    if (wasHidden && imgWidget_) {
        if (targetImgX_ != 0) {
            lv_anim_t xAnim;
            lv_anim_init(&xAnim);
            lv_anim_set_var(&xAnim, imgWidget_);
            lv_anim_set_values(&xAnim, 0, targetImgX_);
            lv_anim_set_duration(&xAnim, 500);
            lv_anim_set_delay(&xAnim, delayMs_);
            lv_anim_set_path_cb(&xAnim, lv_anim_path_ease_out);
            lv_anim_set_exec_cb(&xAnim, imgXAnimCb);
            lv_anim_start(&xAnim);
        }
        if (targetImgY_ != 0) {
            lv_anim_t yAnim;
            lv_anim_init(&yAnim);
            lv_anim_set_var(&yAnim, imgWidget_);
            lv_anim_set_values(&yAnim, 0, targetImgY_);
            lv_anim_set_duration(&yAnim, 500);
            lv_anim_set_delay(&yAnim, delayMs_);
            lv_anim_set_path_cb(&yAnim, lv_anim_path_ease_out);
            lv_anim_set_exec_cb(&yAnim, imgYAnimCb);
            lv_anim_start(&yAnim);
        }
    }
}

void LvglAnimatedSignNode::onBecomeInvisible()
{
    if (imgWidget_) {
        lv_anim_delete(imgWidget_, scaleAnimCb);
        lv_image_set_scale(imgWidget_, targetScale_);
        // Clean up image position animations
        lv_anim_delete(imgWidget_, imgXAnimCb);
        lv_anim_delete(imgWidget_, imgYAnimCb);
        if (targetImgX_ != 0) lv_obj_set_x(imgWidget_, targetImgX_);
        if (targetImgY_ != 0) lv_obj_set_y(imgWidget_, targetImgY_);
    }
    if (startX_ >= 0 && widget_) {
        lv_anim_delete(widget_, posAnimCb);
        if (targetX_ >= 0) lv_obj_set_x(widget_, targetX_);
    }
    LvglDisplayNode::onBecomeInvisible();
}
