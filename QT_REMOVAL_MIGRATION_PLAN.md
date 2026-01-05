# Qt Removal Migration Plan

## Overview

**Total Files in Codebase**: 264
**Files Using Qt**: 66 (25%)
**Files Without Qt**: 198 (75%)

### Categories
- **BE (Backend)**: Non-graphics, core logic - ~50 files
- **FW (Framework/Frontend)**: Graphics/QML - ~16 files (to be replaced with LVGL)

---

## Migration Order: Easiest → Hardest

---

## Phase 1: TRIVIAL (No changes needed)

### 1.1 Already Qt-Free Code
These files have **zero Qt dependencies** - no migration needed.

| Category | Location | Notes |
|----------|----------|-------|
| BE | `at91bootstrap/` | 100% pure C, embedded bootloader |
| BE | `canupdate/updatecommon/crc32.*` | Pure C |
| BE | `canupdate/updatecommon/sha256.*` | Pure C |
| BE | `canupdate/updatecommon/updatecanprotocol.*` | Pure C |
| BE | `canupdate/updateengine/` | Most files Qt-free |

**Effort**: None
**Risk**: None

---

## Phase 2: EASY (Simple Replacements)

### 2.1 QDebug → Standard Logging
**Difficulty**: ⭐ (Very Easy)

| File | Location | Current | Replacement |
|------|----------|---------|-------------|
| `canupdate/updatecommon/utils.h` | BE | `QDebug` | `printf` / `spdlog` / custom logger |

**Replacement Strategy**:
```cpp
// Before (Qt)
qDebug() << "Message" << value;

// After (C++ standard)
printf("Message %d\n", value);
// OR with spdlog
spdlog::debug("Message {}", value);
```

**Effort**: 1-2 hours
**Risk**: Very Low

---

### 2.2 QElapsedTimer → std::chrono
**Difficulty**: ⭐ (Very Easy)

| File | Location | Current | Replacement |
|------|----------|---------|-------------|
| `canquick/defs.h` | BE | `QElapsedTimer` | `std::chrono::steady_clock` |

**Replacement Strategy**:
```cpp
// Before (Qt)
QElapsedTimer timer;
timer.start();
qint64 elapsed = timer.elapsed();

// After (C++11)
auto start = std::chrono::steady_clock::now();
auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(
    std::chrono::steady_clock::now() - start).count();
```

**Effort**: 30 minutes
**Risk**: Very Low

---

## Phase 3: EASY-MEDIUM (Utility Replacements)

### 3.1 QString → std::string
**Difficulty**: ⭐⭐ (Easy but widespread)

**Affected Files** (40+ files):
| Priority | Files | Location |
|----------|-------|----------|
| 1 | `iamjsonactionfactory.h` | BE |
| 2 | All `*action.h/cpp` files | BE |
| 3 | `canrxmsg.h/cpp` | BE |
| 4 | `amjsonconfigreader.h/cpp` | BE |
| 5 | All other files | BE/FW |

**Replacement Strategy**:
```cpp
// Before (Qt)
QString str = "hello";
QString result = str.arg(value);
bool empty = str.isEmpty();
QByteArray bytes = str.toUtf8();

// After (C++17)
std::string str = "hello";
std::string result = std::format("{}", value); // C++20 or fmt lib
bool empty = str.empty();
std::vector<uint8_t> bytes(str.begin(), str.end());
```

**Helper Functions Needed**:
```cpp
// Create string_utils.h with common operations
std::string format(const char* fmt, ...);
std::vector<std::string> split(const std::string& s, char delim);
std::string trim(const std::string& s);
```

**Effort**: 2-3 days
**Risk**: Low (but tedious)

---

### 3.2 QList/QVector → std::vector
**Difficulty**: ⭐⭐ (Easy)

**Affected Files** (20+ files):
| File | Location |
|------|----------|
| `canrxmsg.h` | BE |
| `canargumentsaccumulator.h/cpp` | BE |
| `canstringargumentsaccumulator.h/cpp` | BE |
| `timedsmoother.h/cpp` | BE |
| `bufferedsmoother.h/cpp` | BE |
| `ismoother.h` | BE |

