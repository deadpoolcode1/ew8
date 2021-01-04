#include "versionmsg.h"
#include "defs.h"
#include <QDebug>
#include <QFile>
#include <QTextStream>
#include "amjsonconfigreader.h"
#include <QJsonObject>
#include <QJsonArray>


//TODO remove unused:
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <linux/ioctl.h>
#include <sys/ioctl.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <errno.h>


//NOTE: Next header is used for random()
//TODO: replace with QRandomGenerator, when passing to qt 5.12

#define	AT91C_BASE_SFC	0xf804c000
#define	AT91C_BASE_PMC	0xf0014000

#define	AT91C_SFC_DR0_OFFSET (0x20)
#define	AT91C_PMC_PCR_OFFSET (0x10c)

//Fuse Controller ID:
#define	AT91C_ID_SFC 50
#define	AT91C_PMC_PCR_EN (1 << 28)
#define	AT91C_PMC_PCR_CMD (1 << 12)



void VersionMsg::singleShot(CanManager *aCanManager)
{
    sendVersionInfo(aCanManager);
    sendServiceNumber(aCanManager);
}



void VersionMsg::sendVersionInfo(CanManager *aCanManager)
{
    //NOTE: Engine version:
    struct can_frame frame_to_send;

    QJsonObject jsonObject = AMJsonConfigReader::getInstance()->object();
    QJsonArray jsonArray = jsonObject["MediaVersion"].toArray();

    frame_to_send.can_id = 0x7d0;
    frame_to_send.can_dlc = 8;

    frame_to_send.data[0] = (quint8)MAJOR_VERSION;
    frame_to_send.data[1] = (quint8)MINOR_VERSION;

    //NOTE: Config version (Get from Json):
    frame_to_send.data[2] = (quint8)(0xff);
    frame_to_send.data[3] = (quint8)(0xff);

    if(!jsonArray.isEmpty())
    {
        frame_to_send.data[2] = (quint8)jsonArray.at(0).toInt(0xff);
        frame_to_send.data[3] = (quint8)jsonArray.at(1).toInt(0xff);
    }

    //NOTE: System build version:

    bool success = false;

    #ifndef WIN32
    QFile buildIdFile("/etc/version2epoch");

    QString buildId;

    if(buildIdFile.open(QFile::ReadOnly | QFile::Text))
    {
      QTextStream buildIdStream(&buildIdFile);
      buildId = buildIdStream.readLine();
      buildIdFile.close();
    }

    if(buildId.length() != 8)
    {
       qDebug("System Build ID is not found is not found.");
    }
    else
    {

        frame_to_send.data[4] = (quint8)buildId.right(2).toUInt(&success,16);
        if(success) frame_to_send.data[5] = (quint8)buildId.mid(4,2).toUInt(&success,16);
        if(success) frame_to_send.data[6] = (quint8)buildId.mid(2,2).toUInt(&success,16);
        if(success) frame_to_send.data[7] = (quint8)buildId.left(2).toUInt(&success,16);
    }
#endif

    if(!success)
    {
        frame_to_send.data[4] = (quint8)(0xff);
        frame_to_send.data[5] = (quint8)(0xff);
        frame_to_send.data[6] = (quint8)(0xff);
        frame_to_send.data[7] = (quint8)(0xff);
    }

    aCanManager->write_frame(&frame_to_send);   
}

void VersionMsg::sendServiceNumber(CanManager *aCanManager)
{
    //NOTE: Engine version:
    struct can_frame frame_to_send_LSB;
    struct can_frame frame_to_send_MSB;


    QJsonObject jsonObject = AMJsonConfigReader::getInstance()->object();
    QJsonArray jsonArray = jsonObject["MediaVersion"].toArray();

    frame_to_send_LSB.can_id = 0x7d1;
    frame_to_send_LSB.can_dlc = 8;

    frame_to_send_MSB.can_id = 0x7d2;
    frame_to_send_MSB.can_dlc = 8;

    //TODO read the SN and verify:
    qint32 mem_fd = open("/dev/mem",O_RDWR);

    void* pmc_pcr_ptr = mmap(NULL, AT91C_PMC_PCR_OFFSET + sizeof(quint32), PROT_WRITE,
                        MAP_PRIVATE, mem_fd, AT91C_BASE_PMC);


    void* sfc_dr_ptr = mmap(NULL, AT91C_SFC_DR0_OFFSET + 16*sizeof(quint32), PROT_READ,
                        MAP_PRIVATE, mem_fd, AT91C_BASE_SFC);



    close(mem_fd);


    enableDisableSFC((quint32*)(pmc_pcr_ptr)+(AT91C_PMC_PCR_OFFSET/sizeof(quint32)),true);


    for(qint32 i = 0; i<16;i++)
    {
        qDebug()<<"sn"<<i<<":"<<readDataSFC((quint32*)sfc_dr_ptr+(AT91C_SFC_DR0_OFFSET/sizeof(quint32)),i);
    }



     enableDisableSFC((quint32*)(pmc_pcr_ptr)+(AT91C_PMC_PCR_OFFSET/sizeof(quint32)),false);


    //1. if all are 0x00 send the source

    //2. if not verify

    //3. if broken: set all to 0xFF


    munmap(sfc_dr_ptr, AT91C_SFC_DR0_OFFSET + 16*sizeof(quint32));

    munmap(pmc_pcr_ptr, AT91C_PMC_PCR_OFFSET + sizeof(quint32));

    //aCanManager->write_frame(&frame_to_send_LSB);
    //aCanManager->write_frame(&frame_to_send_MSB);
}

void VersionMsg::enableDisableSFC(quint32* wr_ptr, bool On)
{
    *wr_ptr = On ? (AT91C_ID_SFC | AT91C_PMC_PCR_CMD | AT91C_PMC_PCR_EN) :
                   (AT91C_ID_SFC | AT91C_PMC_PCR_CMD);
}

quint32 VersionMsg::readDataSFC(quint32* rd_ptr, quint32 index)
{
   quint32 ret;
   ret = *(rd_ptr+index);
   return ret;
}




