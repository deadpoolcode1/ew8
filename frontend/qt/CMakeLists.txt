cmake_minimum_required(VERSION 3.14)
project(ew8_qt_frontend CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt5 REQUIRED COMPONENTS Quick Gui Qml)

# Install target path (matches canquick.pro: /opt/canquick/bin)
set(EW8_INSTALL_PREFIX "/opt/canquick" CACHE STRING "Install prefix for canquick")

# Set BASE_TARGET_DIR before including backend so backend code uses the correct path
set(BASE_TARGET_DIR "${EW8_INSTALL_PREFIX}/bin/../" CACHE STRING "Base directory for runtime resources" FORCE)

# Build the backend library
add_subdirectory(../../backend backend_build)

set(FRONTEND_SOURCES
    src/main.cpp
    src/mainprocess.cpp
    src/rootedtreenode.cpp
    src/rootedtree.cpp
    src/displaysignalizer.cpp
    src/qquickqrcode.cpp
    src/ewinfo.cpp
    # Headers with Q_OBJECT (needed for AUTOMOC)
    include/alerttypes.h
    include/mainprocess.h
    include/displaysignalizer.h
    include/qquickqrcode.h
    include/ewinfo.h
)

add_executable(canquick ${FRONTEND_SOURCES})

target_include_directories(canquick PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(canquick PRIVATE
    ew8_backend
    Qt5::Quick Qt5::Gui Qt5::Qml
    qrencode drm
)

target_compile_definitions(canquick PRIVATE
    QT_CORE_LIB
    LOG_INIT_COMPLETE_TO_DMESG
)

# REMOVE_EW8_HW for desktop builds is inherited from ew8_backend (PUBLIC)

# Qt resources
qt5_add_resources(QML_RESOURCES qml.qrc)
target_sources(canquick PRIVATE ${QML_RESOURCES})

# Post-build: create symlinks for runtime resource discovery
# Build /opt/canquick/qml/ as a directory with symlinks to QML files + shared assets
add_custom_command(TARGET canquick POST_BUILD
    COMMAND sudo mkdir -p ${EW8_INSTALL_PREFIX}/bin
    COMMAND sudo rm -rf ${EW8_INSTALL_PREFIX}/qml
    COMMAND sudo mkdir -p ${EW8_INSTALL_PREFIX}/qml
    COMMAND bash -c "sudo ln -sf ${CMAKE_CURRENT_SOURCE_DIR}/qml/*.qml ${CMAKE_CURRENT_SOURCE_DIR}/qml/*.js ${EW8_INSTALL_PREFIX}/qml/"
    COMMAND sudo ln -sfn ${CMAKE_CURRENT_SOURCE_DIR}/../../assets/images ${EW8_INSTALL_PREFIX}/qml/images
    COMMAND sudo ln -sfn ${CMAKE_CURRENT_SOURCE_DIR}/../../assets/fonts ${EW8_INSTALL_PREFIX}/qml/fonts
    COMMAND sudo ln -sfn ${CMAKE_CURRENT_SOURCE_DIR}/../../signals ${EW8_INSTALL_PREFIX}/signals
    COMMAND sudo ln -sfn ${CMAKE_CURRENT_SOURCE_DIR}/../../configs ${EW8_INSTALL_PREFIX}/configs
    COMMAND sudo ln -sfn ${CMAKE_CURRENT_SOURCE_DIR}/../../DBC ${EW8_INSTALL_PREFIX}/dbc
)
