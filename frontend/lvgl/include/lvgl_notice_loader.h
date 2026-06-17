#ifndef LVGL_NOTICE_LOADER_H
#define LVGL_NOTICE_LOADER_H

#include "lvgl.h"
#include <map>
#include <string>

// Data-driven loader for the "notice" overlay screens (disconnect, failsafe,
// error, operation-mode messages). Layout/text/colour/images come from
// configs/notices.json so they can be edited without recompiling — only the
// display-tree wiring and behaviour stay in C++.
namespace LvglNotice {

// Build a notice overlay from configs/notices.json by key. Returns the
// container (full-screen, hidden by default), or nullptr if the key is absent
// or the file failed to parse. Elements that carry an "id" are placed in
// `named` (id -> object) so callers can keep updating them at runtime
// (e.g. the error overlay's dynamic error-code label).
lv_obj_t* createNoticeFromConfig(lv_obj_t* parent, const char* key,
                                 std::map<std::string, lv_obj_t*>* named = nullptr);

} // namespace LvglNotice

#endif // LVGL_NOTICE_LOADER_H
