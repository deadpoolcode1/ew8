#include "versionmsg.h"
#include "defs.h"
#include <QDebug>
#include <QFile>
#include <QTextStream>

//NOTE: Next header is used for random()
//TODO: replace with QRandomGenerator, when passing to qt 5.12

void VersionMsg::singleShot(CanManager *aCanManager)
{
    //NOTE: Engine version:
    struct can_frame frame_to_send;

    frame_to_send.can_id = 0x7d0;
    frame_to_send.can_dlc = 8;

    frame_to_send.data[0] = (quint8)MAJOR_VERSION;
    frame_to_send.data[1] = (quint8)MINOR_VERSION;

    //NOTE: Config version (Get from Json):
    frame_to_send.data[2] = (quint8)(0xff);
    frame_to_send.data[3] = (quint8)(0xff);
    //NOTE: System build version:

    bool success = false;

    #ifndef WIN32
    QFile buildIdFile("/etc/version2epoch");

    QString buildId;

    if(buildIdFile.open(QFile::ReadOnly | QFile::Text))
    {
      QTextStream buildIdStream(&buildIdFile);

      buildIdFile.write("<2> canquick: in main loop");
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
        if(success) frame_to_send.data[5] = (quint8)buildId.mid(2,2).toUInt(&success,16);
        if(success) frame_to_send.data[6] = (quint8)buildId.mid(4,2).toUInt(&success,16);
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

