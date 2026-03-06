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

#endif // LVGL_MENU_DISPLAY_NODE_H
