#include "updatecommon/updatecanprotocol.h"
#include "updatecontrolfile.h"

const char ControlFile::DEFAULT_UPDATE_DIR[] = "/opt/updater/download";
const char ControlFile::m_versionFile[] = "_version";
const char ControlFile::m_defaultSuffix[] = ".1";
const char ControlFile::m_defaultNextSuffix[] = ".2";
const char ControlFile::m_fileName[] = "update.swu";
const char ControlFile::m_statusFile[] = "status";
#ifndef WIN32
#include <sys/stat.h>
#define O_BINARY (0)
#endif

void* ControlFile::IntThread(void* _args)
{
    ControlFile* CF = (ControlFile*) _args;

    ControlFile::WriteThreadSharedData* PD = &(CF->m_PD);
    SHA2Store sha2;

    while(1)
    {

        PD->writtenStatus = 1;
        pthread_mutex_lock( &(PD->cond_var_lock));
        pthread_cond_wait( &(PD->cond_var), &(PD->cond_var_lock));
        pthread_mutex_unlock( &(PD->cond_var_lock));

        int len = PD->_len;
        int chunk = PD->_chunk;

        ControlFile::FileError mErr = CF->_WriteFile(CF->m_payloadBuffer, len, chunk, &sha2); // ChPt

        PD->mErr = mErr;

        // file written and read OK
        CF->m_sums->sums[chunk] = sha2;

        CF->WriteControlFile(CF->m_fileName+CF->m_suffix, PD->_chunk);
        CF->PropagateHeader();
        CF->m_suffix = CF->NextSuffix(CF->m_suffix);

    }
}

ControlFile::ControlFile() : m_sum(), m_sums()
{
    memset((void*)&m_header[0], 0, sizeof(m_header));
    memset((void*)&m_header[1], 0, sizeof(m_header));
    m_currHeader = 0;
    m_Version.assign("");

    m_PD.cond_var_lock =  PTHREAD_MUTEX_INITIALIZER;
    m_PD.cond_var = PTHREAD_COND_INITIALIZER;

    m_threadStatus = pthread_create(&m_ithread, NULL, IntThread, this);
    if (0 != m_threadStatus) {
       LOG("Control file error: can't create thread, status = %d\n", m_threadStatus);
       return;
    }
}

ControlFile::~ControlFile()
{
    m_threadStatus = pthread_join(m_ithread, (void**)&m_joinStatus);
    if (0 != m_joinStatus) {
        LOG("Control file error: can't join thread, status = %d\n", m_joinStatus);
        return;
    }
}

int ControlFile::NextChunk(int _chunk)
{
    if ((_chunk+1) >= (int)m_header[m_currHeader].m_chunks)
        return DEFAULT_CHUNK_NO; // all written
    return _chunk+1;
}

std::string ControlFile::NextSuffix(std::string _suffix)
{
    if (_suffix == std::string(m_defaultSuffix))
        return std::string(m_defaultNextSuffix);
    return std::string(m_defaultSuffix);
}

void ControlFile::PropagateHeader()
{
    if (0 == m_currHeader)
    {  // 0 -> 1
       m_header[1] = m_header[0];
       m_currHeader = 1;
    }
    else
    {   // 1 -> 0
        m_header[0] = m_header[1];
        m_currHeader = 0;
    }
}

