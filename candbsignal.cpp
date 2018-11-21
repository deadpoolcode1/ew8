#include "candbsignal.h"
#include <stdint.h>
#include "defs.h"

//Signals of 0x700 msg:

  Signal SignalsOfAfterMarket_AWS_0x700[] = {
      {"Sound_type", 0, 0, 3, false, 1, 0, 0, 7, SIGNAL_VALUE_TYPE_INTEGER},
      {"time_indicator", 0, 3, 2, false, 1, 0, 0, 3, SIGNAL_VALUE_TYPE_INTEGER},
      {"SoundRepeat", 0, 5, 2, false, 1, 0, 0, 0, SIGNAL_VALUE_TYPE_INTEGER},
      {"SoundSuppressed", 0, 7, 1, false, 1, 0, 0, 0, SIGNAL_VALUE_TYPE_INTEGER},
      {"Secondary_Diagnostic", 1, 0, 3, false, 1, 0, 0, 0, SIGNAL_VALUE_TYPE_INTEGER},
      {"reserved1", 1, 3, 2, true, 1, 0, 0, 0, SIGNAL_VALUE_TYPE_INTEGER},
      {"Zero_speed", 1, 5, 1, false, 1, 0, 0, 1, SIGNAL_VALUE_TYPE_INTEGER},
      {"Hi_Low_BeamControl", 1, 6, 1, false, 1, 0, 0, 1, SIGNAL_VALUE_TYPE_INTEGER},
      {"FLA_Armed", 1, 7, 1, false, 1, 0, 0, 1, SIGNAL_VALUE_TYPE_INTEGER},
      {"Headway_valid", 2, 0, 1, false, 1, 0, 0, 1, SIGNAL_VALUE_TYPE_INTEGER},
      {"Headway_measurement", 2, 1, 7, false, 1, 0, 0, 127, SIGNAL_VALUE_TYPE_INTEGER},
      {"Error_Active", 3, 0, 1, false, 1, 0, 0, 1, SIGNAL_VALUE_TYPE_INTEGER},
      {"Error_code", 3, 1, 7, false, 1, 0, 0, 127, SIGNAL_VALUE_TYPE_INTEGER},
      {"LDW_off", 4, 0, 1, false, 1, 0, 0, 1, SIGNAL_VALUE_TYPE_INTEGER},
      {"LLDW_on", 4, 1, 1, false, 1, 0, 0, 1, SIGNAL_VALUE_TYPE_INTEGER},
      {"RLDW_on", 4, 2, 1, false, 1, 0, 0, 1, SIGNAL_VALUE_TYPE_INTEGER},
      {"FCW_on", 4, 3, 1, false, 1, 0, 0, 1, SIGNAL_VALUE_TYPE_INTEGER},
      {"reserved2", 4, 4, 2, false, 1, 0, 0, 0, SIGNAL_VALUE_TYPE_INTEGER},
      {"Maintenance", 4, 6, 1, false, 1, 0, 0, 1, SIGNAL_VALUE_TYPE_INTEGER},
      {"Fail_safe", 4, 7, 1, false, 1, 0, 0, 1, SIGNAL_VALUE_TYPE_INTEGER},
      {"reserved3", 5, 0, 1, true, 1, 0, 0, 0, SIGNAL_VALUE_TYPE_INTEGER},
      {"PCW_PedDZ", 5, 1, 2, false, 1, 0, 0, 3, SIGNAL_VALUE_TYPE_INTEGER},
      {"Blinker_Reminder", 5, 3, 1, false, 1, 0, 0, 0, SIGNAL_VALUE_TYPE_INTEGER},
      {"cyclist", 5, 4, 1, false, 1, 0, 0, 1, SIGNAL_VALUE_TYPE_INTEGER},
      {"TamperAlert", 5, 5, 1, false, 1, 0, 0, 1, SIGNAL_VALUE_TYPE_INTEGER},
      {"Speed_format", 5, 6, 1, false, 1, 0, 0, 0, SIGNAL_VALUE_TYPE_INTEGER},
      {"TSR_enabbled", 5, 7, 1, false, 1, 0, 0, 1, SIGNAL_VALUE_TYPE_INTEGER},
      {"TSR_warning_level", 6, 0, 3, false, 1, 0, 0, 3, SIGNAL_VALUE_TYPE_INTEGER},
      {"Failsafe_Level", 6, 3, 2, false, 1, 0, 0, 0, SIGNAL_VALUE_TYPE_INTEGER},
      {"FCW_X_Active", 6, 5, 3, false, 1, 0, 0, 0, SIGNAL_VALUE_TYPE_INTEGER},
      {"HW_Warning_level", 7, 0, 2, false, 1, 0, 0, 2, SIGNAL_VALUE_TYPE_INTEGER},
      {"HW_repeatable_enabled", 7, 2, 1, false, 1, 0, 0, 1, SIGNAL_VALUE_TYPE_INTEGER},
      {"reserved5", 7, 3, 2, false, 1, 0, 0, 3, SIGNAL_VALUE_TYPE_INTEGER},
      {"PCW_X_Active", 7, 5, 3, false, 1, 0, 0, 0, SIGNAL_VALUE_TYPE_INTEGER}
  };

  size_t  SignalsOfAfterMarket_AWS_0x700_size =
          sizeof(SignalsOfAfterMarket_AWS_0x700)/sizeof(Signal);


  sg_var_t extractSignal(const char * name, struct can_frame *frame)
  {

     sg_var_t ret;
     Signal * sg_array =  nullptr;
     Signal * sg_desired = nullptr;
     size_t   sg_array_size = 0;

     ret.sg_type =  EXT_SG_VAL_TYPE_BROKEN;
     ret.sg_val._double = 0;

     //Choose appropiate Signals Array
     for (size_t i=0; i<CAN_MESSAGES_TYPES_NUM; i++)
     {
         if(can_id_values_table[i].value ==  frame->can_id)
         {
             sg_array = can_id_values_table[i].sg_array;
             sg_array_size = can_id_values_table[i].sg_array_size;
             i =  CAN_MESSAGES_TYPES_NUM;

         }

     }

     if(sg_array)
     {
         for(size_t i=0; i< sg_array_size;i++)
         {
             if(0 == strcmp(sg_array[i].name,name))
             {
                 sg_desired =  sg_array + i;
                 i = sg_array_size;
             }

         }

     }

     if(sg_desired)
     {
         //Extract the signal value

         quint8 cut_mask = 0xFF>>(0x08 - (sg_desired->numOfBits));
         quint8 raw_val =
                 frame->data[(sg_desired->startByte)]>>(sg_desired->startBit)&cut_mask;

         switch(sg_desired->valueType)
         {
         case SIGNAL_VALUE_TYPE_DOUBLE:
             ret.sg_val._double = (double)raw_val;
             ret.sg_type = EXT_SG_VAL_TYPE_DOUBLE;
             break;

         case SIGNAL_VALUE_TYPE_FLOAT:
             ret.sg_val._double = (double)raw_val;
             ret.sg_type = EXT_SG_VAL_TYPE_DOUBLE;
             break;

         case SIGNAL_VALUE_TYPE_INTEGER:

             if(1 ==sg_desired->numOfBits)
             {
                 ret.sg_val._bool = (bool)raw_val;
                 ret.sg_type = EXT_SG_VAL_TYPE_BOOL;
             }
             else
             {
                  ret.sg_val._int = (qint32)raw_val;
                 ret.sg_type = EXT_SG_VAL_TYPE_INTEGER;
             }
             break;

         default:
             qDebug("Illegal signal value type");
         }

      }

      return ret;
  }



#if 0
 //0x700 msg description
candbsignal_t aws_rx_msg_sg[] =
{
    sound_type
} ;

size_t aws_rx_msg_sg_size = (sizeof(aws_rx_msg_sg)/sizeof(candbsignal_t));

canmsg_sg_t aws_rx_msg = {
  .cid = can_id_master,
  .size = aws_alerts_table_size,
  .cansignals = aws_rx_msg_sg,
 };
#endif
