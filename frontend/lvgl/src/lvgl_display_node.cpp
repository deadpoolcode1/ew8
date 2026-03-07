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

void LvglDisplayNode::onBecomeVisible()
{
    if (widget_ && lv_obj_has_flag(widget_, LV_OBJ_FLAG_HIDDEN))
    {
        lv_obj_remove_flag(widget_, LV_OBJ_FLAG_HIDDEN);
    }
}

void LvglDisplayNode::onBecomeInvisible()
{
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
