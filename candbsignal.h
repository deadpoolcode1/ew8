#ifndef CANDBSIGNAL_H
#define CANDBSIGNAL_H

#include <QObject>
#include "defs.h"


enum SignalValueType
{
    SIGNAL_VALUE_TYPE_INTEGER = 0,
    SIGNAL_VALUE_TYPE_FLOAT   = 1,
    SIGNAL_VALUE_TYPE_DOUBLE  = 2
};

struct Signal
{
    const char* name;
    unsigned int startByte;
    unsigned int startBit;
    unsigned int numOfBits;
    bool sign;
    double factor;
    double offset;
    double min;
    double max;
    SignalValueType valueType;
};

//NOTE: comments etc dropped.
#if 0
typedef struct candbvt_row_s
{
    QString vt_name;
    double val;
}
candbvt_row_t;

typedef  struct candbvt_s
{
    candbvt_row_t * rows;
    size_t size;
} candbvt_t;

typedef struct candbsignal_s

{
    QString sg_name;
    quint8  bit_start;
    quint8  bit_length;
    bool    is_lt_endian;
    bool    is_unsigned;
    double  factor;
    double  offset;
    double  min;
    double  max;
    QString unit;
    candbvt_t vt;
}
candbsignal_t;

typedef struct canmsg_sg_s
{
    can_id_t cid;
    size_t size;
    candbsignal_t * cansignals;
}
canmsg_sg_t;

extern canmsg_sg_t *canmsgs;

#endif

#endif //CANDBSIGNAL_H
