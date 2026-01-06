#ifndef AMJSONACTIONFACTORY_H
#define AMJSONACTIONFACTORY_H

#include "iamjsonactionfactory.h"
class IAMJsonActionFactory;
class AMJsonSignal;

class AMJsonActionFactory : public IAMJsonActionFactory
{
public:

    explicit AMJsonActionFactory(){/*empty*/}

    AMJsonAction * createAMJsonActionInstance(AMJsonProtocol * aJsonProtocol, action_type_e type, core::QString action, ssize_t index);
};

#endif // AMJSONACTIONFACTORY_H
