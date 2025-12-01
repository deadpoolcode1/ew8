#include "updateapi/updatecanapi.h"
#include "updateapi/updatesample.h"
#include "updatecommon/sha256.h"
#include "updatecommon/updatecanprotocol.h"
#include "pthread.h"
#include "updatecommon/utils.h"




///
/// \brief main
/// \param argc should be 3
/// \param argv
/// \return
///
int UploadFile(CANUpdateAPI* uc, std::string _fileName, std::string _version, std::string _sha2code, unsigned int _chunk_size, std::string _flag)
{

    unsigned int CHUNK_SIZE = _chunk_size;

    std::string init_version;
    CANProtocol::UpdateStatus updStatus;

    std::string previous_version;
    CANProtocol::UpdateStatus prevStatus;


    bool forceRollback = (_flag == "-forceRollback");
    bool passUpdate = (_flag == "-passUpdate");
    // passUpdate = true;

    if (_flag == "-dropTest")
    {
        uc->getCANInterface()->SetDropTest(true);
    }

    FILE* inp_file = fopen(_fileName.c_str(), "rb");

    if (!inp_file)
    {
       LOG("Can not open file %s\n", _fileName.c_str());
       return -2;
    }

    fseek(inp_file, 0, SEEK_END);
    uint32_t fileSize = ftell(inp_file);

    //NOTE: Added to recycle junk
    uc->GetCurrentVersion(previous_version, prevStatus);
    if((previous_version != "") && (previous_version != _version))
    {
        LOG("[Lincz]Previous version %s differs from the currently processed %s: Discarding!\n", previous_version.c_str(), _version.c_str());
        uc->DiscardContent(previous_version, false);
    }


    LOG("InitTransfer(): initializing transfer for version %s, hash %s\n", _version.c_str(), _sha2code.c_str());
    CANUpdateAPI::UpdateContextError ucErr = uc->InitTransfer(_version, fileSize, CHUNK_SIZE);

    if (CANUpdateAPI::UpdateContextError::UPDATE_OK != ucErr)
    {
       LOG("Can not initialize transfer\n");
       return -3;
    }

    int next_chunk = uc->GetNextChunk();
    int err_count = 0;

    if (-1 != next_chunk)
    {
        char buffer[CHUNK_SIZE];

        while(1)
        {
            if (0 == next_chunk%20)
            {
                LOG("PushChunk(): sending chunk %d\n", next_chunk);
            }
            if (CHUNK_NUMBER_ERROR == next_chunk)
            {
                next_chunk = uc->GetNextChunk();
                if (next_chunk>0)
                {
                    err_count=0;
                    LOG("Recovering after error: next chunk #%d\n", next_chunk);
                }
                else {
                  if (err_count++>8)
                  {
                      LOG("PushChunk(): Connection lost\n");
                      return -6;
                  }
                }
                continue;
            }
            if (ALL_CHUNKS_ARE_DONE == next_chunk)
            {
                break; // while
            }
            int result = fseek(inp_file, CHUNK_SIZE*next_chunk, SEEK_SET);

            result = fread(buffer, 1, CHUNK_SIZE, inp_file);
            if (0 == result) // EOF
                break;
            else
            {
                next_chunk = uc->PushChunk(next_chunk, buffer, result);
            }
        }
    }

    fclose(inp_file);

    SHA2Store sha2;
    SHA2Store sha_inp;

    str2hash((const char*)_sha2code.c_str(), (char*)sha_inp.bytes);
    if (CANUpdateAPI::UpdateContextError::UPDATE_OK != uc->VerifyContent(sha2))
    {
       LOG("VerifyContent(): fail\n");
       return -4;
    }
    int check = memcmp(sha_inp.bytes, sha2.bytes, sizeof (SHA2Store));
    if (0 == check)
    {
       LOG("VerifyContent(): success\n");
    }
    else
    {
       LOG("VerifyContent(): fail\n");
       return -4;
    }

    // file is uploaded

    if (!passUpdate)
    {

        if (CANUpdateAPI::UpdateContextError::UPDATE_OK !=uc->UpdateContent())
        {
           LOG("UpdateContent(): update failed\n");
           return -4;
        }

        LOG("GetCurrentVersion(): wait for device \"done\" status, looping....\n");

        uc->GetCurrentVersion(init_version, updStatus);

        while(CANProtocol::UpdateStatus::DONE != updStatus)
        {
            usleep(500000);
            if (CANUpdateAPI::UpdateContextError::UPDATE_OK != uc->GetCurrentVersion(init_version, updStatus))
            {
                LOG("GetCurrentVersion(): error while update procedure, exiting...\n");
                return -5;
            }

            if (CANProtocol::UpdateStatus::EXECUTION_ERROR == updStatus)
            {
                LOG("GetCurrentVersion(): update procedure failed, exiting...\nPlease remove unnecessary content!\n");
                uc->DiscardContent(_version, false);
                return -6;
            }
        }

    }

    LOG("DiscardContent(): discarding temporal storage on EW8...\n");
    if (forceRollback)
    {
        LOG("DiscardContent(): Force rollback\n");
    }

    uc->DiscardContent(_version, forceRollback);


    LOG("Updated successfully, new version is %s\n", _version.c_str());

    return 0;
}


