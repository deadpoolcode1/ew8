1) Post git-clone install steps:
  a) Switch to bash:
      
    <somewhere>/ew8-yocto-main$ bash

  a) Reset the source state to original development condition:
 
      <somewhere>/ew8-yocto-main$ ./reset-revisions.sh

  b) Install buildtools prebuild yocto toolchain:
      
      <somewhere>/ew8-yocto-main$ ./build-mobileye/x86_64-buildtools-nativesdk-standalone-2.5.2.sh -y -d poky/buildtools

  c) Copy build configuration files to poky/build-mobileye work directory:

    <somewhere>/ew8-yocto-main$ mkdir -p poky/build-mobileye/conf 
    <somewhere>/ew8-yocto-main$ cp build-mobileye/conf/local.conf poky/build-mobileye/conf 
    <somewhere>/ew8-yocto-main$ cp build-mobileye/conf/bblayers.conf poky/build-mobileye/conf 

2) Prepare to work:
    
   a) Evaluate environment:
    
    <somewhere>/ew8-yocto-main$ cd poky
    <somewhere>/ew8-yocto-main$ source oe-init-build-env build-mobileye
    <somewhere>/ew8-yocto-main$ source ../buildtools/environment-setup-x86_64-pokysdk-linux 

   b) The EW8 rootfs image and canquick recipes has legacy buildtime dependency 'at91bootstrap' package which we provide by 'at91bootstrap-mobileye' recipe:
    
      
    <somewhere>/ew8-yocto-main/poky/build-mobileye$ bitbake at91bootstrap-mobileye

    (It is also the EW8 Bootloader)

3) Build your desired target:
   
   a) EW8 eMMC image:
      
    <somewhere>/ew8-yocto-main/poky/build-mobileye$ bitbake mobileye-baby-image-dev

   b) EW8 Application from gilab.mobileye.com source:

    <somewhere>/ew8-yocto-main/poky/build-mobileye$ bitbake canquick

   c) EW8 Application from localy stored canquick.tar.xz source:

    <somewhere>/ew8-yocto-main/poky/build-mobileye$ bitbake canquick-local

   The result shall be stored into output folder defined at poky/build-mobileye/conf/local.conf
   
   *Advice: Use tmux or screen utility if you build at remote Linux server or either Docker container. 
            The build processes may take up to several hours.
