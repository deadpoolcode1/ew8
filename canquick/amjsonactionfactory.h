#ifndef AMJSONACTIONFACTORY_H
#define AMJSONACTIONFACTORY_H

#include "iamjsonactionfactory.h"
#include "core/types.h"
class IAMJsonActionFactory;
class AMJsonSignal;

class AMJsonActionFactory : public IAMJsonActionFactory
{
public:

    explicit AMJsonActionFactory(){/*empty*/}

    AMJsonAction * createAMJsonActionInstance(AMJsonProtocol * aJsonProtocol, action_type_e type, const String& action, ssize_t index);
};

#endif // AMJSONACTIONFACTORY_H
