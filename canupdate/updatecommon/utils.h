#pragma once

#ifndef UTILS_H
#define UTILS_H

#include <stdio.h>

// Removed Qt dependency - use standard printf for logging
// #include <QDebug>

char ascii2hex(char a);

void str2hash(const char* _str, char* _buffer);

// Use printf for all platforms - Qt-free
#define LOG( ...) ( printf(__VA_ARGS__) )

#endif // UTILS_H
