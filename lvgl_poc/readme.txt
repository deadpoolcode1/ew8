Step-by-Step for Ubuntu Desktop

  Step 1: Install Qt and Dependencies

  sudo apt update
  sudo apt install -y qt5-qmake qtbase5-dev qtdeclarative5-dev \
      libqt5quick5 libqt5quickcontrols2-5 qml-module-qtquick2 \
      qml-module-qtquick-controls2 qml-module-qtquick-layouts \
      qml-module-qtquick-window2 qml-module-qtqml-models2 \
      libsocketcan-dev libqrencode-dev libdrm-dev \
      build-essential can-utils
sudo apt install libsocketcan-dev
sudo apt install qml-module-qt-labs-settings

  Step 2: Set Up Virtual CAN Interface

  sudo modprobe vcan
  sudo ip link add dev can0 type vcan
  sudo ip link set up can0

  Step 3: Build the Application

  cd /mnt/c/Users/Hadar/Downloads/ew8-master/ew8-master/canquick
  mkdir -p build && cd build
  qmake ../canquick.pro
  make -j$(nproc)

  Step 4: Set Up Resource Symlinks

  sudo mkdir -p /opt/canquick/bin
  sudo ln -sf "$(pwd)/../qml" /opt/canquick/qml
  sudo ln -sf "$(pwd)/../signals" /opt/canquick/signals
  sudo ln -sf "$(pwd)/../configs" /opt/canquick/configs
  sudo ln -sf "$(pwd)/../DBC" /opt/canquick/dbc

  Step 5: Run the GUI

  ./canquick

  Step 6: Run the Test (in another terminal)

  cd /mnt/c/Users/Hadar/Downloads/ew8-master/ew8-master/canquick/Tests
  ./basic.sh

  The GUI should respond to the CAN messages and cycle through different views.




cd canquick/lvgl_poc
     git clone --depth 1 https://github.com/lvgl/lvgl.git
     git clone --depth 1 https://github.com/lvgl/lv_drivers.git


canquick/lvgl_poc/
  ├── CMakeLists.txt      # Build configuration
  ├── lv_conf.h           # LVGL configuration (800x480, SDL2)
  ├── main.cpp            # Entry point, SDL2+LVGL integration
  ├── can_receiver.h      # CAN receiver header
  ├── can_receiver.cpp    # SocketCAN integration
  ├── lvgl_ui.h           # UI manager header
  ├── lvgl_ui.cpp         # Speed display + FCW alert widgets
  └── test_poc.sh         # Test script for vcan0

  Build Instructions (run in your VM)

  # 1. Install dependencies
  sudo apt install libsdl2-dev cmake build-essential can-utils

  # 2. Clone LVGL into the poc directory
  cd /path/to/canquick/lvgl_poc
  git clone --depth 1 --branch v9.2.2 https://github.com/lvgl/lvgl.git

  # 3. Build
  mkdir build && cd build
  cmake ..
  make

  # 4. Setup virtual CAN (use can0 to match basic.sh)
  sudo modprobe vcan
  sudo ip link add dev can0 type vcan
  sudo ip link set up can0

  # 5. Run the POC
  ./lvgl_poc

  # 6. In another terminal, run the test
  cd ../..
  ./Tests/basic.sh

  Usage

  - ./lvgl_poc - Uses can0 by default (matches basic.sh)
  - ./lvgl_poc vcan0 - Uses custom interface

  The window will show:
  - Speed display at bottom center (updates when CAN ID 0x760 received)
  - FCW alert at top center (red box appears when CAN ID 0x700 bit 35 is set)