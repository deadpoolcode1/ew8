#ifndef AMJSONPROTOCOL_H
#define AMJSONPROTOCOL_H

#include "amjsonsignal.h"
#include "canrxmsg.h"
#include <vector>

class AMJsonSignal;

class AMJsonProtocol
{
public:
    AMJsonProtocol(QString aName);

    void append(AMJsonSignal * signal);

private:
    QString name;
    std::vector<AMJsonSignal> jsonSignals;


};

#endif // AMJSONPROTOCOL_H
