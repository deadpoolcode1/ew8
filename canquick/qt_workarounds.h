#ifndef QT_WORKAROUNDS_H
#define QT_WORKAROUNDS_H

// Workaround for Qt 6.9.x qfloat16 operator redefinition bug on 64-bit Linux
// On 64-bit Linux (LP64 ABI), 'long' and 'long long' are both 64 bits.
// Qt's qfloat16.h declares comparison operators for both 'long' and 'qint64',
// causing redefinition errors since they resolve to the same type.
//
// Solution: Define QT_NO_FLOAT16_OPERATORS before including Qt headers.
// This is an official Qt macro that disables the arithmetic/comparison operators
// for qfloat16, avoiding the redefinition conflict.
//
// See: https://doc.qt.io/qt-6/qfloat16.html

#if defined(__linux__) && defined(__LP64__)
    // On 64-bit Linux, disable qfloat16 operators to avoid redefinition errors
    #ifndef QT_NO_FLOAT16_OPERATORS
        #define QT_NO_FLOAT16_OPERATORS 1
    #endif
#endif

#endif // QT_WORKAROUNDS_H