**Replacement Strategy**:
```cpp
// Before (Qt)
QList<int> list;
QVector<int> vec;
list.append(item);
vec.push_back(item);

// After (C++ STL)
std::vector<int> list;
std::vector<int> vec;
list.push_back(item);
vec.push_back(item);
```

**Effort**: 1-2 days
**Risk**: Low

---

### 3.3 QMap/QHash → std::map/std::unordered_map
**Difficulty**: ⭐⭐ (Easy)

**Affected Files** (15+ files):
| File | Location |
|------|----------|
| `canargumentsaccumulator.h/cpp` | BE |
| `amjsonactionsmultiplexor.h/cpp` | BE |
| `amjsonsignal.h/cpp` | BE |
| `brightnesscontrol.h/cpp` | BE |
| `graphicitemsenummap.h/cpp` | BE |

**Replacement Strategy**:
```cpp
// Before (Qt)
QMap<QString, int> map;
QHash<QString, int> hash;
map.insert(key, value);
hash.contains(key);

// After (C++ STL)
std::map<std::string, int> map;
std::unordered_map<std::string, int> hash;
map[key] = value;  // or map.insert({key, value});
hash.count(key) > 0;  // or hash.find(key) != hash.end();
```

**Effort**: 1-2 days
**Risk**: Low

---

### 3.4 QVariant → std::variant or std::any
**Difficulty**: ⭐⭐ (Easy-Medium)

**Affected Files**:
| File | Location |
|------|----------|
| `rootedtreenode.h/cpp` | BE |

**Replacement Strategy**:
```cpp
// Before (Qt)
QVariant var;
var.setValue(42);
int val = var.toInt();

// After (C++17)
std::any var;
var = 42;
int val = std::any_cast<int>(var);

// OR for known types
std::variant<int, std::string, double> var;
var = 42;
int val = std::get<int>(var);
```

**Effort**: 4-8 hours
**Risk**: Low

---

## Phase 4: MEDIUM (File I/O Replacements)

### 4.1 QFile/QDir/QFileInfo → std::filesystem
**Difficulty**: ⭐⭐⭐ (Medium)

**Affected Files** (12+ files):
| File | Location | Qt Classes Used |
|------|----------|----------------|
| `brightnesscontrol.h/cpp` | BE | QFile, QTextStream |
| `versionmsg.h/cpp` | BE | QFile, QTextStream, QJsonDocument |
| `ewinfo.h/cpp` | BE | QFile, QTextStream |
| `amsignalsmodel.h` | BE | QFile |
| `canrxmsg.cpp` | BE | QSaveFile |
| `main.cpp` | FW | QFile, QDir |

**Replacement Strategy**:
```cpp
// Before (Qt)
QFile file(path);
if (file.open(QIODevice::ReadOnly)) {
    QByteArray data = file.readAll();
}
QDir dir(path);
QStringList files = dir.entryList();

// After (C++17)
#include <filesystem>
#include <fstream>
namespace fs = std::filesystem;

std::ifstream file(path);
std::string content((std::istreambuf_iterator<char>(file)),
                     std::istreambuf_iterator<char>());

for (const auto& entry : fs::directory_iterator(path)) {
    // process entry.path()
}
```

**Effort**: 2-3 days
**Risk**: Medium (need to handle errors properly)

---

### 4.2 QTextStream → std::fstream
**Difficulty**: ⭐⭐⭐ (Medium)

**Same files as 4.1**

```cpp
// Before (Qt)
QTextStream stream(&file);
QString line = stream.readLine();
stream << "output" << endl;

// After (C++ STL)
std::ifstream stream(path);
std::string line;
std::getline(stream, line);
stream << "output" << std::endl;
```

**Effort**: 1-2 days
**Risk**: Low

---

### 4.3 QSettings → Custom Config or INI Parser
**Difficulty**: ⭐⭐⭐ (Medium)

**Affected Files**:
| File | Location |
|------|----------|
| `brightnesscontrol.h/cpp` | BE |

