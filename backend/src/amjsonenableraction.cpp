#include "amjsonenableraction.h"
#include "amjsonprotocol.h"
#include "amjsonsignal.h"

class AMJsonProtocol;
class AMJsonSignal;

AMJsonEnablerAction::AMJsonEnablerAction(AMJsonProtocol * aJsonProtocol, const String& action): AMJsonAction(aJsonProtocol, Enabler, action)
{
/*empty*/
}

void AMJsonEnablerAction::connect2EnabledDisabled(void)
{
    //NOTE:Enablers to enablers are not be permitted, to avoid recoursion.
    //     Enablers do not enable/disable "itsProtocol".
        AMJsonProtocol * prot = getItsJsonProtocol()->itsModel->getProtocol(getActionName());

        if(prot&&(prot != getItsJsonProtocol())){
            enableDisableConnected.connect([prot, this](bool onOff){ prot->enableDisableThis(this, onOff); });
        }

        List<AMJsonSignal *> jsonSigList = getItsJsonProtocol()->getSignalEntries(getActionName());

        for (AMJsonSignal * jsig : jsonSigList)
        {
            if(Enabler != jsig->type)
            {
                enableDisableConnected.connect([jsig, this](bool onOff){ jsig->enableDisableThis(this, onOff); });
            }
        }

        enableDisableConnected.fire(false);

}

void AMJsonEnablerAction::process(void * /*sender*/, Variant extractedCANsignal)
{
       enableDisableConnected.fire(variantToBool(extractedCANsignal));
}
