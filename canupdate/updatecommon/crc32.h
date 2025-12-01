#pragma once

#ifndef CRC32_H
#include <stdint.h>

uint32_t updateCRC32(unsigned char ch, uint32_t crc);
void crc32reset(uint32_t& _crc32);
uint32_t crc32buf(uint32_t& _crc32, char *buf, uint32_t len);
uint32_t crc32result(uint32_t _crc32);

uint8_t crc8buf(void const *mem, uint32_t len, uint8_t crc = 0xff);

#define CRC32_H

#endif // CRC32_H
