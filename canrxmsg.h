#ifndef CANRXMSG_H
#define CANRXMSG_H

#include "icanrxmsgfactory.h"
#include "defs.h"
#include "canrxmsg.h"

class ICanRxMsgFactory;

class CanRxMsg
{
public:

    static void initCanRxMsgsPool(ICanRxMsgFactory * anICanRxMsgFactory);
    static CanRxMsg * getMsgByCanId(can_id_t cid);
    can_id_t getCanId(void);

    virtual void process(void) = 0;
    virtual void ack(void) = 0;

private:
  static CanRxMsg * CanRxMsgsPool[CAN_MESSAGES_TYPES_NUM];
  static size_t CanRxMsgNumOfObjects;
  static CanRxMsg * createInstance(can_id_t cid);
  static ICanRxMsgFactory * iCanRxMsgFactory;

protected:
  CanRxMsg();
  can_id_t cid;

};

#endif // CANRXMSG_H
