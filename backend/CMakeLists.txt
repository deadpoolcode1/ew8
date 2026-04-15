cmake_minimum_required(VERSION 3.14)
project(ew8_backend CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Grammar file processing — read the .peg file and embed it into a header
# NOTE: candbgrammar.h.in uses qmake's $$VAR syntax, not CMake's ${VAR}.
# So we generate the header directly instead of using configure_file.
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/candbgrammar.peg" CANDBGRAMMAR)
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/candbgrammar.h"
    "#pragma once\n\nconst char candbgrammar[] = R\"peg(\n${CANDBGRAMMAR})peg\";\n")

set(BACKEND_SOURCES
    src/amjsonaction.cpp
    src/amjsonactionfactory.cpp
    src/amjsonactionsmultiplexor.cpp
    src/amjsonargumentaction.cpp
    src/amjsonconfigreader.cpp
    src/amjsonenableraction.cpp
    src/amjsonfixedargumentsactioninvoker.cpp
    src/amjsongraphicitemaction.cpp
    src/amjsonnumericargumentaction.cpp
    src/amjsonprotocol.cpp
    src/amjsonrequestidaction.cpp
    src/amjsonsignal.cpp
    src/amjsonstringargumentaction.cpp
    src/amjsonsystemrequestaction.cpp
    src/amsignalsmodel.cpp
    src/brightnesscontrol.cpp
    src/bufferedsmoother.cpp
    src/canargumentsaccumulator.cpp
    src/candbsignal.cpp
    src/candebugreport.cpp
    src/canintargumentsaccumulator.cpp
    src/canmanager.cpp
    src/canrxmsg.cpp
    src/canrxmsgfactory.cpp
    src/canstringargumentsaccumulator.cpp
    src/entitytype.cpp
    src/graphicitemsenummap.cpp
    src/keepalivemsg.cpp
    src/medisconnectionreport.cpp
    src/timedsmoother.cpp
    src/versionmsg.cpp
    src/watchdogdevice.cpp
    src/snv_calculator.cpp
    src/version_info.cpp
    src/layerspriorityq.cpp
    src/alertcontroller.cpp
    src/app_init.cpp
    src/display_tree.cpp
)

add_library(ew8_backend STATIC ${BACKEND_SOURCES})

target_include_directories(ew8_backend PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
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

# Platform-specific configuration
if(WIN32)
    # Windows desktop: use UDP virtual CAN (no hardware needed)
    # To build with Kvaser hardware support, set -DEW8_USE_KVASER=ON
    option(EW8_USE_KVASER "Use Kvaser CAN hardware instead of UDP virtual CAN" OFF)

    if(EW8_USE_KVASER AND NOT (CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|AMD64"))
        target_link_libraries(ew8_backend PUBLIC canlib32)
    else()
        # UDP virtual CAN — links winsock2
        target_link_libraries(ew8_backend PUBLIC ws2_32)
    endif()
else()
    # Ensure POSIX extensions are available (SIGUSR2, etc.)
    target_compile_definitions(ew8_backend PRIVATE _DEFAULT_SOURCE)
    target_link_libraries(ew8_backend PUBLIC socketcan pthread)
endif()
