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

  Signal SignalsOfAfterMarket_TSR_0x727[] = {
      {"Vision_only_Sign_Type_D1", 0, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"Vision_only_supp_Sign_Type_D1", 1, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"Vision_only_Sign_Type_D2", 2, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"Vision_only_supp_Sign_Type_D2", 3, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"Vision_only_Sign_Type_D3", 4, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"Vision_only_supp_Sign_Type_D3", 5, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"Vision_only_Sign_Type_D4", 6, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"Vision_only_supp_Sign_Type_D4", 7, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER}
  };


  size_t  SignalsOfAfterMarket_TSR_0x727_size =
          sizeof(SignalsOfAfterMarket_TSR_0x727)/sizeof(Signal);

  Signal SignalsOfSmartADAS_S_ADAS_0x7ac[] = {
      {"Message_serial_ID", 0, 0, 8, false, 1, 0, 1, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"Visual_Item_ID", 1, 0, 8, false, 1, 0, 1, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"reserved_2", 2, 0, 8, true, 1, 0, 0, 0, SIGNAL_VALUE_TYPE_INTEGER},
      {"Activation_Flag", 3, 0, 1, false, 1, 0, 0, 1, SIGNAL_VALUE_TYPE_INTEGER},
      {"Max_duration_unit", 3, 1, 2, false, 1, 0, 0, 3, SIGNAL_VALUE_TYPE_INTEGER},
      {"Min_duration_unit", 3, 3, 2, false, 1, 0, 0, 3, SIGNAL_VALUE_TYPE_INTEGER},
      {"Float_parameter_unit", 3, 5, 3, false, 1, 0, 0, 7, SIGNAL_VALUE_TYPE_INTEGER},
      {"Float_parameter_int", 4, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"Float_parameter_frac", 5, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"Min_duration_display", 6, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"Max_duration_display", 7, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER}
  };

  size_t  SignalsOfSmartADAS_S_ADAS_0x7ac_size =
          sizeof(SignalsOfSmartADAS_S_ADAS_0x7ac)/sizeof(Signal);



  Signal SignalsOfSeeQInfo_SN_System_0x410[] = {
      {"SeeQSerialNumber0", 0, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"SeeQSerialNumber1", 1, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"SeeQSerialNumber2", 2, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"SeeQSerialNumber3", 3, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"SeeQSerialNumber4", 4, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"ManufacturerCode0", 5, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"ManufacturerCode1", 6, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"Reserved410", 7, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER}
  };

  size_t  SignalsOfSeeQInfo_SN_System_0x410_size =
          sizeof(SignalsOfSeeQInfo_SN_System_0x410)/sizeof(Signal);

  Signal SignalsOfSeeQInfo_Time_Info_0x411[] = {
      {"SeeqProductionDateWeek0", 0, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"SeeqProductionDateWeek1", 1, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"SeeqProductionDateYear0", 2, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"SeeqProductionDateYear1", 3, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"SeeqProduct0", 4, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"SeeqProduct1", 5, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"SeeqProduct2", 6, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"Reserved411", 7, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER}
  };

  size_t  SignalsOfSeeQInfo_Time_Info_0x411_size =
          sizeof(SignalsOfSeeQInfo_Time_Info_0x411)/sizeof(Signal);

  Signal SignalsOfSeeQInfo_App_Info_0x412[] = {
      {"FW_brain_v_major", 0, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"FW_brain_v_minor", 1, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"FW_MEST_v_major", 2, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"FW_MEST_v_minor", 3, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"FW_MEST_v_subMinor", 4, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"FW_MEST_v_patchNumber", 5, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"Reserved_412_1", 6, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER},
      {"Reserved_412_2", 7, 0, 8, false, 1, 0, 0, 255, SIGNAL_VALUE_TYPE_INTEGER}
  };

  size_t  SignalsOfSeeQInfo_App_Info_0x412_size =
          sizeof(SignalsOfSeeQInfo_App_Info_0x412)/sizeof(Signal);

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
  one2oneParseAndProcessGeneral(IAlertDisplay * alertsDisplay,struct can_frame * recv, const char * name, DISPLAY_ITEM_ID alert, bool polarity)
  {

      bool desired = extractSignal(name,recv).sg_val._bool;

      bool do_active = (desired == polarity);

      if(do_active)
      {
           alertsDisplay->activate(alert);
      }
      else
      {
          alertsDisplay->deactivate(alert);
      }
  }
#endif

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
