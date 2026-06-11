#ifndef LVGL_SCENE_LOADER_H
#define LVGL_SCENE_LOADER_H

#include "lvgl.h"

#include <map>
#include <string>

class LvglDisplayNode;
class LvglMenuController;

// Data-driven scene loader.
//
// Reads configs/scene.json and instantiates display-tree nodes and attaches
// them under named parent groups exposed by buildDisplayTree(). This is what
// lets a whole new alert/indicator be added by configuration alone (graphic
// item + CAN binding + image + placement), with no recompile — and, as the
// migration proceeds, it is also where the existing display tree's node
// assembly lives (moved out of buildDisplayTree).
//
// Two ways to give a leaf node its widget:
//   * "widget":{"factory":...}  -> the loader builds the widget via an
//     LvglWidgets factory (geometry owned by C++; used for migrated sign panels)
//   * "widget_id":"<id>"        -> the node binds to a widget that
//     buildDisplayTree created and registered in the `widgets` map (keeps the
//     original widget creation order, hence z-order, intact)
//   * inline image ("src")      -> a plain lv_image is created
namespace LvglScene {

struct Result {
    // id -> node, for every node that declared an "id" (used by the
    // post-traversal glue in LvglMainProcess to find migrated nodes).
    std::map<std::string, LvglDisplayNode*> nodes;
};

// Build config-defined nodes and attach them to the supplied parent groups.
//   rootWidget : LVGL parent for widgets the loader creates itself.
//   parents    : name -> existing display node (parent lookup + id seed).
//   widgets    : id -> pre-created widget, referenced by "widget_id".
//   menu       : menu controller, for menu-backed node types.
// Safe no-op if configs/scene.json is absent or empty.
Result loadInto(lv_obj_t* rootWidget,
                const std::map<std::string, LvglDisplayNode*>& parents,
                const std::map<std::string, lv_obj_t*>& widgets,
                LvglMenuController* menu);

} // namespace LvglScene

#endif // LVGL_SCENE_LOADER_H
