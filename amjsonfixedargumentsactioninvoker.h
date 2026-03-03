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
    AMJsonFixedArgumentsActionInvoker(AMJsonGraphicItemAction * anAction, List<int32_t> intArgs);

    void process(QObject *sender, Variant extractedCANsignal);

    bool setSupplimentary(Variant extractedCANsignal);



private:
    AMJsonGraphicItemAction * itsAction;
    String itsStringArg;
    List <int32_t> itsIntArgs;
    bool isProcessedWithStringArg;
};

#endif // AMJSONFIXEDARGUMENTSACTIONINVOKER_H
