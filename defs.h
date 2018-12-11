#ifndef DEFS_H
#define DEFS_H

#include <alerttypes.h>

#include "candbsignal.h"

#include <map>


#ifdef WIN32

struct can_frame{
      long can_id;  /* 32 bit CAN_ID + EFF/RTR/ERR flags */
      uint    can_dlc; /* frame payload length in byte (0 .. CAN_MAX_DLEN) */
      uchar    __pad;   /* padding */
      uchar    __res0;  /* reserved / padding */
      uchar    __res1;  /* reserved / padding */
      uchar    data[8];
};

#endif


typedef enum DISPLAY_ERRORS
{
    OK= 0,
    GENERAL_ERROR = 1,
    EMPTY_TREE_QML = 2,
    OBJECT_ALREADY_EXISTS_IN_MAP =3

} DISPLAY_ERRORS_t;


typedef enum ACTION_ERRORS
{
    ACTION_OK= 0,
    ACTION_GENERAL_ERROR = 1,
} ACTION_ERRORS_t;

typedef enum FORCE_INVISIBILITY
{
    DO_NOT_FORCE_INVISIBILITY = 0,
    FORCE_INVISIBILITY = 1
} FORCE_INVISIBILITY_t;

typedef enum can_id_e {
can_id_undefined = -1,
can_id_master = 0,
can_id_tsr   =  1,
can_id_s_adas = 2,
#if 0
can_id_left =   3,
can_id_right =  4,
#endif
} can_id_t;

typedef enum canrxmsg_type_e
{
    msg_simple = 0,
    msg_smart = 1,
}
canrxmsg_type_t;

typedef struct can_id_values_table_row_s
{
  can_id_t mnemonic;
  quint32 value;
  canrxmsg_type_t type;
  Signal * sg_array;
  const size_t sg_array_size;
} can_id_values_table_row_t;



static const can_id_values_table_row_t can_id_values_table[] =
{
  {can_id_master, 0x700, msg_simple, SignalsOfAfterMarket_AWS_0x700, SignalsOfAfterMarket_AWS_0x700_size},
  {can_id_tsr,    0x727, msg_simple, SignalsOfAfterMarket_TSR_0x727, SignalsOfAfterMarket_TSR_0x727_size},
  {can_id_s_adas, 0x7ac, msg_smart,  SignalsOfSmartADAS_S_ADAS_0x7ac, SignalsOfSmartADAS_S_ADAS_0x7ac_size},
};

#define CAN_MESSAGES_TYPES_NUM (sizeof(can_id_values_table)/sizeof(can_id_values_table_row_t))
#define MAX_SMART_ITEMS_NUM    (0xFF - 0x0)


#define CAN_MSG_MASTER_SOUND_BYTE 0
#define CAN_MSG_MASTER_SOUND_TYPE_MSK 0x07


#define CAN_MSG_MASTER_TIME_IND_BYTE 0
#define CAN_MSG_MASTER_TIME_IND_MSK  0x18
#define CAN_MSG_MASTER_TIME_IND_SHIFT 0x3

#define CAN_MSG_MASTER_SND_REP_MSK 0x60
#define CAN_MSG_MASTER_SND_REP_SHIFT 0x5

#define CAN_MSG_MASTER_SND_SUPPRESSED_MSK  0x80

//===================================

#define CAN_MSG_MASTER_SEC_DIAG_BYTE 1
#define CAN_MSG_MASTER_SEC_DIAG_MSK 0x10


#define CAN_MSG_MASTER_ZERO_SPEED_BYTE 1
#define CAN_MSG_MASTER_ZERO_SPEED_MSK 1

#define CAN_MSG_MASTER_BEAM_BYTE 1
#define CAN_MSG_MASTER_BEAM_MSK  0x40

#define CAN_MSG_MASTER_FLA_BYTE 1
#define CAN_MSG_MASTER_FLA_MSK  0x80

//===================================

#define CAN_MSG_MASTER_HMW_BYTE 2
#define CAN_MSG_MASTER_HMW_MSK  0xFE
#define CAN_MSG_MASTER_HMW_SHIFT  0x1

#define CAN_MSG_MASTER_HMWEN_BYTE 2
#define CAN_MSG_MASTER_HMWEN_MSK  0x01

//===================================