///
/// \brief ControlFile::GetUpdateStatus
/// get on of update statuses from "status" file from current dir
/// \return
///
CANProtocol::UpdateStatus ControlFile::GetUpdateStatus()
{
    int status;
    int result;
    char buffer[16];
    CANProtocol::UpdateStatus us;

    status = open(m_statusFile, O_RDONLY);
    if (-1 != status)
    {  // file exists
        result = read(status, buffer, 16-1);
        if (result < 0)  {  result = 0;  }
        buffer[result] = '\0';
        int tail = (result>0)?(result-1):0;

        while(tail>=0)
        {
            if (buffer[tail] < ' ') // less than space
            {   buffer[tail] = '\0';
                tail--;
            }
            else break;
        }

        if(0) LOG("get update status: <%s>\n", buffer);

        close(status);

        if (0 == strcmp(CANProtocol::InternalUpdateStatusUploading, buffer))
        {  us = CANProtocol::UpdateStatus::UPLOADING; }
        else
        {  if (0 == strcmp(CANProtocol::InternalUpdateStatusUploaded, buffer))
           {  us = CANProtocol::UpdateStatus::UPLOADED; }
           else
           {  if (0 == strcmp(CANProtocol::InternalUpdateStatusOnExecution, buffer))
              {  us = CANProtocol::UpdateStatus::ON_EXECUTION; }
              else
              { if (0 == strcmp(CANProtocol::InternalUpdateStatusDone, buffer))
                {  us = CANProtocol::UpdateStatus::DONE; }
                else
                {  if (0 == strcmp(CANProtocol::InternalUpdateStatusRollback, buffer))
                   {  us = CANProtocol::UpdateStatus::ROLLBACK; }
                   else
                   {  us = CANProtocol::UpdateStatus::EXECUTION_ERROR; }
                }
              }
           }
        }
    }
    else
    {
        us = CANProtocol::UpdateStatus::UNKNOWN;
    }
    return us;
}

///
/// \brief ControlFile::SetUpdateStatus
/// set an update status into "status" file or remove the status file
/// \param _status status string
/// \return
///
ControlFile::FileError ControlFile::SetUpdateStatus(char* _status)
{
    int status_fd;
    int result;
    CANProtocol::UpdateStatus us = CANProtocol::UpdateStatus::UNKNOWN;

    if (0) LOG("set update status: %s\n", _status);

    if (0 == strcmp(CANProtocol::InternalUpdateStatusUploading, _status))
    {  us = CANProtocol::UpdateStatus::UPLOADING; }
    else if (0 == strcmp(CANProtocol::InternalUpdateStatusUploaded, _status))
    {  us = CANProtocol::UpdateStatus::UPLOADED; }
    else if (0 == strcmp(CANProtocol::InternalUpdateStatusOnExecution, _status))
    {  us = CANProtocol::UpdateStatus::ON_EXECUTION; }
    else if (0 == strcmp(CANProtocol::InternalUpdateStatusDone, _status))
    {  us = CANProtocol::UpdateStatus::DONE; }
    else if (0 == strcmp(CANProtocol::InternalUpdateStatusRollback, _status))
    {  us = CANProtocol::UpdateStatus::ROLLBACK; }
    else if (0 == strcmp(CANProtocol::InternalUpdateStatusError, _status))
    {  us = CANProtocol::UpdateStatus::EXECUTION_ERROR; }
    else
    {  us = CANProtocol::UpdateStatus::UNKNOWN;  }

    if (CANProtocol::UpdateStatus::UNKNOWN != us)
    {
        status_fd = open(m_statusFile, O_WRONLY | O_BINARY | O_CREAT | O_TRUNC);
        if (-1 == status_fd)
        {
            LOG("Error opening file %s\n", m_statusFile);
            return FileError::FILE_WRITE_ERROR;
        }
        result = write(status_fd, _status, strlen(_status));
#ifndef WIN32
        fsync(status_fd);
#endif
        close(status_fd);
        if (result <= 0)  {  return FileError::FILE_WRITE_ERROR;  }
    }
    else
    {
        result = remove(m_statusFile);
    }

    return (result <= 0) ? FileError::FILE_WRITE_ERROR : FileError::OK;
}

std::string ControlFile::GetVersion()
{
    int ver;
    unsigned char buffer[512];
    int result=0;

    if (0 != chdir(DEFAULT_UPDATE_DIR))
        return std::string("");

    ver = open(m_versionFile, O_RDONLY);
    if (-1 != ver)
    {
        result = read(ver, buffer, 512-1);
        if (result < 0)  {  result = 0;  }
        buffer[result] = '\0';
    }
    // removing special symbols at the end
    int tail = (result>0)?(result-1):0;
    while(tail>=0)
    {
        if (buffer[tail] < ' ') // less than space
        {   buffer[tail] = '\0';
            tail--;
        }
        else break;
    }
    close(ver);

    if (0) LOG("version: %s\n", buffer);

    return std::string((char*)buffer);
}

