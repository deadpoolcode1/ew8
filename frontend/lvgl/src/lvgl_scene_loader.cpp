#include "lvgl_scene_loader.h"

#include "lvgl_display_node.h"
#include "lvgl_blink_display_node.h"
#include "lvgl_value_display_node.h"
#include "lvgl_string_display_node.h"
#include "lvgl_hmw_state_node.h"
#include "lvgl_menu_display_node.h"
#include "lvgl_test_display_node.h"
#include "lvgl_widgets.h"
#include "graphicitemsenummap.h"
#include "alerttypes_core.h"

#include "core/core.h"
#include "core/file_utils.h"
#include "core/json.h"
#include "core/resource_paths.h"

#include <vector>
#include <deque>

namespace {

// Some node constructors store a raw `const char*` without copying (e.g.
// LvglHmwStateNode::gifSrc_). JSON-derived std::strings are temporaries, so we
// keep program-lifetime copies here and hand out stable c_str() pointers.
const char* persistentCStr(const std::string& s)
{
    static std::deque<std::string> store;  // stable addresses across growth
    store.push_back(s);
    return store.back().c_str();
}

const core::JsonObject& sceneRoot()
{
    static const core::JsonObject root = []() -> core::JsonObject {
        const std::string path = core::resourceBaseDir() + "configs/scene.json";
        core::File f(path);
        if (!f.exists() || !f.open(core::File::ReadOnly)) {
            coreDebug() << "scene.json not found at" << path << "(no extra nodes)";
            return core::JsonObject();
        }
        core::JsonParseError err;
        core::JsonDocument doc = core::JsonDocument::fromJson(f.readAll(), &err);
        f.close();
        if (core::JsonParseError::NoError != err.error()) {
            coreDebug() << "scene.json parse error:" << err.errorString();
            return core::JsonObject();
        }
        return doc.object();
    }();
    return root;
}

lv_align_t alignByName(const std::string& name)
{
    static const std::map<std::string, lv_align_t> m = {
        {"top_left", LV_ALIGN_TOP_LEFT},       {"top_mid", LV_ALIGN_TOP_MID},
        {"top_right", LV_ALIGN_TOP_RIGHT},     {"left_mid", LV_ALIGN_LEFT_MID},
        {"center", LV_ALIGN_CENTER},           {"right_mid", LV_ALIGN_RIGHT_MID},
        {"bottom_left", LV_ALIGN_BOTTOM_LEFT}, {"bottom_mid", LV_ALIGN_BOTTOM_MID},
        {"bottom_right", LV_ALIGN_BOTTOM_RIGHT},
    };
    auto it = m.find(name);
    return it != m.end() ? it->second : LV_ALIGN_TOP_LEFT;
}

void positionWidget(lv_obj_t* o, const core::JsonObject& e)
{
    if (e.contains("pos")) {
        core::JsonArray p = e["pos"].toArray();
        lv_obj_set_pos(o, p[0].toInt(), p[1].toInt());
        return;
    }
    if (!e.contains("align") && !e.contains("offset")) return;
    int ox = 0, oy = 0;
    if (e.contains("offset")) {
        core::JsonArray off = e["offset"].toArray();
        ox = off[0].toInt();
        oy = off[1].toInt();
    }
    lv_obj_align(o, alignByName(e["align"].toString("top_left")), ox, oy);
}

lv_obj_t* makeImageWidget(lv_obj_t* parent, const core::JsonObject& spec)
{
    lv_obj_t* img = lv_image_create(parent);
    lv_image_set_src(img, spec["src"].toString().c_str());
    if (spec.contains("scale")) lv_image_set_scale(img, spec["scale"].toInt(256));
    if (spec.contains("pivot")) {
        core::JsonArray pv = spec["pivot"].toArray();
        lv_image_set_pivot(img, pv[0].toInt(), pv[1].toInt());
    }
    positionWidget(img, spec);
    lv_obj_add_flag(img, LV_OBJ_FLAG_HIDDEN);
    return img;
}

// State carried through the recursive build.
struct BuildCtx {
    lv_obj_t* rootWidget;
    const std::map<std::string, lv_obj_t*>* widgets;  // id -> pre-created widget
    LvglMenuController* menu;
    std::map<std::string, LvglDisplayNode*> idMap;     // id -> node (seeded with parents)
    std::vector<std::pair<LvglDisplayNode*, core::JsonObject>> built;  // for wiring pass
};

lv_obj_t* widgetById(BuildCtx& ctx, const std::string& id)
{
    if (id.empty() || !ctx.widgets) return nullptr;
    auto it = ctx.widgets->find(id);
    if (it != ctx.widgets->end()) return it->second;
    coreDebug() << "scene.json: unknown widget_id" << id.c_str();
    return nullptr;
}

// Resolve the primary widget for a leaf node: by widget_id, by factory, or inline.
lv_obj_t* makeWidget(BuildCtx& ctx, const core::JsonObject& spec)
{
    if (spec.contains("widget_id"))
        return widgetById(ctx, spec["widget_id"].toString());
    if (spec.contains("widget")) {
        core::JsonObject w = spec["widget"].toObject();
        const std::string fac = w["factory"].toString();
        const std::string src = w["src"].toString();
        const bool upper = w["upper"].toBool(true);
        if (fac == "left_panel_sign")
            return LvglWidgets::createLeftPanelSign(ctx.rootWidget, src.c_str(), upper);
        if (fac == "right_panel_sign")
            return LvglWidgets::createRightPanelSign(ctx.rootWidget, src.c_str(), upper);
        coreDebug() << "scene.json: unknown widget factory" << fac.c_str();
        return nullptr;
    }
    if (spec.contains("src"))
        return makeImageWidget(ctx.rootWidget, spec);
    return nullptr;
}

// A value/speed/string node may carry its text label either inline (factory
// speed_limit_sign builds it) or by id.
lv_obj_t* makeWidgetWithLabel(BuildCtx& ctx, const core::JsonObject& spec, lv_obj_t** label)
{
    *label = nullptr;
    if (spec.contains("widget") &&
        spec["widget"].toObject()["factory"].toString() == "speed_limit_sign") {
        core::JsonObject w = spec["widget"].toObject();
        return LvglWidgets::createSpeedLimitSign(ctx.rootWidget, w["src"].toString().c_str(),
                                                 w["upper"].toBool(true), label);
    }
    if (spec.contains("label_id")) *label = widgetById(ctx, spec["label_id"].toString());
    return makeWidget(ctx, spec);
}

void applyIntroAnim(LvglDisplayNode* node, const core::JsonObject& spec)
{
    if (spec.contains("intro_anim")) {
        core::JsonObject a = spec["intro_anim"].toObject();
        node->setContainerIntroAnim(a["start"].toInt(256), a["target"].toInt(256), a["delay"].toInt(0));
    }
    if (spec.contains("intro_x")) {
        core::JsonObject a = spec["intro_x"].toObject();
        node->setContainerIntroXAnim(a["start"].toInt(0), a["target"].toInt(0));
    }
    if (spec.contains("intro_y")) {
        core::JsonObject a = spec["intro_y"].toObject();
        node->setContainerIntroYAnim(a["start"].toInt(0), a["target"].toInt(0));
    }
    if (spec.contains("move_to_front"))
        node->setMoveToFrontOnShow(spec["move_to_front"].toBool());
}

DISPLAY_ITEM_ID entityOf(const core::JsonObject& spec)
{
    if (!spec.contains("graphic_item")) return (DISPLAY_ITEM_ID)AlertTypes::ALERT_NONE;
    const std::string gi = spec["graphic_item"].toString();
    // Built-in core alert types that aren't in the GraphicItems table.
    if (gi == "ALERT_NOCOM") return (DISPLAY_ITEM_ID)AlertTypes::ALERT_NOCOM;
    DISPLAY_ITEM_ID id = GraphicItemsEnumMap::getId(gi);
    if (id == (DISPLAY_ITEM_ID)AlertTypes::ALERT_NONE)
        coreDebug() << "scene.json: unknown graphic_item" << gi.c_str();
    return id;
}

// Construct the node object for a leaf/group spec (no parenting yet).
LvglDisplayNode* makeNode(BuildCtx& ctx, const core::JsonObject& spec)
{
    const std::string type = spec["type"].toString();
    const int layer = spec["layer"].toInt(0);
    const DISPLAY_ITEM_ID e = entityOf(spec);

    if (type == "group")
        return new LvglDisplayNode(nullptr, layer, spec["mutex"].toBool(false), spec["mode"].toBool(false));
    if (type == "dummy")
        return new LvglDisplayNode(nullptr, layer, e);
    if (type == "image") {
        if (spec.contains("mode"))  // modeGroup leaf (test-screen panels)
            return new LvglDisplayNode(makeWidget(ctx, spec), layer, e, spec["mode"].toBool());
        return new LvglDisplayNode(makeWidget(ctx, spec), layer, e);
    }
    if (type == "blink")
        return new LvglBlinkDisplayNode(makeWidget(ctx, spec), layer, e);
    if (type == "timed")
        return new LvglTimedDisplayNode(makeWidget(ctx, spec), layer, e, spec["max_duration_ms"].toInt(5000));
    if (type == "value") {
        lv_obj_t* label = nullptr;
        lv_obj_t* w = makeWidgetWithLabel(ctx, spec, &label);
        return new LvglValueDisplayNode(w, layer, e, label, spec["divisor"].toInt(0));
    }
    if (type == "string")
        return new LvglStringDisplayNode(makeWidget(ctx, spec), layer, e,
                                         widgetById(ctx, spec["label_id"].toString()));
    if (type == "speed")
        return new LvglSpeedDisplayNode(makeWidget(ctx, spec), layer, e,
                                        widgetById(ctx, spec["value_label_id"].toString()),
                                        widgetById(ctx, spec["unit_label_id"].toString()));
    if (type == "error")
        return new LvglErrorDisplayNode(makeWidget(ctx, spec), layer, e,
                                        widgetById(ctx, spec["code_label_id"].toString()));
    if (type == "gif")
        return new LvglGifDisplayNode(makeWidget(ctx, spec), layer, e,
                                      widgetById(ctx, spec["gif_id"].toString()));
    if (type == "hmw_state")
        return new LvglHmwStateNode(layer, e,
                                    widgetById(ctx, spec["road_strip_id"].toString()),
                                    persistentCStr(spec["gif_src"].toString()),
                                    widgetById(ctx, spec["forward_car_id"].toString()),
                                    spec["car_margin"].toInt(40),
                                    spec["car_scale_x"].toInt(192),
                                    spec["car_scale_y"].toInt(192));
    if (type == "supp_sign")
        return new LvglSuppSignNode(makeWidget(ctx, spec), layer, e,
                                    widgetById(ctx, spec["supp_img_id"].toString()),
                                    spec.contains("label_id") ? widgetById(ctx, spec["label_id"].toString()) : nullptr);
    if (type == "shape_usa")
        return new LvglShapeUsaNode(layer, e,
                                    widgetById(ctx, spec["sli_sign_img_id"].toString()),
                                    widgetById(ctx, spec["sli_supp_sign_img_id"].toString()),
                                    spec.contains("sli_speed_label_id") ? widgetById(ctx, spec["sli_speed_label_id"].toString()) : nullptr);
    if (type == "overspeed")
        return new LvglOverspeedBlinkNode(layer, e,
                                          widgetById(ctx, spec["sli_widget_id"].toString()),
                                          widgetById(ctx, spec["isa_speed_widget_id"].toString()));
    if (type == "isa_state")
        return new LvglIsaStateNode(layer, e, ctx.menu);
    if (type == "tsr_state")
        return new LvglTsrStateNode(layer, e, ctx.menu);
    if (type == "volume_done")
        return new LvglVolumeDoneNode(layer, e, ctx.menu);
    if (type == "volume_fail")
        return new LvglVolumeFailNode(layer, e, ctx.menu);
    if (type == "qrcode")
        return new LvglQRCodeNode(layer, e, ctx.menu);
    if (type == "signal_test_item")
        return new LvglSignalTestItemNode(widgetById(ctx, spec["small_img_id"].toString()),
                                          widgetById(ctx, spec["big_img_id"].toString()),
                                          layer, e, spec["wildcard"].toString().c_str());
    if (type == "signal_test_speed")
        return new LvglSignalTestSpeedNode(widgetById(ctx, spec["small_img_id"].toString()),
                                           widgetById(ctx, spec["big_img_id"].toString()),
                                           widgetById(ctx, spec["small_label_id"].toString()),
                                           widgetById(ctx, spec["big_label_id"].toString()),
                                           layer, e);
    if (type == "peripheral_test_group") {
        std::vector<PeripheralSubItem> items;
        core::JsonArray arr = spec["items"].toArray();
        for (int i = 0; i < arr.size(); ++i) {
            core::JsonObject it = arr[i].toObject();
            items.push_back({widgetById(ctx, it["icon_id"].toString()),
                             it["wildcard"].toString(),
                             it["range_left"].toInt(), it["range_right"].toInt()});
        }
        return new LvglPeripheralTestGroupNode(widgetById(ctx, spec["container_id"].toString()),
                                               layer, e, items,
                                               widgetById(ctx, spec["result_id"].toString()));
    }
    coreDebug() << "scene.json: unknown node type" << type.c_str();
    return nullptr;
}

void buildNode(BuildCtx& ctx, const core::JsonObject& spec, LvglDisplayNode* parent)
{
    LvglDisplayNode* node = makeNode(ctx, spec);
    if (!node) return;

    applyIntroAnim(node, spec);

    if (parent) {
        node->setParent(parent);
        parent->appendChild(node);
    }
    if (spec.contains("id")) ctx.idMap[spec["id"].toString()] = node;
    ctx.built.emplace_back(node, spec);

    if (spec.contains("children")) {
        core::JsonArray kids = spec["children"].toArray();
        for (int i = 0; i < kids.size(); ++i)
            buildNode(ctx, kids[i].toObject(), node);
    }
}

// Resolve a node reference (by id) to a built/seed node, or nullptr.
LvglDisplayNode* nodeRef(BuildCtx& ctx, const core::JsonObject& spec, const char* key)
{
    if (!spec.contains(key)) return nullptr;
    const std::string id = spec[key].toString();
    auto it = ctx.idMap.find(id);
    if (it != ctx.idMap.end()) return it->second;
    coreDebug() << "scene.json: unknown node ref" << key << "->" << id.c_str();
    return nullptr;
}

// Second pass: type-specific cross-references that can't be set at construction
// because the referenced node may be built later in the file.
void wireNode(BuildCtx& ctx, LvglDisplayNode* node, const core::JsonObject& spec)
{
    if (auto* blk = nodeRef(ctx, spec, "blocked_by")) node->setBlockingNode(blk);

    if (auto* su = dynamic_cast<LvglShapeUsaNode*>(node)) {
        if (auto* sli = nodeRef(ctx, spec, "sli_node")) su->setSliNode(sli);
    }
    if (auto* val = dynamic_cast<LvglValueDisplayNode*>(node)) {
        if (auto* su = nodeRef(ctx, spec, "shape_usa_node")) val->setShapeUsaNode(su);
    }
    if (auto* sp = dynamic_cast<LvglSpeedDisplayNode*>(node)) {
        if (auto* sh = nodeRef(ctx, spec, "speed_show_node")) sp->setSpeedShowNode(sh);
    }
    if (auto* isa = dynamic_cast<LvglIsaStateNode*>(node)) {
        if (spec.contains("isa_error_widget_id") || spec.contains("isa_inactive_widget_id"))
            isa->setIsaWidgets(widgetById(ctx, spec["isa_error_widget_id"].toString()),
                               widgetById(ctx, spec["isa_inactive_widget_id"].toString()));
        if (spec.contains("isa_speed_node") || spec.contains("isa_highway_node"))
            isa->setIsaSignNodes(nodeRef(ctx, spec, "isa_speed_node"),
                                 nodeRef(ctx, spec, "isa_highway_node"));
        if (auto* inact = nodeRef(ctx, spec, "isa_inactive_node")) isa->setIsaInactiveNode(inact);
    }
}

} // namespace

