#include "amjsonsignal.h"

#include "amsignalsmodel.h"

#include "canstringargumentsaccumulator.h"

#include <qdebug.h>

#include <QMetaEnum>

#include <QObject>

class CanStringArgumentsAccumulator;

AMJsonSignal::AMJsonSignal(QString name, QString action, QString type, QObject * parent) : QObject(parent)
{
    init(name, action, true, type, -1);
}

AMJsonSignal::AMJsonSignal(QString name, QString action, bool polarity, QString type, QObject * parent) : QObject(parent)
{
     init(name, action, polarity, type, -1);
}

AMJsonSignal::AMJsonSignal(QString name, QString action, QString type, ssize_t index, QObject * parent) : QObject(parent)
{
     init(name, action, true, type, index);
}


void AMJsonSignal::init(QString aName, QString anAction, bool aPolarity, QString aType, ssize_t anIndex)
{
    QMetaObject metaObj = this->staticMetaObject;
    QMetaEnum metaEnum = metaObj.enumerator(metaObj.indexOfEnumerator("action_type_e"));

    name = aName;

    action = anAction;

    type = (action_type_e)metaEnum.keyToValue(aType.toLatin1());

    index = anIndex;

    polarity = aPolarity;

    is_enabled = true;

    itsProtocol = nullptr;

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
     if(Enabler == type)
     {
         AMJsonProtocol * prot = model->getProtocol(action);

         if(prot){
             connect(this,SIGNAL(enableDisableConnected(bool, IAlertDisplay *)),prot,SLOT(enableDisableThis(bool, IAlertDisplay *)));
         }

         QList<AMJsonSignal *> jsonSigList = itsProtocol->getSignalEntries(action);

         foreach(AMJsonSignal * jsig, jsonSigList)
         {
             connect(this,SIGNAL(enableDisableConnected(bool, IAlertDisplay *)),jsig,SLOT(enableDisableThis(bool, IAlertDisplay *)));
         }

         emit enableDisableConnected(false, nullptr);
     }
 }

 void AMJsonSignal::enableDisableThis(bool onOff, IAlertDisplay * alertDisplay)
 {
     if(is_enabled == onOff)
     {
         //skip
     }
     else
     {
         is_enabled = onOff;
         qDebug ("Signal %s is %s",qPrintable(name), onOff?"enabled" : "disabled");

         if(alertDisplay&&!is_enabled&&GraphicItem == type)
         {
             alertDisplay->mutex.lock();
             alertDisplay->deactivate(AMSignalsModel::getInstance()->jsonGetGraphicItemEnum(action));
            alertDisplay->mutex.unlock();
         }
     }


 }

