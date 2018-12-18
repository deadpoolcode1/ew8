#include "amjsonsignal.h"

#include "amsignalsmodel.h"

#include <iostream>

#include <qdebug.h>

#include <QMetaEnum>

AMJsonSignal::AMJsonSignal(QString aName, QString anAction, QString aType, ssize_t anIndex)
{


    QMetaObject metaObj = this->staticMetaObject;
    QMetaEnum metaEnum = metaObj.enumerator(metaObj.indexOfEnumerator("action_type_e"));

    name = aName;

    action = anAction;

    type = (action_type_e)metaEnum.keyToValue(aType.toLatin1());

    index = anIndex;

    qDebug() << "JSON: new signal with name" << name <<"action: "<< action << "type: "<< type <<" extracted.";



    //TODO initizlize actions map
}

 QString AMJsonSignal::getName(void)
 {
     return name;
 }
