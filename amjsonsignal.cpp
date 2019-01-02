#include "amjsonsignal.h"

#include "amsignalsmodel.h"

#include "canstringargumentsaccumulator.h"

#include <qdebug.h>

#include <QMetaEnum>

#include <QObject>

class CanStringArgumentsAccumulator;

AMJsonSignal::AMJsonSignal(QString name, QString action, QString type, QObject * parent) : QObject(parent)
{
    init(name, action, true, type, -1, nullptr);
}

AMJsonSignal::AMJsonSignal(QString name, QString action, bool polarity, QString type, QObject * parent) : QObject(parent)
{
     init(name, action, polarity, type, -1, nullptr);
}

AMJsonSignal::AMJsonSignal(QString name, QString action, QString type, ssize_t index, QObject * parent) : QObject(parent)
{
     init(name, action, true, type, index, nullptr);
}

AMJsonSignal::AMJsonSignal(QString name, QString action, qint32 trueValue, QString type, QObject * parent) : QObject(parent)
{
     QList<qint32> * trueValues = new QList<qint32>;

     trueValues->append(trueValue);

     init(name, action, true, type, -1, trueValues);
}

AMJsonSignal::AMJsonSignal(QString name, QString action, QList<qint32> * trueValues, QString type, QObject * parent) : QObject(parent)
{
     init(name, action, true, type, -1, trueValues);
}


void AMJsonSignal::init(QString aName, QString anAction, bool aPolarity, QString aType, ssize_t anIndex,  QList<qint32> * aTrueValues)
{
    QMetaObject metaObj = this->staticMetaObject;
    QMetaEnum metaEnum = metaObj.enumerator(metaObj.indexOfEnumerator("action_type_e"));

    name = aName;

    action = anAction;

    type = (action_type_e)metaEnum.keyToValue(aType.toLatin1());

    index = anIndex;

    polarity = aPolarity;

    itsProtocol = nullptr;

    trueValues = aTrueValues;

    if(StringArgument == type)
    {
#if 0
        DISPLAY_ITEM_ID action_disp_id = AMSignalsModel::getInstance()->jsonGetGraphicItemEnum(action);
#endif
        CanStringArgumentsAccumulator::getInstance(action)->growTriggeringSize(anIndex);
    }

    qDebug() << "JSON: new signal with name" << name <<"action: "<< action << "type: "<< type <<" extracted.";

    //TODO use actions map
}

 QString AMJsonSignal::getName(void)
 {
     return name;
 }

 void AMJsonSignal::connect2EnabledDisabled(AMSignalsModel * model)
 {
     //NOTE:Enablers to enablers are not be permitted, to avoid recoursion.
     //     Enablers do not enable/disable "itsProtocol".
     if(Enabler == type)
     {
         AMJsonProtocol * prot = model->getProtocol(action);

         if(prot&&(prot != this->itsProtocol)){
             connect(this,SIGNAL(enableDisableConnected(bool, IAlertDisplay *)),prot,SLOT(enableDisableThis(bool, IAlertDisplay *)));
         }

         QList<AMJsonSignal *> jsonSigList = itsProtocol->getSignalEntries(action);

         foreach(AMJsonSignal * jsig, jsonSigList)
         {
             if(AMJsonSignal::Enabler != jsig->type)
             {
                 connect(this,SIGNAL(enableDisableConnected(bool, IAlertDisplay *)),jsig,SLOT(enableDisableThis(bool, IAlertDisplay *)));
             }
         }

         emit enableDisableConnected(false, nullptr);
     }
 }

 void AMJsonSignal::enableDisableThis(bool onOff, IAlertDisplay * alertDisplay)
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

         if(alertDisplay&&GraphicItem == type)
         {
             alertDisplay->mutex.lock();
             alertDisplay->deactivate(AMSignalsModel::getInstance()->jsonGetGraphicItemEnum(action));
            alertDisplay->mutex.unlock();
         }
     }
     else if (!is_pre_enabled && is_post_enabled)
     {
         qDebug ("Signal %s is %s",qPrintable(name), "enabled");
     }
 }

