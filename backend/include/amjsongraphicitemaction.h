#ifndef AMJSONGRAPHICITEMACTION_H
#define AMJSONGRAPHICITEMACTION_H

#include "core/types.h"

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
public:

    static AMJsonGraphicItemAction * getInstance(AMJsonProtocol * aJsonProtocol, const String& action);

    static AMJsonGraphicItemAction * getInstanceByItemID(DISPLAY_ITEM_ID aGraphicItemID);

    void process(void * sender, Variant extractedCANsignal);

    bool setSupplimentary(Variant extractedCANsignal);

    bool getIsActived(void);


    //TODO: For code reliability, verify that is not connected more than once!
    //NOTE: graphicItem signal appears at most once for one DISPLAY_GRAPHIC_ITEM.
    void connect2Arguments(AMJsonArgumentAction * argumentSignal);
    void setCalledWithFixedArgument(bool isArgOfStringType);

    void argumentComplete(uint8_t intArg, uint8_t fracArg, uint8_t unitArg);
    void argumentComplete(const String& strArg);
    void forceDeactivation(void);

private:

    explicit AMJsonGraphicItemAction(AMJsonProtocol * aJsonProtocol, DISPLAY_ITEM_ID aGraphicItemID, const String& action);

    void deactivate(void);

    void activate(bool do_reactivate = false);


    DISPLAY_ITEM_ID itsGraphicItemID;

    bool hasArguments;
    bool areArgumentsReceived;
    bool isSupplemented;
    Variant itsSupplimentary;
    List<Variant> itsSuppDomain;

    uint8_t argInt;
    uint8_t argFrac;
    uint8_t argUnits;
    String argStr;

    bool isArgOfStringType;

    IAlertDisplay * itsDisplay;

    static Map<DISPLAY_ITEM_ID, AMJsonGraphicItemAction *> itsObjects;

    List<void *> activators;
};

#endif // AMJSONGRAPHICITEMACTION_H
