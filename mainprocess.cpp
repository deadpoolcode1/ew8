#include "mainprocess.h"
#include "canmanager.h"
//#include "mainwindow.h"
#include "ialertdisplay.h"

#include <QThread>

MainProcess::MainProcess()//(QObject *parent) : QObject(parent)
{
  //  mw = new MainWindow();
    canmgr = new CanManager(this);

    //connect(canmgr, &CanManager::resultReady, this, &MainProcess::handleResults);
    //connect(canmgr, &CanManager::finished, canmgr, &QObject::deleteLater);
}

int MainProcess::exec()
{
    canmgr->start();
  //  mw->show();
    return 0;
}

void MainProcess::handleResults(const QString &)
{



}

void MainProcess::pdz_display(bool on)
{

    if(on)
    {
       // mw->move(40,40);
    }
    else
    {

       // mw->move(0,0);

    }
}

void MainProcess::pcw_display(bool on)
{

    if(on)
    {
      //  mw->move(20,20);
    }
    else
    {

       // mw->move(0,0);

    }
}
