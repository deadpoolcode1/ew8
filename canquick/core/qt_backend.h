#ifndef CORE_QT_BACKEND_H
#define CORE_QT_BACKEND_H

// =============================================================================
// Qt Backend Selection Header
// =============================================================================
//
// This header controls whether to use actual Qt classes or custom replacements.
//
// USAGE:
//   - By DEFAULT: Custom core:: replacement classes are used (no Qt dependency)
//   - Define USE_QT_BACKEND: Actual Qt classes are used (for testing/validation)
//
// To enable Qt backend, add to your .pro file:
//   DEFINES += USE_QT_BACKEND
//
// Or compile with:
//   qmake "DEFINES+=USE_QT_BACKEND"
//
// =============================================================================

// When USE_QT_BACKEND is defined, we use actual Qt classes
// When USE_QT_BACKEND is NOT defined (default), we use custom replacements

#ifdef USE_QT_BACKEND

// Include actual Qt headers
#include <QString>
#include <QChar>
#include <QList>
#include <QVector>
#include <QMap>
#include <QMultiMap>
#include <QHash>
#include <QVariant>
#include <QStringList>

// Qt is available and will be used
#define USING_QT_BACKEND 1
#define USING_CORE_BACKEND 0

#else // !USE_QT_BACKEND (DEFAULT - use custom replacements)

// Custom replacements will be defined in types.h
#define USING_QT_BACKEND 0
#define USING_CORE_BACKEND 1

#endif // USE_QT_BACKEND

#endif // CORE_QT_BACKEND_H
