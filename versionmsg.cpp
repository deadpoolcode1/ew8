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

VersionMsg * VersionMsg::instance = nullptr;


VersionMsg::VersionMsg(CanManager * aCanManager)
{
    itsCanManager = aCanManager;
    readVersionInfo();
#ifndef WIN32
    readServiceNumber();
#endif
}

void VersionMsg::sendAll(void)
{
    itsCanManager->write_frame(&version2send);
#ifndef WIN32
    itsCanManager->write_frame(&sn2send_LSB);
    itsCanManager->write_frame(&sn2send_MSB);
#endif
}


void VersionMsg::singleShot()
{
    if(nullptr != instance)
    {
        instance->sendAll();
    }
    else
    {
        qDebug("WARNING: Version Message is not constructed yet.");
    }
}


void VersionMsg::create(CanManager *aCanManager)
{
    if(nullptr == instance)
    {
        instance = new VersionMsg(aCanManager);
    }
    else
    {
        qDebug("WARNING: Version Message is already constructed.");
    }
}



void VersionMsg::readVersionInfo(void)
{
    //NOTE: Engine version:
    QJsonObject jsonObject = AMJsonConfigReader::getInstance()->object();
    QJsonArray jsonArray = jsonObject["MediaVersion"].toArray();

    version2send.can_id = 0x7d0;
    version2send.can_dlc = 8;

    version2send.data[0] = (quint8)MAJOR_VERSION;
    version2send.data[1] = (quint8)MINOR_VERSION;

    //NOTE: Config version (Get from Json):
    version2send.data[2] = (quint8)(0xff);
    version2send.data[3] = (quint8)(0xff);

    if(!jsonArray.isEmpty())
    {
        version2send.data[2] = (quint8)jsonArray.at(0).toInt(0xff);
        version2send.data[3] = (quint8)jsonArray.at(1).toInt(0xff);
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

        version2send.data[4] = (quint8)buildId.right(2).toUInt(&success,16);
        if(success) version2send.data[5] = (quint8)buildId.mid(4,2).toUInt(&success,16);
        if(success) version2send.data[6] = (quint8)buildId.mid(2,2).toUInt(&success,16);
        if(success) version2send.data[7] = (quint8)buildId.left(2).toUInt(&success,16);
    }
#endif

    if(!success)
    {
        version2send.data[4] = (quint8)(0xff);
        version2send.data[5] = (quint8)(0xff);
        version2send.data[6] = (quint8)(0xff);
        version2send.data[7] = (quint8)(0xff);
    }
}

#ifndef WIN32

void VersionMsg::readServiceNumber(void)
{
    //NOTE: Engine version:
    QJsonObject jsonObject = AMJsonConfigReader::getInstance()->object();
    QJsonArray jsonArray = jsonObject["MediaVersion"].toArray();

    sn2send_LSB.can_id = 0x7d1;
    sn2send_LSB.can_dlc = 8;

    sn2send_MSB.can_id = 0x7d2;
    sn2send_MSB.can_dlc = 8;

    //TODO read the SN and verify:
    qint32 mem_fd = open("/dev/mem",O_RDWR);

    void* pmc_pcr_ptr = mmap(NULL, AT91C_PMC_PCR_OFFSET + sizeof(quint32), PROT_WRITE,
                        MAP_PRIVATE, mem_fd, AT91C_BASE_PMC);


    void* sfc_dr_ptr = mmap(NULL, AT91C_SFC_DR0_OFFSET + 16*sizeof(quint32), PROT_READ,
                        MAP_PRIVATE, mem_fd, AT91C_BASE_SFC);



    close(mem_fd);


    enableDisableSFC((quint32*)(pmc_pcr_ptr)+(AT91C_PMC_PCR_OFFSET/sizeof(quint32)),true);


    quint32 readRegister;
    quint32 emptyRegisters = 0;
    quint8 byteLSB;
    bool regIntegrity = true;

    for(qint32 i = 0; i<16 && regIntegrity;i++)
    {
        readRegister = readDataSFC((quint32*)sfc_dr_ptr+(AT91C_SFC_DR0_OFFSET/sizeof(quint32)),i);


        byteLSB = (quint8)(readRegister & 0xff);

        if(0 == readRegister)
        {
            emptyRegisters++;
        }
        else
        {
            quint8 byteMSB = (quint8)((readRegister >> 010)& 0xff);



            regIntegrity = (byteLSB == (quint8)(~ byteMSB));

            qDebug()<< "EW8 Sn:"<< i << " Num:" << hex << (quint32)byteLSB << " Control:" << hex <<(quint32)byteMSB << " Integrity: " << regIntegrity;
        }

        if(i < 8)
        {
            sn2send_LSB.data[i] = byteLSB;
        }
        else
        {
            sn2send_MSB.data[i-8] = byteLSB;
        }
    }

     enableDisableSFC((quint32*)(pmc_pcr_ptr)+(AT91C_PMC_PCR_OFFSET/sizeof(quint32)),false);

     if(!regIntegrity | ((0 != emptyRegisters) && (16 != emptyRegisters)))
     {
         for(qint32 i = 0; i<16;i++)
         {
             if(i < 8)
             {
                 sn2send_LSB.data[i] = 0xff;
             }
             else
             {
                 sn2send_MSB.data[i-8] = 0xff;
             }
         }
     }

    munmap(sfc_dr_ptr, AT91C_SFC_DR0_OFFSET + 16*sizeof(quint32));

    munmap(pmc_pcr_ptr, AT91C_PMC_PCR_OFFSET + sizeof(quint32));
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

#endif




