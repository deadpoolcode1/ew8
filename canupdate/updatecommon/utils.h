#pragma once

#ifndef UTILS_H
#define UTILS_H

#include <stdio.h>
#include <QDebug>

char ascii2hex(char a);

void str2hash(const char* _str, char* _buffer);

#ifndef WIN32
//#define LOG( ...) ( printf("[%s:%d]: ", __func__, __LINE__), printf(__VA_ARGS__) )
#define LOG( ...) ( printf(__VA_ARGS__) )
#else
//#define LOG( ...) ( qDebug("[%s:%d]: ", __func__, __LINE__), printf(__VA_ARGS__) )
#define LOG( ...) ( qDebug(__VA_ARGS__) )
#endif

#endif // UTILS_H
