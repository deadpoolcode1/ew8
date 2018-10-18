#ifndef TSRCANRXMSG_H
#define TSRCANRXMSG_H


class TsrCanRxMsg : public SimpleCanRxMsg
{
public:
    TsrCanRxMsg();
    void process(struct can_frame * frame);
};

#endif // TSRCANRXMSG_H
