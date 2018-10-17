#ifndef SMARTCANRXMSG_H
#define SMARTCANRXMSG_H

class SmartCanRxMsg : public CanRxMsg
{
public:
    SmartCanRxMsg();

    void process(void);
    void ack(void);
};

#endif // SMARTCANRXMSG_H
