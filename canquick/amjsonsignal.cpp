#include "amjsonsignal.h"

#include "amsignalsmodel.h"

#include "canstringargumentsaccumulator.h"

#include "canintargumentsaccumulator.h"

#include "graphicitemsenummap.h"

#include "candbsignal.h"

#include "bufferedsmoother.h"
#include "timedsmoother.h"

#include "core/core.h"

#include <QMetaEnum>

#include "core/json.h"

#include <QObject>

class CanStringArgumentsAccumulator;
class CanIntArgumentsAccumulator;

core::QMap<uint32_t,AMJsonSignal *> AMJsonSignal::objectsPool;

core::QList<int32_t> * AMJsonSignal::extractSetValuesField( core::JsonObject signal_obj, core::QString fieldName, set_ops_t * a_set_op)
{

      core::QList<int32_t> * trueValues = nullptr;
      * a_set_op = set_op_na;

    if(signal_obj.contains(fieldName.toStdString()))
    {
        trueValues = new core::QList<int32_t>();

        if (signal_obj[fieldName.toStdString()].isArray()){

            core::JsonArray trueValues_Array = signal_obj[fieldName.toStdString()].toArray();

            if (trueValues_Array[0].isString())
            {
                core::QString opString = core::QString(trueValues_Array[0].toString());
                if("gt" == opString)
                {
                    * a_set_op = set_op_gt;
                }
                else if ("ge" == opString)
                {
                    * a_set_op = set_op_ge;
                }
                else if ("lt" == opString)
                {
                    * a_set_op = set_op_lt;
                }
                else if ("le" == opString)
                {
                    * a_set_op = set_op_le;
                }
                else
                {
                    coreDebug() << "Set: operation type error";
                }

                trueValues->append(trueValues_Array[1].toInt(0));


            }
            else
            {
                   * a_set_op = set_op_or;

                for(const core::JsonValue & value : trueValues_Array)
                {
                    trueValues->append(value.toInt(0));
                }
            }


        }
        else
        {
            int32_t sigTrueValue = signal_obj["Set"].toInt(0);
            * a_set_op = set_op_or;
            trueValues->append(sigTrueValue);
        }
    }
    return trueValues;
}

AMJsonSignal::AMJsonSignal(AMJsonProtocol * aProtocol, core::JsonValue singleSignalsEntry, QObject * parent) : QObject(parent)
{

    //Signal row parsing:
    core::JsonObject signal_obj = singleSignalsEntry.toObject();
    core::QString sigName;
    core::QString supName = "";
    core::QString sigAction;
    core::QString sigType;
    bool polarity = true;
    int32_t sigIndex = -1;
    bool isValueTable = false;

    activatedAction = nullptr;

    core::JsonValue sigNameJsonValue = signal_obj["name"];

    isSupplementedSignalEntry = (sigNameJsonValue.isArray());
     core::QList<int32_t> * domainTrueValues = nullptr;
     set_ops_t a_domain_set_op = set_op_na;

    if(isSupplementedSignalEntry)
    {
        sigName = core::QString(sigNameJsonValue.toArray().at(0).toString());
        supName = core::QString(sigNameJsonValue.toArray().at(1).toString());
        domainTrueValues = extractSetValuesField(signal_obj, "Domain", & a_domain_set_op);
    }
    else
    {

        sigName = core::QString(sigNameJsonValue.toString());
    }


    //Action parsing:
    if (signal_obj["action"].isArray())
    {
        core::JsonArray actionArray = signal_obj["action"].toArray();

        sigAction = core::QString(actionArray[0].toString());
        if ("inverted" == core::QString(actionArray[1].toString()))
        {
            polarity = false;
        }
    }
    else
    {
        sigAction = core::QString(signal_obj["action"].toString());
    }
    //end of Action parsing

    sigType =  core::QString(signal_obj["type"].toString());

    sigIndex = signal_obj["index"].toInt(-1);

    uint32_t bufferLength = 0;
    uint32_t skipSmoothingDelta = 0;
    core::QString smoothingType;

    //>>>>Smoothing parameters handling(for IntArgument)<<<<<<
    core::JsonValue smoothedVal = signal_obj["smoothed"];

    if( !smoothedVal.isUndefined() && smoothedVal.isArray())
    {
            core::JsonArray sigSmoothed_Array = smoothedVal.toArray();
            bufferLength = (uint32_t)sigSmoothed_Array.at(0).toInt(0);
            skipSmoothingDelta = (uint32_t)sigSmoothed_Array.at(1).toInt(0);
            smoothingType = core::QString(sigSmoothed_Array.at(2).toString("items"));
            coreDebug()<<"smoothing type: "<< smoothingType;
    }




    //WARNING: Polarity suitable only for single decision type(boolean or sets) signals
    if(polarity)
    {
        if(-1 == sigIndex)
        {
              //Used properties: (aProtocol, sigName, sigAction, sigType)

                //Find is a value table:


                if(!signal_obj.contains("isValueTable"))
                {
                   isValueTable = false;
                }
                else
                {
                   isValueTable = signal_obj["isValueTable"].toBool(false);
                }



                init(aProtocol, sigName, supName, sigAction, true, sigType, -1, set_op_na, nullptr, a_domain_set_op, domainTrueValues, isValueTable);
        }
        else
        {
            //Used properties (argument signal) : (aProtocol, sigName, sigAction, sigType, sigIndex)
             init(aProtocol, sigName, supName, sigAction, true, sigType, sigIndex, set_op_na, nullptr, a_domain_set_op, domainTrueValues, false);

             if(bufferLength > 0)
             {
                setSmoothing(bufferLength, skipSmoothingDelta, smoothingType);
             }
        }
    }



    if(!isValueTable && (-1 == sigIndex))
    {

        set_ops_t a_set_op = set_op_na;
        core::QList<int32_t> * sigTrueValues = extractSetValuesField(signal_obj, "Set", & a_set_op);
        init(aProtocol, sigName, supName, sigAction, polarity, sigType, -1, a_set_op, sigTrueValues,   a_domain_set_op, domainTrueValues, false);
    }

    poolIndex = objectsPool.size();
    objectsPool.insert(poolIndex,this);
}

