#include "canmanager.h"
#include <string.h>
#include <stdio.h>
#include "defs.h"

#ifndef WIN32
#include <unistd.h>
#include <can_netlink.h>
#include <libsocketcan.h>

#include <net/if.h>
#include <linux/types.h>

#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/uio.h>

#include <linux/can.h>
#include <linux/can/raw.h>

#else

#include "canlib.h"

#endif


#include <QThread>
#include <QMutex>

#include <iostream>


#include "ialertdisplay.h"

CanManager::CanManager(IAlertDisplay * alertdisp)
{
    mydisplays = alertdisp;
    init();
}


void CanManager::init(void)
{

 for(size_t i = 0; i < CAN_MESSAGES_TYPES_NUM;i++)
 {
    init_frame(&(prev_frame[i]));
 }

#ifndef WIN32
    socknum = socket(PF_CAN, SOCK_RAW, CAN_RAW);

    strcpy(ifr.ifr_name, "can0" );
    ioctl(socknum, SIOCGIFINDEX, &ifr);

    addr.can_family = AF_CAN;
    addr.can_ifindex = ifr.ifr_ifindex;

    bind(socknum, (struct sockaddr *)&addr, sizeof(addr));
    std::cout << "can0 initiated"<<std::endl;
#else
      canInitializeLibrary();

      //Channel initialization
      hnd = canOpenChannel(1, 0);
      stat = canSetBusParams(hnd, canBITRATE_500K, 0, 0, 0, 0, 0);
      stat = canBusOn(hnd);

#endif
}

void CanManager::read_frame(void)
{
#ifndef WIN32
    struct can_frame frame;

    ssize_t nbytes = 0;

    nbytes = read(socknum, &frame, sizeof(struct can_frame));

    if (nbytes < 0) {
        perror("can raw socket read");
   //     return 1;
    }

    /* paranoid check ... */
    if (nbytes < (ssize_t)sizeof(struct can_frame)) {
        fprintf(stderr, "read: incomplete CAN frame\n");
  //      return 1;
    }

        /* do something with the received CAN frame */

   parse_frame(&frame);

#else
      stat = canOK;

      struct can_frame frame;

      unsigned int flags;

      /*
      long id;
      unsigned int dlc, flags;
      unsigned char data[8];
      */
      DWORD time;

      //Waits up to 100 ms for a message
         stat = canReadWait(hnd, &(frame.can_id), (frame.data), &(frame.can_dlc), &flags, &time, 100);
         if (stat == canOK){
           if (flags & canMSG_ERROR_FRAME){
             printf("***ERROR FRAME RECEIVED***");
           }
           else {
             parse_frame(&frame);
           }
         }
         //Break the loop if something goes wrong
         else if (stat != canERR_NOMSG){

         }


#endif
}



void CanManager::init_frame(struct can_frame * frame)
{
      frame->can_id =  0x0;
      frame->can_dlc = 0x0;
      frame->__pad =   0x0;
      frame->__res0 =  0x0;
      frame->__res1 =  0x0;
      frame->data[0] = 0x0;
      frame->data[1] = 0x0;
      frame->data[2] = 0x0;
      frame->data[3] = 0x0;
      frame->data[4] = 0x0;
      frame->data[5] = 0x0;
      frame->data[6] = 0x0;
      frame->data[7] = 0x0;
}

void CanManager::write_frame(void)
{


}

void CanManager::run()
{
    QString result;

    while(1)
    {
        mydisplays->mutex.lock();
        this->read_frame();
        mydisplays->mutex.unlock();

#ifdef WIN32
        std::this_thread::sleep_for(std::chrono::milliseconds(2));
#else
        msleep(2);
#endif
    }

    emit resultReady(result);
}


qint32 CanManager::alertStateParseAndCmp(struct can_frame * prev, struct can_frame * recv, quint32 byte, quint8 mask)
{
    quint32 ret = 0;

    quint32 prevState = (prev->data[byte]&mask)? 1 : 0;

    quint32 recvState = (recv->data[byte]&mask)? 1 : 0;

    ret = recvState - prevState;

    return ret;
}

AlertTypes::EnAlert CanManager::fromHMWField(quint32 field)
{
    AlertTypes::EnAlert ret;


    //WARNING: ALERT_HMWXX are suggested to be ordered according to their indices
    ret = (AlertTypes::EnAlert)((field) + (quint32) AlertTypes::ALERT_HMW0) ;

    return ret;

}

