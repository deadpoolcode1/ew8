cmake_minimum_required(VERSION 3.14)
project(ew8_lvgl_frontend C CXX)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# SDL2 — cross-platform detection
if(WIN32)
    # Try pkg-config first (MSYS2/MinGW), then find_package (vcpkg)
    find_package(PkgConfig QUIET)
    if(PKG_CONFIG_FOUND)
        pkg_check_modules(SDL2 QUIET sdl2)
    endif()
    if(NOT SDL2_FOUND)
        find_package(SDL2 REQUIRED)
        if(TARGET SDL2::SDL2)
            set(SDL2_LIBRARIES SDL2::SDL2 SDL2::SDL2main)
        endif()
    endif()
else()
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(SDL2 REQUIRED sdl2)
endif()

# LVGL configuration
set(LV_CONF_PATH "${CMAKE_CURRENT_SOURCE_DIR}/lv_conf.h" CACHE STRING "" FORCE)
set(LV_CONF_BUILD_DISABLE_EXAMPLES ON CACHE BOOL "" FORCE)
set(LV_CONF_BUILD_DISABLE_DEMOS ON CACHE BOOL "" FORCE)

# Vendored LVGL library (submodule at v9.2.2)
# Apply local patches (GIF decoder fixes) if not already applied
execute_process(
    COMMAND git apply --check --directory=frontend/lvgl/lvgl
        ${CMAKE_CURRENT_SOURCE_DIR}/patches/lvgl-gif-fixes.patch
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../..
    RESULT_VARIABLE PATCH_CHECK_RESULT
    ERROR_QUIET OUTPUT_QUIET
)
if(PATCH_CHECK_RESULT EQUAL 0)
    execute_process(
        COMMAND git apply --directory=frontend/lvgl/lvgl
            ${CMAKE_CURRENT_SOURCE_DIR}/patches/lvgl-gif-fixes.patch
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../..
    )
    message(STATUS "Applied LVGL GIF patches")
else()
    message(STATUS "LVGL GIF patches already applied or not needed")
endif()

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
)

# SDL2 linking
if(WIN32)
    target_link_libraries(ew8_lvgl PRIVATE SDL2)
else()
    target_link_libraries(ew8_lvgl PRIVATE ${SDL2_LIBRARIES} pthread)
endif()

target_compile_definitions(ew8_lvgl PRIVATE
    LV_CONF_INCLUDE_SIMPLE
)

# SDL2 on Windows: we handle main() ourselves
if(WIN32)
    target_compile_definitions(ew8_lvgl PRIVATE SDL_MAIN_HANDLED)
endif()

# Copy shared assets to build directory for runtime access.
#
# The app locates its resources via core::resourceBaseDir(), which expects
# configs/, dbc/ and signals/ alongside the executable. The build used to copy
# only images/, so a run-from-build (or a packaged build) was missing the other
# three trees and depended on hand-made symlinks (IMS-11650). Copy all of them.
# DBC is copied to a lowercase "dbc/" to match the lookup path in
# candbsignal.cpp on case-sensitive filesystems.
set(EW8_REPO_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/../..)
file(COPY ${EW8_REPO_ROOT}/assets/images DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
file(COPY ${EW8_REPO_ROOT}/configs       DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
file(COPY ${EW8_REPO_ROOT}/signals       DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
file(COPY ${EW8_REPO_ROOT}/DBC/          DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/dbc)

# Bundle the MinGW C++ runtime and SDL2 DLLs next to the executable so it can
# launch without C:\msys64\mingw64\bin being on PATH — otherwise the process
# exits silently because SDL2.dll / the runtime can't be found (IMS-11651).
# These four DLLs are MinGW-specific; on MSVC/vcpkg toolchains the C++ runtime
# is redistributed differently, so this only runs for a MinGW build.
if(WIN32 AND MINGW)
    get_filename_component(MINGW_BIN_DIR "${CMAKE_CXX_COMPILER}" DIRECTORY)

    # SDL2.dll may live under the SDL2 package prefix (from pkg-config) rather
    # than the compiler's bin directory; search both.
    set(EW8_DLL_SEARCH_DIRS "${MINGW_BIN_DIR}")
    foreach(_sdl_dir IN ITEMS "${SDL2_PREFIX}" "${SDL2_LIBDIR}" "${SDL2_EXEC_PREFIX}")
        if(_sdl_dir)
            list(APPEND EW8_DLL_SEARCH_DIRS "${_sdl_dir}" "${_sdl_dir}/bin" "${_sdl_dir}/../bin")
        endif()
    endforeach()

    foreach(_dll_name libgcc_s_seh-1.dll libstdc++-6.dll libwinpthread-1.dll SDL2.dll)
        string(MAKE_C_IDENTIFIER "EW8_DLL_PATH_${_dll_name}" _dll_cachevar)
        find_file(${_dll_cachevar} NAMES ${_dll_name} PATHS ${EW8_DLL_SEARCH_DIRS} NO_DEFAULT_PATH)
        if(${_dll_cachevar})
            add_custom_command(TARGET ew8_lvgl POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_if_different
                        "${${_dll_cachevar}}" "$<TARGET_FILE_DIR:ew8_lvgl>"
                COMMENT "Bundling ${_dll_name}"
                VERBATIM)
        else()
            message(WARNING
                "ew8_lvgl: runtime DLL '${_dll_name}' not found in "
                "${EW8_DLL_SEARCH_DIRS}; it must be on PATH or copied next to "
                "ew8_lvgl.exe manually.")
        endif()
    endforeach()
endif()
