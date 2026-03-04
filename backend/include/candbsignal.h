#ifndef CANDBSIGNAL_H
#define CANDBSIGNAL_H

// Include defs.h first (which includes Qt headers before core types)
#include "defs.h"

// Include core library after Qt headers are already included
#include "core/serialization.h"

#include <string>
#include <vector>
#include <any>

#include "peglib.h"
using namespace peg;

#ifndef WIN32
#include <linux/types.h>
#include <net/if.h>
#include <sys/socket.h>
#include <linux/can.h>
#else
#include "canlib.h"
#endif

class AMJsonProtocol;

typedef enum SignalValueType_e
{
    SIGNAL_VALUE_TYPE_INTEGER = 0,
    SIGNAL_VALUE_TYPE_FLOAT   = 1,
    SIGNAL_VALUE_TYPE_DOUBLE  = 2,
}
SignalValueType;

typedef struct Signal_s
{
    std::string name;
    unsigned int startByte;
    unsigned int startBit;
    unsigned int numOfBits;
    bool sign;
    double factor;
    double offset;
    double min;
    double max;
    SignalValueType valueType;
    uint32_t AMJsonSignalIdx;
}
Signal;

typedef struct SerializedSignal_s
{
public:
    uint32_t startByte;
    uint32_t startBit;
    uint32_t numOfBits;
    uint8_t sign;
    double factor;
    double offset;
    double min;
    double max;
    int32_t enumValueType;
    uint32_t AMJsonSignalIdx;
} SerializedSignal_t;




typedef struct Value_s
{
    std::string name;
    double value;
}
Value;



core::DataStream & operator<< (core::DataStream &out, const Signal & any);
core::DataStream & operator>> (core::DataStream &in, Signal & any);

class CanDBSignal {
public:

    CanDBSignal();

    bool processDBCFile(AMJsonProtocol * prot);

private:

     bool parseDBCFileString(const std::string& extractedFile);
     bool readDBCFile(const std::string& protocolName, std::string& extractedFile);
     void init_parser(void);

     AMJsonProtocol * curParsedProtocol;

     parser * pParser;

     std::vector<std::string> * phrases;
     std::vector<std::string> * c_identifiers;
     std::vector<std::string> * signs;
     std::vector<std::string> * ecu_tokens;
     std::vector<int64_t> * numbers;//TODO think about floats implementation
     std::vector<Signal *> * cansignals;
     std::vector<Value> * vtRows;
};

std::any extractSignal(Signal * canSignal, struct can_frame *frame);


#endif //CANDBSIGNAL_H
