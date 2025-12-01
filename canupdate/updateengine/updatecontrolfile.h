#pragma once

#ifndef UPDATECONTROLFILE_H
#define UPDATECONTROLFILE_H

#include <cstdio>
#include "updatecommon/sha256.h"
#include "cstring"
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <fcntl.h>
#include "updatecommon/utils.h"

#include "updatecommon/updatecanprotocol.h"


const unsigned int m_granularity = 32; // 32B alignment

struct ControlFileHeader
{
    uint64_t m_fileSize;
    uint64_t reserved[3];

    uint32_t m_chunkSize;
    uint32_t m_lastChunkSize;
    int64_t m_chunks;
    int64_t m_lastSuccessfulChunk; // also the first chunk to read
    uint64_t m_UpdateSize;  // update file size

};


struct ControlFile
{
    struct ControlFileHeader m_header[2];
    SHA2Store m_sum;
    struct SHASums *m_sums;
    static const char m_fileName[];
    std::string m_suffix;

    int64_t m_fileSize = 0;
    int m_currHeader = 0;

    static const int DEFAULT_CHUNK_NO = -1; //

    static const char DEFAULT_UPDATE_DIR[];
    static const char m_versionFile[];
    static const char m_defaultSuffix[];
    static const char m_defaultNextSuffix[];
    static const char m_statusFile[];

    std::string m_Version;

    enum class FileError
    {
        OK = 0,
        FILE_NOT_FOUND = 1,
        NO_MEMORY = 2,
        OTHER_FILE_ERROR = 3,
        FILE_DAMAGED = 4,
        FILE_WRITE_ERROR = 5,
        SHA2ERROR = 6
    };

    enum class BOOTSTRAP_CODE
    {
        OPENED_OK = 0,
        NO_BOOT_DATA = 1,
    };

    BOOTSTRAP_CODE m_bootCode;
    int m_threadStatus;
    int m_joinStatus;
    pthread_t m_ithread;

    struct WriteThreadSharedData
    {
        unsigned char* _buf;
        uint32_t _len;
        int _chunk;
        FileError mErr;

        int last_succ_chunk_before;

        // thread-related
        /// int dataTrigger; // fill in data and set to non-zero
        int writtenStatus;

        pthread_mutex_t cond_var_lock; // condition variable for file writing thread
        pthread_cond_t cond_var; // mutex for conditional variable
    };

    struct WriteThreadSharedData m_PD;
    unsigned char m_payloadBuffer[2048];

    static void* IntThread(void* _args);

    ControlFile();
    ~ControlFile();

    int NextChunk(int _chunk);

    std::string NextSuffix(std::string _suffix);
    void PropagateHeader();

    FileError InitControlFile(uint32_t _size, uint32_t _chunk_size);
    FileError ReadControlFile(std::string _fileName);
    FileError CheckStoredImage(std::string _binFile, int& lastCorrectChunk);
    FileError WriteControlFile(std::string _fileName);
    FileError WriteControlFile(std::string _fileName, int chunk);
    void DeleteStorage();

    FileError _WriteFile(unsigned char* _buf, uint32_t _len, int _chunk_no, SHA2Store* sha2sum);
    FileError WriteFile(unsigned char* _buf, uint32_t _len);
    FileError CheckChunkSHA2(int _chunk_no, SHA2Store* _sha2sum);

    std::string GetVersion();
    FileError WriteVersion(std::string _str);
    FileError BootStrap();
    FileError RemoveContent(std::string _version);
    FileError WriteNewVersion(char* _version);
    FileError WriteExistingVersion(char* _version);
    FileError CheckAndLoadControlFile();
    FileError CheckVersion(std::string _version);

    CANProtocol::UpdateStatus GetUpdateStatus();
    ControlFile::FileError SetUpdateStatus(char* status);

};

#endif // UPDATECONTROLFILE_H
