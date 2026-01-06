#include "amjsongraphicitemaction.h"
#include "amjsonfixedargumentsactioninvoker.h"

class AMJsonGraphicItemAction;

AMJsonFixedArgumentsActionInvoker::AMJsonFixedArgumentsActionInvoker(AMJsonGraphicItemAction * anAction, const String& aStringArg)
{
    itsAction =  anAction;
    itsStringArg = aStringArg;
    itsIntArgs.clear();
    isProcessedWithStringArg = true;
    itsAction->setCalledWithFixedArgument(isProcessedWithStringArg);
}


bool AMJsonFixedArgumentsActionInvoker::setSupplimentary (QVariant extractedCanSignal)
{
    bool ret = itsAction->setSupplimentary(extractedCanSignal);
    return ret;
}

AMJsonFixedArgumentsActionInvoker::AMJsonFixedArgumentsActionInvoker(AMJsonGraphicItemAction * anAction, List<int32_t> intArgs)
{
    itsAction =  anAction;
    itsStringArg = "";
    itsIntArgs = intArgs;
    isProcessedWithStringArg = false;
    itsAction->setCalledWithFixedArgument(isProcessedWithStringArg);
}

void AMJsonFixedArgumentsActionInvoker::process(QObject *sender, QVariant extractedCANsignal)
{
    //WARNING: arguments are applied on action activation only.
    if(extractedCANsignal.toBool())
    {
        if(isProcessedWithStringArg)
        {
            itsAction->argumentComplete(itsStringArg);
        }
        else
        {
            switch(itsIntArgs.size())
            {
            case 1:
                itsAction->argumentComplete((uint8_t)itsIntArgs.at(0), 0, 0);
                break;
            case 2:
                itsAction->argumentComplete((uint8_t)itsIntArgs.at(0),(uint8_t)itsIntArgs.at(1), 0);
                break;

            case 3:
                itsAction->argumentComplete((uint8_t)itsIntArgs.at(0),(uint8_t)itsIntArgs.at(1),(uint8_t)itsIntArgs.at(2));
                break;
            }
        }
    }

    itsAction->process(sender,extractedCANsignal);

}


