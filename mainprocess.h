#ifndef MAINPROCESS_H
#define MAINPROCESS_H

#include <QObject>
//#include "mainwindow.h"
#include "canmanager.h"
#include "ialertdisplay.h"
#include <QQmlApplicationEngine>
#include "rootedtree.h"

class MainProcess : public QThread, IAlertDisplay
{
    Q_OBJECT
public:

    explicit MainProcess(QObject *aComponentObject, QThread * parent = nullptr);

    int launchEverything(void);

    void updateDisplay(void);

    //alerts display:
    virtual void activate(DISPLAY_ITEM_ID at, quint8 valueInt, quint8 valueFrac, visual_item_unit_t unit);
    virtual void activate(DISPLAY_ITEM_ID at, QString stringArg);
    virtual void deactivate(DISPLAY_ITEM_ID at);

    static MainProcess* getInstance(QObject * aComponentObject);

public slots:

    void forceItemDeactivation(int _alertType, QString _objName);

    void process();

private:
    void activate(DISPLAY_ITEM_ID at, bool isStrArg, QString strArg, quint8 valueInt, quint8 valueFrac, visual_item_unit_t unit);

    static MainProcess* instance;

//    MainWindow * mw;
    CanManager * canmgr;

// pointers to display static panels trees
    RootedTree* mainPanelTree;
    RootedTree* tsrPanelTree;
    RootedTree* statusPanelTree;
    RootedTree* smartADASPanelTree;

// pointer to QML defining trees for all panels.
    QObject *componentObject;

    bool flag_tree_changed;
};

#endif // MAINPROCESS_H
