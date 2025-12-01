#include "mainprocessapi.h"
#include "updatecommon/caninterface.h"
#include "updateapi/updatesample.h"
#include "updatecommon/crc32.h"
#include "updatecommon/updatecanprotocol.h"
#include "updatecommon/utils.h"
#include "updatecommon/version.h"
#include <exception>

unsigned int DEFAULT_CHUNK_SIZE = 3*512;
unsigned int MAX_CHUNK_SIZE = 256*7;

MainProcess::MainProcess()
{
    m_canInterface = new CANInterface((int)CANProtocol::UpdateCANPacketID, 1);
}

int MainProcess::LaunchEverything(int argc, char *argv[])
{

    CANUpdateAPI* UpdateAPI = new CANUpdateAPI(m_canInterface);
    m_canInterface->SetFrameProcessor((CANReceptor*)UpdateAPI);

    LOG("CANSim version: %d.%d.%d\n", GET_VERSION_MAJOR(SW_VERSION), GET_VERSION_MINOR(SW_VERSION), GET_VERSION_BUILD(SW_VERSION));

    if (argc>=4)
    {
        unsigned int chunk_size;
        bool use_default_chunk_size = true;

        std::string flag = "";
        bool has_chunk_size_in_args = false;

        if((argv[4]))
        {
            try{
                chunk_size = (unsigned int) std::stoul(argv[4]);
                has_chunk_size_in_args = true;

                if(chunk_size > 0 && chunk_size <= MAX_CHUNK_SIZE)
                {
                    use_default_chunk_size =  false;
                }

            }
            catch(...)
            {
                //NOTE: 4th argument is not an unsigned number, it can be a flag.
                flag = std::string((argv[4])?argv[4]:"");
            }
        }

        if(use_default_chunk_size)
        {
            LOG("Using default chunk size: %d\n", DEFAULT_CHUNK_SIZE);
            chunk_size = DEFAULT_CHUNK_SIZE;
        }



        if(argc >= 5 && has_chunk_size_in_args)
        {
            flag = std::string((argv[5])?argv[5]:"");
        }

        UploadFile(UpdateAPI, std::string(argv[1]), std::string(argv[2]), std::string(argv[3]), chunk_size, flag);
    }

    return 0;
}



