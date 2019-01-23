#include "amjsonenableraction.h"
#include "amjsonprotocol.h"
#include "amjsonsignal.h"

class AMJsonProtocol;
class AMJsonSignal;

AMJsonEnablerAction::AMJsonEnablerAction(AMJsonSignal * aJsonSignal, QString action, AMJsonAction * parent): AMJsonAction(aJsonSignal, action, parent)
{

}

void AMJsonEnablerAction::connect2EnabledDisabled(void)
{
    //NOTE:Enablers to enablers are not be permitted, to avoid recoursion.
    //     Enablers do not enable/disable "itsProtocol".
        AMJsonProtocol * prot = getItsJsonSignal()->itsProtocol->itsModel->getProtocol(action);

        if(prot&&(prot != getItsJsonSignal()->itsProtocol)){
            connect(this,SIGNAL(enableDisableConnected(bool)),prot,SLOT(enableDisableThis(bool)));
        }

        QList<AMJsonSignal *> jsonSigList = getItsJsonSignal()->itsProtocol->getSignalEntries(action);

        foreach(AMJsonSignal * jsig, jsonSigList)
        {
            if(AMJsonSignal::Enabler != jsig->type)
            {
                connect(this,SIGNAL(enableDisableConnected(bool)),jsig,SLOT(enableDisableThis(bool)));
            }
        }

        emit enableDisableConnected(false);

}

void AMJsonEnablerAction::process(QVariant extractedCANsignal)
{
       emit enableDisableConnected(extractedCANsignal.toBool());
}
