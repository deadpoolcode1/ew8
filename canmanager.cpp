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
      hnd = canOpenChannel(0, canOPEN_ACCEPT_VIRTUAL);
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


void CanManager::hmwStateParse(struct can_frame * frame, hmw_state_t * result)
{
    //previous and received data:
    qint32 byte = CAN_MSG_MASTER_HMW_BYTE;
    qint32 mask = CAN_MSG_MASTER_HMW_MSK;
    qint32 shift =  CAN_MSG_MASTER_HMW_SHIFT;

    qint32 en_byte =  CAN_MSG_MASTER_HMWEN_BYTE;
    qint32 en_msk = CAN_MSG_MASTER_HMWEN_MSK;

    quint32 level_byte = CAN_MSG_MASTER_HW_LEVEL_BYTE;
    quint32 level_msk = CAN_MSG_MASTER_HW_LEVEL_MSK;
    quint32 level_shift = CAN_MSG_MASTER_HW_LEVEL_SHIFT;


    //TODO consider what if hmw measurement > 0xF?
    qint32 frameState = ((frame->data[byte]&mask) >> shift);

    qint32 frameValidState = ((frame->data[en_byte]&en_msk)? 1 : 0);

    quint32 frameLevelState = ((frame->data[level_byte]&level_msk)>>level_shift);

    //make decision:

    result->is_active =  true;

    switch(frameLevelState)
    {
    case HW_Clear:

        result->is_active = false;

        break;

    case HW_Green:

        result->alert =  AlertTypes::ALERT_HMW_MONITOR;
        result->value = AlertTypes::HMW_GR;

        break;

    case HW_Monitor:

         result->alert =  AlertTypes::ALERT_HMW_MONITOR;
         result->value = (AlertTypes::EnHMW) frameState;

        break;

    case HW_Alert:

         result->alert =  AlertTypes::ALERT_HMW_ALERT;
         result->value = (AlertTypes::EnHMW) frameState;


        break;

    }

    if(!frameValidState)
    {
        result->is_active =  false;
    }
}

void CanManager::hmwStateParseAndProcess(struct can_frame * prev, struct can_frame * recv)
{

    //extract data and make decision:

    hmw_state_t prevres;
    hmw_state_t recvres;

    hmwStateParse(prev,&prevres);
    hmwStateParse(recv,&recvres);


    //execute decision:

    //deactivation
    if(prevres.is_active && (!recvres.is_active ||(prevres.value != recvres.value) || (prevres.alert != recvres.alert)))
    {
        mydisplays->deactivate(prevres.alert);
    }

    //activation
    if(recvres.is_active && (!prevres.is_active || (prevres.value != recvres.value) || (prevres.alert != recvres.alert)))
    {
        mydisplays->activate(recvres.alert,(quint8)recvres.value);
    }


}

void CanManager::beamStateParseAndProcess(struct can_frame * prev, struct can_frame * recv)
{
    qint32 byte = CAN_MSG_MASTER_BEAM_BYTE;
    qint32 mask = CAN_MSG_MASTER_BEAM_MSK;

    qint32 en_byte =  CAN_MSG_MASTER_FLA_BYTE;
    qint32 en_msk = CAN_MSG_MASTER_FLA_MSK;


    AlertTypes::EnAlert prevState = ((prev->data[byte]&mask)? AlertTypes::ALERT_HI_BEAM : AlertTypes::ALERT_LOW_BEAM);

    AlertTypes::EnAlert recvState = ((recv->data[byte]&mask)? AlertTypes::ALERT_HI_BEAM : AlertTypes::ALERT_LOW_BEAM);


    qint32 prevValidState = ((prev->data[en_byte]&en_msk)? 1 : 0);

    qint32 recvValidState = ((recv->data[en_byte]&en_msk)? 1 : 0);


    if ((prevValidState && !recvValidState) || (recvState != prevState))
    {
        mydisplays->deactivate(prevState);
    }


    if(recvValidState && ((!prevValidState) || (recvState != prevState)))
    {
        mydisplays->activate(recvState);
    }

}


