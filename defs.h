#ifndef DEFS_H
#define DEFS_H

#include <alerttypes.h>

#include "candbsignal.h"

typedef quint32 CanStdId_t;

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

typedef enum canrxmsg_type_e
{
    msg_simple = 0,
    msg_smart = 1,
}
canrxmsg_type_t;

typedef struct can_msg_types_table_row_s
{
  CanStdId_t std_id;
  canrxmsg_type_t type;
} can_msg_types_table_row_t;



static const can_msg_types_table_row_t can_msg_types_table[] =
{
    {0x7ac, msg_smart},
};

const size_t can_msg_types_table_size =  sizeof(can_msg_types_table)/sizeof(can_msg_types_table_row_t);



#define CAN_MESSAGES_TYPES_NUM can_msg_types_table_size
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
