cmake_minimum_required(VERSION 3.14)
project(ew8_lvgl_frontend C CXX)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# SDL2
find_package(PkgConfig REQUIRED)
pkg_check_modules(SDL2 REQUIRED sdl2)

# LVGL configuration
set(LV_CONF_PATH "${CMAKE_CURRENT_SOURCE_DIR}/lv_conf.h" CACHE STRING "" FORCE)
set(LV_CONF_BUILD_DISABLE_EXAMPLES ON CACHE BOOL "" FORCE)
set(LV_CONF_BUILD_DISABLE_DEMOS ON CACHE BOOL "" FORCE)

# Vendored LVGL library (submodule)
# Disable ASM language to prevent LVGL from compiling ARM .S files on x86
# The LVGL CMakeLists.txt enables ASM and globs all .S files, but
# the helium/neon .S files are ARM-only and fail on x86_64.
set(CMAKE_ASM_COMPILER_WORKS TRUE)  # Skip ASM compiler check
add_subdirectory(lvgl lvgl_build)

# Remove ARM assembly sources that were globbed by LVGL's cmake
get_target_property(LVGL_SOURCES lvgl SOURCES)
list(FILTER LVGL_SOURCES EXCLUDE REGEX ".*\\.(S)$")
set_target_properties(lvgl PROPERTIES SOURCES "${LVGL_SOURCES}")

# Install target path
set(EW8_INSTALL_PREFIX "/opt/canquick" CACHE STRING "Install prefix")

# Set BASE_TARGET_DIR before including backend
set(BASE_TARGET_DIR "${EW8_INSTALL_PREFIX}/bin/../" CACHE STRING "Base directory for runtime resources" FORCE)

# Build the backend library
add_subdirectory(../../backend backend_build)

set(FRONTEND_SOURCES
    src/main.cpp
    src/sdl_display.cpp
    src/lvgl_display_node.cpp
    src/lvgl_main_process.cpp
    src/lvgl_widgets.cpp
    src/lvgl_value_display_node.cpp
    src/lvgl_string_display_node.cpp
    src/lvgl_blink_display_node.cpp
    src/lvgl_hmw_state_node.cpp
    src/lvgl_menu_controller.cpp
    src/lvgl_menu_display_node.cpp
    src/lvgl_test_display_node.cpp
    fonts/lv_font_intelone_bold_18.c
    fonts/lv_font_intelone_bold_20.c
    fonts/intelone_medium_14.c
    fonts/intelone_medium_17.c
    fonts/intelone_medium_20.c
    fonts/intelone_medium_22.c
    fonts/intelone_medium_24.c
    fonts/intelone_medium_28.c
    fonts/intelone_medium_36.c
    fonts/intelone_medium_44.c
)

add_executable(ew8_lvgl ${FRONTEND_SOURCES})

target_include_directories(ew8_lvgl PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}/lvgl
    ${SDL2_INCLUDE_DIRS}
)

target_link_libraries(ew8_lvgl PRIVATE
    ew8_backend
    lvgl
    ${SDL2_LIBRARIES}
    pthread
)

target_compile_definitions(ew8_lvgl PRIVATE
    LV_CONF_INCLUDE_SIMPLE
)

# Copy shared assets to build directory for runtime access
file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/../../assets/images DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
