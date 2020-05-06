#ifndef KEEPALIVEMSG_H
#define KEEPALIVEMSG_H

#include "canmanager.h"

class CanManager;

class KeepAliveMsg:  public QObject
{
    Q_OBJECT

public:
    static void create(CanManager * aCanManager);

public slots:
    void triggerTimeout(void);

private:
    CanManager * itsCanManager;
    explicit KeepAliveMsg(CanManager * aCanManager);
    QTimer * triggerTimer;
    static KeepAliveMsg * instance;

};

#endif // KEEPALIVEMSG_H