void CanManager::hmwStateParseAndProcess(struct can_frame * prev, struct can_frame * recv)
{
    qint32 byte = CAN_MSG_MASTER_HMW_BYTE;
    qint32 mask = CAN_MSG_MASTER_HMW_MSK;

    qint32 shift = 1;

    qint32 prevState = ((prev->data[byte]&mask) >> shift);

    qint32 recvState = ((recv->data[byte]&mask) >> shift);


    //when state is bigger than 16 a green car is present
    if (prevState >= 16)
    {
        prevState = 16;
    }


    if (recvState >= 16)
    {
        recvState = 16;
    }



    if(recvState != prevState)
    {
        mydisplays->deactivate(fromHMWField(prevState));

        mydisplays->activate(fromHMWField(recvState));
    }
}

void CanManager::parse_frame(struct can_frame * frame)
{
    can_id_t received_id = can_id_undefined;
    bool is_frame_updated = false;

    for (size_t i = 0; i < CAN_MESSAGES_TYPES_NUM; i++)
    {
         if(can_id_values_table[i].value == frame->can_id)
         {
             received_id = can_id_values_table[i].mnemonic;
             
             i = CAN_MESSAGES_TYPES_NUM;
         }
    }

    //TODO compare with received:

   if(0 != memcmp(&prev_frame[received_id], frame, sizeof(struct can_frame)))
   {
     is_frame_updated = true;
   }




    //display information:


   if(!is_frame_updated)
   {
       //skip
   }
   else
   {


       struct can_frame * preframe = &prev_frame[received_id];

       qint32 alertAction;


        switch(received_id)
        {
               case can_id_master:

//                    mydisplays->mutex.lock();

                   //byte 2:

                   hmwStateParseAndProcess(preframe,frame);

                   //byte 4:

                   if(1 == (alertAction = alertStateParseAndCmp(preframe, frame, CAN_MSG_MASTER_LDW_OFF_BYTE, CAN_MSG_MASTER_LDW_OFF_MSK)))
                   {
                      //TODO activate off LDWOFF alert
                   }
                   else if (-1 == alertAction)
                   {


                   }

                   if(1 == (alertAction = alertStateParseAndCmp(prev_frame, frame, CAN_MSG_MASTER_LLDW_BYTE, CAN_MSG_MASTER_LLDW_MSK)))
                   {
                      mydisplays->activate(AlertTypes::ALERT_LLDW);
                   }
                   else if (-1 == alertAction)
                   {
                     mydisplays->deactivate(AlertTypes::ALERT_LLDW);
                   }


                   if(1 == (alertAction = alertStateParseAndCmp(prev_frame, frame, CAN_MSG_MASTER_RLDW_BYTE, CAN_MSG_MASTER_RLDW_MSK)))
                   {
                      mydisplays->activate(AlertTypes::ALERT_RLDW);
                   }
                   else if (-1 == alertAction)
                   {
                     mydisplays->deactivate(AlertTypes::ALERT_RLDW);
                   }

                   if(1 == (alertAction = alertStateParseAndCmp(prev_frame, frame, CAN_MSG_MASTER_FCW_BYTE, CAN_MSG_MASTER_FCW_MSK)))
                   {
                      mydisplays->activate(AlertTypes::ALERT_FCW);
                   }
                   else if (-1 == alertAction)
                   {
                     mydisplays->deactivate(AlertTypes::ALERT_FCW);
                   }

                   //byte 5:


                   if(1 == (alertAction = alertStateParseAndCmp(prev_frame, frame, CAN_MSG_MASTER_PCW_BYTE, CAN_MSG_MASTER_PCW_MSK)))
                   {
                      mydisplays->activate(AlertTypes::ALERT_PCW);
                   }
                   else if (-1 == alertAction)
                   {
                     mydisplays->deactivate(AlertTypes::ALERT_PCW);
                   }

                   if(1 == (alertAction = alertStateParseAndCmp(prev_frame, frame, CAN_MSG_MASTER_PDZ_BYTE, CAN_MSG_MASTER_PDZ_MSK)))
                   {
                      mydisplays->activate(AlertTypes::ALERT_PDZ);
                   }
                   else if (-1 == alertAction)
                   {
                     mydisplays->deactivate(AlertTypes::ALERT_PDZ);
                   }

 //                  mydisplays->mutex.unlock();
               break;
        }

        memcpy(&prev_frame[received_id], frame, sizeof(struct can_frame));
   }

}