**Replacement Options**:
1. Use `inih` library (lightweight INI parser)
2. Use JSON config (since you already have JSON parsing)
3. Custom simple key-value storage

**Effort**: 4-8 hours
**Risk**: Low

---

### 4.4 QFileSystemWatcher → inotify (Linux)
**Difficulty**: ⭐⭐⭐ (Medium)

**Affected Files**:
| File | Location |
|------|----------|
| `brightnesscontrol.h/cpp` | BE |

**Replacement Strategy**:
```cpp
// Use Linux inotify API directly or libuv/libevent
#include <sys/inotify.h>

int fd = inotify_init();
int wd = inotify_add_watch(fd, path, IN_MODIFY);
// Read events in a thread
```

**Effort**: 1-2 days
**Risk**: Medium (platform-specific)

---

## Phase 5: MEDIUM-HARD (Threading & Timing)

### 5.1 QThread → std::thread
**Difficulty**: ⭐⭐⭐⭐ (Medium-Hard)

**Affected Files**:
| File | Location | Complexity |
|------|----------|------------|
| `mainprocess.h/cpp` | BE | HIGH - Main orchestrator |
| `canmanager.h/cpp` | BE | HIGH - CAN bus manager |
| `medisconnectionreport.h/cpp` | BE | MEDIUM |

**Replacement Strategy**:
```cpp
// Before (Qt)
class Worker : public QThread {
    Q_OBJECT
    void run() override { /* work */ }
signals:
    void resultReady(int result);
};

// After (C++11)
class Worker {
public:
    void start() {
        thread_ = std::thread([this]() { run(); });
    }
    void run() { /* work */ }
    std::function<void(int)> onResultReady;
private:
    std::thread thread_;
};
```

**Effort**: 3-5 days
**Risk**: Medium-High (threading bugs are subtle)

---

### 5.2 QMutex → std::mutex
**Difficulty**: ⭐⭐⭐ (Medium)

**Affected Files**:
| File | Location |
|------|----------|
| `mainprocess.cpp` | BE |
| `canmanager.cpp` | BE |
| `amjsonconfigreader.cpp` | BE |
| `ialertdisplay.h` | BE |

**Replacement Strategy**:
```cpp
// Before (Qt)
QMutex mutex;
QMutexLocker locker(&mutex);

// After (C++11)
std::mutex mutex;
std::lock_guard<std::mutex> locker(mutex);
// OR std::unique_lock for more flexibility
```

**Effort**: 1 day
**Risk**: Low (direct mapping)

---

### 5.3 QTimer → Custom Timer System
**Difficulty**: ⭐⭐⭐⭐ (Medium-Hard)

**Affected Files** (12+ files):
| File | Location |
|------|----------|
| `mainprocess.h/cpp` | BE |
| `canmanager.h/cpp` | BE |
| `smartitem.h/cpp` | BE |
| `timedsmoother.h/cpp` | BE |
| `brightnesscontrol.h/cpp` | BE |
| `medisconnectionreport.h/cpp` | BE |

**Replacement Options**:
1. **Simple approach**: Use `std::thread` with `std::this_thread::sleep_for`
2. **Event loop approach**: Use `libuv` or `libevent`
3. **Custom timer wheel**: For many timers

```cpp
// Custom Timer Class
class Timer {
public:
    void start(int intervalMs, std::function<void()> callback) {
        running_ = true;
        thread_ = std::thread([=]() {
            while (running_) {
                std::this_thread::sleep_for(std::chrono::milliseconds(intervalMs));
                if (running_) callback();
            }
        });
    }
    void stop() { running_ = false; if (thread_.joinable()) thread_.join(); }
private:
    std::atomic<bool> running_{false};
    std::thread thread_;
};
```

**Effort**: 3-5 days
**Risk**: Medium (need to handle edge cases)

---

## Phase 6: HARD (JSON & Serialization)

### 6.1 QJsonDocument → nlohmann/json or RapidJSON
**Difficulty**: ⭐⭐⭐⭐ (Hard)

