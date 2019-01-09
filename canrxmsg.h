#ifndef CANRXMSG_H
#define CANRXMSG_H

#include "icanrxmsgfactory.h"
#include "ialertdisplay.h"
#include "defs.h"

#include "canmanager.h"

#include "amjsonprotocol.h"

class CanManager;

class IAlertDisplay;
class ICanRxMsgFactory;

class AMJsonProtocol;

class CanRxMsg
{
public:

    static void initCanRxMsgsPool(ICanRxMsgFactory * anICanRxMsgFactory, IAlertDisplay *anAlertDisplay, AMSignalsModel * amSignalsModel);
    static CanRxMsg * getMsgByCanId(can_id_t cid);

    //TODO: 1) move the method usage to the ICanRxMsgFactory.
    //TODO: 2) generalize CanRxMsg instances to SimpleCanRxMsg and SmartCanRxMsg.
    void setCanID(can_id_t canID);
    void setItsJsonProtocol(AMJsonProtocol * aJsonProtocol);

    //NOTE: depends on JSON and DBC already parsed
    void initCanJsonSignalsListInProcessOrder(void);

    virtual void process(struct can_frame * frame) = 0;
    virtual void ack(CanManager * canMngr) = 0;

private:
  static CanRxMsg * CanRxMsgsPool[CAN_MESSAGES_TYPES_NUM];
  static size_t canRxMsgNumOfObjects;
  static CanRxMsg * createInstance(can_id_t cid, AMSignalsModel * model);
  static ICanRxMsgFactory * iCanRxMsgFactory;
  can_id_t cid;

protected:
  CanRxMsg();

  can_id_t getCanID(void);

  AMJsonProtocol * itsJsonProtocol;

  struct can_frame prev_frame; //NOTE: is not initialized till first frame is received.
  bool is_a_first_frame;

  Signal * canSignalsArray;
  size_t canSignalsArray_size;

  QList<AMJsonSignal *> canJsonSignalsListInProcessOrder;
};

#endif // CANRXMSG_H
