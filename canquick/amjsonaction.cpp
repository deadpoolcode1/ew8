#include "amjsonaction.h"
#include "amjsonsignal.h"

AMJsonAction::AMJsonAction(AMJsonProtocol * aJsonProtocol, action_type_e aType, core::QString anAction, QObject *parent) : QObject(parent)
{
  action = anAction;
  itsProtocol = aJsonProtocol;
  type = aType;
}


bool AMJsonAction::setSupplimentary(core::QVariant)
{
    return false;
}

AMJsonProtocol * AMJsonAction::getItsJsonProtocol(void)
{
    return itsProtocol;
}

 core::QString AMJsonAction::getActionName(void)
 {
     return action;
 }

action_type_e AMJsonAction::getActionType(void)
{
  return type;
}

