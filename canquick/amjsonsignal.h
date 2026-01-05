#ifndef AMJSONSIGNAL_H
#define AMJSONSIGNAL_H

#include "defs.h"
#include "core/types.h"

#include <QObject>

#include "amjsonprotocol.h"
#include "core/json.h"

#include "ialertdisplay.h"

#include "amjsonaction.h"

#include "iamjsonactionfactory.h"

class AMJsonAction;

class IAMJsonActionFactory;

class AMSignalsModel;

class AMJsonProtocol;

class IAlertDisplay;

class AMJsonSignal: public QObject
{
    Q_OBJECT

public:

    //TODO split to oop-pattern

    AMJsonSignal(AMJsonProtocol * aProtocol, core::JsonValue singleSignalsEntry, QObject * parent = nullptr);

    QString getName(void);

    AMJsonProtocol * itsProtocol;

    bool getIsEnabled(void) {return disablers.isEmpty();}

    void process(QVariant pureExtractedCANsignal);
    void process(QVariant pureExtractedCANsignal, QVariant extractedSupCANsignal);

    void deactivateAllGraphicItems(void);

    void triggerAllDisablers(void);

    Signal * getCanDbSignal(void);
    Signal * getCanDbSupSignal(void);
    bool getIsSupplemented(void){return isSupplementedSignalEntry;}

    void setItsCanDbSignal(Signal * canSignalPtr);

    void setItsCanSecDbSignal(Signal * canSignalPtr);

    QString getItsSupName(void);

    static  AMJsonSignal * getByIndex(quint32 idx);

    quint32 getItsIndex(void);


    //TODO: remove
    QString action;

    //TODO: move two following statements to private section
    bool polarity;
    action_type_e type;
    QList<qint32> * trueValues;//actual, when is not boolean
    set_ops_t trueValuesOp;
    ssize_t index;//NOTE: used on distributed multiple bytes arguments

    AMJsonAction * getItsAction(void){return itsValueTable ? nullptr : itsAction;}


    bool extractSetUnsetAction(QVariant extractedCANsignal, bool * do_active);

public slots:

    void enableDisableThis(bool OnOff);

private:

  quint32 poolIndex;
  static QMap<quint32, AMJsonSignal *> objectsPool;

  AMJsonAction * itsAction;

  std::unordered_map<double, IAMJsonProcessable *> * itsValueTable;
  IAMJsonProcessable * activatedAction;

  void setActivatedAction(IAMJsonProcessable * anAction){activatedAction = anAction;}

  QList<qint32> * extractSetValuesField( core::JsonObject signal_obj, QString fieldName, set_ops_t * a_set_op);

  bool getDomainValidity(QVariant extractedSupCANsignal);

  IAMJsonProcessable * getActivatedAction(void){return activatedAction;}

  IAMJsonActionFactory * itsAMJsonActionFactory;

  void init(AMJsonProtocol * aProtocol, QString itsName, QString itsSupName, QString action, bool polarity, QString type,ssize_t index, set_ops_t trueValuesOp, QList<qint32> * trueValues, set_ops_t trueDomainOp, QList<qint32> * trueDomainValues, bool isValueTable);
  void setSmoothing(quint32 bufferLength, quint32 skipSmoothingDelta, QString smoothingType);

  QString itsName;

  QString itsSupName;

  bool isSupplementedSignalEntry;

  set_ops_t itsDomainSetOp;
  QList<qint32> * itsDomainTrueValues;


  QList<QObject *> disablers;

  Signal itsCanDbSignal;
  Signal itsSecondCanDbSignal;

};

#endif // AMJSONSIGNAL_H
