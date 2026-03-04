#include "versionmsg.h"
#include "defs.h"
#include "core/core.h"
#include "core/file_utils.h"
#include "amjsonconfigreader.h"
#include "core/json.h"

#ifndef WIN32
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
#endif

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
#if !((defined WIN32) || (defined REMOVE_EW8_HW))
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
        coreDebug() << "WARNING: Version Message is not constructed yet.";
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
        coreDebug() << "WARNING: Version Message is already constructed.";
    }
}



void VersionMsg::readVersionInfo(void)
{

    version2send.can_id = 0x7d0;
    version2send.can_dlc = 8;

    //NOTE: Engine version:
    version2send.data[0] = (uint8_t)MAJOR_VERSION;
    version2send.data[1] = (((uint8_t)MINOR_VERSION) << 2)|(((int8_t)OTA_TEST_VERSION) & (uint8_t)0x3);

    version2send.data[2] = (uint8_t)(0xff);
    version2send.data[3] = (uint8_t)(0xff);


    //NOTE: Config version:
    core::JsonValue configVersion = AMJsonConfigReader::getInstance()->getJsonTopEntry("ConfigVersion");
    core::JsonArray jsonArray = configVersion.toArray();
    if(!jsonArray.isEmpty())
    {
        version2send.data[2] = (uint8_t)jsonArray.at(0).toInt(0xff);
        version2send.data[3] = (((uint8_t)jsonArray.at(1).toInt(0x3f)) << 2)|(((int8_t)jsonArray.at(2).toInt(0x3)) & (uint8_t)0x3);
    }

    //NOTE: System build version:
    bool success = false;

    #if !((defined WIN32) || (defined REMOVE_EW8_HW))
    core::File buildIdFile("/etc/version2epoch");

    std::string buildId;

    if(buildIdFile.open(core::File::ReadOnly | core::File::Text))
    {
      core::TextStream buildIdStream(&buildIdFile);
      buildId = buildIdStream.readLine();
      buildIdFile.close();
    }

    if(buildId.length() != 8)
    {
       coreDebug() << "System Build ID is not found.";
    }
    else
    {
        try {
            version2send.data[4] = (uint8_t)std::stoul(buildId.substr(6, 2), nullptr, 16);
            version2send.data[5] = (uint8_t)std::stoul(buildId.substr(4, 2), nullptr, 16);
            version2send.data[6] = (uint8_t)std::stoul(buildId.substr(2, 2), nullptr, 16);
            version2send.data[7] = (uint8_t)std::stoul(buildId.substr(0, 2), nullptr, 16);
            success = true;
        } catch (...) {
            success = false;
        }
    }
#endif

    if(!success)
    {
        version2send.data[4] = (uint8_t)(0xff);
        version2send.data[5] = (uint8_t)(0xff);
        version2send.data[6] = (uint8_t)(0xff);
        version2send.data[7] = (uint8_t)(0xff);
    }
}

#if !((defined WIN32) || (defined REMOVE_EW8_HW))

void VersionMsg::readServiceNumber(void)
{
    sn2send_LSB.can_id = 0x7d1;
    sn2send_LSB.can_dlc = 8;

    sn2send_MSB.can_id = 0x7d2;
    sn2send_MSB.can_dlc = 8;

    //TODO read the SN and verify:
    int32_t mem_fd = open("/dev/mem",O_RDWR);

    void* pmc_pcr_ptr = mmap(NULL, AT91C_PMC_PCR_OFFSET + sizeof(uint32_t), PROT_WRITE,
                        MAP_PRIVATE, mem_fd, AT91C_BASE_PMC);


    void* sfc_dr_ptr = mmap(NULL, AT91C_SFC_DR0_OFFSET + 16*sizeof(uint32_t), PROT_READ,
                        MAP_PRIVATE, mem_fd, AT91C_BASE_SFC);



    close(mem_fd);


    enableDisableSFC((uint32_t*)(pmc_pcr_ptr)+(AT91C_PMC_PCR_OFFSET/sizeof(uint32_t)),true);


    uint32_t readRegister;
    uint32_t emptyRegisters = 0;
    uint8_t byteLSB;
    bool regIntegrity = true;

    for(int32_t i = 0; i<16 && regIntegrity;i++)
    {
        readRegister = readDataSFC((uint32_t*)sfc_dr_ptr+(AT91C_SFC_DR0_OFFSET/sizeof(uint32_t)),i);


        byteLSB = (uint8_t)(readRegister & 0xff);

        if(0 == readRegister)
        {
            emptyRegisters++;
        }
        else
        {
            uint8_t byteMSB = (uint8_t)((readRegister >> 010)& 0xff);



            regIntegrity = (byteLSB == (uint8_t)(~ byteMSB));


            coreDebug()<< "EW8 Sn:"<< i << " Num:" << std::hex << (uint32_t)byteLSB << " Control:" << std::hex <<(uint32_t)byteMSB << " Integrity: " << regIntegrity;

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

     enableDisableSFC((uint32_t*)(pmc_pcr_ptr)+(AT91C_PMC_PCR_OFFSET/sizeof(uint32_t)),false);

     if(!regIntegrity | ((0 != emptyRegisters) && (16 != emptyRegisters)))
     {
         for(int32_t i = 0; i<16;i++)
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

    munmap(sfc_dr_ptr, AT91C_SFC_DR0_OFFSET + 16*sizeof(uint32_t));

    munmap(pmc_pcr_ptr, AT91C_PMC_PCR_OFFSET + sizeof(uint32_t));
}

void VersionMsg::enableDisableSFC(uint32_t* wr_ptr, bool On)
{
    *wr_ptr = On ? (AT91C_ID_SFC | AT91C_PMC_PCR_CMD | AT91C_PMC_PCR_EN) :
                   (AT91C_ID_SFC | AT91C_PMC_PCR_CMD);
}

uint32_t VersionMsg::readDataSFC(uint32_t* rd_ptr, uint32_t index)
{
   uint32_t ret;
   ret = *(rd_ptr+index);
   return ret;
}

#endif