namespace LvglScene {

Result loadInto(lv_obj_t* rootWidget,
                const std::map<std::string, LvglDisplayNode*>& parents,
                const std::map<std::string, lv_obj_t*>& widgets,
                LvglMenuController* menu)
{
    Result result;
    const core::JsonObject& root = sceneRoot();
    if (!root.contains("nodes")) return result;

    BuildCtx ctx;
    ctx.rootWidget = rootWidget;
    ctx.widgets = &widgets;
    ctx.menu = menu;
    ctx.idMap = parents;  // seed so children can reference existing tree groups

    core::JsonArray nodes = root["nodes"].toArray();
    for (int i = 0; i < nodes.size(); ++i) {
        core::JsonObject spec = nodes[i].toObject();
        const std::string parentName = spec["parent"].toString();
        auto it = ctx.idMap.find(parentName);
        if (it == ctx.idMap.end()) {
            coreDebug() << "scene.json: unknown parent" << parentName.c_str() << "- skipping node" << i;
            continue;
        }
        buildNode(ctx, spec, it->second);
    }

    // Cross-reference wiring pass.
    for (auto& nb : ctx.built) wireNode(ctx, nb.first, nb.second);

    result.nodes = ctx.idMap;
    coreDebug() << "scene.json: built" << (int)ctx.built.size() << "config nodes";
    return result;
}

} // namespace LvglScene