ControlFile::FileError ControlFile::WriteVersion(std::string _version_str)
{
    int ver_fd;
    int result;

    if(m_Version != _version_str){

        if (0 != chdir(DEFAULT_UPDATE_DIR))
        {
            m_Version.assign("");
            return FileError::OTHER_FILE_ERROR;
        }

        if (0) LOG("version: %s\n", _version_str.c_str());

        ver_fd = open(m_versionFile, O_WRONLY | O_BINARY | O_CREAT | O_TRUNC);
        if (-1 == ver_fd)
        {
            LOG("Error opening file %s\n", _version_str.c_str());
            return FileError::FILE_WRITE_ERROR;
        }
        result = write(ver_fd, _version_str.c_str(), strlen(_version_str.c_str()));
#ifndef WIN32
        fsync(ver_fd);
#endif
        close(ver_fd);

        if (result <= 0)  {  return FileError::FILE_WRITE_ERROR;  }

        m_Version.assign(_version_str);

        if (0 != chdir(_version_str.c_str()))
        {
            return FileError::FILE_WRITE_ERROR;
        }
    }

    return FileError::OK;
}

ControlFile::FileError ControlFile::WriteExistingVersion(char* _version)
{
    FileError ret = FileError::OK;

    ret = WriteVersion(_version);

    if(FileError::OK == ret)
    {
        //NOTE: outputs data about existing version state:
        LOG("Version %s set as current for update\n", m_Version.c_str());
        LOG("File: Chs:%ld Fsz:%ld Chsz:%d Usize:%ld LChSz:%d SUCC:%ld\n", (long)m_header[m_currHeader].m_chunks, (long)m_header[m_currHeader].m_fileSize,
            m_header[m_currHeader].m_chunkSize, (long)m_header[m_currHeader].m_UpdateSize,
            m_header[m_currHeader].m_lastChunkSize, (long)m_header[m_currHeader].m_lastSuccessfulChunk);
    }
    return ret;
}


ControlFile::FileError ControlFile::WriteNewVersion(char* _version)
{

    ControlFile::FileError ret = FileError::OK;

    if(0) LOG("version: %s\n", _version);

    if (0 != chdir(DEFAULT_UPDATE_DIR))
    {
        ret = FileError::OTHER_FILE_ERROR;
    }

    if (ret == FileError::OK)
    {
        if((0 != chdir(_version)))
        {
            if (0) LOG("make dir %s\n", _version);
#ifdef WIN32
            if (0 != mkdir(_version))
#else
            if (0 != mkdir(_version, 0777))
#endif
            {
                ret = FileError::FILE_WRITE_ERROR;
            }

            if (ret == FileError::OK)
            {

                if (0 != chdir(_version))
                {
                    ret = FileError::FILE_WRITE_ERROR;
                }
                else
                {
                    if (0) LOG("new dir %s\n", _version);
                }
                // successfully changed
            }
        }
    }


    if(FileError::OK == ret)
    {
        LOG("InitTransfer(): version %s\n", _version);
        ret = WriteVersion(_version);
    }

    return ret;
}

ControlFile::FileError ControlFile::CheckAndLoadControlFile()
{
    if(0) LOG("Check+load\n");

    std::string CFName = std::string(m_fileName);
    const int nothing = -1000;
    int last[2] = { nothing, nothing};
    FileError MErr[2];
    std::string suffix_1 = NextSuffix(std::string(""));
    std::string suffix_2 = NextSuffix(suffix_1);
    int result;

    if (FileError::OK == (MErr[0] = ReadControlFile(CFName+suffix_1)))
    {
        MErr[0] = CheckStoredImage(CFName, last[0]);
    }
    if (FileError::OK == (MErr[1] = ReadControlFile(CFName+suffix_2)))
    {
        MErr[1] = CheckStoredImage(CFName, last[1]);
    }
    // choose the best
    if ((nothing == last[0]) && (nothing == last[1]))
    {    m_bootCode = BOOTSTRAP_CODE::NO_BOOT_DATA;
         return FileError::FILE_NOT_FOUND;
    }
    int code = 0;
    if (nothing == last[1]) // take file .1
    {
        code = 0;
    } else
    if (nothing == last[0]) // take file .1
    {
        code = 1;
    } else
    // two files looks OK
    { code = (last[1] > last[0]) ? 1: 0;  }
    ReadControlFile(CFName + ((code == 0) ? suffix_1: suffix_2 ));
    CheckStoredImage(CFName, result);
    m_header[m_currHeader].m_lastSuccessfulChunk = result;
    m_bootCode = BOOTSTRAP_CODE::OPENED_OK;
    m_suffix = ((code == 0) ? suffix_1: suffix_2 );
    LOG("Restored control files: %d+1 chunks, (%s:%d+1 vs %s:%d+1)\n", result, suffix_1.c_str(), last[0], suffix_2.c_str(), last[1] );
    return FileError::OK;
}

