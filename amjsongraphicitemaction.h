#ifndef AMJSONGRAPHICITEMACTION_H
#define AMJSONGRAPHICITEMACTION_H

#include <QObject>

#include "defs.h"
#include "amjsonaction.h"
#include "amjsonargumentaction.h"
#include "ialertdisplay.h"

class AMJsonAction;
class AMJsonArgumentAction;

class AMJsonSignal;
class IAlertDisplay;


class AMJsonGraphicItemAction: public AMJsonAction
{
    Q_OBJECT

public:
    explicit AMJsonGraphicItemAction(AMJsonSignal * aJsonSignal, QString action, AMJsonAction * parent = nullptr);

    void process(QVariant extractedCANsignal);

    bool getIsActived(void);
    void deactivate(void);

    void activate(bool do_reactivate = false);

    //TODO: For code reliability, verify that is not connected more than once!
    //NOTE: graphicItem signal appears at most once for one DISPLAY_GRAPHIC_ITEM.
    void connect2Arguments(AMJsonArgumentAction * argumentSignal);


public slots:
    void argumentComplete(quint8 intArg, quint8 fracArg, quint8 unitArg);
    void argumentComplete(QString strArg);

private:
    DISPLAY_ITEM_ID itsGraphicItemID;

    bool hasArguments;
    bool areArgumentsReceived;

    quint8 argInt;
    quint8 argFrac;
    quint8 argUnits;
    QString argStr;

    bool isArgOfStringType;

    bool isActivated;
    IAlertDisplay * itsDisplay;

};

#endif // AMJSONGRAPHICITEMACTION_H
