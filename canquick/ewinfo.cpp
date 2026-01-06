#include "ewinfo.h"
#include "defs.h"
#include "core/core.h"
#include <QFile>
#include <QTextStream>
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

String EWInfo::getEwsn(void)
{
  return ewsn_str;
}

String EWInfo::getEngineVer(void)
{
   return ewbin_str;
}

String EWInfo::getConfigVer(void)
{
  return ewcfg_str;
}

String EWInfo::getSnv(void)
{
#if 0
    ewsn_str = "3021016070300013";
    setMeSn("0121011070P00524");
    coreDebug()<<"SNV property ="<<snv_str;
#endif
  return snv_str;
}

String EWInfo::getOSBuildTimestamp(void)
{
  return ewosbuild_str;
}

void EWInfo::setMeSn(String aMeSn)
{

//TODO compute the snv value

    std::string ew = ewsn_str.toStdString();
    std::string me = aMeSn.toStdString();

    //TODO verifications: length etc
    if(me.length() == 16 && ew.length() == 16)
    {
    uint64_t A = (uint64_t)(uint8_t)ew[me[15]%16];//4:0:48
    uint64_t B = (uint64_t)(uint8_t)ew[me[14]%16] ;//2:2:50
    uint64_t C = (uint64_t)(uint8_t)ew[me[13]%16] ;//5:1:49
    uint64_t D = (uint64_t)(uint8_t)ew[me[12]%16] ;//0:3:51
    uint64_t E = (uint64_t)(uint8_t)ew[me[11]%16] ;//0:3:51

    uint64_t F = (uint64_t)(uint8_t)me[ew[0]%16] ;
    uint64_t G = (uint64_t)(uint8_t)me[ew[1]%16] ;
    uint64_t H = (uint64_t)(uint8_t)me[ew[11]%16] ;
    uint64_t I = (uint64_t)(uint8_t)me[ew[12]%16] ;
    uint64_t J = (uint64_t)(uint8_t)me[ew[13]%16] ;

    uint64_t SNV = (uint64_t)((A+B+C+D+E)*(F+G+H+I+J)*(A*B*C*D*E+F*G*H*I*J)) % ULONG_LONG_MAX;

#if 0
    coreDebug() << " A:" << A << " B:" << B << " C:" << C
              << "D:" << D << " E:" << E << " F:" << F << " G:" << G << " H:" << H <<
                 " I:" << I << " J:"<< J;

    coreDebug()<< "uint64_t SNV=" << SNV;
#endif

    snv_str = std::to_string(SNV);


    is_snv_ready = true;

    emit snvChanged(snv_str);
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
    //NOTE: Engine version:
     ewbin_str = std::to_string(MAJOR_VERSION) + "." + std::to_string(MINOR_VERSION) + "." + std::to_string(OTA_TEST_VERSION);

     coreDebug() << "EWInfo:Engine version " << ewbin_str;

    //NOTE: Config version:
    core::JsonArray jsonArray = AMJsonConfigReader::getInstance()->getJsonTopEntry("ConfigVersion").toArray();
    if(!jsonArray.isEmpty())
    {
        ewcfg_str = std::to_string(jsonArray.at(0).toInt(0xff)) + "." + std::to_string(jsonArray.at(1).toInt(0x3f)) + "." + std::to_string((jsonArray.at(2).toInt(0x3)) & 0x3);
    }
}


#if !((defined WIN32) || (defined REMOVE_EW8_HW))

void EWInfo::readOSBuildInfo(void)
{

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
       LOG_DEBUG("System Build ID is not found is not found.");
    }
    else
    {
       bool ok;
       uint32_t tstamp = buildId.toUInt(&ok, 16);
       if(ok)
       {
           ewosbuild_str = std::to_string(tstamp);
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

#if QT_VERSION >= QT_VERSION_CHECK(5,  14, 0)
            coreDebug()<< "EW8 Sn:"<< i << " Num:" << Qt::hex << (uint32_t)byteLSB << " Control:" << Qt::hex <<(uint32_t)byteMSB << " Integrity: " << regIntegrity;
#else
            coreDebug()<< "EW8 Sn:"<< i << " Num:" << std::hex << (uint32_t)byteLSB << " Control:" << std::hex <<(uint32_t)byteMSB << " Integrity: " << regIntegrity;
#endif
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
            ewsn_str.append(QChar((char)byteLSB));
        }
        else
        {
            ewsn_str.append("X");
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




