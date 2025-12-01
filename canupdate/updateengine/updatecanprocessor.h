#pragma once

#ifndef UPDATECANPROCESSOR_H
#define UPDATECANPROCESSOR_H

class CANProcessor;

#include <cstdio>
#include <cstdint>

#include "updatecontrolfile.h"

typedef void* (*script_func)(void*);

class CANProcessor {

public:
    struct ControlFile* m_controlFile;

    enum class CANProcessorStatus
    {
        OK = 0,
        DIR_EXISTS = 10,
        ACTIVE_TRANSMISSION = 11,
        NEED_VERSION = 12,
        FILE_WRITE_ERROR = 13,
        SHA2_ERROR = 14,
        CONTENT_PENDING = 15,
        SCRIPT_ERROR = 16,
        NEED_TO_WAIT = 17,
    };

    enum class CANProcessorState
    {
        READY = 0,
        DOWNLOADING = 1,
        PERROR = 2,
        UPDATING = 3,
        ROLLINGBACK = 4,
    };

    std::string m_fileName = "blob.swu";
    CANProcessorState m_state;

    CANProcessorStatus SetVersion(char* _new_version_name);
    CANProcessorStatus SetInfo(uint32_t _size, unsigned int _chunk_size);
    CANProcessorStatus GetNextChunk(int& _chunk);
    CANProcessorStatus DownloadedData(unsigned char* _buf, uint32_t _size);
    bool CheckChunkSize(uint32_t _size);
    CANProcessorStatus CheckChunkSHA2(int _chunk_no, SHA2Store* _sha2sum);
    CANProcessorStatus UpdateContent();
    CANProcessorStatus RemoveContent(unsigned char* _version);
    CANProcessorStatus GetContentVersion(unsigned char* _version, unsigned int _len);
    CANProtocol::UpdateStatus GetUpdateStatus();
    CANProcessorStatus ForceRollBack();
    CANProcessorStatus PowerOn();

    CANProcessorStatus RunScript(char* _script, script_func _run_script);
    static void* RunUpdate(void* _param);
    static void* RunRollback(void* _param);
    static void* RunPowerOn(void* _param);

    CANProcessor(ControlFile* _cf);

};

#endif // UPDATECANPROCESSOR_H
