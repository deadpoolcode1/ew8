EW8 Linux
copy to Linux machine sdk from \\files\ims\SWTools\DeliveriesFromIntegration\EW8YoctoSDK\
install it on Linux machine
Extract content of the archive \\files\ims\SWTools\DeliveriesFromIntegration\EW8YoctoSDK\config-qt-ew8-danro.tar\ to temporary folder
in extract folders update the path to the actual username. From linux you can use the command: find . -type f | xargs sed -i 's;/homes/mobileye/danro/poky-sdk/2.5.2/;/homes/username/poky-sdk;g'
copy content of the updated folder to ~/.config folder

copy to home dir (any folder there) the 2 files qtcreator-start.sh and qtcreator-4.6.0.tar.xz
extract to the folder the archive qtcreator-4.6.0.tar.xz
in file qtcreator-start.sh, update pathes to the actual user and installtion source folder

copy and extract in home dir the file bin-ew8.tar.xz from \\files\ims\SWTools\DeliveriesFromIntegration\EW8YoctoSDK\
Create in home dir folder ~/work/wic

how to update wic image with new swu version
copy to the ~/work/wic folder the original wic file (from deliveryFromIntegration) and the swu file
duplicate the file ~/bin-ew8/wic-canquick-replace.conf.example to new file without .example extension (.conf extension)
edit the new file with base image file name for INPUTFILE, new image file name for OUTPUTFILE, engine swu file for FW_SWUPACK, media swu file for MEDIA_SWUPACK
all the source files (wic image and swu packages) should be in the ~/work/wic folders

get from git the repo of yocto with all submodules (run command git --recurse-sumodules git@gitlab.mobileye.com:ims-sw-tools/embedded/ew8-yocto/ew8-yocto-main.git)
run the reset-revisions.sh

build the yocto
cd poky
bash
source oe-init-buid-env build-mobileye

edit the file yocto\build-mobileye\conf\local.conf to the right path for tmp 
copy the file local.conf and bblayers.conf from yocto\build-mobileye\conf\ to yocto\poky\build-mobileye\conf

edit .gitconfig file to add alias:
[url "https://github.com"]
	insteadOf = git://github.com

once code commmited to gitlab, to create a new version with image ans swu, edit bb files in ~/yocto/meta-mobileye/recipes-baby/canquick/ to take from expected revision (line SRC_URI)
in folder ~/yocto/meta-mobileye/recipes-baby/canquick/files update in diff files major and minor version to expected.

script ~/bin-ew8/canquick-build.sh build all automatic. Still need to update the version numbers and update the git rev in bb files.


how to prepare a new EW8 version:
1 - make required code change and update versions
2 - push the code to gitlab
3 - update git revision in bb files (~/yocto/meta-mobileye/recipes-baby/canquick/)
4- update version for OCU for test in ~/yocto/meta-mobileye/recipes-baby/canquick/ (modify_version_x.x.*.diff)
5 - run file ~/bin-ew8/canquick-build.sh
6 - OCU file in folder /homes/danro/work/OCU
7 - wic file in folder /home/mobileye/danro/tmp/yocto/tmp/deploy
8 - to build wic file based on previous wic but with new swu, update file wic-canquick-replace.conf and run ~/bin-ew8/wic-canquick-replace.sh


how to update splash logo:
use ~bin-ew8/pack_splash.sh to convert svg logo to raw.lz4 file
replace files me_splash_320x240.raw.lz4 and me_splash_320x240.svg in ~yocto/meta-mobileye/recipes-core/ew8_splash/files/