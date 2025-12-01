#ifndef IAMJSONACTIONFACTORY_H
#define IAMJSONACTIONFACTORY_H

#include "amjsonaction.h"
#include "amjsonsignal.h"
#include "defs.h"

#include <QString>

class AMJsonAction;
class AMJsonProtocol;

class IAMJsonActionFactory
{
public:
    /**
     * @arg type - AMJsonSignal::action_type_e
     */
    virtual AMJsonAction * createAMJsonActionInstance(AMJsonProtocol * aJsonProtocol, action_type_e type, QString action, ssize_t index) = 0;
};

#endif // IAMJSONACTIONFACTORY_H