AMJsonSignal * AMJsonSignal::getByIndex(uint32_t idx)
{
    AMJsonSignal * ret;
    ret = objectsPool.value(idx, nullptr);
    return ret;
}

uint32_t AMJsonSignal::getItsIndex(void)
{
    return poolIndex;
}

core::QString AMJsonSignal::getItsSupName(void)
{
    return itsSupName;
}

void AMJsonSignal::init(AMJsonProtocol * aProtocol, core::QString aName, core::QString aSupName, core::QString anAction, bool aPolarity, core::QString aType, ssize_t anIndex, set_ops_t  a_set_op, core::QList<int32_t> * aTrueValues,  set_ops_t trueDomainOp, core::QList<int32_t> * trueDomainValues, bool isValueTable)
{
    itsValueTable = nullptr;

    itsProtocol = aProtocol;
    itsAMJsonActionFactory = aProtocol->itsModel->getItsAMJsonActionFactory();

    itsName = aName;
    itsSupName = aSupName;

    itsDomainSetOp = trueDomainOp;
    itsDomainTrueValues = trueDomainValues,

    action = anAction;


    index = anIndex;

    polarity = aPolarity;

    trueValuesOp = a_set_op;

    trueValues = aTrueValues;

    if(false ==  isValueTable)
    {
        type = ActionType::fromString(aType);/*(action_type_e)metaEnum.keyToValue(aType.toLatin1());*/
        itsAction = itsAMJsonActionFactory->createAMJsonActionInstance(this->itsProtocol,type,action,index);
    }
    else
    {
        AmJsonActionsMultiplexor * mux = itsProtocol->getMultiplexorByName(action);
        if(nullptr != mux)
        {
            type = (action_type_e)(mux->getItsValuesType());
            itsValueTable = mux->getItsValueTable();
        }

    }

    if(StringArgument == type)
    {
        DISPLAY_ITEM_ID action_disp_id = GraphicItemsEnumMap::getId(action);
        CanStringArgumentsAccumulator::getInstance(action_disp_id)->growTriggeringSize(anIndex);
    }


    itsProtocol->append(this);

    coreDebug() << "JSON: new signal with name" << itsName <<"action: "<< action << "type: "<< type <<" extracted.";

    //TODO use actions map
}

