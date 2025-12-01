#pragma once

#include <string>
#include "updateapi/updatecanapi.h"

#ifndef UPDATESAMPLE_H
#define UPDATESAMPLE_H

int UploadFile(CANUpdateAPI* uc, std::string _fileName, std::string _version, std::string _sha2code, unsigned int _chunk_size,  std::string _flag);

#endif // UPDATESAMPLE_H