#define CAN_MSG_MASTER_ERR_ACT_BYTE 3
#define CAN_MSG_MASTER_ERR_ACT_MSK  0x01

#define CAN_MSG_MASTER_ERR_CODE_BYTE 3
#define CAN_MSG_MASTER_ERR_CODE_MSK  0xFE
#define CAN_MSG_MASTER_ERR_CODE_SHIFT  0x1

//====================================

#define CAN_MSG_MASTER_LDW_OFF_BYTE 4
#define CAN_MSG_MASTER_LDW_OFF_MSK 0x01

#define CAN_MSG_MASTER_LLDW_BYTE 4
#define CAN_MSG_MASTER_LLDW_MSK 0x02

#define CAN_MSG_MASTER_RLDW_BYTE 4
#define CAN_MSG_MASTER_RLDW_MSK 0x04

#define CAN_MSG_MASTER_FCW_BYTE 4
#define CAN_MSG_MASTER_FCW_MSK 0x08

#define CAN_MSG_MASTER_MNTC_BYTE 4
#define CAN_MSG_MASTER_MNTC_MSK 0x40

#define CAN_MSG_MASTER_FLSAFE_BYTE 4
#define CAN_MSG_MASTER_FLSAFE_MSK 0x80

//====================================

#define CAN_MSG_MASTER_PDZ_BYTE 5
#define CAN_MSG_MASTER_PDZ_MSK 0x02

#define CAN_MSG_MASTER_PCW_BYTE 5
#define CAN_MSG_MASTER_PCW_MSK 0x04

#define CAN_MSG_MASTER_BLINKERS_BYTE 5
#define CAN_MSG_MASTER_BLINKERS_MSK 0x08

#define CAN_MSG_MASTER_CYCLIST_BYTE 5
#define CAN_MSG_MASTER_CYCLIST_MSK 0x10


#define CAN_MSG_MASTER_TAMPER_BYTE 5
#define CAN_MSG_MASTER_TAMPER_MSK 0x20

#define CAN_MSG_MASTER_SPEED_FMT_BYTE 5
#define CAN_MSG_MASTER_SPEED_FMT_MSK 0x40

#define CAN_MSG_MASTER_TSREN_BYTE 5
#define CAN_MSG_MASTER_TSREN_MSK 0x80

//====================================

#define CAN_MSG_MASTER_TSR_WRNLEV_BYTE 6
#define CAN_MSG_MASTER_TSR_WRNLEV_MSK 0x07

#define CAN_MSG_MASTER_FLSAFE_LEV_BYTE 6
#define CAN_MSG_MASTER_FLSAFE_LEV_MSK 0x18
#define CAN_MSG_MASTER_FLSAFE_LEV_SHIFT 0x4

//====================================

#define CAN_MSG_MASTER_HW_LEVEL_BYTE 7
#define CAN_MSG_MASTER_HW_LEVEL_MSK 0x3
#define CAN_MSG_MASTER_HW_LEVEL_SHIFT 0x0

#define CAN_MSG_MASTER_HW_REPEN_BYTE 7
#define CAN_MSG_MASTER_HW_REPEN_MSK 0x04
#define CAN_MSG_MASTER_HW_REPEN_SHIFT 0x3

//Smart Adas defines:
#define CAN_MSG_S_ADAS_M_ID_BYTE 0
#define CAN_MSG_S_ADAS_VIS_ITEM_BYTE 1

#define CAN_MSG_S_ADAS_ACTIV_BYTE 3
#define CAN_MSG_S_ADAS_ACTIV_MSK 0x1

#define CAN_MSG_S_ADAS_MAXDUR_UNIT_BYTE 3
#define CAN_MSG_S_ADAS_MAXDUR_UNIT_MSK 0x06
#define CAN_MSG_S_ADAS_MAXDUR_UNIT_SHIFT 1

#define CAN_MSG_S_ADAS_MINDUR_UNIT_BYTE 3
#define CAN_MSG_S_ADAS_MINDUR_UNIT_MSK 0x18
#define CAN_MSG_S_ADAS_MINDUR_UNIT_SHIFT 3

#define CAN_MSG_S_ADAS_PARAM_UNIT_BYTE 3
#define CAN_MSG_S_ADAS_PARAM_UNIT_MSK 0xE0
#define CAN_MSG_S_ADAS_PARAM_UNIT_SHIFT 5

