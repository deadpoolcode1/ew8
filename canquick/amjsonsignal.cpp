#include "amjsonsignal.h"

#include "amsignalsmodel.h"

#include "canstringargumentsaccumulator.h"

#include "canintargumentsaccumulator.h"

#include "graphicitemsenummap.h"

#include "candbsignal.h"

#include "bufferedsmoother.h"
#include "timedsmoother.h"

#include <qdebug.h>

#include <QMetaEnum>

#include "core/json.h"

#include <QObject>

class CanStringArgumentsAccumulator;
class CanIntArgumentsAccumulator;

QMap<quint32,AMJsonSignal *> AMJsonSignal::objectsPool;

QList<qint32> * AMJsonSignal::extractSetValuesField( core::JsonObject signal_obj, QString fieldName, set_ops_t * a_set_op)
{

      QList<qint32> * trueValues = nullptr;
      * a_set_op = set_op_na;

    if(signal_obj.contains(fieldName.toStdString()))
    {
        trueValues = new QList<qint32>();

        if (signal_obj[fieldName.toStdString()].isArray()){

            core::JsonArray trueValues_Array = signal_obj[fieldName.toStdString()].toArray();

            if (trueValues_Array[0].isString())
            {
                QString opString = QString::fromStdString(trueValues_Array[0].toString());
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
                    qDebug() << "Set: operation type error";
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
            qint32 sigTrueValue = signal_obj["Set"].toInt(0);
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
    QString sigName;
    QString supName = "";
    QString sigAction;
    QString sigType;
    bool polarity = true;
    qint32 sigIndex = -1;
    bool isValueTable = false;

    activatedAction = nullptr;

    core::JsonValue sigNameJsonValue = signal_obj["name"];

    isSupplementedSignalEntry = (sigNameJsonValue.isArray());
     QList<qint32> * domainTrueValues = nullptr;
     set_ops_t a_domain_set_op = set_op_na;

    if(isSupplementedSignalEntry)
    {
        sigName = QString::fromStdString(sigNameJsonValue.toArray().at(0).toString());
        supName = QString::fromStdString(sigNameJsonValue.toArray().at(1).toString());
        domainTrueValues = extractSetValuesField(signal_obj, "Domain", & a_domain_set_op);
    }
    else
    {

        sigName = QString::fromStdString(sigNameJsonValue.toString());
    }


    //Action parsing:
    if (signal_obj["action"].isArray())
    {
        core::JsonArray actionArray = signal_obj["action"].toArray();

        sigAction = QString::fromStdString(actionArray[0].toString());
        if ("inverted" == QString::fromStdString(actionArray[1].toString()))
        {
            polarity = false;
        }
    }
    else
    {
        sigAction = QString::fromStdString(signal_obj["action"].toString());
    }
    //end of Action parsing

    sigType =  QString::fromStdString(signal_obj["type"].toString());

    sigIndex = signal_obj["index"].toInt(-1);

    quint32 bufferLength = 0;
    quint32 skipSmoothingDelta = 0;
    QString smoothingType;

    //>>>>Smoothing parameters handling(for IntArgument)<<<<<<
    core::JsonValue smoothedVal = signal_obj["smoothed"];

    if( !smoothedVal.isUndefined() && smoothedVal.isArray())
    {
            core::JsonArray sigSmoothed_Array = smoothedVal.toArray();
            bufferLength = (quint32)sigSmoothed_Array.at(0).toInt(0);
            skipSmoothingDelta = (quint32)sigSmoothed_Array.at(1).toInt(0);
            smoothingType = QString::fromStdString(sigSmoothed_Array.at(2).toString("items"));
            qDebug()<<"smoothing type: "<< smoothingType;
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
        QList<qint32> * sigTrueValues = extractSetValuesField(signal_obj, "Set", & a_set_op);
        init(aProtocol, sigName, supName, sigAction, polarity, sigType, -1, a_set_op, sigTrueValues,   a_domain_set_op, domainTrueValues, false);
    }

    poolIndex = objectsPool.size();
    objectsPool.insert(poolIndex,this);
}

AMJsonSignal * AMJsonSignal::getByIndex(quint32 idx)
{
    AMJsonSignal * ret;
    ret = objectsPool.value(idx, nullptr);
    return ret;
}

quint32 AMJsonSignal::getItsIndex(void)
{
    return poolIndex;
}

QString AMJsonSignal::getItsSupName(void)
{
    return itsSupName;
}

void AMJsonSignal::init(AMJsonProtocol * aProtocol, QString aName, QString aSupName, QString anAction, bool aPolarity, QString aType, ssize_t anIndex, set_ops_t  a_set_op, QList<qint32> * aTrueValues,  set_ops_t trueDomainOp, QList<qint32> * trueDomainValues, bool isValueTable)
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

    qDebug() << "JSON: new signal with name" << itsName <<"action: "<< action << "type: "<< type <<" extracted.";

    //TODO use actions map
}

void AMJsonSignal::setSmoothing(quint32 bufferLength, quint32 skipSmoothingDelta, QString aSmoothingType)
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
            qDebug()<<"WARNING: unknown smoothing argument";
        }

        if(nullptr != smoother)
        {
            CanIntArgumentsAccumulator::getInstance(action_disp_id)->addSmoothingAlgorithm(smoother);
        }
    }
}

 QString AMJsonSignal::getName(void)
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
     if (!itsSupName.isEmpty())
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

 void AMJsonSignal::process(QVariant extractedCANsignal, QVariant extractedSupCANsignal)
 {

     if(itsProtocol->getIsEnabled()&&this->getIsEnabled())
     {
       if(itsValueTable != nullptr)
       {

           bool is_domain_valid = getDomainValidity(extractedSupCANsignal);

           IAMJsonProcessable * toActivate = is_domain_valid ? itsValueTable->value(extractedCANsignal.toInt()) : nullptr;

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

  void AMJsonSignal::process(QVariant pureExtractedCANsignal)
  {
      process(pureExtractedCANsignal, QVariant(0));
  }

 bool AMJsonSignal::getDomainValidity(QVariant extractedSupCANsignal)
 {
     bool ret = true;

     if(extractedSupCANsignal.type() == QVariant::Int && nullptr != (itsDomainTrueValues))
     {
         qint32 desired = extractedSupCANsignal.toInt();
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
             qDebug () << "Domain set operation in not defined.";
             break;
         }

     }

     return ret;

 }

 bool AMJsonSignal::extractSetUnsetAction(QVariant extractedCANsignal, bool * do_active)
 {
     bool success = true;

     if (extractedCANsignal.type() == QVariant::Bool)
     {
         bool desired = extractedCANsignal.toBool();
         *do_active = (desired == polarity);
     }
     else if (extractedCANsignal.type() == QVariant::Int && nullptr != (trueValues))
     {
         qint32 desired = extractedCANsignal.toInt();
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
             qDebug () << "Set operation in not defined.";
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
         qDebug ("Signal %s is %s",qPrintable(itsName), "disabled");
         deactivateAllGraphicItems();
     }
     else if (!is_pre_enabled && is_post_enabled)
     {
         qDebug ("Signal %s is %s",qPrintable(itsName), "enabled");
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
             foreach (IAMJsonProcessable * anAction, *itsValueTable)
             {
                 emit ((AMJsonEnablerAction *)anAction)-> enableDisableConnected(false);
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
                 foreach (AMJsonAction * anAction, *itsValueTable)
                 {
                     anAction -> process(this, QVariant(false));
                 }
#endif
             }
         }
     }
 }







