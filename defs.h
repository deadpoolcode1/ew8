#ifndef DEFS_H
#define DEFS_H

#define CAN_MESSAGES_TYPES_NUM 5

typedef enum DISPLAY_ERRORS
{
    OK= 0,
    GENERAL_ERROR = 1,
    EMPTY_TREE_QML = 2

} DISPLAY_ERRORS_t;

typedef enum can_id_e {

can_id_master = 0x700,
can_id_left =   0x610,
can_id_right =  0x620,

} can_id_t;



#endif // DEFS_H
