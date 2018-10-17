#ifndef TSRCANRXMSG_H
#define TSRCANRXMSG_H


class TsrCanRxMsg : public SimpleCanRxMsg
{
public:
    TsrCanRxMsg();
    void process();
};

#endif // TSRCANRXMSG_H
