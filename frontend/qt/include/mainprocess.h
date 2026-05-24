#ifndef MAINPROCESS_H
#define MAINPROCESS_H

#include <QObject>
#include "core/thread.h"
#include "core/timer.h"
#include "canmanager.h"
#include "core/types.h"
#include "rootedtree.h"
#include "brightnesscontrol.h"
#include "alertcontroller.h"

class MainProcess : public QObject
{
    Q_OBJECT

public:

    explicit MainProcess(QObject *aComponentObject, QObject * parent = nullptr);

    int launchEverything(void);

    void updateDisplay(void);

    void setBrightnessControl(BrightnessControl * aBrightnessControl);

    static MainProcess* getInstance(QObject * aComponentObject);

signals:
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

    // Trailing-edge flush for the display throttle window (see process()).
    void onWindowExpired(void);

    static MainProcess* instance;

    //Objects for signals connection:
    BrightnessControl * theBrightnessControl;

    CanManager * canmgr;

    AlertController * alertController;

// pointers to display static panels trees
    RootedTree* generalPanelTree;

// pointer to QML defining trees for all panels.
    QObject *componentObject;

    core::Timer * updateDisplayTimeWindow;

    core::Thread * itsThread;
};

#endif // MAINPROCESS_H
