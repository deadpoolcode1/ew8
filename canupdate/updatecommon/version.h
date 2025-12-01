#pragma once

#ifndef VERSION_H
#define VERSION_H

#include <stdint.h>

#define MAJ_VER (1)
#define MIN_VER (4)
#define BUILD_VER (0)

#define MAKE_VERSION(major, minor, build) ((((major) & 0xFF) << 24) | (((minor) & 0xFF) <<  16) | ((build) & 0xFFFF))

#define GET_VERSION_MAJOR(ver) ((((uint32_t)(ver)) >> 24) & 0xFF)
#define GET_VERSION_MINOR(ver) ((((uint32_t)(ver)) >> 16) & 0xFF)
#define GET_VERSION_BUILD(ver) (((uint32_t)(ver)) & 0xFFFF)

#define SW_VERSION MAKE_VERSION(MAJ_VER, MIN_VER, BUILD_VER)

#endif // VERSION_H