**Affected Files** (10+ files):
| File | Location | Complexity |
|------|----------|------------|
| `amjsonconfigreader.h/cpp` | BE | HIGH - Main config |
| `amsignalsmodel.h` | BE | MEDIUM |
| `amjsonprotocol.h/cpp` | BE | HIGH |
| `amjsonsignal.h/cpp` | BE | MEDIUM |
| `graphicitemsenummap.h/cpp` | BE | LOW |
| `versionmsg.h/cpp` | BE | LOW |

**Replacement Strategy (using nlohmann/json)**:
```cpp
// Before (Qt)
QJsonDocument doc = QJsonDocument::fromJson(data);
QJsonObject obj = doc.object();
QString value = obj["key"].toString();
QJsonArray arr = obj["items"].toArray();

// After (nlohmann/json)
#include <nlohmann/json.hpp>
using json = nlohmann::json;

json doc = json::parse(data);
std::string value = doc["key"].get<std::string>();
auto arr = doc["items"];
for (auto& item : arr) { /* process */ }
```

**Effort**: 3-5 days
**Risk**: Medium (API is similar but not identical)

---

### 6.2 QDataStream → Custom Serialization
**Difficulty**: ⭐⭐⭐⭐ (Hard)

**Affected Files**:
| File | Location |
|------|----------|
| `canrxmsg.h/cpp` | BE |
| `candbsignal.h/cpp` | BE |

**Replacement Options**:
1. Raw binary I/O with `std::fstream`
2. Protocol Buffers (if cross-platform needed)
3. MessagePack
4. Custom binary format

```cpp
// Custom serialization
template<typename T>
void serialize(std::ostream& os, const T& value) {
    os.write(reinterpret_cast<const char*>(&value), sizeof(T));
}

template<typename T>
T deserialize(std::istream& is) {
    T value;
    is.read(reinterpret_cast<char*>(&value), sizeof(T));
    return value;
}
```

**Effort**: 2-3 days
**Risk**: Medium (need to match existing format)

---

## Phase 7: VERY HARD (Meta-Object System & Signals/Slots)

### 7.1 Q_OBJECT / Signals & Slots → Observer Pattern / Callbacks
**Difficulty**: ⭐⭐⭐⭐⭐ (Very Hard)

**Affected Files**: 31 files with Q_OBJECT

**This is the most challenging part** as it requires architectural redesign.

**Key Files to Refactor**:
| File | Location | Signals/Slots Count |
|------|----------|---------------------|
| `mainprocess.h/cpp` | BE | 10+ signals, 15+ slots |
| `canmanager.h/cpp` | BE | 5+ signals, 10+ slots |
| `amjsonprotocol.h/cpp` | BE | 5+ signals |
| `amjsonsignal.h/cpp` | BE | 5+ signals |
| `smartitem.h/cpp` | BE | 3+ signals |
| All `*action.h` files | BE | 2-3 signals each |

**Replacement Strategy**:

**Option A: Simple Callbacks (std::function)**
```cpp
// Before (Qt)
class Sender : public QObject {
    Q_OBJECT
signals:
    void valueChanged(int newValue);
};

class Receiver : public QObject {
    Q_OBJECT
public slots:
    void onValueChanged(int value) { /* handle */ }
};

// Connection
connect(sender, &Sender::valueChanged, receiver, &Receiver::onValueChanged);

// After (C++ callbacks)
class Sender {
public:
    std::function<void(int)> onValueChanged;

    void setValue(int v) {
        if (onValueChanged) onValueChanged(v);
    }
};

class Receiver {
public:
    void handleValueChanged(int value) { /* handle */ }
};

// Connection
sender.onValueChanged = [&receiver](int v) { receiver.handleValueChanged(v); };
```

**Option B: Observer Pattern (for multiple listeners)**
```cpp
template<typename... Args>
class Signal {
public:
    using Slot = std::function<void(Args...)>;

    void connect(Slot slot) { slots_.push_back(slot); }
    void emit(Args... args) {
        for (auto& slot : slots_) slot(args...);
    }
private:
    std::vector<Slot> slots_;
};

class Sender {
public:
    Signal<int> valueChanged;
};

// Usage
sender.valueChanged.connect([](int v) { /* handle */ });
sender.valueChanged.emit(42);
```

