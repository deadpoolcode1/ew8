#include "amjsonsignal.h"

#include "amsignalsmodel.h"

#include "canstringargumentsaccumulator.h"

#include "canintargumentsaccumulator.h"

#include "graphicitemsenummap.h"

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

    isActivated = false;

    hasArguments = false;

    itsProtocol = aProtocol;
    itsDisplay =  aProtocol->itsModel->getItsCanManager()->getItsDisplay();


    name = aName;

    action = anAction;

    type = (action_type_e)metaEnum.keyToValue(aType.toLatin1());

    index = anIndex;

    polarity = aPolarity;

    trueValues = aTrueValues;

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

 void AMJsonSignal::connect2EnabledDisabled()
 {
     //NOTE:Enablers to enablers are not be permitted, to avoid recoursion.
     //     Enablers do not enable/disable "itsProtocol".
     if(Enabler == type)
     {
         AMJsonProtocol * prot = itsProtocol->itsModel->getProtocol(action);

         if(prot&&(prot != this->itsProtocol)){
             connect(this,SIGNAL(enableDisableConnected(bool)),prot,SLOT(enableDisableThis(bool)));
         }

         QList<AMJsonSignal *> jsonSigList = itsProtocol->getSignalEntries(action);

         foreach(AMJsonSignal * jsig, jsonSigList)
         {
             if(AMJsonSignal::Enabler != jsig->type)
             {
                 connect(this,SIGNAL(enableDisableConnected(bool, IAlertDisplay *)),jsig,SLOT(enableDisableThis(bool, IAlertDisplay *)));
             }
         }

         emit enableDisableConnected(false);
     }
 }

 void AMJsonSignal::activate(void)
 {
     if(GraphicItem == type)
     {
         //TODO: request active arguments

         if(isActivated)
         {
             //reactivate on arguments change
         }
         else
         {
             itsDisplay->mutex.lock();
             itsDisplay->activate(GraphicItemsEnumMap::getId(action));
             itsDisplay->mutex.unlock();

             isActivated = true;
         }
     }
 }

 void AMJsonSignal::deactivate(void)
 {
     if(GraphicItem == type && isActivated)
     {
         itsDisplay->mutex.lock();
         itsDisplay->deactivate(GraphicItemsEnumMap::getId(action));
         itsDisplay->mutex.unlock();

         isActivated = false;
     }
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
         deactivate();
     }
     else if (!is_pre_enabled && is_post_enabled)
     {
         qDebug ("Signal %s is %s",qPrintable(name), "enabled");
     }
 }

 void AMJsonSignal::connect2Arguments(AMJsonSignal * argumentSignal)
 {

     if(!hasArguments)
     {
         if (argumentSignal->type == AMJsonSignal::IntArgument)
         {


             CanIntArgumentsAccumulator * intAcc = CanIntArgumentsAccumulator::getInstance(GraphicItemsEnumMap::getId(argumentSignal->action));
             if(intAcc)
             {
                 connect(intAcc, SIGNAL(argumentComplete(qint8,qint8,qint8)),this,SLOT(argumentComplete(qint8,qint8,qint8)));
                 hasArguments = true;
                 argType = IntArgument;
             }
         }
         else if(argumentSignal->type == AMJsonSignal::StringArgument)
         {
             CanStringArgumentsAccumulator * strAcc = CanStringArgumentsAccumulator::getInstance(GraphicItemsEnumMap::getId(argumentSignal->action));

             if(strAcc)
             {
                 connect(strAcc, SIGNAL(argumentComplete(QString)),this,SLOT(argumentComplete(QString)));
                 hasArguments = true;
                 argType = StringArgument;
             }

         }
     }

 }


 void AMJsonSignal::argumentComplete(QString anArg)
 {

 }

 void AMJsonSignal::argumentComplete(qint8 intArg, qint8 fracArg, qint8 unitArg)
 {

 }

 bool AMJsonSignal::getIsActived(void)
 {
     return isActivated;
 }


