#ifndef AMJSONACTIONFACTORY_H
#define AMJSONACTIONFACTORY_H

#include "iamjsonactionfactory.h"
class IAMJsonActionFactory;
class AMJsonSignal;

class AMJsonActionFactory : public IAMJsonActionFactory
{
public:

    explicit AMJsonActionFactory(){/*empty*/}

    AMJsonAction * createAMJsonActionInstance(AMJsonSignal * aJsonSignal, qint32 type, QString action);
};

#endif // AMJSONACTIONFACTORY_H
