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

    static void initCanRxMsgsPool(ICanRxMsgFactory * anICanRxMsgFactory, IAlertDisplay *anAlertDisplay);
    static CanRxMsg * getMsgByCanId(can_id_t cid);
    void setDisplay(IAlertDisplay *anAlertDisplay);

    virtual void process(struct can_frame * frame) = 0;
    virtual void ack(CanManager * canMngr) = 0;

private:
  static CanRxMsg * CanRxMsgsPool[CAN_MESSAGES_TYPES_NUM];
  static size_t canRxMsgNumOfObjects;
  static CanRxMsg * createInstance(can_id_t cid);
  static ICanRxMsgFactory * iCanRxMsgFactory;
  can_id_t cid;

protected:
  CanRxMsg();
  void setCanID(can_id_t canID);
  can_id_t getCanID(void);


  IAlertDisplay * alertsDisplay;

  AMJsonProtocol * itsJsonProtocol;

  struct can_frame prev_frame; //NOTE: is not initialized till first frame is received.
  bool is_a_first_frame;

  Signal * canSignalsArray;
  size_t canSignalsArray_size;

};

#endif // CANRXMSG_H
