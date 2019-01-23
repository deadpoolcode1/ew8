#ifndef AMJSONARGUMENTACTION_H
#define AMJSONARGUMENTACTION_H

#include <QObject>

#include "defs.h"

#include "amjsonaction.h"

class AMJsonAction;

class AMJsonArgumentAction : public AMJsonAction
{
public:
    explicit AMJsonArgumentAction(AMJsonSignal * aJsonSignal, QString action, AMJsonAction * parent = nullptr);

    //NOTE: default index value (0)
    void setIndex(ssize_t anIndex) {itsIndex = anIndex;}

    virtual void process(QVariant extractedCANsignal) = 0;

protected:

    DISPLAY_ITEM_ID itsGraphicItemID;
    ssize_t itsIndex;

};

#endif // AMJSONARGUMENTACTION_H
