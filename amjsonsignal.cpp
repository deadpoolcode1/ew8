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

#include <QJsonObject>
#include <QJsonValue>
#include <QJsonArray>

#include <QObject>

class CanStringArgumentsAccumulator;
class CanIntArgumentsAccumulator;

QMap<quint32,AMJsonSignal *> AMJsonSignal::objectsPool;


AMJsonSignal::AMJsonSignal(AMJsonProtocol * aProtocol, QJsonValue singleSignalsEntry, QObject * parent) : QObject(parent)
{

    //Signal row parsing:
    QJsonObject signal_obj = singleSignalsEntry.toObject();
    QString sigName;
    QString sigAction;
    QString sigType;
    bool polarity = true;
    qint32 sigIndex = -1;

    activatedAction = nullptr;

    sigName = signal_obj["name"].toString();


    //Action parsing:
    if (signal_obj["action"].isArray())
    {
        QJsonArray actionArray = signal_obj["action"].toArray();

        sigAction = actionArray[0].toString();
        if ("inverted" == actionArray[1].toString())
        {
            polarity = false;
        }
    }
    else
    {
        sigAction = signal_obj["action"].toString();
    }
    //end of Action parsing

    sigType =  signal_obj["type"].toString();

    sigIndex = signal_obj["index"].toInt(-1);

    quint32 bufferLength = 0;
    quint32 skipSmoothingDelta = 0;
    QString smoothingType;

    //>>>>Smoothing parameters handling(for IntArgument)<<<<<<
    QJsonObject::iterator smoothedQObj = signal_obj.find("smoothed");

    if( smoothedQObj != signal_obj.end() && smoothedQObj.value().isArray())
    {
            QJsonArray sigSmoothed_Array = smoothedQObj.value().toArray();
            bufferLength = (quint32)sigSmoothed_Array.at(0).toInt(0);
            skipSmoothingDelta = (quint32)sigSmoothed_Array.at(1).toInt(0);
            smoothingType = sigSmoothed_Array.at(2).toString("items");
            qDebug()<<"smoothing type: "<< smoothingType;
    }




    if(polarity)
    {
        if(-1 == sigIndex)
        {
            //TODO verify syntax the signal on DBC side must be boolean
            if(signal_obj.find("Set") == signal_obj.end())
            {

              //Used properties: (aProtocol, sigName, sigAction, sigType)

                //Find is a value table:
                bool isValueTable;

                if(signal_obj.find("isValueTable") == signal_obj.end())
                {
                   isValueTable = false;
                }
                else
                {
                   isValueTable = signal_obj["isValueTable"].toBool(false);
                }



                init(aProtocol, sigName, sigAction, true, sigType, -1, nullptr, isValueTable);

            }
            else //extract field of True Values
            {
                //TODO verify syntax the signal on DBC side must be non-boolean integer
                QList<qint32> * sigTrueValues = new QList<qint32>();

                if (signal_obj["Set"].isArray()){

                    QJsonArray sigTrueValues_Array = signal_obj["Set"].toArray();


                    foreach(QJsonValue value, sigTrueValues_Array)
                    {
                        sigTrueValues->append(value.toInt(0));
                    }
                }
                else
                {
                    qint32 sigTrueValue = signal_obj["Set"].toInt(0);
                    sigTrueValues->append(sigTrueValue);
                }

                 //Used properties: (aProtocol, sigName, sigAction, sigTrueValues, sigType)
                 init(aProtocol, sigName, sigAction, true, sigType, -1, sigTrueValues, false);
            }
        }
        else
        {
            //Used properties (argument signal) : (aProtocol, sigName, sigAction, sigType, sigIndex)
             init(aProtocol, sigName, sigAction, true, sigType, sigIndex, nullptr, false);

             if(bufferLength > 0)
             {
                setSmoothing(bufferLength, skipSmoothingDelta, smoothingType);
             }
        }
    }
    else
    {
        //Used properties:  (aProtocol, sigName, sigAction, false, sigType);
        init(aProtocol, sigName, sigAction, polarity, sigType, -1, nullptr, false);
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

void AMJsonSignal::init(AMJsonProtocol * aProtocol, QString aName, QString anAction, bool aPolarity, QString aType, ssize_t anIndex,  QList<qint32> * aTrueValues, bool isValueTable)
{
    itsValueTable = nullptr;

    itsProtocol = aProtocol;
    itsAMJsonActionFactory = aProtocol->itsModel->getItsAMJsonActionFactory();

    name = aName;

    action = anAction;


    index = anIndex;

    polarity = aPolarity;

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

    qDebug() << "JSON: new signal with name" << name <<"action: "<< action << "type: "<< type <<" extracted.";

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
     return name;
 }

 Signal * AMJsonSignal::getCanDbSignal(void)
 {
    return &itsCanDbSignal;
 }

void AMJsonSignal::setItsCanDbSignal(Signal *canSignalPtr)
{
#if 0
    itsCanDbSignal = *canSignalPtr;
#else
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
#endif
}

 void AMJsonSignal::process(QVariant extractedCANsignal)
 {
     if(itsProtocol->getIsEnabled()&&this->getIsEnabled())
     {
       if(itsValueTable != nullptr)
       {
           IAMJsonProcessable * toActivate = itsValueTable->value(extractedCANsignal.toInt());

           IAMJsonProcessable * toDeactivate = getActivatedAction();

           if(toActivate != toDeactivate)//WARNING: without args only
               //TODO: if args are present compare the args
           {

               if(toDeactivate != nullptr){
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
         *do_active = (trueValues->contains(desired));
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
         qDebug ("Signal %s is %s",qPrintable(name), "disabled");
         deactivateAllGraphicItems();
     }
     else if (!is_pre_enabled && is_post_enabled)
     {
         qDebug ("Signal %s is %s",qPrintable(name), "enabled");
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







