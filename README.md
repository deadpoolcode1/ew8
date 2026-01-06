# EW8 Project

## Release Notes

### Version 1.0.4

**Release Date:** January 2026

**Summary:** Major refactoring to remove Qt library dependencies from the backend, replacing them with pure C/C++ STL implementations.

---

## Qt Library Removal

This release removes the following Qt dependencies from the backend codebase, replacing them with lightweight C++ STL-based alternatives:

### Level 1: Core Type Replacements

| Qt Type | Replacement | Location |
|---------|-------------|----------|
| `qint8`, `qint16`, `qint32`, `qint64` | `int8_t`, `int16_t`, `int32_t`, `int64_t` | `<cstdint>` |
| `quint8`, `quint16`, `quint32`, `quint64` | `uint8_t`, `uint16_t`, `uint32_t`, `uint64_t` | `<cstdint>` |
| `QProcess` | `core::Process` | `core/core.h` |
| `qDebug()`, `qWarning()`, `qCritical()` | `core::LogStream` macros | `core/logger.h` |

### Level 2: Container & Type Replacements

| Qt Type | Replacement | Underlying STL Type |
|---------|-------------|---------------------|
| `QString` | `QString` wrapper class | `std::string` |
| `QByteArray` | `ByteArray` | `std::vector<uint8_t>` |
| `QList<T>` | `QList<T>` wrapper class | `std::vector<T>` |
| `QVector<T>` | `QVector<T>` alias | `std::vector<T>` |
| `QMap<K,V>` | `QMap<K,V>` wrapper class | `std::map<K,V>` |
| `QMultiMap<K,V>` | `QMultiMap<K,V>` wrapper class | `std::multimap<K,V>` |
| `QHash<K,V>` | `Hash<K,V>` | `std::unordered_map<K,V>` |
| `QVariant` | `QVariant` wrapper class | `std::any` |
| `QChar` | `QChar` wrapper class | `char` |
| `QStringList` | `QStringList` alias | `QList<QString>` |

---

## New Core Library (`canquick/core/`)

A new pure C++ core library was introduced with the following components:

| File | Purpose | Replaces |
|------|---------|----------|
| `types.h` | Type definitions and Qt-compatible container wrappers | `QString`, `QList`, `QMap`, `QVariant`, etc. |
| `core.h` | Main include + Process class | `QProcess` |
| `logger.h` | Logging system with stream support | `QDebug` |
| `elapsed_timer.h` | High-resolution timing | `QElapsedTimer` |
| `mutex.h` | Mutex and synchronization | `QMutex`, `QMutexLocker` |
| `signal.h` | Signal/slot system | Qt signals/slots |
| `thread.h` | Threading utilities | `QThread` |
| `timer.h` | Timer implementation | `QTimer` |
| `file_utils.h` | File operations | `QFile`, `QDir`, `QFileInfo`, `QTextStream` |
| `file_watcher.h` | File system monitoring | `QFileSystemWatcher` |
| `json.h` | JSON parsing/serialization | `QJsonDocument`, `QJsonObject`, `QJsonArray` |
| `serialization.h` | Binary serialization | `QDataStream`, `QSaveFile` |
| `settings.h` | Application settings | `QSettings` |

---

## Implementation Details

### Qt-Compatible API

The replacement classes maintain Qt-compatible APIs for seamless migration:

```cpp
// QString example - same API, STL backend
QString str = "Hello";
str.isEmpty();      // works
str.toLower();      // works
str.arg(42);        // works
str.toStdString();  // works

// QList example
QList<int> list;
list.append(1);     // works
list.isEmpty();     // works
list.contains(1);   // works

// QMap example
QMap<QString, int> map;
map.insert("key", 42);  // works
map.contains("key");    // works
map.value("key");       // works
```

### Conditional Compilation

All replacements are guarded by `#ifndef QT_CORE_LIB`, allowing the codebase to work with or without Qt:

```cpp
#ifndef QT_CORE_LIB
// Pure C++ implementations active
#endif
```

---

## Commit History

**50 commits** | **95 files changed** | **+5,997 / -981 lines**

### Key Commits

- `fd041a1` - Add comprehensive Qt removal migration plan
- `f9629d8` - BE Qt removal: Phase 1 - Core infrastructure and initial migrations
- `cc4b014` - BE Qt removal: Phase 2 - More file migrations
- `9ea0dc0` - Replace Qt backend dependencies (Level 1 tasks)
- `9b944e0` - Level 2: Add Qt-compatible type wrappers
- `959ba3d` - Replace Qt integer types with standard C++ types
- `95611c7` - Remove QDebug logging in favor of core/logger.h
- `b9f2577` - Remove QByteArray Qt dependency
- `a849050` - Add foreach macro for Qt QList compatibility
- `f7b934f` - Remove QMap Qt dependency
- `dc46a77` - Remove QHash Qt dependency
- `3f0935d` - Remove QVariant Qt dependency

---

## Migration Guide

To use the new Qt-free backend:

1. Include the core headers:
   ```cpp
   #include "core/core.h"   // All core functionality
   // or individually:
   #include "core/types.h"  // Types only
   #include "core/logger.h" // Logging only
   ```

2. Build without Qt by not defining `QT_CORE_LIB`

3. Existing code using Qt types will work unchanged due to API compatibility

---

## Files Modified

41 source files now include the new core headers, with Qt dependencies replaced throughout the `canquick/` directory.
