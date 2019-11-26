#ifndef AMJSONFIXEDARGUMENTSACTIONINVOKER_H
#define AMJSONFIXEDARGUMENTSACTIONINVOKER_H

#include "iamjsonprocessable.h"

//class AMJsonAction;
//class AMJsonGraphicItemAction;

class AMJsonFixedArgumentsActionInvoker: public IAMJsonProcessable
{

public:

    AMJsonFixedArgumentsActionInvoker(AMJsonGraphicItemAction * anAction, QString aStringArg);
    AMJsonFixedArgumentsActionInvoker(AMJsonGraphicItemAction * anAction, QList<qint32> intArgs);

    void process(QObject *sender, QVariant extractedCANsignal);




private:
    AMJsonGraphicItemAction * itsAction;
    QString itsStringArg;
    QList <qint32> itsIntArgs;
    bool isProcessedWithStringArg;
};

#endif // AMJSONFIXEDARGUMENTSACTIONINVOKER_H
