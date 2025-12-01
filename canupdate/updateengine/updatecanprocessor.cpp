#include "updatecanprocessor.h"

CANProcessor::CANProcessor(ControlFile* _cf)
{
    m_controlFile = _cf;
    m_state = CANProcessorState::READY;
}

void* CANProcessor::RunUpdate(void* _param)
{
    CANProcessor* cp = (CANProcessor*)_param;

    cp->m_controlFile->SetUpdateStatus((char*)CANProtocol::InternalUpdateStatusOnExecution);
    // knows update status from .swu file

    system("/opt/updater/scripts/updater_run.sh");

    cp->m_state = CANProcessorState::READY;

    pthread_exit(NULL);
    return NULL;
}

void* CANProcessor::RunRollback(void* _param)
{
    CANProcessor* cp = (CANProcessor*)_param;

    system("/opt/updater/scripts/updater_successful_boot.sh");

    cp->m_controlFile->SetUpdateStatus((char*)CANProtocol::InternalUpdateStatusRollback);

    cp->m_state = CANProcessorState::READY;

    pthread_exit(NULL);
    return NULL;
}

void* CANProcessor::RunPowerOn(void* _param)
{
    CANProcessor* cp = (CANProcessor*)_param;

    system("/opt/updater/scripts/updater_successful_boot.sh");

    cp->m_state = CANProcessorState::READY;

    pthread_exit(NULL);
    return NULL;
}

CANProcessor::CANProcessorStatus CANProcessor::RunScript(char* _script, script_func _run_script)
{
    pthread_t intThread;
    int threadStatus = pthread_create(&intThread, NULL, _run_script, this);

    if (0 != threadStatus)
    {
        LOG("Control file error: can't create thread for script %s, status = %d\n", _script, threadStatus);
        return CANProcessorStatus::SCRIPT_ERROR;
    }

    return CANProcessorStatus::OK;
}

CANProcessor::CANProcessorStatus CANProcessor::SetVersion(char* _new_version_name)
{

    CANProcessor::CANProcessorStatus ret = CANProcessorStatus::OK;

    if (CANProcessorState::READY != m_state)
    {
        ret = CANProcessorStatus::ACTIVE_TRANSMISSION;
    }
    else
    {


        if(0) LOG("version: %s\n", _new_version_name);
        //Find out if dir exists
        ControlFile::FileError mErr = m_controlFile->CheckVersion(_new_version_name);

        if (ControlFile::FileError::OK == mErr)
        {
            ret = CANProcessorStatus::DIR_EXISTS; // into version's dir

            if(ControlFile::FileError::OK != m_controlFile->WriteExistingVersion(_new_version_name))
            {
                ret =  CANProcessorStatus::FILE_WRITE_ERROR;
            }

        }

        else
        {
            if(ControlFile::FileError::OK != m_controlFile->WriteNewVersion(_new_version_name))
            {
                ret =  CANProcessorStatus::FILE_WRITE_ERROR;
            }
        }

    }

    return ret;
}

CANProcessor::CANProcessorStatus CANProcessor::SetInfo(uint32_t _size, unsigned int _chunk_size)
{
    if(0) LOG("size: %u chunk size:%u\n", _size, _chunk_size);
    ControlFile::FileError fe;

    if (CANProcessorState::READY != m_state)
    {
        return CANProcessorStatus::ACTIVE_TRANSMISSION;
    }

    fe = m_controlFile->InitControlFile(_size, _chunk_size);

    if (ControlFile::FileError::OK != fe)
          {  return CANProcessorStatus::FILE_WRITE_ERROR;  }

    m_controlFile->SetUpdateStatus((char*)CANProtocol::InternalUpdateStatusUploading);

    return  CANProcessorStatus::OK;
}

CANProcessor::CANProcessorStatus CANProcessor::GetNextChunk(int& _chunk)
{
    _chunk = m_controlFile->NextChunk(m_controlFile->m_header[m_controlFile->m_currHeader].m_lastSuccessfulChunk);
    if (CANProcessorState::READY == m_state) // waiting for command
    {  // open the file
        if ((_chunk) >= m_controlFile->m_header[m_controlFile->m_currHeader].m_chunks)
        {
            _chunk = ControlFile::DEFAULT_CHUNK_NO;
        }
        if (0) LOG("next chunk: %d\n", _chunk);
        return CANProcessorStatus::OK;
    } else
    {
      LOG("file is busy\n");
      return CANProcessorStatus::NEED_VERSION;
    }
}

