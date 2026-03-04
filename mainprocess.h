#ifndef MAINPROCESS_H
#define MAINPROCESS_H

#include <QObject>
#include <QThread>
#include <QTimer>
#include "canmanager.h"
#include "ialertdisplay.h"
#include "core/types.h"
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
    virtual void activate(DISPLAY_ITEM_ID at, uint8_t valueInt = 0, uint8_t valueFrac = 0, uint8_t unit = 0) override;
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

    void volumeKeySent(int32_t);

    void isaFullActivationRequestSend();
    void isaPartialDeactivationRequestSend();
    void isaFullDeactivationRequestSend();

    void forwardBrightnessChanged(int32_t newLevel);

    void process();

    void onKeyPressedReport(int32_t key);
    void onKeyReleasedReport(int32_t key);
    void onAlertsReport(bool a, bool b, bool c, bool d);

private:
    void activateInternal(DISPLAY_ITEM_ID at, bool isStrArg, const String& strArg, uint8_t valueInt, uint8_t valueFrac, uint8_t unit);

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
