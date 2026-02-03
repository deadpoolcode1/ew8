cmake_minimum_required(VERSION 3.14)
project(lvgl_poc C CXX)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find SDL2
find_package(PkgConfig REQUIRED)
pkg_check_modules(SDL2 REQUIRED sdl2)

# LVGL configuration path
set(LV_CONF_PATH "${CMAKE_CURRENT_SOURCE_DIR}/lv_conf.h" CACHE STRING "" FORCE)
set(LV_CONF_BUILD_DISABLE_EXAMPLES ON CACHE BOOL "" FORCE)
set(LV_CONF_BUILD_DISABLE_DEMOS ON CACHE BOOL "" FORCE)

# Add LVGL library
add_subdirectory(lvgl)

# Source files
set(SOURCES
    main.cpp
    can_receiver.cpp
    lvgl_ui.cpp
    lvgl_alert_display.cpp
    medisconnectionreport_lvgl.cpp
)

# Create executable
add_executable(lvgl_poc ${SOURCES})

# Include directories
# Note: Include parent directory (..) to allow #include "core/xxx.h" to work
target_include_directories(lvgl_poc PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/..
    ${CMAKE_CURRENT_SOURCE_DIR}/lvgl
    ${SDL2_INCLUDE_DIRS}
)

# Link libraries
target_link_libraries(lvgl_poc PRIVATE
    lvgl
    ${SDL2_LIBRARIES}
    pthread
)

# Compiler definitions
target_compile_definitions(lvgl_poc PRIVATE
    LV_CONF_INCLUDE_SIMPLE
)

# Copy images to build directory for runtime access
file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/images DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
