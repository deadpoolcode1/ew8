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

    QString getName(void);

    AMJsonSignal * getSignal(QString aName);

private:
    QString name;
    std::vector<AMJsonSignal> jsonSignals;


};

#endif // AMJSONPROTOCOL_H
