#ifndef CANRXMSG_H
#define CANRXMSG_H

#include "icanrxmsgfactory.h"
#include "ialertdisplay.h"
#include "defs.h"

#include "canmanager.h"

class IAlertDisplay;
class ICanRxMsgFactory;

class CanRxMsg
{
public:

    static void initCanRxMsgsPool(ICanRxMsgFactory * anICanRxMsgFactory, IAlertDisplay *anAlertDisplay);
    static CanRxMsg * getMsgByCanId(can_id_t cid);
    void setDisplay(IAlertDisplay *anAlertDisplay);
    can_id_t getCanId(void);

    virtual void process(struct can_frame * frame) = 0;
    virtual void ack(void) = 0;

private:
  static CanRxMsg * CanRxMsgsPool[CAN_MESSAGES_TYPES_NUM];
  static size_t canRxMsgNumOfObjects;
  static CanRxMsg * createInstance(can_id_t cid);
  static ICanRxMsgFactory * iCanRxMsgFactory;

protected:
  CanRxMsg();
  can_id_t cid;
  IAlertDisplay * alertsDisplay;

  struct can_frame prev_frame; //NOTE: is not initialized till first frame is received.
  bool is_a_first_frame;

};

#endif // CANRXMSG_H
