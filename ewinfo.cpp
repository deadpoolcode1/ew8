#include "ewinfo.h"
#include "defs.h"
#include <QDebug>
#include <QFile>
#include <QTextStream>
#include "amjsonconfigreader.h"
#include <QJsonArray>

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
  return ewsn_str;
}

QString EWInfo::getEngineVer(void)
{
   return ewbin_str;
}

QString EWInfo::getConfigVer(void)
{
  return ewcfg_str;
}

QString EWInfo::getSnv(void)
{
#if 0
    ewsn_str = "3021016070300013";
    setMeSn("0121011070P00524");
    qDebug()<<"SNV property ="<<snv_str;
#endif
  return snv_str;
}

QString EWInfo::getOSBuildTimestamp(void)
{
  return ewosbuild_str;
}

void EWInfo::setMeSn(QString aMeSn)
{

//TODO compute the snv value

    QByteArray ew = ewsn_str.toLocal8Bit();
    QByteArray me = aMeSn.toLocal8Bit();

    //TODO verifications: length etc
    if(me.length() == 16 && ew.length() == 16)
    {
    quint64 A = (quint64)ew[me[15]%16];//4:0:48
    quint64 B = (quint64)ew[me[14]%16] ;//2:2:50
    quint64 C = (quint64)ew[me[13]%16] ;//5:1:49
    quint64 D = (quint64)ew[me[12]%16] ;//0:3:51
    quint64 E = (quint64)ew[me[11]%16] ;//0:3:51

    quint64 F = (quint64)me[ew[0]%16] ;
    quint64 G = (quint64)me[ew[1]%16] ;
    quint64 H = (quint64)me[ew[11]%16] ;
    quint64 I = (quint64)me[ew[12]%16] ;
    quint64 J = (quint64)me[ew[13]%16] ;

    quint64 SNV = (quint64)((A+B+C+D+E)*(F+G+H+I+J)*(A*B*C*D*E+F*G*H*I*J)) % ULONG_LONG_MAX;

#if 0
    qDebug () << " A:" << A << " B:" << B << " C:" << C
              << "D:" << D << " E:" << E << " F:" << F << " G:" << G << " H:" << H <<
                 " I:" << I << " J:"<< J;

    qDebug()<< "quint64 SNV=" << SNV;
#endif

    snv_str = QString::number(SNV);


    is_snv_ready = true;

    emit snvChanged(snv_str);
    }
    else
    {
        qDebug() << "SN number length is wrong";
    }
}


void EWInfo::declareQML(void)
{
       qmlRegisterType<EWInfo>("builtin.mobileye.EWInfo",0, 1, "EWInfo");
}


void EWInfo::readEWInfo(void)
{
    //NOTE: Engine version:
     ewbin_str = QString("%1.%2.%3")
    .arg(MAJOR_VERSION)
    .arg(MINOR_VERSION)
    .arg(OTA_TEST_VERSION);

     qDebug() << "EWInfo:Engine version " << ewbin_str;

    //NOTE: Config version:
    QJsonArray jsonArray = AMJsonConfigReader::getInstance()->getJsonTopEntry("ConfigVersion").toArray();
    if(!jsonArray.isEmpty())
    {
        ewcfg_str = QString("%1.%2.%3")
         .arg(jsonArray.at(0).toInt(0xff))
         .arg(jsonArray.at(1).toInt(0x3f))
         .arg((jsonArray.at(2).toInt(0x3)) & 0x3);
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
       qDebug("System Build ID is not found is not found.");
    }
    else
    {
       bool ok;
       quint32 tstamp = buildId.toUInt(&ok, 16);
       if(ok)
       {
           ewosbuild_str = QString::number(tstamp);
       }

    }

}


void EWInfo::readServiceNumber(void)
{
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

    ewsn_str = "";

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

#if QT_VERSION >= QT_VERSION_CHECK(5,  14, 0)
            qDebug()<< "EW8 Sn:"<< i << " Num:" << Qt::hex << (quint32)byteLSB << " Control:" << Qt::hex <<(quint32)byteMSB << " Integrity: " << regIntegrity;
#else
            qDebug()<< "EW8 Sn:"<< i << " Num:" << std::hex << (quint32)byteLSB << " Control:" << std::hex <<(quint32)byteMSB << " Integrity: " << regIntegrity;
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

     enableDisableSFC((quint32*)(pmc_pcr_ptr)+(AT91C_PMC_PCR_OFFSET/sizeof(quint32)),false);

     if(!regIntegrity | ((0 != emptyRegisters) && (16 != emptyRegisters)))
     {
         for(qint32 i = 0; i<16;i++)
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

    munmap(sfc_dr_ptr, AT91C_SFC_DR0_OFFSET + 16*sizeof(quint32));

    munmap(pmc_pcr_ptr, AT91C_PMC_PCR_OFFSET + sizeof(quint32));
}

void EWInfo::enableDisableSFC(quint32* wr_ptr, bool On)
{
    *wr_ptr = On ? (AT91C_ID_SFC | AT91C_PMC_PCR_CMD | AT91C_PMC_PCR_EN) :
                   (AT91C_ID_SFC | AT91C_PMC_PCR_CMD);
}

quint32 EWInfo::readDataSFC(quint32* rd_ptr, quint32 index)
{
   quint32 ret;
   ret = *(rd_ptr+index);
   return ret;
}

#endif




