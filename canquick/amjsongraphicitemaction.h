#ifndef AMJSONGRAPHICITEMACTION_H
#define AMJSONGRAPHICITEMACTION_H

#include "core/types.h"
#include <QObject>

#include "defs.h"
#include "amjsonaction.h"
#include "amjsonargumentaction.h"
#include "ialertdisplay.h"

class AMJsonAction;
class AMJsonArgumentAction;

class AMJsonSignal;
class IAlertDisplay;


class AMJsonGraphicItemAction: public AMJsonAction
{
    Q_OBJECT

public:

    static AMJsonGraphicItemAction * getInstance(AMJsonProtocol * aJsonProtocol, core::QString action);

    static AMJsonGraphicItemAction * getInstanceByItemID(DISPLAY_ITEM_ID aGraphicItemID);

    void process(QObject * sender, core::QVariant extractedCANsignal);

    bool setSupplimentary(core::QVariant extractedCANsignal);

    bool getIsActived(void);


    //TODO: For code reliability, verify that is not connected more than once!
    //NOTE: graphicItem signal appears at most once for one DISPLAY_GRAPHIC_ITEM.
    void connect2Arguments(AMJsonArgumentAction * argumentSignal);
    void setCalledWithFixedArgument(bool isArgOfStringType);


public slots:
    void argumentComplete(uint8_t intArg, uint8_t fracArg, uint8_t unitArg);
    void argumentComplete(core::QString strArg);
    void forceDeactivation(void);

private:

    explicit AMJsonGraphicItemAction(AMJsonProtocol * aJsonProtocol, DISPLAY_ITEM_ID aGraphicItemID, core::QString action, AMJsonAction * parent = nullptr);

    void deactivate(void);

    void activate(bool do_reactivate = false);


    DISPLAY_ITEM_ID itsGraphicItemID;

    bool hasArguments;
    bool areArgumentsReceived;
    bool isSupplemented;
    core::QVariant itsSupplimentary;
    core::QList<core::QVariant> itsSuppDomain;

    uint8_t argInt;
    uint8_t argFrac;
    uint8_t argUnits;
    core::QString argStr;

    bool isArgOfStringType;

    IAlertDisplay * itsDisplay;

    static core::QMap<DISPLAY_ITEM_ID, AMJsonGraphicItemAction *> itsObjects;

    core::QList<QObject *> activators;
};

#endif // AMJSONGRAPHICITEMACTION_H
