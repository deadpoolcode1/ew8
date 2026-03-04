#include "snv_calculator.h"
#include <climits>

uint64_t calculateSNV(const std::string& ew, const std::string& me)
{
    if (me.length() != 16 || ew.length() != 16)
    {
        return 0;
    }

    uint64_t A = (uint64_t)(uint8_t)ew[me[15] % 16];
    uint64_t B = (uint64_t)(uint8_t)ew[me[14] % 16];
    uint64_t C = (uint64_t)(uint8_t)ew[me[13] % 16];
    uint64_t D = (uint64_t)(uint8_t)ew[me[12] % 16];
    uint64_t E = (uint64_t)(uint8_t)ew[me[11] % 16];

    uint64_t F = (uint64_t)(uint8_t)me[ew[0] % 16];
    uint64_t G = (uint64_t)(uint8_t)me[ew[1] % 16];
    uint64_t H = (uint64_t)(uint8_t)me[ew[11] % 16];
    uint64_t I = (uint64_t)(uint8_t)me[ew[12] % 16];
    uint64_t J = (uint64_t)(uint8_t)me[ew[13] % 16];

    uint64_t SNV = (uint64_t)((A + B + C + D + E) * (F + G + H + I + J) * (A * B * C * D * E + F * G * H * I * J)) % ULONG_LONG_MAX;

    return SNV;
}
