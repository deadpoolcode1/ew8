cmake_minimum_required(VERSION 3.14)
project(ew8_backend CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Grammar file processing — read the .peg file and embed it into a header
# NOTE: candbgrammar.h.in uses qmake's $$VAR syntax, not CMake's ${VAR}.
# So we generate the header directly instead of using configure_file.
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/../candbgrammar.peg" CANDBGRAMMAR)
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/candbgrammar.h"
    "#pragma once\n\nconst char candbgrammar[] = R\"peg(\n${CANDBGRAMMAR})peg\";\n")

set(BACKEND_SOURCES
    ../amjsonaction.cpp
    ../amjsonactionfactory.cpp
    ../amjsonactionsmultiplexor.cpp
    ../amjsonargumentaction.cpp
    ../amjsonconfigreader.cpp
    ../amjsonenableraction.cpp
    ../amjsonfixedargumentsactioninvoker.cpp
    ../amjsongraphicitemaction.cpp
    ../amjsonnumericargumentaction.cpp
    ../amjsonprotocol.cpp
    ../amjsonrequestidaction.cpp
    ../amjsonsignal.cpp
    ../amjsonstringargumentaction.cpp
    ../amjsonsystemrequestaction.cpp
    ../amsignalsmodel.cpp
    ../brightnesscontrol.cpp
    ../bufferedsmoother.cpp
    ../canargumentsaccumulator.cpp
    ../candbsignal.cpp
    ../candebugreport.cpp
    ../canintargumentsaccumulator.cpp
    ../canmanager.cpp
    ../canrxmsg.cpp
    ../canrxmsgfactory.cpp
    ../canstringargumentsaccumulator.cpp
    ../entitytype.cpp
    ../graphicitemsenummap.cpp
    ../keepalivemsg.cpp
    ../medisconnectionreport.cpp
    ../timedsmoother.cpp
    ../versionmsg.cpp
    ../watchdogdevice.cpp
)

add_library(ew8_backend STATIC ${BACKEND_SOURCES})

target_include_directories(ew8_backend PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/..
    ${CMAKE_CURRENT_BINARY_DIR}
)

# Version numbers (match canquick.pro)
set(MAJOR_VERSION 3 CACHE STRING "Major version")
set(MINOR_VERSION 0 CACHE STRING "Minor version")
set(OTA_TEST_VERSION 0 CACHE STRING "OTA test version")

# Resource base directory — each frontend sets this for its own compile
set(BASE_TARGET_DIR "" CACHE STRING "Base directory for runtime resources")

# Match canquick.pro definitions
target_compile_definitions(ew8_backend PUBLIC
    VERIFY_ALL_ALERTS_IMPLEMENTED
    MAJOR_VERSION=${MAJOR_VERSION}
    MINOR_VERSION=${MINOR_VERSION}
    OTA_TEST_VERSION=${OTA_TEST_VERSION}
)
# BASE_TARGET_DIR — set by the frontend before add_subdirectory(backend)
target_compile_definitions(ew8_backend PUBLIC
    "BASE_TARGET_DIR=\"${BASE_TARGET_DIR}\""
)

# Desktop build: disable HW-specific code (matches canquick.pro for x86_64)
if(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|AMD64")
    target_compile_definitions(ew8_backend PUBLIC REMOVE_EW8_HW)
endif()

# Ensure POSIX extensions are available (SIGUSR2, etc.)
target_compile_definitions(ew8_backend PRIVATE _DEFAULT_SOURCE)

if(WIN32)
    target_link_libraries(ew8_backend PUBLIC canlib32)
else()
    target_link_libraries(ew8_backend PUBLIC socketcan pthread)
endif()
