#ifndef DEFS_H
#define DEFS_H

#include <alerttypes.h>

#include "candbsignal.h"

#if 0
#    define DISPLAY_ITEM_ID AlertTypes::EnAlert
#else
//Enables usage of JSON enums unlisted in C++
    typedef qint32 DISPLAY_ITEM_ID;
#endif

#ifdef WIN32

struct can_frame{
      long can_id; 
      quint32    can_dlc;
      quint8    data[8];
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
can_id_cq_system_info = 3,
can_id_cq_time_info = 4,
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
#ifndef WIN32
  quint32 value;
#else
   long value;
#endif
  canrxmsg_type_t type;
  Signal * sg_array;
  const size_t sg_array_size;
} can_id_values_table_row_t;



static const can_id_values_table_row_t can_id_values_table[] =
{
  {can_id_master, 0x700, msg_simple, SignalsOfAfterMarket_AWS_0x700, SignalsOfAfterMarket_AWS_0x700_size},
  {can_id_tsr,    0x727, msg_simple, SignalsOfAfterMarket_TSR_0x727, SignalsOfAfterMarket_TSR_0x727_size},
  {can_id_s_adas, 0x7ac, msg_smart,  SignalsOfSmartADAS_S_ADAS_0x7ac, SignalsOfSmartADAS_S_ADAS_0x7ac_size},
  {can_id_cq_system_info,0x410, msg_simple, SignalsOfSeeQInfo_SN_System_0x410, SignalsOfSeeQInfo_SN_System_0x410_size},
  {can_id_cq_time_info,0x411, msg_simple, SignalsOfSeeQInfo_Time_Info_0x411, SignalsOfSeeQInfo_Time_Info_0x411_size},
};

//WARNING: on dbc realization the VT must be encapsulated in its protocol.
typedef struct vt_name2hex_s
{
  const char* name;
  Value * vt_array;
  const size_t vt_array_size;
} vt_name2hex_t;

static const vt_name2hex_t vt_name2hex_table[] =
{
    {"Vision_only_Sign_Type",ValuesOfVisionOnlySignType,ValuesOfVisionOnlySignType_size},
};

static const size_t vt_name2hex_table_size = sizeof(vt_name2hex_table)/sizeof(vt_name2hex_t);

#define CAN_MESSAGES_TYPES_NUM (sizeof(can_id_values_table)/sizeof(can_id_values_table_row_t))
#define MAX_SMART_ITEMS_NUM    (0xFF - 0x0)

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

#if 0
enum action_type_e
{
    GraphicItem = 0,
    Enabler = 1,
    StringArgument = 2,
    IntArgument = 3,
};
Q_DECLARE_METATYPE(action_type_e)
#endif

#endif // DEFS_H
