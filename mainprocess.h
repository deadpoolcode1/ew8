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
     virtual void display(AlertTypes::EnAlert at);
     virtual void hide(AlertTypes::EnAlert at);

//signals:
//    void operate(const QString &);

public slots:
    void handleResults(const QString &);

private:
//    MainWindow * mw;
    CanManager * canmgr;

    QObject *componentObject;

    QmlTreeParser * qmlTreeParser;

    bool pcw_flag;
    bool pdz_flag;
    bool flag_updated;
};

#endif // MAINPROCESS_H