**Option C: Use sigslot library**
- Header-only, lightweight
- https://github.com/palacaze/sigslot

**Effort**: 2-3 weeks
**Risk**: HIGH (architectural change, many connections to update)

---

### 7.2 Q_PROPERTY → Plain Getters/Setters
**Difficulty**: ⭐⭐⭐⭐ (Hard)

**Affected Files**:
| File | Location |
|------|----------|
| `ewinfo.h/cpp` | BE |
| `amjsonsignal.h/cpp` | BE |
| `qquickhalfcircletray.h/cpp` | FW |

```cpp
// Before (Qt)
class MyClass : public QObject {
    Q_OBJECT
    Q_PROPERTY(int value READ value WRITE setValue NOTIFY valueChanged)
public:
    int value() const { return m_value; }
    void setValue(int v) { m_value = v; emit valueChanged(); }
signals:
    void valueChanged();
private:
    int m_value;
};

// After (Plain C++)
class MyClass {
public:
    int value() const { return m_value; }
    void setValue(int v) {
        m_value = v;
        if (onValueChanged) onValueChanged();
    }
    std::function<void()> onValueChanged;
private:
    int m_value;
};
```

**Effort**: 1-2 weeks
**Risk**: Medium

---

### 7.3 Q_ENUM / Q_GADGET → Standard C++ Enums + Reflection
**Difficulty**: ⭐⭐⭐⭐ (Hard)

**Affected Files**:
| File | Location |
|------|----------|
| `actiontype.h` | BE |
| `sysreqtype.h` | BE |
| `amjsonprotocol.h` | BE |
| `alerttypes.h` | FW |

**Replacement Strategy**:
```cpp
// Before (Qt)
class ActionType {
    Q_GADGET
public:
    enum Type { None, Click, Scroll };
    Q_ENUM(Type)

    static QString toString(Type t) {
        return QMetaEnum::fromType<Type>().valueToKey(t);
    }
};

// After (C++ with magic_enum or custom)
#include <magic_enum.hpp>

enum class ActionType { None, Click, Scroll };

std::string toString(ActionType t) {
    return std::string(magic_enum::enum_name(t));
}
```

**Effort**: 1-2 days
**Risk**: Low (magic_enum is header-only)

---

## Phase 8: EXTREMELY HARD (Graphics - FW)

### 8.1 QProcess → POSIX fork/exec
**Difficulty**: ⭐⭐⭐⭐ (Hard)

**Affected Files**:
| File | Location |
|------|----------|
| `amjsonsystemrequestaction.cpp` | BE |

```cpp
// Before (Qt)
QProcess process;
process.start("command", args);
process.waitForFinished();

// After (POSIX)
#include <unistd.h>
#include <sys/wait.h>

pid_t pid = fork();
if (pid == 0) {
    execvp("command", argv);
    _exit(1);
} else {
    int status;
    waitpid(pid, &status, 0);
}
```

**Effort**: 1 day
**Risk**: Medium

---

### 8.2 Main Application Entry → LVGL Init
**Difficulty**: ⭐⭐⭐⭐⭐ (Very Hard)

**File**: `main.cpp`

```cpp
// Before (Qt)
int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    engine.load(QUrl("qrc:/main.qml"));
    return app.exec();
}

// After (LVGL)
int main(int argc, char *argv[]) {
    lv_init();
    // Initialize display driver
    // Initialize input driver
    // Create UI
    while(1) {
        lv_timer_handler();
        usleep(5000);
    }
}
```

**Effort**: 1-2 weeks
**Risk**: Very High (complete rewrite)

---

### 8.3 QQuickPaintedItem → LVGL Canvas
**Difficulty**: ⭐⭐⭐⭐⭐ (Very Hard)

**Affected Files**:
| File | Location |
|------|----------|
| `qquickqrcode.h/cpp` | FW |

**LVGL Replacement**:
```cpp
// LVGL canvas for custom drawing
lv_obj_t* canvas = lv_canvas_create(parent);
lv_canvas_set_buffer(canvas, buffer, width, height, LV_IMG_CF_TRUE_COLOR);
lv_canvas_fill_bg(canvas, lv_color_white(), LV_OPA_COVER);
// Draw QR code using LVGL drawing API
```

