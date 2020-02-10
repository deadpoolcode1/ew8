#ifndef CANDBSIGNAL_H
#define CANDBSIGNAL_H

#include <QObject>
#include <QDataStream>

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

typedef enum ext_sgval_type_s
{
    EXT_SG_VAL_TYPE_BROKEN = -1,
    EXT_SG_VAL_TYPE_INTEGER = 0,
    EXT_SG_VAL_TYPE_BOOL = 1,
    EXT_SG_VAL_TYPE_DOUBLE = 2
} ext_sgval_type_t;

typedef struct Signal_s
{
    QString name;
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
    QString name;
    double value;
}
Value;

//WARNING: on dbc realization the VT must be encapsulated in its protocol.
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

QDataStream & operator<< (QDataStream &out, const Signal & any);
QDataStream & operator>> (QDataStream &in, Signal & any);

class CanDBSignal {
public:

    CanDBSignal();

    bool processDBCFile(AMJsonProtocol * prot);

private:

     bool parseDBCFileString(QString extractedFile);
     bool readDBCFile(QString protocolName, QString & extractedFile);
     void init_parser(void);

     AMJsonProtocol * curParsedProtocol;

     parser * pParser;

     QList<QString> * phrases;
     QList<QString> * c_identifiers;
     QList<QString> *  signs;
     QList<QString> * ecu_tokens;
     QList<qint64> * numbers;//TODO think about floats implementation
     QList<Signal *> * cansignals;
     QList<Value> * vtRows;
};

sg_var_t extractSignal(Signal * canSignal, struct can_frame *frame);


#endif //CANDBSIGNAL_H
