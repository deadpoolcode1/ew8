#ifndef MAINPROCESS_H
#define MAINPROCESS_H

#include <QObject>
#include "canmanager.h"
#include "ialertdisplay.h"
#include <QQmlApplicationEngine>
#include "rootedtree.h"
#include "brightnesscontrol.h"

class MainProcess : public QObject, IAlertDisplay
{
    Q_OBJECT

public:

    explicit MainProcess(QObject *aComponentObject, QObject * parent = nullptr);

    int launchEverything(void);

    void updateDisplay(void);

    void setBrightnessControl(BrightnessControl * aBrightnessControl);

    //alerts display (IAlertDisplay interface implementation):
    virtual void activate(DISPLAY_ITEM_ID at, quint8 valueInt = 0, quint8 valueFrac = 0, quint8 unit = 0) override;
    virtual void activate(DISPLAY_ITEM_ID at, const std::string& stringArg) override;
    virtual void deactivate(DISPLAY_ITEM_ID at) override;
    virtual void forceUpdate(void) override;
    virtual void message(const std::string& stringMessage) override;

    static MainProcess* getInstance(QObject * aComponentObject);

signals:
    void startUpdateDisplayWindow();

    void messageDisplayWindow(QVariant aStrMsg);

public slots:

    void debugMessagesConnected(bool On);

    void volumeKeySent(qint32);

    void isaFullActivationRequestSend();
    void isaPartialDeactivationRequestSend();
    void isaFullDeactivationRequestSend();

    void forwardBrightnessChanged(qint32 newLevel);

    void process();

private:
    void activateInternal(DISPLAY_ITEM_ID at, bool isStrArg, const QString& strArg, quint8 valueInt, quint8 valueFrac, quint8 unit);

    bool isDataComplete;

    static MainProcess* instance;

    //Objects for signals connection:
    BrightnessControl * theBrightnessControl;

//    MainWindow * mw;
    CanManager * canmgr;

// pointers to display static panels trees
    RootedTree* generalPanelTree;

// pointer to QML defining trees for all panels.
    QObject *componentObject;

    QTimer * updateDisplayTimeWindow;

    QThread * itsThread;

    bool flag_tree_changed;
};

#endif // MAINPROCESS_H