///
/// \brief ControlFile::CheckVersion
/// returns OK if version already exists
///         FILE_NOT_FOUND if not exists
/// \param _version version to check
/// \return
///
ControlFile::FileError ControlFile::CheckVersion(std::string _version)
{
    int result;
    FileError mErr = FileError::OK;

    result = chdir(ControlFile::DEFAULT_UPDATE_DIR);
    if (0 != result)
    {
        mErr = FileError::OTHER_FILE_ERROR;
    }
    else
    {
        result = chdir(_version.c_str());
        if (0 == result)
        {
            LOG("Request for version %s\n", _version.c_str());
            mErr = CheckAndLoadControlFile();
        }
        else
        {
            mErr = FileError::FILE_NOT_FOUND;
        }
    }

    return mErr;
}

///
/// \brief ControlFile::BootStrap
/// \note here errors are not real error, just statuses
/// \return
///
ControlFile::FileError ControlFile::BootStrap()
{
    int result;
    FileError merr;

    result = chdir(ControlFile::DEFAULT_UPDATE_DIR);
    if (-1 == result)
    {
#ifdef WIN32
        mkdir(ControlFile::DEFAULT_UPDATE_DIR);
#else
        mkdir(ControlFile::DEFAULT_UPDATE_DIR, 0777);
#endif
    }

    std::string v = GetVersion();
    if (0) LOG("Version at updated power on: %s\n", v.c_str());

    if (v.length() > 0)
    {  // something meaningful
       result = chdir(v.c_str());
       if (result == 0)
       {
           if (0) LOG("Look for version %s\n", v.c_str());
           merr = CheckAndLoadControlFile();
           if (FileError::OK != merr)
               return merr;
           else
           {
               m_Version .assign(v);
               if(0) LOG("Version %s set as current for update\n", m_Version.c_str());
               if(0) LOG("File: Chs:%ld Fsz:%ld Chsz:%d Usize:%ld LChSz:%d SUCC:%ld\n", (long)m_header[m_currHeader].m_chunks, (long)m_header[m_currHeader].m_fileSize,
                      m_header[m_currHeader].m_chunkSize, (long)m_header[m_currHeader].m_UpdateSize,
                      m_header[m_currHeader].m_lastChunkSize, (long)m_header[m_currHeader].m_lastSuccessfulChunk);
               return merr;
           }
       }
    }
    m_bootCode = BOOTSTRAP_CODE::NO_BOOT_DATA;
    return FileError::FILE_NOT_FOUND;
}

ControlFile::FileError ControlFile::RemoveContent(std::string _version)
{
    std::string contentName = _version + "/" + m_fileName;
    std::string statusName = _version + "/" + m_statusFile;
    chdir("..");

    LOG("DiscardContent(): remove version: %s\n", _version.c_str());

    int result = remove((contentName + m_suffix).c_str());
    result = remove((contentName + NextSuffix(m_suffix)) .c_str());
    result = remove(contentName.c_str());

    result = remove(statusName.c_str());

    result = rmdir(_version.c_str());
    m_Version.assign("");
    if (0 == result)
        return FileError::OK;
    else
        return FileError::FILE_NOT_FOUND;
}

