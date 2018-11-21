#ifndef AWSCANRXMSG_H
#define AWSCANRXMSG_H

#include "simplecanrxmsg.h"

class SimpleCanRxMsg;

class AwsCanRxMsg : public SimpleCanRxMsg
{
public:
    AwsCanRxMsg();
    void process(struct can_frame * frame);


protected:

    typedef struct can_msg_content_s{
     quint8 sound_type;
     quint8 time_indicator;
     quint8 sound_repeat;
     bool   sound_suppressed;
     quint8 secondary_diagnoctic;
     bool   zero_speed;
     bool   hi_low_beam_control;
     bool   fla_armed;
     bool   head_way_valid;
     quint8 headway_measurement;
     bool   error_active;
     bool   error_code;
     bool   ldw_off;
     bool   lldw_on;
     bool   rldw_on;
     bool   fcw_on;
     bool   maintenance;
     bool   fail_safe;
     bool   ped_dz;
     bool   pcw;
     bool   blinker_reminder;
     bool   cyclist;
     bool   tamper;
     bool   speed_format;
     bool   tsr_enabled;
     quint8 tsr_warning_level;
     quint8 failsafe_level;
     quint8 fcw_x_active;
     quint8 headway_warning_level;
     bool   hw_repeatable_enabled;
     quint8 pcw_x_active;
    } can_msg_content_t;


    can_msg_content_t parse(struct can_frame *frame);

};

#endif // AWSCANRXMSG_H
