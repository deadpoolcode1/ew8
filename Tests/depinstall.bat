@echo off
REM EW8 Windows dependency installer
REM Installs Python CAN libraries for testing and checks for SDL2

echo === EW8 Windows Dependency Installer ===
echo.

REM Python test dependencies
echo Installing Python test dependencies...
python -m pip install --upgrade pip
python -m pip install cantools
python -m pip install python-can

echo.
echo === Python dependencies installed ===
echo.

REM Check for SDL2
echo Checking for SDL2...
where sdl2-config >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo SDL2 found in PATH.
) else (
    echo SDL2 not found. To build the LVGL frontend, install SDL2:
    echo.
    echo   Option 1 - vcpkg:
    echo     vcpkg install sdl2:x64-windows
    echo     cmake -B build -DCMAKE_TOOLCHAIN_FILE=[vcpkg-root]/scripts/buildsystems/vcpkg.cmake
    echo.
    echo   Option 2 - Manual:
    echo     Download SDL2-devel from https://github.com/libsdl-org/SDL/releases
    echo     Set SDL2_DIR to the cmake/ folder inside the extracted archive
    echo     cmake -B build -DSDL2_DIR=path/to/SDL2/cmake
    echo.
    echo   Option 3 - MSYS2 ^(if using MinGW^):
    echo     pacman -S mingw-w64-x86_64-SDL2
)

echo.
echo === Setup complete ===
pause