ControlFile::FileError ControlFile::InitControlFile(uint32_t _size, uint32_t _chunk_size)
{
    if(0) LOG("size: %u, chSize: %u \n", _size, _chunk_size);

    if (0 == _size)
        return FileError::FILE_DAMAGED;

    m_header[m_currHeader].m_UpdateSize = _size;
    m_header[m_currHeader].m_chunkSize  = _chunk_size;
    memset((char*) m_header[m_currHeader].reserved, 0, sizeof(m_header[m_currHeader].reserved));

    m_header[m_currHeader].m_lastChunkSize = m_header[m_currHeader].m_UpdateSize % m_header[m_currHeader].m_chunkSize;

    m_header[m_currHeader].m_chunks = m_header[m_currHeader].m_UpdateSize / m_header[m_currHeader].m_chunkSize  +  ((m_header[m_currHeader].m_lastChunkSize > 0) ? 1 : 0);
    m_header[m_currHeader].m_lastSuccessfulChunk = DEFAULT_CHUNK_NO;

    m_header[m_currHeader].m_fileSize = sizeof(ControlFileHeader) + sizeof(SHA2Store)*(m_header[m_currHeader].m_chunks +1);

    if(0) LOG("chunks: %u, last chunk: %u \n", (unsigned int)m_header[m_currHeader].m_chunks, m_header[m_currHeader].m_lastChunkSize);

    m_sums = new SHASums(m_header[m_currHeader].m_chunks);

    m_suffix = NextSuffix(std::string(""));

    return WriteControlFile(m_fileName + m_suffix);
}


ControlFile::FileError ControlFile::ReadControlFile(std::string _fileName)
{
    if(0) LOG("version: %s\n", _fileName.c_str());

    int infile;
    unsigned int result;

    infile = open(_fileName.c_str(), O_RDONLY | O_BINARY);
    if (-1 == infile)
    {
        if(0) LOG("Can open control file %s!\n", _fileName.c_str());
        return FileError::FILE_NOT_FOUND;
    }

    m_fileSize = lseek(infile, 0, SEEK_END);
    if (-1 == m_fileSize)
    {
        LOG("Control file size get error\n");
        return FileError::OTHER_FILE_ERROR;
    }

    if (-1 == lseek(infile, 0, SEEK_SET))
    {
        LOG("Control file positioning error\n");
        return FileError::OTHER_FILE_ERROR;
    }

    memset((void*)&(m_header[m_currHeader]), 0, sizeof(m_header));

    result = read(infile, &m_header[m_currHeader], sizeof(ControlFileHeader));
    if (result < sizeof(ControlFileHeader))
    {
        LOG("Error reading control file header\n");
        return FileError::NO_MEMORY;
    }

    // checking header
    if (m_header[m_currHeader].m_fileSize != (uint64_t) m_fileSize)
    {
        LOG("File size in header is not equal to real control file size\n");
        return FileError::FILE_DAMAGED;
    }

    m_sums = new SHASums(m_header[m_currHeader].m_chunks);

    result = read(infile, m_sums->sums, sizeof(SHA2Store)*m_header[m_currHeader].m_chunks);

    if (result < sizeof(SHA2Store)*m_header[m_currHeader].m_chunks)
    {
        LOG("Error while reading MD5 sums from control file\n");
        delete m_sums;
        return FileError::FILE_DAMAGED;
    }

    result = read(infile, (void*)&m_sum, sizeof(SHA2Store));

    if (result < sizeof(SHA2Store))
    {
        LOG("Error while reading final MD5 sum for control file\n");
        delete m_sums;
        return FileError::FILE_DAMAGED;
    }
    // All done except calculating SHA256

    SHA256 sha256;
    SHA2Store sha256result;
    sha256.add(&m_header[m_currHeader], sizeof(ControlFileHeader));
    sha256.add(m_sums->sums, m_header[m_currHeader].m_chunks * sizeof(SHA2Store));
    sha256.getHash((unsigned char*)&sha256result);

    if (0 != memcmp((void*)&m_sum, (void*)&sha256result, sizeof(SHA2Store)))
    {
        LOG("SHA256 sum is incorrect\n");
        delete m_sums;
        return FileError::FILE_DAMAGED;
    }

    LOG("Last succ chunk: %llu\n", m_header[m_currHeader].m_lastSuccessfulChunk);

    close(infile);

    return FileError::OK;
}