void CanManager::sliSingleStateParseAndProcess(struct can_frame * prev, struct can_frame * recv, quint8 signType, AlertTypes::EnAlert alert)
{

    bool is_sign_in_prev =  false;
    bool is_sign_in_recv =  false;

    quint8 sign_byte_prev;
    quint8 sign_byte_recv;


    for (size_t i = 0; i < 4; i++)
    {

        sign_byte_prev = prev->data[i*2];
        sign_byte_recv = recv->data[i*2];

        //supp_byte = frame->data[1+i*2];

        if (signType == sign_byte_prev)
        {
          is_sign_in_prev = true;
        }

        if (signType == sign_byte_recv)
        {
          is_sign_in_recv = true;
        }
    }

    if (is_sign_in_recv&&!is_sign_in_prev)
    {
        mydisplays->activate(alert);
    }

    if (is_sign_in_prev&&!is_sign_in_recv)
    {
         mydisplays->deactivate(alert);
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


                   //byte 1:

               beamStateParseAndProcess(preframe,frame);

               //byte 2:

               hmwStateParseAndProcess(preframe,frame);

               //byte 4:

               if(1 == (alertAction = alertStateParseAndCmp(preframe, frame, CAN_MSG_MASTER_LDW_OFF_BYTE, CAN_MSG_MASTER_LDW_OFF_MSK)))
               {
                   mydisplays->deactivate(AlertTypes::ALERT_LDWON);
                   mydisplays->activate(AlertTypes::ALERT_LDWOFF);
               }
               else if (-1 == alertAction)
               {
                   mydisplays->deactivate(AlertTypes::ALERT_LDWOFF);
                   mydisplays->activate(AlertTypes::ALERT_LDWON);
               }

               if(1 == (alertAction = alertStateParseAndCmp(preframe, frame, CAN_MSG_MASTER_LLDW_BYTE, CAN_MSG_MASTER_LLDW_MSK)))
               {
                  mydisplays->activate(AlertTypes::ALERT_LLDW);
               }
               else if (-1 == alertAction)
               {
                 mydisplays->deactivate(AlertTypes::ALERT_LLDW);
               }


               if(1 == (alertAction = alertStateParseAndCmp(preframe, frame, CAN_MSG_MASTER_RLDW_BYTE, CAN_MSG_MASTER_RLDW_MSK)))
               {
                  mydisplays->activate(AlertTypes::ALERT_RLDW);
               }
               else if (-1 == alertAction)
               {
                 mydisplays->deactivate(AlertTypes::ALERT_RLDW);
               }

               if(1 == (alertAction = alertStateParseAndCmp(preframe, frame, CAN_MSG_MASTER_FCW_BYTE, CAN_MSG_MASTER_FCW_MSK)))
               {
                  mydisplays->activate(AlertTypes::ALERT_FCW);
               }
               else if (-1 == alertAction)
               {
                 mydisplays->deactivate(AlertTypes::ALERT_FCW);
               }

               //byte 5:


               if(1 == (alertAction = alertStateParseAndCmp(preframe, frame, CAN_MSG_MASTER_PCW_BYTE, CAN_MSG_MASTER_PCW_MSK)))
               {
                  mydisplays->activate(AlertTypes::ALERT_PCW);
               }
               else if (-1 == alertAction)
               {
                 mydisplays->deactivate(AlertTypes::ALERT_PCW);
               }

               if(1 == (alertAction = alertStateParseAndCmp(preframe, frame, CAN_MSG_MASTER_PDZ_BYTE, CAN_MSG_MASTER_PDZ_MSK)))
               {
                  mydisplays->activate(AlertTypes::ALERT_PDZ);
               }
               else if (-1 == alertAction)
               {
                 mydisplays->deactivate(AlertTypes::ALERT_PDZ);
               }


#if 0
               if(1 == (alertAction = alertStateParseAndCmp(preframe, frame, CAN_MSG_MASTER_BLINKERS_BYTE, CAN_MSG_MASTER_BLINKERS_MSK)))
               {
                  mydisplays->activate(AlertTypes::ALERT_BLINKERS);
               }
               else if (-1 == alertAction)
               {
                 mydisplays->deactivate(AlertTypes::ALERT_BLINKERS);
               }
#endif


//                  mydisplays->mutex.unlock();
           break;

        case can_id_sli:

            sliSingleStateParseAndProcess(preframe,frame, 0x9, AlertTypes::ALERT_SLI_REGULAR);

            sliSingleStateParseAndProcess(preframe,frame, 0xE, AlertTypes::ALERT_FORWARD);

            break;
    }

    memcpy(preframe, frame, sizeof(struct can_frame));
}

}