void AMJsonSignal::setSmoothing(uint32_t bufferLength, uint32_t skipSmoothingDelta, core::QString aSmoothingType)
{
    if(IntArgument == type)
    {
        DISPLAY_ITEM_ID action_disp_id = GraphicItemsEnumMap::getId(action);

        ISmoother * smoother = nullptr;

        if ("items" == aSmoothingType)
        {
            smoother = new BufferedSmoother(bufferLength, skipSmoothingDelta);
        }
        else if ("msec" == aSmoothingType)
        {
            smoother = new TimedSmoother(bufferLength, skipSmoothingDelta);
        }
        else
        {
            coreDebug()<<"WARNING: unknown smoothing argument";
        }

        if(nullptr != smoother)
        {
            CanIntArgumentsAccumulator::getInstance(action_disp_id)->addSmoothingAlgorithm(smoother);
        }
    }
}

 core::QString AMJsonSignal::getName(void)
 {
     return itsName;
 }

 Signal * AMJsonSignal::getCanDbSignal(void)
 {
    return &itsCanDbSignal;
 }

 Signal * AMJsonSignal::getCanDbSupSignal(void)
 {
     Signal * ret  = nullptr;
     if (!itsSupName.empty())
     {
         ret = & itsSecondCanDbSignal;
     }
     return ret;
 }

void AMJsonSignal::setItsCanDbSignal(Signal *canSignalPtr)
{
    itsCanDbSignal.name = canSignalPtr->name;
    itsCanDbSignal.startByte = canSignalPtr->startByte;
    itsCanDbSignal.startBit = canSignalPtr->startBit;
    itsCanDbSignal.numOfBits = canSignalPtr->numOfBits;
    itsCanDbSignal.sign = canSignalPtr->sign;
    itsCanDbSignal.factor =  canSignalPtr->factor;
    itsCanDbSignal.offset = canSignalPtr->offset;
    itsCanDbSignal.min = canSignalPtr->min;
    itsCanDbSignal.max = canSignalPtr->max;
    itsCanDbSignal.valueType = canSignalPtr->valueType;
}

