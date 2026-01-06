#ifndef AMJSONENABLERACTION_H
#define AMJSONENABLERACTION_H

#include "core/types.h"
#include "amjsonaction.h"
#include "defs.h"

class AMJsonAction;

class AMJsonEnablerAction : public AMJsonAction
{
    Q_OBJECT

public:
    explicit AMJsonEnablerAction(AMJsonProtocol * aJsonProtocol, core::QString action, AMJsonAction * parent = nullptr);

    //WARNING: connect the enabled signals and protocols
    //just after all of them are inserted in the model.
    void connect2EnabledDisabled(void);

    void process(QObject * sender, core::QVariant extractedCANsignal);

signals:

    void enableDisableConnected(bool OnOff);
};

#endif // AMJSONENABLERACTION_H
