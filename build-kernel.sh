#!/bin/bash

CYAN="\\033[1;36m"
GREEN="\\033[1;32m"
YELLOW="\\E[33;44m"
RED="\\033[1;31m"
RESET="\\e[0m"
DEVICE="honami"
THREADS="4"
DATE=`date +%Y-%m-%d_%H%M`

if [ -z "$1" ]
  then
    echo -n -e "\n${RED}You can specify the device to build for with an argument (e.g: ./build-kernel.sh honami)${RESET}\n\n"
    echo -n -e "${CYAN}Please input the codename of the device you're building for ${YELLOW}(honami / amami)${RESET}${CYAN} : ${RESET}\n"
    read device
    DEVICE=${device}
else
    DEVICE=$1
fi

echo -n -e "${CYAN}How many CPU threads to use ? ${RESET}"
read threads

cd ../../../
. build/envsetup.sh
lunch cm_${DEVICE}-userdebug
mka bootimage -j${threads}

mkdir -p tmp-dir/system/lib/modules
cp -f out/target/product/${DEVICE}/boot.img tmp-dir/boot.img
cp -f out/target/product/${DEVICE}/system/lib/modules/wlan.ko tmp-dir/system/lib/modules/wlan.ko
cp -f kernel/sony/msm8974/placeholder.zip tmp-dir/placeholder.zip
cd tmp-dir
zip -u placeholder.zip boot.img
zip -u placeholder.zip system/lib/modules/wlan.ko
mv -f placeholder.zip ../kernel/sony/msm8974/Pimped-Kernel-${DEVICE}-${DATE}.zip
cd ../
rm -rf tmp-dir
cd kernel/sony/msm8974

echo -n -e "${GREEN}Made flashable package:${RESET} ${YELLOW}Pimped-Kernel-${DATE}.zip${RESET}\n"