**Effort**: 3-5 days
**Risk**: High

---

### 8.4 QQuickItem → LVGL Widgets
**Difficulty**: ⭐⭐⭐⭐⭐ (Very Hard)

**Affected Files**:
| File | Location |
|------|----------|
| `displaysignalizer.h/cpp` | FW |
| `qquickhalfcircletray.h/cpp` | FW |

**Effort**: 1-2 weeks per component
**Risk**: High

---

### 8.5 QML Files → LVGL UI
**Difficulty**: ⭐⭐⭐⭐⭐ (Very Hard)

All `.qml` files need complete redesign for LVGL.

**Effort**: 3-4 weeks
**Risk**: Very High (complete UI rewrite)

---

### 8.6 QQmlExtensionPlugin → LVGL Custom Widgets
**Difficulty**: ⭐⭐⭐⭐⭐ (Very Hard)

**Affected Files**:
| File | Location |
|------|----------|
| `ewqmlplugin_plugin.h/cpp` | FW |

**Effort**: 1 week
**Risk**: High

---

## Summary: Migration Order

| Phase | Difficulty | Category | Est. Effort | Dependencies |
|-------|------------|----------|-------------|--------------|
| 1 | Trivial | Already Qt-free | 0 | None |
| 2.1 | ⭐ | QDebug | 2 hours | None |
| 2.2 | ⭐ | QElapsedTimer | 30 min | None |
| 3.1 | ⭐⭐ | QString | 2-3 days | None |
| 3.2 | ⭐⭐ | QList/QVector | 1-2 days | Phase 3.1 |
| 3.3 | ⭐⭐ | QMap/QHash | 1-2 days | Phase 3.1 |
| 3.4 | ⭐⭐ | QVariant | 4-8 hours | Phase 3.1 |
| 4.1 | ⭐⭐⭐ | QFile/QDir | 2-3 days | Phase 3.1 |
| 4.2 | ⭐⭐⭐ | QTextStream | 1-2 days | Phase 4.1 |
| 4.3 | ⭐⭐⭐ | QSettings | 4-8 hours | Phase 4.1 |
| 4.4 | ⭐⭐⭐ | QFileSystemWatcher | 1-2 days | None |
| 5.1 | ⭐⭐⭐⭐ | QThread | 3-5 days | Phase 7.1 |
| 5.2 | ⭐⭐⭐ | QMutex | 1 day | None |
| 5.3 | ⭐⭐⭐⭐ | QTimer | 3-5 days | Phase 5.1 |
| 6.1 | ⭐⭐⭐⭐ | QJson* | 3-5 days | Phase 3.1 |
| 6.2 | ⭐⭐⭐⭐ | QDataStream | 2-3 days | Phase 4.1 |
| 7.1 | ⭐⭐⭐⭐⭐ | Signals/Slots | 2-3 weeks | None (start early) |
| 7.2 | ⭐⭐⭐⭐ | Q_PROPERTY | 1-2 weeks | Phase 7.1 |
| 7.3 | ⭐⭐⭐⭐ | Q_ENUM | 1-2 days | None |
| 8.1 | ⭐⭐⭐⭐ | QProcess | 1 day | None |
| 8.2-8.6 | ⭐⭐⭐⭐⭐ | LVGL Migration | 4-6 weeks | All BE phases |

---

## Recommended Libraries

| Purpose | Library | License |
|---------|---------|---------|
| JSON | nlohmann/json | MIT |
| Logging | spdlog | MIT |
| Enum reflection | magic_enum | MIT |
| Signals/Slots | sigslot | MIT |
| INI parsing | inih | BSD |
| Graphics | LVGL | MIT |
| Testing | Catch2 / GoogleTest | BSD/Apache |

---

## File-by-File Checklist

### BE (Backend) - 50 Files

