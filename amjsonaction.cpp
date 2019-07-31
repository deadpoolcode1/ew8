#include "amjsonaction.h"
#include "amjsonsignal.h"

AMJsonAction::AMJsonAction(AMJsonProtocol * aJsonProtocol, action_type_e aType, QString anAction, QObject *parent) : QObject(parent)
{
  action = anAction;
  itsProtocol = aJsonProtocol;
  type = aType;
}

AMJsonProtocol * AMJsonAction::getItsJsonProtocol(void)
{
    return itsProtocol;
}

 QString AMJsonAction::getActionName(void)
 {
     return action;
 }

action_type_e AMJsonAction::getActionType(void)
{
  return type;
}