void AMJsonSignal::setItsCanSecDbSignal(Signal *canSignalPtr)
{
    itsSecondCanDbSignal.name = canSignalPtr->name;
    itsSecondCanDbSignal.startByte = canSignalPtr->startByte;
    itsSecondCanDbSignal.startBit = canSignalPtr->startBit;
    itsSecondCanDbSignal.numOfBits = canSignalPtr->numOfBits;
    itsSecondCanDbSignal.sign = canSignalPtr->sign;
    itsSecondCanDbSignal.factor =  canSignalPtr->factor;
    itsSecondCanDbSignal.offset = canSignalPtr->offset;
    itsSecondCanDbSignal.min = canSignalPtr->min;
    itsSecondCanDbSignal.max = canSignalPtr->max;
    itsSecondCanDbSignal.valueType = canSignalPtr->valueType;
}

 void AMJsonSignal::process(core::QVariant extractedCANsignal, core::QVariant extractedSupCANsignal)
 {

     if(itsProtocol->getIsEnabled()&&this->getIsEnabled())
     {
       if(itsValueTable != nullptr)
       {

           bool is_domain_valid = getDomainValidity(extractedSupCANsignal);

           IAMJsonProcessable * toActivate = nullptr;
           if (is_domain_valid) {
               auto it = itsValueTable->find(extractedCANsignal.toInt());
               if (it != itsValueTable->end()) {
                   toActivate = it->second;
               }
           }

           IAMJsonProcessable * toDeactivate = getActivatedAction();

           bool supUpdated = (toActivate != nullptr && isSupplementedSignalEntry && toActivate->setSupplimentary(extractedSupCANsignal));

           if (toActivate != toDeactivate || (supUpdated))//WARNING: without args only
               //TODO: if args are present compare the args
           {
               if(toDeactivate != nullptr)
               {

                   toDeactivate->process(this, false);

               }

               if(toActivate != nullptr)
               {


                   toActivate->process(this, true);

               }

               setActivatedAction(toActivate);
           }


           //TODO activate the action apropiately
       }
       else
       {
         bool do_activate;
         bool success = extractSetUnsetAction(extractedCANsignal, &do_activate);
         itsAction->process(this, success ? do_activate : extractedCANsignal);
       }
     }
 }

  void AMJsonSignal::process(core::QVariant pureExtractedCANsignal)
  {
      process(pureExtractedCANsignal, core::QVariant(0));
  }

 bool AMJsonSignal::getDomainValidity(core::QVariant extractedSupCANsignal)
 {
     bool ret = true;

     if(extractedSupCANsignal.typeId() == QMetaType::Int && nullptr != (itsDomainTrueValues))
     {
         int32_t desired = extractedSupCANsignal.toInt();
         switch (itsDomainSetOp)
         {
         case set_op_or:
             ret = ((itsDomainTrueValues->contains(desired)) == polarity);
             break;
         case set_op_lt:
             ret = ((itsDomainTrueValues->constFirst() > desired) == polarity);
             break;
         case set_op_le:
             ret = ((itsDomainTrueValues->constFirst() >= desired) == polarity);
             break;
         case set_op_gt:
             ret = ((itsDomainTrueValues->constFirst() < desired) == polarity);
             break;
         case set_op_ge:
             ret = ((itsDomainTrueValues->constFirst() <= desired) == polarity);
             break;
         default:
             coreDebug() << "Domain set operation in not defined.";
             break;
         }

     }

     return ret;

 }

 bool AMJsonSignal::extractSetUnsetAction(core::QVariant extractedCANsignal, bool * do_active)
 {
     bool success = true;

     if (extractedCANsignal.typeId() == QMetaType::Bool)
     {
         bool desired = extractedCANsignal.toBool();
         *do_active = (desired == polarity);
     }
     else if (extractedCANsignal.typeId() == QMetaType::Int && nullptr != (trueValues))
     {
         int32_t desired = extractedCANsignal.toInt();
         switch (trueValuesOp)
         {
         case set_op_or:
             * do_active = ((trueValues->contains(desired)) == polarity);
             break;
         case set_op_lt:
             * do_active = ((trueValues->constFirst() > desired) == polarity);
             break;
         case set_op_le:
             * do_active = ((trueValues->constFirst() >= desired) == polarity);
             break;
         case set_op_gt:
             * do_active = ((trueValues->constFirst() < desired) == polarity);
             break;
         case set_op_ge:
             * do_active = ((trueValues->constFirst() <= desired) == polarity);
             break;
         default:
             coreDebug() << "Set operation in not defined.";
             break;
         }
     }
     else
     {
         //TODO verify on Json Parsing
         success = false;
     }

     return success;

 }

 void AMJsonSignal::enableDisableThis(bool onOff)
 {

     bool is_pre_enabled = disablers.isEmpty();

     if (false == onOff && !disablers.contains(sender()))
     {
         disablers.append(sender());
     }
     else if (true == onOff && disablers.contains(sender()))
     {
         disablers.removeOne(sender());
     }

     bool is_post_enabled = disablers.isEmpty();

     if(is_pre_enabled && !is_post_enabled)
     {
         LOG_DEBUG("Signal %s is %s", qPrintable(itsName), "disabled");
         deactivateAllGraphicItems();
     }
     else if (!is_pre_enabled && is_post_enabled)
     {
         LOG_DEBUG("Signal %s is %s", qPrintable(itsName), "enabled");
     }
 }

 void AMJsonSignal::triggerAllDisablers(void)
 {
     if(Enabler == type)
     {
         if(nullptr == itsValueTable)
         {
             if(nullptr != itsAction)
             {
                 emit ((AMJsonEnablerAction *)itsAction)-> enableDisableConnected(false);
             }
         }
         else
         {
             for (const auto& pair : *itsValueTable)
             {
                 emit ((AMJsonEnablerAction *)pair.second)-> enableDisableConnected(false);
             }
         }
     }
 }


 void AMJsonSignal::deactivateAllGraphicItems(void)
 {
     if(GraphicItem == type)
     {
         if(nullptr == itsValueTable)
         {
             if(nullptr != itsAction)
             {
                 itsAction -> process(this, QVariant(false));
             }
         }
         else
         {
             IAMJsonProcessable * activeAction = getActivatedAction();

             if(nullptr != activeAction)
             {
                 setActivatedAction(nullptr);
                 activeAction->process(this, QVariant(false));
             }
             else
             {
# if 0
                 for (const auto& pair : *itsValueTable)
                 {
                     pair.second -> process(this, QVariant(false));
                 }
#endif
             }
         }
     }
 }







