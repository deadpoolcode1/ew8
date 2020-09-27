#ifndef DEFS_H
#define DEFS_H

#include <alerttypes.h>

#include "candbsignal.h"

typedef quint32 CanStdId_t;

#include <QElapsedTimer>

extern QElapsedTimer bootUpTimer;

#define DEFAULT_EW_CAN_CONNECTION_TIMEOUT (500)
#define DEFAULT_EW_KEEP_ALIVE_TIMEOUT (200)

#define DYNAMIC_DISPLAY_ITEM_ID

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


static const can_msg_types_table_row_t hardcoded_can_msg_types_table[] =
{
   // {0x7ac, msg_smart},
};

const size_t hardcoded_can_msg_types_table_size =  sizeof(hardcoded_can_msg_types_table)/sizeof(can_msg_types_table_row_t);


#define HARDCODED_CAN_MESSAGES_TYPES_NUM can_msg_types_table_size

#endif // DEFS_H
