#include "lvgl_notice_loader.h"

#include "core/core.h"
#include "core/file_utils.h"
#include "core/json.h"
#include "core/resource_paths.h"

#include <cstdint>
#include <cstdlib>

// Fonts are compiled-in symbols; the JSON references them by name via the
// registry below. To use a brand-new size, add the compiled font here.
LV_FONT_DECLARE(intelone_bold_18);
LV_FONT_DECLARE(intelone_bold_20);
LV_FONT_DECLARE(intelone_medium_14);
LV_FONT_DECLARE(intelone_medium_17);
LV_FONT_DECLARE(intelone_medium_20);
LV_FONT_DECLARE(intelone_medium_22);
LV_FONT_DECLARE(intelone_medium_24);
LV_FONT_DECLARE(intelone_medium_28);
LV_FONT_DECLARE(intelone_medium_36);
LV_FONT_DECLARE(intelone_medium_44);

namespace {

constexpr int kDisplayWidth = 320;
constexpr int kDisplayHeight = 240;

// Parse the notices file once and cache the root object.
const core::JsonObject& noticesRoot()
{
    static const core::JsonObject root = []() -> core::JsonObject {
        const std::string path = core::resourceBaseDir() + "configs/notices.json";
        core::File f(path);
        if (!f.exists() || !f.open(core::File::ReadOnly)) {
            coreDebug() << "notices.json not found at" << path;
            return core::JsonObject();
        }
        core::JsonParseError err;
        core::JsonDocument doc = core::JsonDocument::fromJson(f.readAll(), &err);
        f.close();
        if (core::JsonParseError::NoError != err.error()) {
            coreDebug() << "notices.json parse error:" << err.errorString();
            return core::JsonObject();
        }
        return doc.object();
    }();
    return root;
}

const lv_font_t* fontByName(const std::string& name, const lv_font_t* fallback)
{
    static const std::map<std::string, const lv_font_t*> registry = {
        {"intelone_bold_18", &intelone_bold_18},
        {"intelone_bold_20", &intelone_bold_20},
        {"intelone_medium_14", &intelone_medium_14},
        {"intelone_medium_17", &intelone_medium_17},
        {"intelone_medium_20", &intelone_medium_20},
        {"intelone_medium_22", &intelone_medium_22},
        {"intelone_medium_24", &intelone_medium_24},
        {"intelone_medium_28", &intelone_medium_28},
        {"intelone_medium_36", &intelone_medium_36},
        {"intelone_medium_44", &intelone_medium_44},
    };
    auto it = registry.find(name);
    if (it != registry.end()) return it->second;
    if (!name.empty()) coreDebug() << "notices.json unknown font:" << name;
    return fallback;
}

// "#rrggbb" / "rrggbb" -> 0xrrggbb. Returns true on success.
bool parseColor(const std::string& s, uint32_t* out)
{
    std::string hex = s;
    if (!hex.empty() && hex[0] == '#') hex = hex.substr(1);
    if (hex.size() != 6) return false;
    char* end = nullptr;
    unsigned long v = std::strtoul(hex.c_str(), &end, 16);
    if (end == hex.c_str() || *end != '\0') return false;
    *out = static_cast<uint32_t>(v);
    return true;
}

lv_align_t alignByName(const std::string& name)
{
    static const std::map<std::string, lv_align_t> m = {
        {"top_left", LV_ALIGN_TOP_LEFT},     {"top_mid", LV_ALIGN_TOP_MID},
        {"top_right", LV_ALIGN_TOP_RIGHT},   {"left_mid", LV_ALIGN_LEFT_MID},
        {"center", LV_ALIGN_CENTER},         {"right_mid", LV_ALIGN_RIGHT_MID},
        {"bottom_left", LV_ALIGN_BOTTOM_LEFT}, {"bottom_mid", LV_ALIGN_BOTTOM_MID},
        {"bottom_right", LV_ALIGN_BOTTOM_RIGHT},
    };
    auto it = m.find(name);
    return it != m.end() ? it->second : LV_ALIGN_TOP_LEFT;
}

// Position an element either absolutely ("pos":[x,y]) or by alignment
// ("align":"center","offset":[x,y]). Mirrors the lv_obj_set_pos / lv_obj_align
// calls of the original hand-written overlays.
void positionElement(lv_obj_t* o, const core::JsonObject& e)
{
    if (e.contains("pos")) {
        core::JsonArray p = e["pos"].toArray();
        lv_obj_set_pos(o, p[0].toInt(), p[1].toInt());
        return;
    }
    int ox = 0, oy = 0;
    if (e.contains("offset")) {
        core::JsonArray off = e["offset"].toArray();
        ox = off[0].toInt();
        oy = off[1].toInt();
    }
    lv_obj_align(o, alignByName(e["align"].toString("top_left")), ox, oy);
}

} // namespace

namespace LvglNotice {

lv_obj_t* createNoticeFromConfig(lv_obj_t* parent, const char* key,
                                 std::map<std::string, lv_obj_t*>* named)
{
    const core::JsonObject& root = noticesRoot();
    if (!root.contains(key)) {
        coreDebug() << "notices.json missing key:" << key;
        return nullptr;
    }
    core::JsonObject spec = root[key].toObject();

    // Full-screen container, hidden by default. Background is transparent
    // unless "background" is a colour (then it covers opaquely, like the
    // disconnect overlay's solid black).
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_set_size(cont, kDisplayWidth, kDisplayHeight);
    lv_obj_set_pos(cont, 0, 0);
    lv_obj_set_style_border_width(cont, 0, 0);
    lv_obj_set_style_pad_all(cont, 0, 0);
    lv_obj_set_style_radius(cont, 0, 0);
    lv_obj_remove_flag(cont, LV_OBJ_FLAG_SCROLLABLE);

    uint32_t bg = 0;
    if (spec.contains("background") && parseColor(spec["background"].toString(), &bg)) {
        lv_obj_set_style_bg_color(cont, lv_color_hex(bg), 0);
        lv_obj_set_style_bg_opa(cont, LV_OPA_COVER, 0);
    } else {
        lv_obj_set_style_bg_opa(cont, LV_OPA_TRANSP, 0);
    }
    lv_obj_add_flag(cont, LV_OBJ_FLAG_HIDDEN);

    core::JsonArray elements = spec["elements"].toArray();
    for (int i = 0; i < elements.size(); ++i) {
        core::JsonObject e = elements[i].toObject();
        const std::string type = e["type"].toString();
        lv_obj_t* o = nullptr;

        if (type == "image") {
            o = lv_image_create(cont);
            lv_image_set_src(o, e["src"].toString().c_str());
            if (e.contains("scale")) lv_image_set_scale(o, e["scale"].toInt(256));
            if (e.contains("pivot")) {
                core::JsonArray pv = e["pivot"].toArray();
                lv_image_set_pivot(o, pv[0].toInt(), pv[1].toInt());
            }
        } else if (type == "label") {
            o = lv_label_create(cont);
            lv_label_set_text(o, e["text"].toString().c_str());
            lv_obj_set_style_text_font(
                o, fontByName(e["font"].toString(), &intelone_bold_20), 0);
            uint32_t col = 0xffffff;
            parseColor(e["color"].toString("#ffffff"), &col);
            lv_obj_set_style_text_color(o, lv_color_hex(col), 0);
        } else {
            coreDebug() << "notices.json unknown element type:" << type;
            continue;
        }

        positionElement(o, e);

        if (named && e.contains("id")) {
            (*named)[e["id"].toString()] = o;
        }
    }

    return cont;
}

} // namespace LvglNotice
