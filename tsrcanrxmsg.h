#ifndef TSRCANRXMSG_H
#define TSRCANRXMSG_H


class TsrCanRxMsg : public SimpleCanRxMsg
{
public:
    TsrCanRxMsg();
    void process(struct can_frame * frame);

    static void enable();
    static void disable();


private:
    static bool is_enabled;
    void sliStateParseAndProcess(struct can_frame * prev, struct can_frame * recv);


};

#endif // TSRCANRXMSG_H
