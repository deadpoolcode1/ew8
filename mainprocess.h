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

    explicit MainProcess(QQmlApplicationEngine *  engine);//(QObject *parent = nullptr);

    void run() override;

    int exec(void);

    void updateDisplay(void);

//alerts display:
    virtual void activate(AlertTypes::EnAlert at);
    virtual void deactivate(AlertTypes::EnAlert at);

//signals:
//    void operate(const QString &);

    static MainProcess* getInstance(QQmlApplicationEngine *  engine);
public slots:
    void handleResults(const QString &);

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
