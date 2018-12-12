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

extern Signal SignalsOfAfterMarket_TSR_0x727[];
extern size_t SignalsOfAfterMarket_TSR_0x727_size;

extern Signal SignalsOfSmartADAS_S_ADAS_0x7ac[];
extern size_t SignalsOfSmartADAS_S_ADAS_0x7ac_size;

extern Signal SignalsOfSeeQInfo_SN_System_0x410[];
extern size_t  SignalsOfSeeQInfo_SN_System_0x410_size;

extern Signal SignalsOfSeeQInfo_Time_Info_0x411[];
extern size_t  SignalsOfSeeQInfo_Time_Info_0x411_size;

extern Signal SignalsOfSeeQInfo_App_Info_0x412[];
extern size_t  SignalsOfSeeQInfo_App_Info_0x412_size;

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

#if 0
//Used for signals that just match to display alerts one-to-one
void one2oneParseAndProcessGeneral(IAlertDisplay * alertsDisplay, struct can_frame * recv, const char * name, AlertTypes::EnAlert alert, bool polarity = true);
#endif


#endif //CANDBSIGNAL_H
