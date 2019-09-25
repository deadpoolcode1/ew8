#ifndef CANRXMSG_H
#define CANRXMSG_H

#include "icanrxmsgfactory.h"
#include "ialertdisplay.h"
#include "defs.h"

#include "canmanager.h"

#include "amjsonprotocol.h"
#include "candbsignal.h"

class CanManager;

class IAlertDisplay;
class ICanRxMsgFactory;

class AMJsonProtocol;

class CanRxMsg
{
public:

    static void initCanRxMsgsPool(ICanRxMsgFactory * anICanRxMsgFactory, AMSignalsModel * amSignalsModel);
    static void completeInitCanRxMsgsPool(void);
    static CanRxMsg * createInstance(quint32 StdId);
    static CanRxMsg * getMsgByCanId(quint32 std_id);
    //TODO: 1) move the method usage to the ICanRxMsgFactory.
    //TODO: 2) generalize CanRxMsg instances to SimpleCanRxMsg and SmartCanRxMsg.
    void applyCanDBSignalsArray(QList<Signal *> * canDBSignals);
    void setItsJsonProtocol(AMJsonProtocol * aJsonProtocol);

    Signal * getCANSignalByName(QString name);

    //NOTE: depends on JSON and DBC already parsed
    void initCanJsonSignalsListInProcessOrder(void);

    virtual void process(struct can_frame * frame) = 0;
    virtual void ack(CanManager * canMngr) = 0;

    static  const QList<CanStdId_t> & getMsgsWhiteList(void);

private:
  //Uses StdId as the key
  static QMap<CanStdId_t, CanRxMsg *> CanRxMsgsPool;
  static QList<CanStdId_t> msgsWhiteList;
  static ICanRxMsgFactory * iCanRxMsgFactory;
  static AMSignalsModel * itsAMSignalsModel;


protected:
  CanRxMsg();

  quint32 getCanID(void);

  AMJsonProtocol * itsJsonProtocol;

#if 0
  //WARNING: not in use
  quint32 StdID;
#endif

  canrxmsg_type_t itsMsgType;

  //WARNING: Used to initialize canJsonSignalsListInProcessOrder
  QList<Signal *> * canSignalsArray;

  QList<AMJsonSignal *> canJsonSignalsListInProcessOrder;
};

#endif // CANRXMSG_H
