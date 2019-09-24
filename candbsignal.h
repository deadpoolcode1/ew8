#ifndef CANDBSIGNAL_H
#define CANDBSIGNAL_H

#include <QObject>

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
}
Signal;

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

Signal * extractSignalPtr(const char * name, quint32 msgId);

sg_var_t extractSignal(Signal * canSignal, struct can_frame *frame);

#if 0
//Used for signals that just match to display alerts one-to-one
void one2oneParseAndProcessGeneral(IAlertDisplay * alertsDisplay, struct can_frame * recv, const char * name, DISPLAY_ITEM_ID alert, bool polarity = true);
#endif


#endif //CANDBSIGNAL_H
