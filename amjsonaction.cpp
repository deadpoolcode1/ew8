#include "amjsonaction.h"
#include "amjsonsignal.h"

AMJsonAction::AMJsonAction(AMJsonSignal * aJsonSignal, QString anAction, QObject *parent) : QObject(parent)
{
  action = anAction;
  itsCANSignal = aJsonSignal;
}

AMJsonSignal * AMJsonAction::getItsJsonSignal(void)
{
    return itsCANSignal;
}

 QString AMJsonAction::getActionName(void)
 {
     return action;
 }


