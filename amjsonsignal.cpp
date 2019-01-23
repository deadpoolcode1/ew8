#include "amjsonsignal.h"

#include "amsignalsmodel.h"

#include "canstringargumentsaccumulator.h"

#include "canintargumentsaccumulator.h"

#include "graphicitemsenummap.h"

#include "candbsignal.h"

#include <qdebug.h>

#include <QMetaEnum>

#include <QObject>

class CanStringArgumentsAccumulator;
class CanIntArgumentsAccumulator;

AMJsonSignal::AMJsonSignal(AMJsonProtocol * protocol, QString name, QString action, QString type, QObject * parent) : QObject(parent)
{
    init(protocol, name, action, true, type, -1, nullptr);
}

AMJsonSignal::AMJsonSignal(AMJsonProtocol * protocol, QString name, QString action, bool polarity, QString type, QObject * parent) : QObject(parent)
{
     init(protocol, name, action, polarity, type, -1, nullptr);
}

AMJsonSignal::AMJsonSignal(AMJsonProtocol * protocol, QString name, QString action, QString type, ssize_t index, QObject * parent) : QObject(parent)
{
     init(protocol, name, action, true, type, index, nullptr);
}

AMJsonSignal::AMJsonSignal(AMJsonProtocol * protocol, QString name, QString action, qint32 trueValue, QString type, QObject * parent) : QObject(parent)
{
     QList<qint32> * trueValues = new QList<qint32>;

     trueValues->append(trueValue);

     init(protocol, name, action, true, type, -1, trueValues);
}

AMJsonSignal::AMJsonSignal(AMJsonProtocol * protocol, QString name, QString action, QList<qint32> * trueValues, QString type, QObject * parent) : QObject(parent)
{
     init(protocol, name, action, true, type, -1, trueValues);
}


void AMJsonSignal::init(AMJsonProtocol * aProtocol, QString aName, QString anAction, bool aPolarity, QString aType, ssize_t anIndex,  QList<qint32> * aTrueValues)
{
    QMetaObject metaObj = this->staticMetaObject;
    QMetaEnum metaEnum = metaObj.enumerator(metaObj.indexOfEnumerator("action_type_e"));

    itsValueTable = nullptr;

    itsProtocol = aProtocol;
    itsAMJsonActionFactory = aProtocol->itsModel->getItsAMJsonActionFactory();

    name = aName;

    action = anAction;

    type = (action_type_e)metaEnum.keyToValue(aType.toLatin1());

    index = anIndex;

    polarity = aPolarity;

    trueValues = aTrueValues;

    if(EnumItem != type)
    {
        itsAction = itsAMJsonActionFactory->createAMJsonActionInstance(this,type,action);
    }

    if(StringArgument == type)
    {
        DISPLAY_ITEM_ID action_disp_id = GraphicItemsEnumMap::getId(action);
        CanStringArgumentsAccumulator::getInstance(action_disp_id)->growTriggeringSize(anIndex);
    }

    qDebug() << "JSON: new signal with name" << name <<"action: "<< action << "type: "<< type <<" extracted.";

    //TODO use actions map
}

 QString AMJsonSignal::getName(void)
 {
     return name;
 }

Signal * AMJsonSignal::getCanDbSignal()
 {
    return itsCanDbSignal;
 }

void AMJsonSignal::setItsCanDbSignal(Signal *canSignalPtr)
{
    itsCanDbSignal = canSignalPtr;
}

 void AMJsonSignal::process(QVariant extractedCANsignal)
 {
     if(itsProtocol->getIsEnabled()&&this->getIsEnabled())
     {
       if(itsValueTable != nullptr)
       {
           itsValueTable->value(extractedCANsignal.toInt());
       }
       else
       {
         bool do_activate;
         bool success = extractSetUnsetAction(extractedCANsignal, &do_activate);

         itsAction->process(success ? do_activate : extractedCANsignal);
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
             foreach (AMJsonAction * anAction, *itsValueTable)
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
                 ((AMJsonGraphicItemAction *)itsAction)-> deactivate();
             }
         }
         else
         {
             foreach (AMJsonAction * anAction, *itsValueTable)
             {
                 ((AMJsonGraphicItemAction *)anAction)-> deactivate();
             }
         }
     }
 }







