#ifndef AMJSONENABLERACTION_H
#define AMJSONENABLERACTION_H

#include "amjsonaction.h"
#include "defs.h"
#include "core/types.h"
#include "core/signal.h"

class AMJsonAction;

class AMJsonEnablerAction : public AMJsonAction
{
public:
    explicit AMJsonEnablerAction(AMJsonProtocol * aJsonProtocol, const String& action);

    //WARNING: connect the enabled signals and protocols
    //just after all of them are inserted in the model.
    void connect2EnabledDisabled(void);

    void process(void * sender, Variant extractedCANsignal);

    core::Signal<bool> enableDisableConnected;
};

#endif // AMJSONENABLERACTION_H
