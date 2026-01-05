#ifndef CANDBSIGNAL_H
#define CANDBSIGNAL_H

// Use core library instead of Qt
#include "core/types.h"
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

#include "defs.h"

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
    quint32 AMJsonSignalIdx;
}
Signal;

typedef struct SerializedSignal_s
{
public:
    quint32 startByte;
    quint32 startBit;
    quint32 numOfBits;
    quint8 sign;
    double factor;
    double offset;
    double min;
    double max;
    qint32 enumValueType;
    quint32 AMJsonSignalIdx;
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
     std::vector<qint64> * numbers;//TODO think about floats implementation
     std::vector<Signal *> * cansignals;
     std::vector<Value> * vtRows;
};

std::any extractSignal(Signal * canSignal, struct can_frame *frame);


#endif //CANDBSIGNAL_H