ControlFile::FileError ControlFile::CheckStoredImage(std::string _binFile, int& lastCorrectChunk)
{
    LOG("file: %s for %lld chs\n", _binFile.c_str(), m_header[m_currHeader].m_lastSuccessfulChunk);

    int bin = open(_binFile.c_str(), O_RDONLY | O_BINARY);
    if (-1 == bin)
    {
        LOG("Can open stored image file %s!\n", _binFile.c_str());
        return FileError::FILE_NOT_FOUND;
    }

    unsigned int chunks = m_header[m_currHeader].m_lastSuccessfulChunk;
    unsigned int chunk_size = m_header[m_currHeader].m_chunkSize;

    char* buffer = new char[chunk_size];

    for(unsigned int ch = 0; ch < chunks; ch++)
    {
        SHA256 sha2sum;
        SHA2Store sha2temp;
        unsigned int status = read(bin, buffer, chunk_size);
        if (status == chunk_size)
        {
            sha2sum.add((void*)buffer, chunk_size);
            sha2sum.getHash((unsigned char*)&sha2temp);
            int eqs = memcmp((void*)&sha2temp, (void*)&(m_sums->sums[ch]), sizeof(SHA2Store));
            if (0 == eqs)
            {
                continue;
            }
        }
        // execution reaches here only if something is wrong
        close(bin);
        lastCorrectChunk = ch-1;
        delete [] buffer;
        return FileError::FILE_DAMAGED;
    }
    close(bin);
    lastCorrectChunk = chunks;
    delete [] buffer;
    return FileError::OK;
}

ControlFile::FileError ControlFile::WriteControlFile(std::string _fileName)
{
    int outFile;
    unsigned int result;

    if (0) LOG("file: %s\n", _fileName.c_str());

    outFile = open(_fileName.c_str(), O_RDWR | O_CREAT | O_BINARY);
    if (-1 == outFile)
    {
        LOG("Can not create control file %s!\n", _fileName.c_str());
        return FileError::FILE_NOT_FOUND;
    }

    unsigned fileSize = sizeof(ControlFileHeader) + ((m_header[m_currHeader].m_chunks + 1) * sizeof(SHA2Store));

    m_header[m_currHeader].m_fileSize = fileSize;

    SHA256 sha256;
    SHA2Store sha256result;
    sha256.add(&m_header[m_currHeader], sizeof(ControlFileHeader));
    sha256.add(m_sums->sums, m_header[m_currHeader].m_chunks * sizeof(SHA2Store));
    sha256.getHash((unsigned char*)&m_sum);

    result = write(outFile, &(m_header[m_currHeader]), sizeof(ControlFileHeader));
    if (result < sizeof(ControlFileHeader))
    {
        LOG("Can not write control file header\n");
        return FileError::FILE_WRITE_ERROR;
    }

    result = write(outFile, m_sums->sums, sizeof(SHA2Store)* m_header[m_currHeader].m_chunks);
    if (result < sizeof(SHA2Store)*m_header[m_currHeader].m_chunks)
    {
        LOG("Can not write control file MD5 sums\n");
        return FileError::FILE_WRITE_ERROR;
    }

    result = write(outFile,(void*)&m_sum, sizeof(SHA2Store));
    if (result < sizeof(SHA2Store))
    {
        LOG("Can not write control file final MD5 sum\n");
        return FileError::FILE_WRITE_ERROR;
    }

#ifndef WIN32
    fsync(outFile);
#endif

    close(outFile);
    return FileError::OK;
}

