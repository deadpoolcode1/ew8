#ifndef MAINPROCESS_H
#define MAINPROCESS_H

#include <QObject>
//#include "mainwindow.h"
#include "canmanager.h"
#include "ialertdisplay.h"
#include "qmltreeparser.h"
#include <QQmlApplicationEngine>

class MainProcess : public QThread, IAlertDisplay
{
    Q_OBJECT
public:

    explicit MainProcess(QObject *aComponentObject);

    void run() override;

    int exec(void);

    void updateDisplay(void);

    //alerts display:
    virtual void activate(AlertTypes::EnAlert at, quint8 valueInt, quint8 valueFrac, visual_item_unit_t unit);
    virtual void deactivate(AlertTypes::EnAlert at);

    static MainProcess* getInstance(QObject * aComponentObject);

public slots:

    void forceItemDeactivation(int _alertType, QString _objName);

private:
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
