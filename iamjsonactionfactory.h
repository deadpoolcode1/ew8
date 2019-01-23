#ifndef IAMJSONACTIONFACTORY_H
#define IAMJSONACTIONFACTORY_H

#include "amjsonaction.h"
#include "amjsonsignal.h"

#include <QString>

class AMJsonAction;

class IAMJsonActionFactory
{
public:
    /**
     * @arg type - AMJsonSignal::action_type_e, excluding AMJsonSignal::EnumItem
     */
    virtual AMJsonAction * createAMJsonActionInstance(AMJsonSignal * aJsonSignal, qint32 type, QString action) = 0;
};

#endif // IAMJSONACTIONFACTORY_H