#### Tier 1: Minimal Changes (5 files)
- [ ] `canupdate/updatecommon/utils.h` - QDebug only
- [ ] `canquick/defs.h` - QElapsedTimer only
- [ ] `canquick/iamjsonactionfactory.h` - QString only
- [ ] `canquick/icanrxmsgfactory.h` - Pure interface
- [ ] `canquick/iamjsonprocessable.h` - Pure interface

#### Tier 2: Container/Utility Changes (15 files)
- [ ] `canquick/canargumentsaccumulator.h/cpp`
- [ ] `canquick/canstringargumentsaccumulator.h/cpp`
- [ ] `canquick/canintargumentsaccumulator.h`
- [ ] `canquick/rootedtreenode.h/cpp`
- [ ] `canquick/rootedtree.h`
- [ ] `canquick/layerspriorityq.h`
- [ ] `canquick/graphicitemsenummap.h/cpp`
- [ ] `canquick/keepalivemsg.h/cpp`
- [ ] `canquick/bufferedsmoother.h/cpp`
- [ ] `canquick/ismoother.h`

#### Tier 3: File I/O Changes (8 files)
- [ ] `canquick/versionmsg.h/cpp`
- [ ] `canquick/ewinfo.h/cpp`
- [ ] `canquick/brightnesscontrol.h/cpp`
- [ ] `canquick/canrxmsg.h/cpp`
- [ ] `canquick/amsignalsmodel.h`

#### Tier 4: Threading/Timer Changes (6 files)
- [ ] `canquick/mainprocess.h/cpp`
- [ ] `canquick/canmanager.h/cpp`
- [ ] `canquick/medisconnectionreport.h/cpp`
- [ ] `canquick/timedsmoother.h/cpp`
- [ ] `canquick/smartitem.h/cpp`

#### Tier 5: JSON Changes (6 files)
- [ ] `canquick/amjsonconfigreader.h/cpp`
- [ ] `canquick/amjsonprotocol.h/cpp`
- [ ] `canquick/amjsonsignal.h/cpp`
- [ ] `canquick/candbsignal.h/cpp`

#### Tier 6: Action System (Signals/Slots Heavy - 12 files)
- [ ] `canquick/amjsonaction.h`
- [ ] `canquick/amjsonargumentaction.h`
- [ ] `canquick/amjsonnumericargumentaction.h`
- [ ] `canquick/amjsonstringargumentaction.h`
- [ ] `canquick/amjsonenableraction.h/cpp`
- [ ] `canquick/amjsonrequestidaction.h/cpp`
- [ ] `canquick/amjsonsystemrequestaction.h/cpp`
- [ ] `canquick/amjsongraphicitemaction.h`
- [ ] `canquick/amjsonactionsmultiplexor.h/cpp`
- [ ] `canquick/amjsonactionfactory.h/cpp`
- [ ] `canquick/canrxmsgfactory.h/cpp`
- [ ] `canquick/actiontype.h`
- [ ] `canquick/sysreqtype.h`

### FW (Frontend) - 16 Files

#### Graphics/QML (Complete Replacement with LVGL)
- [ ] `canquick/main.cpp`
- [ ] `canquick/qquickqrcode.h/cpp`
- [ ] `canquick/displaysignalizer.h/cpp`
- [ ] `canquick/alerttypes.h`
- [ ] `canquick/plugins/ewqmlplugin/ewqmlplugin_plugin.h/cpp`
- [ ] `canquick/plugins/ewqmlplugin/qquickhalfcircletray.h/cpp`
- [ ] All `.qml` files

---

## Quick Start Recommendations

1. **Start with Phase 2** (QDebug, QElapsedTimer) - Quick wins
2. **Set up alternative libraries early** (nlohmann/json, spdlog, sigslot)
3. **Create abstraction headers** for common Qt types → STL mappings
4. **Phase 7.1 (Signals/Slots) should start in parallel** - it's the longest
5. **Keep FW (Phase 8) for last** - it requires all BE work complete

---

## Notes

- Total estimated effort: 8-12 weeks for full migration
- BE migration: 4-6 weeks
- FW migration (LVGL): 4-6 weeks
- Recommend completing BE before starting FW
- Test thoroughly after each phase