#define CAN_MSG_S_ADAS_PARAM_INT_BYTE 4
#define CAN_MSG_S_ADAS_PARAM_FRAC_BYTE 5

#define CAN_MSG_S_ADAS_MINDUR_BYTE 6
#define CAN_MSG_S_ADAS_MAXDUR_BYTE 7

typedef enum visual_item_unit_e
{
    viu_None = -1,
    viu_KMH = 0,
    viu_MPH = 1,
    viu_Meter = 2,
    viu_Feet = 3,
    viu_Second = 4,
    viu_Minute = 5,
}
visual_item_unit_t;



typedef enum duration_unit_e
{
    du_second = 0,
    du_10_seconds = 1,
    du_minute = 2,
    du_hour = 3,
}
duration_unit_t;


typedef struct du_units_table_row_s
{
   duration_unit_t unit;
   quint32 msec;
}
du_units_table_row_t;

static const du_units_table_row_t du_units_table[] =
{
    {du_second,      1000u},
    {du_10_seconds, 10000u},
    {du_minute,     60000u},
    {du_hour,     3600000u},
};

static const size_t du_units_table_size = (sizeof(du_units_table)/sizeof(du_units_table_row_t));

enum HW_Warn_level_e
{
    HW_Clear = 0x0,
    HW_Monitor = 0x1,
    HW_Alert  = 0x2,

};

enum PCW_PedDZ_e
{
    ped_Clear = 0,//"No pedestrian"
    ped_PedDZ = 1,//"Pedestrian in danger zone"
    ped_PCW = 2,//"PCW"
};

//TODO construct according to dbc layout(currently for 0x700 message):
typedef struct aws_alerts_table_row_s
{
   quint8 start_bit;
   quint8 length_bits;
   qint32 minimum;
   qint32 maximum;
   AlertTypes::EnAlert alert;
   quint8 value;
}
aws_alerts_table_row_t;

static const aws_alerts_table_row_t aws_alerts_table[] =
{
    {0,0,0,0,AlertTypes::ALERT_NONE,(quint8)0},
};

static const size_t aws_alerts_table_size = sizeof(aws_alerts_table)/sizeof(aws_alerts_table_row_t);

typedef struct tsr_alerts_table_row_s
{
   quint8 hexcode;
   AlertTypes::EnAlert alert;
   quint8 value;
}
tsr_alerts_table_row_t;

static const tsr_alerts_table_row_t tsr_alerts_table[] =
{
    //Speed Limits Regular Signs:
    {0x0, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_10},
    {0x1, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_20},
    {0x2, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_30},
    {0x3, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_40},
    {0x4, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_50},
    {0x5, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_60},
    {0x6, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_70},
    {0x7, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_80},
    {0x8, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_90},
    {0x9, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_100},
    {0xA, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_110},
    {0xB, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_120},
    {0xC, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_130},
    {0xD, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_140},

    {0xE, AlertTypes::ALERT_FORWARD    , (quint8)       0x00},


    //Speed Limits Electronic Signs:
    {0x1C, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_10},
    {0x1D, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_20},
    {0x1E, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_30},
    {0x1F, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_40},
    {0x20, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_50},
    {0x21, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_60},
    {0x22, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_70},
    {0x23, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_80},
    {0x24, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_90},
    {0x25, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_100},
    {0x26, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_110},
    {0x27, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_120},
    {0x28, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_130},
    {0x29, AlertTypes::ALERT_SLI, (quint8)AlertTypes::SLI_140},

    //Electonic End of All restrictions:
    {0x32,AlertTypes::ALERT_END_ALL_RESTR,(quint8)      0x00},

    //Regular End of All restrictions:
    {0x40,AlertTypes::ALERT_END_ALL_RESTR,(quint8)      0x00},


    {0xAB,AlertTypes::ALERT_MOTORWAY   , (quint8)       0x00},


    {0xAF,AlertTypes::ALERT_PLAYGROUND , (quint8)       0x00},

    {0xC8,AlertTypes::ALERT_NO_PASS, (quint8)           0x00},
    {0xFF,AlertTypes::ALERT_NONE,    (quint8)           0x00},



};

static const size_t tsr_alerts_table_size = sizeof(tsr_alerts_table)/sizeof(tsr_alerts_table_row_t);

typedef std::map <QString, qint32> json_enum_t;

#endif // DEFS_H
