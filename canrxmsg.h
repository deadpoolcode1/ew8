#ifndef CANRXMSG_H
#define CANRXMSG_H

#include "icanrxmsgfactory.h"
#include "ialertdisplay.h"
#include "defs.h"

#include "canmanager.h"

#include "amjsonprotocol.h"
#include "candbsignal.h"

#include <QDataStream>

class CanManager;

class IAlertDisplay;
class ICanRxMsgFactory;

class AMJsonProtocol;
class MeDisconnectionReport;

class CanRxMsg
{
public:

    static void initCanRxMsgsPool(ICanRxMsgFactory * anICanRxMsgFactory, AMSignalsModel * amSignalsModel);
    static void completeInitCanRxMsgsPool(void);
    static void setItsDisconnectionReport(MeDisconnectionReport * aDisconnectionReport);

    static CanRxMsg * createInstance(quint32 StdId);
    static CanRxMsg * getMsgByCanId(quint32 std_id);
    //TODO: 1) move the method usage to the ICanRxMsgFactory.
    //TODO: 2) generalize CanRxMsg instances to SimpleCanRxMsg and SmartCanRxMsg.
    void applyCanDBSignalsArray(QList<Signal *> * canDBSignals);
    void setItsJsonProtocol(AMJsonProtocol * aJsonProtocol);

    Signal * getCANSignalByName(QString name);

    //NOTE: depends on JSON and DBC already parsed
    void initCanJsonSignalsListInProcessOrder(void);

    virtual void process(struct can_frame * frame);
    virtual void ack(CanManager * canMngr);

    static  const QList<CanStdId_t> & getMsgsWhiteList(void);
    static bool saveToStorage(void);
    static bool loadFromStorage(void);
    static void forceDBCParsing(void);
    static void expectRequestId(quint16 requestId);
    static void receiveRequestIdByteLSB(quint8 aByte);
    static void receiveRequestIdByteMSB(quint8 aByte);
    static void discardRequestId(void);

    //TODO: make readonly property
    static bool isAlreadyLoaded;

    void canRxJsonSignalsParseAndProcess(struct can_frame * frame);

private:
  static bool isRequestSent;
  static quint16 requestId;
  static bool isRequestIdLSBByteReceived;
  static bool isDBCParsingForced;
  //Uses StdId as the key
  static QMap<CanStdId_t, CanRxMsg *> CanRxMsgsPool;
  static QList<CanStdId_t> msgsWhiteList;
  static ICanRxMsgFactory * iCanRxMsgFactory;
  static AMSignalsModel * itsAMSignalsModel;
  static MeDisconnectionReport * itsDisconnectionReport;

  friend class CanRxMsgFactory;




protected:
  CanRxMsg();

  quint32 getCanID(void);

  QString itsJsonProtocolName;
  AMJsonProtocol * itsJsonProtocol;

  //WARNING: Used to initialize canJsonSignalsListInProcessOrder
  QList<Signal *> * canSignalsArray;

  QList<AMJsonSignal *> canJsonSignalsListInProcessOrder;

  QList<Signal> canJsonSignalsPoolIdxInProcessOrder;

  friend QDataStream & operator<< (QDataStream &out, const CanRxMsg &any);
  friend QDataStream & operator>> (QDataStream &in, CanRxMsg &any);
};

extern QDataStream & operator<< (QDataStream &out, const CanRxMsg & any);
extern QDataStream & operator>> (QDataStream &in, CanRxMsg &any);

#endif // CANRXMSG_H
