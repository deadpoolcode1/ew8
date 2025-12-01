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
    void startRequestTimeoutTimer();
    void stopRequestTimeoutTimer();

public slots:
    void resetConnectionTimeout(void);
    void fireConnectionTimeout(void);
    void fireRequestTimeout(void);

private:
 bool isInDisconnectionAlert;
 QThread * itsThread;
 QTimer * connectionTimeoutTimer;
 QTimer * requestTimeoutTimer;
 IAlertDisplay * itsDisplay;
 //TODO set
};

#endif // MEDISCONNECTIONREPORT_H
