#include "amjsonenableraction.h"
#include "amjsonprotocol.h"
#include "amjsonsignal.h"

class AMJsonProtocol;
class AMJsonSignal;

AMJsonEnablerAction::AMJsonEnablerAction(AMJsonProtocol * aJsonProtocol, const String& action, AMJsonAction * parent): AMJsonAction(aJsonProtocol, Enabler, action, parent)
{
/*empty*/
}

void AMJsonEnablerAction::connect2EnabledDisabled(void)
{
    //NOTE:Enablers to enablers are not be permitted, to avoid recoursion.
    //     Enablers do not enable/disable "itsProtocol".
        AMJsonProtocol * prot = getItsJsonProtocol()->itsModel->getProtocol(getActionName());

        if(prot&&(prot != getItsJsonProtocol())){
            connect(this,SIGNAL(enableDisableConnected(bool)),prot,SLOT(enableDisableThis(bool)));
        }

        QList<AMJsonSignal *> jsonSigList = getItsJsonProtocol()->getSignalEntries(getActionName());

        foreach(AMJsonSignal * jsig, jsonSigList)
        {
            if(Enabler != jsig->type)
            {
                connect(this,SIGNAL(enableDisableConnected(bool)),jsig,SLOT(enableDisableThis(bool)));
            }
        }

        emit enableDisableConnected(false);

}

void AMJsonEnablerAction::process(QObject * /*sender*/, QVariant extractedCANsignal)
{
       emit enableDisableConnected(extractedCANsignal.toBool());
}
