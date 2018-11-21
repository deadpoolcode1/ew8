#ifndef CANDBSIGNAL_H
#define CANDBSIGNAL_H

#include <QObject>

#ifndef WIN32
#include <linux/types.h>
#include <net/if.h>
#include <sys/socket.h>
#include <linux/can.h>
#else
#include "canlib.h"
#endif

typedef enum SignalValueType_e
{
    SIGNAL_VALUE_TYPE_INTEGER = 0,
    SIGNAL_VALUE_TYPE_FLOAT   = 1,
    SIGNAL_VALUE_TYPE_DOUBLE  = 2,
}
SignalValueType;

typedef enum ext_sgval_type_s
{
    EXT_SG_VAL_TYPE_BROKEN = -1,
    EXT_SG_VAL_TYPE_INTEGER = 0,
    EXT_SG_VAL_TYPE_BOOL = 1,
    EXT_SG_VAL_TYPE_DOUBLE = 2
} ext_sgval_type_t;

typedef struct Signal_s
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
}
Signal;

extern Signal SignalsOfAfterMarket_AWS_0x700[];
extern size_t SignalsOfAfterMarket_AWS_0x700_size;

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

typedef struct sg_var_s
{
    ext_sgval_type_t sg_type;
    union sg_var_u
    {
        double _double;
        qint32 _int;
        bool _bool;
        quint64 container;
    } sg_val;
}
sg_var_t;

sg_var_t extractSignal(const char * name, struct can_frame *frame);


#endif //CANDBSIGNAL_H
