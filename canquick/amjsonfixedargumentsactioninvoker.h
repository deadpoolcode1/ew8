#ifndef AMJSONFIXEDARGUMENTSACTIONINVOKER_H
#define AMJSONFIXEDARGUMENTSACTIONINVOKER_H

#include "iamjsonprocessable.h"
#include "core/types.h"

//class AMJsonAction;
//class AMJsonGraphicItemAction;

class AMJsonFixedArgumentsActionInvoker: public IAMJsonProcessable
{

public:

    AMJsonFixedArgumentsActionInvoker(AMJsonGraphicItemAction * anAction, const String& aStringArg);
    AMJsonFixedArgumentsActionInvoker(AMJsonGraphicItemAction * anAction, QList<int32_t> intArgs);

    void process(QObject *sender, QVariant extractedCANsignal);

    bool setSupplimentary(QVariant extractedCANsignal);



private:
    AMJsonGraphicItemAction * itsAction;
    String itsStringArg;
    QList <int32_t> itsIntArgs;
    bool isProcessedWithStringArg;
};

#endif // AMJSONFIXEDARGUMENTSACTIONINVOKER_H