bool CANProcessor::CheckChunkSize(uint32_t _size)
{
    if (0) LOG("inp chunk: %d\n", _size);
    int next_chunk = m_controlFile->NextChunk(m_controlFile->m_header[m_controlFile->m_currHeader].m_lastSuccessfulChunk);
    uint32_t _ch_size = m_controlFile->m_header[m_controlFile->m_currHeader].m_chunkSize;
    if ((next_chunk+1) >= m_controlFile->m_header[m_controlFile->m_currHeader].m_chunks)
        _ch_size = m_controlFile->m_header[m_controlFile->m_currHeader].m_lastChunkSize;
    if (0 == _ch_size) _ch_size = m_controlFile->m_header[m_controlFile->m_currHeader].m_chunkSize;
    return (_ch_size == _size);
}

CANProcessor::CANProcessorStatus CANProcessor::CheckChunkSHA2(int _chunk_no, SHA2Store* _sha2sum)
{
    if (0) LOG("chunk: %d\n", _chunk_no);

    ControlFile::FileError mErr = m_controlFile->CheckChunkSHA2(_chunk_no, _sha2sum);
    switch (mErr) {
        case ControlFile::FileError::OK:   return CANProcessorStatus::OK;
        case ControlFile::FileError::SHA2ERROR:   return CANProcessorStatus::SHA2_ERROR;
        case ControlFile::FileError::FILE_DAMAGED:
        case ControlFile::FileError::FILE_NOT_FOUND:
        case ControlFile::FileError::OTHER_FILE_ERROR:
        case ControlFile::FileError::FILE_WRITE_ERROR:
        case ControlFile::FileError::NO_MEMORY:
    default:
        return CANProcessorStatus::FILE_WRITE_ERROR;
    }
}

CANProcessor::CANProcessorStatus CANProcessor::DownloadedData(unsigned char* _buf, uint32_t _size)
{
    if (0) LOG("size: %u\n", _size);

    ControlFile::FileError mErr = m_controlFile->WriteFile(_buf, _size);
    if (ControlFile::FileError::OK != mErr)
        return CANProcessorStatus::FILE_WRITE_ERROR;
    else
        return CANProcessorStatus::OK;
}

CANProcessor::CANProcessorStatus CANProcessor::UpdateContent()
{
    if (CANProcessorState::READY == m_state)
    {
        m_state = CANProcessorState::UPDATING;
        LOG("UpdateContent(): running SWUpdate\n");

        CANProcessorStatus pst;
        // run software update TODO

        RunScript((char*)"UpdateContent", RunUpdate);

        pst = CANProcessorStatus::CONTENT_PENDING;
        return pst;
    }
    else
    {
        return CANProcessorStatus::NEED_TO_WAIT;
    }
}

CANProcessor::CANProcessorStatus CANProcessor::ForceRollBack()
{
    if (CANProcessorState::READY == m_state)
    {
        m_state = CANProcessorState::ROLLINGBACK;
        LOG("FORCE ROLLBACK\n");

        CANProcessorStatus pst;

        RunScript((char*)"ForceRollback", RunRollback);

        pst = CANProcessorStatus::CONTENT_PENDING;
        return pst;
    }
    else
    {
        return CANProcessorStatus::NEED_TO_WAIT;
    }
}

CANProcessor::CANProcessorStatus CANProcessor::PowerOn()
{
    LOG("CAN Update: Boot is successful, updating environment...\n");

    CANProcessorStatus pst;

    RunScript((char*)"PowerOn", RunPowerOn);

    pst = CANProcessorStatus::CONTENT_PENDING;
    return pst;
}

CANProcessor::CANProcessorStatus CANProcessor::RemoveContent(unsigned char* _version)
{
    if (0) LOG("version: %s\n", _version);

    if (CANProcessorState::READY != m_state)
    {
        return CANProcessorStatus::NEED_TO_WAIT;
    }

    ControlFile::FileError mErr = m_controlFile->RemoveContent(std::string((char*)_version));
    return (ControlFile::FileError::OK != mErr) ?
        CANProcessorStatus::NEED_VERSION : CANProcessorStatus::OK;
}

CANProtocol::UpdateStatus CANProcessor::GetUpdateStatus()
{
    CANProtocol::UpdateStatus sErr = m_controlFile->GetUpdateStatus();
    if (0) LOG("update status: %d\n", (int)sErr);
    return sErr;
}

CANProcessor::CANProcessorStatus CANProcessor::GetContentVersion(unsigned char* _version, unsigned int _len)
{
    if (0) LOG("VER: %s\n", m_controlFile->m_Version.c_str());
    if (m_controlFile->m_Version.length() < 1)
    {
        _version[0] = '\0';
        return CANProcessorStatus::NEED_VERSION;
    }

    strncpy((char*)_version, (char*)m_controlFile->m_Version.c_str(), std::min(_len,m_controlFile->m_Version.length()+1));

    if(0) LOG("version: %s\n", _version);

    return CANProcessorStatus::OK;
}
