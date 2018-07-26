#ifndef DEFS_H
#define DEFS_H

#include <stdint.h>

#define CAN_MESSAGES_TYPES_NUM 1

typedef enum DISPLAY_ERRORS
{
    OK= 0,
    GENERAL_ERROR = 1,
    EMPTY_TREE_QML = 2

} DISPLAY_ERRORS_t;

typedef enum can_id_e {

can_id_undefined = -1,
can_id_master = 0,
can_id_left =   1,
can_id_right =  2,

} can_id_t;


typedef struct can_id_values_table_row_s
{
  can_id_t mnemonic;
  uint32_t   value;
} can_id_values_table_row_t;



static const can_id_values_table_row_t can_id_values_table[] =
{
  {can_id_master, 0x700},
  {can_id_left, 0x610},
  {can_id_right, 0x620},
};

#define CAN_MSG_MASTER_LDW_OFF_BYTE 4
#define CAN_MSG_MASTER_LDW_OFF_MSK 0x01

#define CAN_MSG_MASTER_LLDW_BYTE 4
#define CAN_MSG_MASTER_LLDW_MSK 0x02

#define CAN_MSG_MASTER_RLDW_BYTE 4
#define CAN_MSG_MASTER_RLDW_MSK 0x04

#define CAN_MSG_MASTER_FCW_BYTE 4
#define CAN_MSG_MASTER_FCW_MSK 0x08

#define CAN_MSG_MASTER_PCW_BYTE 5
#define CAN_MSG_MASTER_PCW_MSK 0x02

#define CAN_MSG_MASTER_PDZ_BYTE 5
#define CAN_MSG_MASTER_PDZ_MSK 0x04

#endif // DEFS_H
