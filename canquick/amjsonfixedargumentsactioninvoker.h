#ifndef AMJSONFIXEDARGUMENTSACTIONINVOKER_H
#define AMJSONFIXEDARGUMENTSACTIONINVOKER_H

#include "iamjsonprocessable.h"
#include "core/types.h"

//class AMJsonAction;
//class AMJsonGraphicItemAction;

class AMJsonFixedArgumentsActionInvoker: public IAMJsonProcessable
{

public:

    AMJsonFixedArgumentsActionInvoker(AMJsonGraphicItemAction * anAction, core::QString aStringArg);
    AMJsonFixedArgumentsActionInvoker(AMJsonGraphicItemAction * anAction, core::QList<int32_t> intArgs);

    void process(QObject *sender, core::QVariant extractedCANsignal);

    bool setSupplimentary(core::QVariant extractedCANsignal);



private:
    AMJsonGraphicItemAction * itsAction;
    core::QString itsStringArg;
    core::QList<int32_t> itsIntArgs;
    bool isProcessedWithStringArg;
};

#endif // AMJSONFIXEDARGUMENTSACTIONINVOKER_H
