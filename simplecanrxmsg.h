#ifndef SIMPLECANRXMSG_H
#define SIMPLECANRXMSG_H


class SimpleCanRxMsg : public CanRxMsg
{
public:

    virtual void process() = 0;
    void ack(void);

protected:
     SimpleCanRxMsg();
};

#endif // SIMPLECANRXMSG_H
