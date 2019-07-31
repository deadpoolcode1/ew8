#ifndef AMJSONGRAPHICITEMACTION_H
#define AMJSONGRAPHICITEMACTION_H

#include <QObject>
#include <QMap>

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

    static AMJsonGraphicItemAction * getInstance(AMJsonProtocol * aJsonProtocol, QString action);

    void process(QObject * sender, QVariant extractedCANsignal);

    bool getIsActived(void);


    //TODO: For code reliability, verify that is not connected more than once!
    //NOTE: graphicItem signal appears at most once for one DISPLAY_GRAPHIC_ITEM.
    void connect2Arguments(AMJsonArgumentAction * argumentSignal);


public slots:
    void argumentComplete(quint8 intArg, quint8 fracArg, quint8 unitArg);
    void argumentComplete(QString strArg);

private:

    explicit AMJsonGraphicItemAction(AMJsonProtocol * aJsonProtocol, DISPLAY_ITEM_ID aGraphicItemID, QString action, AMJsonAction * parent = nullptr);

    void deactivate(void);

    void activate(bool do_reactivate = false);


    DISPLAY_ITEM_ID itsGraphicItemID;

    bool hasArguments;
    bool areArgumentsReceived;

    quint8 argInt;
    quint8 argFrac;
    quint8 argUnits;
    QString argStr;

    bool isArgOfStringType;

    IAlertDisplay * itsDisplay;

    static QMap<DISPLAY_ITEM_ID, AMJsonGraphicItemAction *> itsObjects;

    QList<QObject *> activators;
};

#endif // AMJSONGRAPHICITEMACTION_H
