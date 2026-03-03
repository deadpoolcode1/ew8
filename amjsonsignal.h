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

    String getName(void);

    AMJsonProtocol * itsProtocol;

    bool getIsEnabled(void) {return disablers.empty();}

    void process(Variant pureExtractedCANsignal);
    void process(Variant pureExtractedCANsignal, Variant extractedSupCANsignal);

    void deactivateAllGraphicItems(void);

    void triggerAllDisablers(void);

    Signal * getCanDbSignal(void);
    Signal * getCanDbSupSignal(void);
    bool getIsSupplemented(void){return isSupplementedSignalEntry;}

    void setItsCanDbSignal(Signal * canSignalPtr);

    void setItsCanSecDbSignal(Signal * canSignalPtr);

    String getItsSupName(void);

    static  AMJsonSignal * getByIndex(uint32_t idx);

    uint32_t getItsIndex(void);


    //TODO: remove
    String action;

    //TODO: move two following statements to private section
    bool polarity;
    action_type_e type;
    List<int32_t> * trueValues;//actual, when is not boolean
    set_ops_t trueValuesOp;
    ssize_t index;//NOTE: used on distributed multiple bytes arguments

    AMJsonAction * getItsAction(void){return itsValueTable ? nullptr : itsAction;}


    bool extractSetUnsetAction(Variant extractedCANsignal, bool * do_active);

public slots:

    void enableDisableThis(bool OnOff);

private:

  uint32_t poolIndex;
  static Map<uint32_t, AMJsonSignal *> objectsPool;

  AMJsonAction * itsAction;

  std::unordered_map<double, IAMJsonProcessable *> * itsValueTable;
  IAMJsonProcessable * activatedAction;

  void setActivatedAction(IAMJsonProcessable * anAction){activatedAction = anAction;}

  List<int32_t> * extractSetValuesField( core::JsonObject signal_obj, const String& fieldName, set_ops_t * a_set_op);

  bool getDomainValidity(Variant extractedSupCANsignal);

  IAMJsonProcessable * getActivatedAction(void){return activatedAction;}

  IAMJsonActionFactory * itsAMJsonActionFactory;

  void init(AMJsonProtocol * aProtocol, const String& itsName, const String& itsSupName, const String& action, bool polarity, const String& type, ssize_t index, set_ops_t trueValuesOp, List<int32_t> * trueValues, set_ops_t trueDomainOp, List<int32_t> * trueDomainValues, bool isValueTable);
  void setSmoothing(uint32_t bufferLength, uint32_t skipSmoothingDelta, const String& smoothingType);

  String itsName;

  String itsSupName;

  bool isSupplementedSignalEntry;

  set_ops_t itsDomainSetOp;
  List<int32_t> * itsDomainTrueValues;


  List<QObject *> disablers;

  Signal itsCanDbSignal;
  Signal itsSecondCanDbSignal;

};

#endif // AMJSONSIGNAL_H
