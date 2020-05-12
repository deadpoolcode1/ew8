#ifndef KEEPALIVEMSG_H
#define KEEPALIVEMSG_H

#include "canmanager.h"

class CanManager;

class KeepAliveMsg:  public QObject
{
    Q_OBJECT

    enum system_type_e: quint8
    {
        stypeLinux = 0x0,
        stypeBareMetal = 0x1,
        stypeInvalid = 0xf,
    };

public:
    static void create(CanManager * aCanManager);



public slots:
    void triggerTimeout(void);

private:
    CanManager * itsCanManager;
    explicit KeepAliveMsg(CanManager * aCanManager);
    QTimer * triggerTimer;
    static KeepAliveMsg * instance;
    QElapsedTimer uptimeReference;
    quint16 sessionId;
    system_type_e system_type;
    struct can_frame frame_to_send;
    bool isValid;
    quint8 errorId;
};

#endif // KEEPALIVEMSG_H
