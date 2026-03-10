#ifndef LVGL_MENU_DISPLAY_NODE_H
#define LVGL_MENU_DISPLAY_NODE_H

#include "lvgl_display_node.h"

class LvglMenuController;

// Display node that forwards VOLUME_DONE activation to menu controller
class LvglVolumeDoneNode : public LvglDisplayNode {
public:
    LvglVolumeDoneNode(int layer, DISPLAY_ITEM_ID entityType, LvglMenuController* ctrl);
    void onBecomeVisible() override;
    void onBecomeInvisible() override;
private:
    LvglMenuController* ctrl_;
};

// Display node that forwards VOLUME_FAIL activation to menu controller
class LvglVolumeFailNode : public LvglDisplayNode {
public:
    LvglVolumeFailNode(int layer, DISPLAY_ITEM_ID entityType, LvglMenuController* ctrl);
    void onBecomeVisible() override;
    void onBecomeInvisible() override;
private:
    LvglMenuController* ctrl_;
};

// Display node that forwards INFO_QRCODE activation to menu controller
class LvglQRCodeNode : public LvglDisplayNode {
public:
    LvglQRCodeNode(int layer, DISPLAY_ITEM_ID entityType, LvglMenuController* ctrl);
    void onBecomeVisible() override;
    void onBecomeInvisible() override;
private:
    LvglMenuController* ctrl_;
};

// Display node for supplementary signs — changes image based on CAN arg value
// For SLI_SUPP: valueInt_ = speed value, valueFrac_ = supp type
class LvglSuppSignNode : public LvglDisplayNode {
public:
    LvglSuppSignNode(lv_obj_t* widget, int layer, DISPLAY_ITEM_ID entityType,
                     lv_obj_t* suppImg, lv_obj_t* speedLabel = nullptr);
    void onBecomeVisible() override;
private:
    lv_obj_t* suppImg_;
    lv_obj_t* speedLabel_;
    static const char* getSuppImagePath(int suppValue);
};

// Display node for SHAPE_USA — switches SLI sign between circular and rectangular
class LvglShapeUsaNode : public LvglDisplayNode {
public:
    LvglShapeUsaNode(int layer, DISPLAY_ITEM_ID entityType,
                     lv_obj_t* sliSignImg, lv_obj_t* sliSuppSignImg,
                     lv_obj_t* sliSpeedLabel = nullptr);
    void setSliNode(LvglDisplayNode* node) { sliNode_ = node; }
    void onBecomeVisible() override;
    void onBecomeInvisible() override;
private:
    lv_obj_t* sliSignImg_;
    lv_obj_t* sliSuppSignImg_;
    lv_obj_t* sliSpeedLabel_;
    LvglDisplayNode* sliNode_ = nullptr;
    bool wasUsaActive_ = false;
};

// Display node for ALERT_ISA_OVERSPEED — blinks SLI/ISA speed signs when active
class LvglOverspeedBlinkNode : public LvglDisplayNode {
public:
    LvglOverspeedBlinkNode(int layer, DISPLAY_ITEM_ID entityType,
                           lv_obj_t* sliWidget, lv_obj_t* isaSpeedWidget);
    void onBecomeVisible() override;
    void onBecomeInvisible() override;
private:
    lv_obj_t* sliWidget_;
    lv_obj_t* isaSpeedWidget_;
    bool blinking_ = false;
    static void blinkAnimCb(void* obj, int32_t val);
    void startBlink(lv_obj_t* widget);
    void stopBlink(lv_obj_t* widget);
};

// Display node for STATE_ISA_NOT_TSR — notifies menu controller of ISA availability
// QML: on first activation, forces ALERT_ISA_ERROR icon visible for 1000ms ("isa_init" state)
class LvglIsaStateNode : public LvglDisplayNode {
public:
    LvglIsaStateNode(int layer, DISPLAY_ITEM_ID entityType, LvglMenuController* ctrl);
    void setIsaWidgets(lv_obj_t* errorWidget, lv_obj_t* inactiveWidget) {
        isaErrorWidget_ = errorWidget;
        isaInactiveWidget_ = inactiveWidget;
    }
    void setIsaSignNodes(LvglDisplayNode* isaSpeedNode, LvglDisplayNode* isaHighwayNode) {
        isaSpeedNode_ = isaSpeedNode;
        isaHighwayNode_ = isaHighwayNode;
    }
    void setIsaInactiveNode(LvglDisplayNode* node) { isaInactiveNode_ = node; }
    void onBecomeVisible() override;
    void onBecomeInvisible() override;
private:
    bool shouldShowInitPhase() const;
    static void initTimerCb(lv_timer_t* timer);
    LvglMenuController* ctrl_;
    lv_obj_t* isaErrorWidget_ = nullptr;
    lv_obj_t* isaInactiveWidget_ = nullptr;
    LvglDisplayNode* isaSpeedNode_ = nullptr;
    LvglDisplayNode* isaHighwayNode_ = nullptr;
    LvglDisplayNode* isaInactiveNode_ = nullptr;
    lv_timer_t* initTimer_ = nullptr;
    bool isaInitPhase_ = false;
    bool wasIsaActive_ = false;  // tracks previous visibility for hidden→visible detection
};

// Display node for STATE_TSR_NOT_ISA — notifies menu controller of TSR mode (ISA unavailable)
class LvglTsrStateNode : public LvglDisplayNode {
public:
    LvglTsrStateNode(int layer, DISPLAY_ITEM_ID entityType, LvglMenuController* ctrl);
    void onBecomeVisible() override;
    void onBecomeInvisible() override;
private:
    LvglMenuController* ctrl_;
};

#endif // LVGL_MENU_DISPLAY_NODE_H
