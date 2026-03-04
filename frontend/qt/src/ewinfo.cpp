#include "ewinfo.h"
#include "defs.h"
#include <QQmlEngine>
#include "core/core.h"
#include "core/file_utils.h"
#include "amjsonconfigreader.h"
#include "core/json.h"
#include "snv_calculator.h"
#include "version_info.h"

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
#include <ctype.h>
#endif

#include <limits.h>

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


EWInfo::EWInfo(QObject * parent) : QObject(parent)
{
    ewsn_str = "NA";
    ewbin_str = "NA";
    ewcfg_str = "NA";
    snv_str = "NA";
    ewosbuild_str = "NA";
    is_snv_ready = false;
    readEWInfo();

#if !((defined WIN32) || (defined REMOVE_EW8_HW))
    readServiceNumber();
    readOSBuildInfo();
#endif
}

QString EWInfo::getEwsn(void)
{
  return QString::fromStdString(ewsn_str);
}

QString EWInfo::getEngineVer(void)
{
   return QString::fromStdString(ewbin_str);
}

QString EWInfo::getConfigVer(void)
{
  return QString::fromStdString(ewcfg_str);
}

QString EWInfo::getSnv(void)
{
#if 0
    ewsn_str = "3021016070300013";
    setMeSn("0121011070P00524");
    coreDebug()<<"SNV property ="<<snv_str;
#endif
  return QString::fromStdString(snv_str);
}

QString EWInfo::getOSBuildTimestamp(void)
{
  return QString::fromStdString(ewosbuild_str);
}

void EWInfo::setMeSn(const QString& aMeSn)
{

//TODO compute the snv value

    std::string ew = ewsn_str;
    std::string me = aMeSn.toStdString();

    if(me.length() == 16 && ew.length() == 16)
    {
        uint64_t SNV = calculateSNV(ew, me);
        snv_str = std::to_string(SNV);
        is_snv_ready = true;
        emit snvChanged(QString::fromStdString(snv_str));
    }
    else
    {
        coreDebug() << "SN number length is wrong";
    }
}


void EWInfo::declareQML(void)
{
       qmlRegisterType<EWInfo>("builtin.mobileye.EWInfo",0, 1, "EWInfo");
}


void EWInfo::readEWInfo(void)
{
    VersionInfo vi = buildVersionInfo();
    ewbin_str = vi.engine;
    ewcfg_str = vi.config;

    coreDebug() << "EWInfo:Engine version " << ewbin_str;
}


#if !((defined WIN32) || (defined REMOVE_EW8_HW))

void EWInfo::readOSBuildInfo(void)
{

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
       LOG_DEBUG("System Build ID is not found is not found.");
    }
    else
    {
       try {
           uint32_t tstamp = std::stoul(buildId, nullptr, 16);
           ewosbuild_str = std::to_string(tstamp);
       } catch (...) {
           // Conversion failed
       }

    }

}


void EWInfo::readServiceNumber(void)
{
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

    ewsn_str = "";

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
            ewsn_lsb[i] = byteLSB;
        }
        else
        {
             ewsn_msb [i-8] = byteLSB;
        }

        if(isprint(byteLSB))
        {
            ewsn_str.push_back((char)byteLSB);
        }
        else
        {
            ewsn_str.push_back('X');
        }
    }

     enableDisableSFC((uint32_t*)(pmc_pcr_ptr)+(AT91C_PMC_PCR_OFFSET/sizeof(uint32_t)),false);

     if(!regIntegrity | ((0 != emptyRegisters) && (16 != emptyRegisters)))
     {
         for(int32_t i = 0; i<16;i++)
         {
             if(i < 8)
             {
                 ewsn_lsb[i] = 0xff;
             }
             else
             {
                 ewsn_msb[i-8] = 0xff;
             }
         }
     }

     if(!regIntegrity)
     {
         ewsn_str = "ERR";
     }
     else if (0 != emptyRegisters)
     {
         ewsn_str = "NA";
     }

    munmap(sfc_dr_ptr, AT91C_SFC_DR0_OFFSET + 16*sizeof(uint32_t));

    munmap(pmc_pcr_ptr, AT91C_PMC_PCR_OFFSET + sizeof(uint32_t));
}

void EWInfo::enableDisableSFC(uint32_t* wr_ptr, bool On)
{
    *wr_ptr = On ? (AT91C_ID_SFC | AT91C_PMC_PCR_CMD | AT91C_PMC_PCR_EN) :
                   (AT91C_ID_SFC | AT91C_PMC_PCR_CMD);
}

uint32_t EWInfo::readDataSFC(uint32_t* rd_ptr, uint32_t index)
{
   uint32_t ret;
   ret = *(rd_ptr+index);
   return ret;
}

#endif