ControlFile::FileError ControlFile::WriteControlFile(std::string _fileName, int _chunk)
{
    int outFile;
    unsigned int result;

    if (0) LOG("file: %s\n", _fileName.c_str());

    outFile = open(_fileName.c_str(), O_RDWR | O_CREAT | O_BINARY);
    if (-1 == outFile)
    {
        LOG("Can not create control file %s!\n", _fileName.c_str());
        return FileError::FILE_NOT_FOUND;
    }

    unsigned fileSize = sizeof(ControlFileHeader) + ((m_header[m_currHeader].m_chunks + 1) * sizeof(SHA2Store));

    m_header[m_currHeader].m_fileSize = fileSize;

    SHA256 sha256;
    SHA2Store sha256result;
    sha256.add(&(m_header[m_currHeader]), sizeof(ControlFileHeader));
    sha256.add(m_sums->sums, m_header[m_currHeader].m_chunks * sizeof(SHA2Store));
    sha256.getHash((unsigned char*)&m_sum);

    result = write(outFile, &(m_header[m_currHeader]), sizeof(ControlFileHeader));
    if (result < sizeof(ControlFileHeader))
    {
        LOG("Can not write control file header\n");
        return FileError::FILE_WRITE_ERROR;
    }

    // optimized write
    if (m_header[m_currHeader].m_chunks <= 16) // too low number of chunks
    {
        result = write(outFile, m_sums->sums, sizeof(SHA2Store)* m_header[m_currHeader].m_chunks);
        if (result < sizeof(SHA2Store)*m_header[m_currHeader].m_chunks)
        {
            LOG("Can not write control file MD5 sums\n");
            return FileError::FILE_WRITE_ERROR;
        }
    }
    else
    {
        int start_chunk = (_chunk-2 < 0) ?  0 : (_chunk-2);
        long ofs = sizeof(ControlFileHeader) + sizeof (SHA2Store)* start_chunk;
        if (-1 == lseek(outFile, ofs, SEEK_SET))
        {    LOG("Can not skip in file\n");
             return FileError::FILE_WRITE_ERROR;
        }
        if (0) LOG("Opt write %d - %d\n", start_chunk, _chunk);
        result = write(outFile, &(m_sums->sums[start_chunk]), sizeof(SHA2Store)* (_chunk - start_chunk + 1));
        if (sizeof(SHA2Store)* (_chunk - start_chunk + 1) != result)
        {    LOG("Can not write in optimized way in control file\n");
             return FileError::FILE_WRITE_ERROR;
        }
        ofs = sizeof(ControlFileHeader) + sizeof (SHA2Store)* m_header[m_currHeader].m_chunks;
        if (-1 == lseek(outFile, ofs, SEEK_SET))
        {    LOG("Can not skip in file up to end\n");
             return FileError::FILE_WRITE_ERROR;
        }

    }

    result = write(outFile,(void*)&m_sum, sizeof(SHA2Store));
    if (result < sizeof(SHA2Store))
    {
        LOG("Can not write control file final MD5 sum\n");
        return FileError::FILE_WRITE_ERROR;
    }

#ifndef WIN32
    fsync(outFile);
#endif

    close(outFile);
    return FileError::OK;
}

ControlFile::FileError ControlFile::WriteFile(unsigned char* _buf, uint32_t _len)
{
    SHA2Store sha2;

    if (FileError::OK != m_PD.mErr)
    { // error in writing thread was occured
        m_header[m_currHeader].m_lastSuccessfulChunk = m_PD.last_succ_chunk_before;
        return FileError::OK;
    }

    int chunk = NextChunk(m_header[m_currHeader].m_lastSuccessfulChunk);
    if (DEFAULT_CHUNK_NO == chunk)
        chunk = m_header[m_currHeader].m_chunks;

    if (DEFAULT_CHUNK_NO == chunk)
        return FileError::OTHER_FILE_ERROR;

    if (0 == chunk%20)
    {
        LOG("PushChunk(): writing chunk: %d\n", chunk);
    }

    int n = 1000;
    while (0 == m_PD.writtenStatus)
    {   usleep(500); n--;
        if (n==0)  {  n = 1000;
            pthread_mutex_lock( &(m_PD.cond_var_lock));
            pthread_cond_signal( &(m_PD.cond_var) );
            pthread_mutex_unlock( &(m_PD.cond_var_lock));
        }

    }
    m_PD.writtenStatus = 0;

    memcpy(m_payloadBuffer, _buf, _len);
    m_PD._len = _len;
    m_PD._chunk = chunk;
    m_PD.last_succ_chunk_before = m_header[m_currHeader].m_lastSuccessfulChunk;

    pthread_mutex_lock( &(m_PD.cond_var_lock));
    pthread_cond_signal( &(m_PD.cond_var) );
    pthread_mutex_unlock( &(m_PD.cond_var_lock));

    m_header[m_currHeader].m_lastSuccessfulChunk = chunk;
    // file write is done by thread

     return FileError::OK;
}

