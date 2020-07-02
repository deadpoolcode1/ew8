#ifndef MEDISCONNECTIONREPORT_H
#define MEDISCONNECTIONREPORT_H

#include <QObject>
#include <QTimer>
#include "ialertdisplay.h"

class MeDisconnectionReport : public QObject
{
    Q_OBJECT
public:
    explicit MeDisconnectionReport(IAlertDisplay * itsDisplay, QObject *parent = nullptr);
    void launch(void);

signals:
    void timeoutStop(void);
    void timeoutStart(void);

public slots:
    void resetConnectionTimeout(void);
    void fireConnectionTimeout(void);

private:
 bool isInDisconnectionAlert;
 QThread * itsThread;
 QTimer * timeoutTimer;
 IAlertDisplay * itsDisplay;
};

#endif // MEDISCONNECTIONREPORT_H
