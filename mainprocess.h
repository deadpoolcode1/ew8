#ifndef MAINPROCESS_H
#define MAINPROCESS_H

#include <QObject>
//#include "mainwindow.h"
#include "canmanager.h"
#include "ialertdisplay.h"
#include <QQmlApplicationEngine>

class MainProcess : public IAlertDisplay
{
    Q_OBJECT
public:
    explicit MainProcess(QQmlApplicationEngine *  engine);//(QObject *parent = nullptr);

    int exec(void);

    void updateDisplay(void);

//alerts display:
     virtual void pdz_display(bool);
     virtual void pcw_display(bool);

//signals:
//    void operate(const QString &);

public slots:
    void handleResults(const QString &);

private:
//    MainWindow * mw;
    CanManager * canmgr;
    QObject * objImage;

    QObject *componentObject;

    bool pcw_flag;
    bool pdz_flag;
};

#endif // MAINPROCESS_H
