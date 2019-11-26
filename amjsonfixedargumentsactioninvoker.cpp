#include "amjsongraphicitemaction.h"
#include "amjsonfixedargumentsactioninvoker.h"

class AMJsonGraphicItemAction;

AMJsonFixedArgumentsActionInvoker::AMJsonFixedArgumentsActionInvoker(AMJsonGraphicItemAction * anAction, QString aStringArg)
{
    itsAction =  anAction;
    itsStringArg = aStringArg;
    itsIntArgs.clear();
    isProcessedWithStringArg = true;
    itsAction->setCalledWithFixedArgument(isProcessedWithStringArg);
}

AMJsonFixedArgumentsActionInvoker::AMJsonFixedArgumentsActionInvoker(AMJsonGraphicItemAction * anAction, QList<qint32> intArgs)
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
            switch(itsIntArgs.length())
            {
            case 1:
                itsAction->argumentComplete((quint8)itsIntArgs.at(0), 0, 0);
                break;
            case 2:
                itsAction->argumentComplete((quint8)itsIntArgs.at(0),(quint8)itsIntArgs.at(1), 0);
                break;

            case 3:
                itsAction->argumentComplete((quint8)itsIntArgs.at(0),(quint8)itsIntArgs.at(1),(quint8)itsIntArgs.at(2));
                break;
            }
        }
    }

    itsAction->process(sender,extractedCANsignal);

}


