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

    core::QString getName(void);

    AMJsonProtocol * itsProtocol;

    bool getIsEnabled(void) {return disablers.isEmpty();}

    void process(core::QVariant pureExtractedCANsignal);
    void process(core::QVariant pureExtractedCANsignal, core::QVariant extractedSupCANsignal);

    void deactivateAllGraphicItems(void);

    void triggerAllDisablers(void);

    Signal * getCanDbSignal(void);
    Signal * getCanDbSupSignal(void);
    bool getIsSupplemented(void){return isSupplementedSignalEntry;}

    void setItsCanDbSignal(Signal * canSignalPtr);

    void setItsCanSecDbSignal(Signal * canSignalPtr);

    core::QString getItsSupName(void);

    static  AMJsonSignal * getByIndex(uint32_t idx);

    uint32_t getItsIndex(void);


    //TODO: remove
    core::QString action;

    //TODO: move two following statements to private section
    bool polarity;
    action_type_e type;
    core::QList<int32_t> * trueValues;//actual, when is not boolean
    set_ops_t trueValuesOp;
    ssize_t index;//NOTE: used on distributed multiple bytes arguments

    AMJsonAction * getItsAction(void){return itsValueTable ? nullptr : itsAction;}


    bool extractSetUnsetAction(core::QVariant extractedCANsignal, bool * do_active);

public slots:

    void enableDisableThis(bool OnOff);

private:

  uint32_t poolIndex;
  static core::QMap<uint32_t, AMJsonSignal *> objectsPool;

  AMJsonAction * itsAction;

  std::unordered_map<double, IAMJsonProcessable *> * itsValueTable;
  IAMJsonProcessable * activatedAction;

  void setActivatedAction(IAMJsonProcessable * anAction){activatedAction = anAction;}

  core::QList<int32_t> * extractSetValuesField( core::JsonObject signal_obj, core::QString fieldName, set_ops_t * a_set_op);

  bool getDomainValidity(core::QVariant extractedSupCANsignal);

  IAMJsonProcessable * getActivatedAction(void){return activatedAction;}

  IAMJsonActionFactory * itsAMJsonActionFactory;

  void init(AMJsonProtocol * aProtocol, core::QString itsName, core::QString itsSupName, core::QString action, bool polarity, core::QString type,ssize_t index, set_ops_t trueValuesOp, core::QList<int32_t> * trueValues, set_ops_t trueDomainOp, core::QList<int32_t> * trueDomainValues, bool isValueTable);
  void setSmoothing(uint32_t bufferLength, uint32_t skipSmoothingDelta, core::QString smoothingType);

  core::QString itsName;

  core::QString itsSupName;

  bool isSupplementedSignalEntry;

  set_ops_t itsDomainSetOp;
  core::QList<int32_t> * itsDomainTrueValues;


  core::QList<QObject *> disablers;

  Signal itsCanDbSignal;
  Signal itsSecondCanDbSignal;

};

#endif // AMJSONSIGNAL_H