ControlFile::FileError ControlFile::CheckChunkSHA2(int _chunk_no, SHA2Store* _sha2sum)
{
    size_t bresult;
    int result;

    if(0) LOG("chunk num: %d\n", _chunk_no);

    int temp = open(m_fileName, O_RDONLY | O_BINARY);
    if (-1 == temp)
    {
        LOG("can not open blob file\n");
        return FileError::FILE_NOT_FOUND;
    }

    if (_chunk_no >= (int)m_header[m_currHeader].m_chunks)
    {
        LOG("incorrent chunk number\n");
        return FileError::OTHER_FILE_ERROR;
    }

    long fOffset = (DEFAULT_CHUNK_NO != _chunk_no) ? (m_header[m_currHeader].m_chunkSize * _chunk_no): 0 ;

    long size = m_header[m_currHeader].m_chunkSize;
    if (DEFAULT_CHUNK_NO == _chunk_no)
    {
        size = lseek(temp, 0, SEEK_END);
        if (-1 == size)
        {   LOG("Can not get blob file size\n");
            return FileError::FILE_DAMAGED;
        }
    }

    result = lseek(temp, fOffset, SEEK_SET);
    if (-1 == result)
    {
        LOG("can not seek blob file for sum check\n");
        return FileError::FILE_WRITE_ERROR;
    }

    const unsigned int memoryLen = 32768;
    unsigned char* memory = new unsigned char[memoryLen];

    if (!memory)
    {
        LOG("Memory allocation error\n");
        return FileError::NO_MEMORY;
    }

    SHA256 value;
    while (size>0)
    {
        unsigned int _len = ((unsigned int)size > memoryLen)? memoryLen:size;
        bresult = read(temp, memory, _len);
        if (bresult == 0) break;
        value.add(memory, bresult);
        size -= _len;
    }

    close(temp);
    delete[] memory;

    if (size>0)
    {
        LOG("not able to read the data block from blob file");
        return FileError::FILE_DAMAGED;
    }
    SHA2Store sha2counted;
    value.getHash(sha2counted.bytes);
    std::string hast_str = value.getHash();
    LOG("VerifyContent(): calculated file hash: %s\n", hast_str.c_str());

    if (-1 == _chunk_no)
    {
       SetUpdateStatus((char*)CANProtocol::InternalUpdateStatusUploaded);
    }

    value.getHash(_sha2sum->bytes);

    return FileError::OK;
}

ControlFile::FileError ControlFile::_WriteFile(unsigned char* _buf, uint32_t _len, int _chunk_no, SHA2Store* _sha2sum)
{
    int temp;
    int result;
    size_t bresult;

    if (0) LOG("len: %u\n", _len);

    temp = open(m_fileName, O_RDWR | O_BINARY | O_CREAT);
    if (-1 == temp)
    {
        temp = open(m_fileName, O_RDWR | O_BINARY | O_CREAT);
        if (-1 == temp)
        {
            LOG("can not open blob file\n");
            return FileError::FILE_NOT_FOUND;
        }
    }

    if (_chunk_no >= (int)m_header[m_currHeader].m_chunks)
    {
        LOG("incorrent chunk number\n");
        return FileError::OTHER_FILE_ERROR;
    }

    long fOffset = m_header[m_currHeader].m_chunkSize * _chunk_no;

    result = lseek(temp, fOffset, SEEK_SET);
    if (-1 == result)
    {
        LOG("can not seek blob file for write\n");
        return FileError::FILE_WRITE_ERROR;
    }

    bresult = write(temp, _buf, _len);
    if (bresult != _len)
    {
        LOG("can not write chunk to blob file\n");
        return FileError::FILE_NOT_FOUND;
    }

#ifndef WIN32
    fsync(temp);
#endif
    close(temp);

    temp = open(m_fileName, O_RDONLY | O_BINARY);
    if (-1 == temp)
    {
        LOG("can not open blob file for sum check\n");
        return FileError::FILE_NOT_FOUND;
    }

    result = lseek(temp, fOffset, SEEK_SET);
    if (-1 == result)
    {
        LOG("can not seek blob file 2nd time\n");
        return FileError::FILE_WRITE_ERROR;
    }

    unsigned char* blob = new unsigned char[_len];
    if (!blob)
    {
        LOG("can not allocate memory for chunk\n");
        return FileError::NO_MEMORY;
    }

    bresult = read(temp, blob, _len);
    if (bresult != _len)
    {
        LOG("can not read full chunk to blob file\n");
        delete [] blob;
        return FileError::FILE_NOT_FOUND;
    }
    // checking SHA2 sum

    close(temp);

    SHA256 sha2;
    sha2.add(blob, _len);
    sha2.getHash(_sha2sum->bytes);

    delete[] blob;

    return FileError::OK;
}

void ControlFile::DeleteStorage()
{
     delete m_sums;
}
