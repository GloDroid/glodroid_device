#!/bin/bash

# It is necessary to install tools for deploying before script usage:
# sudo apt install u-boot-tools
#
# The first parameter should consists of a name of SDCard reader device, eg:
# ./deploying sdd
# 1st parameter should be set obligatorily.

#----- Parameters initialization ----------------------------------------------
BOARD_NAME=plus2e
OUT_DIR=out
OUT_TARGET_DIR=${OUT_DIR}/target/product/${BOARD_NAME}
ARTIFACTS_DIR=${OUT_DIR}/deploying
KERNEL_IMAGE_NAME=zImage
DTB_NAME=sun8i-h3-orangepi-plus2e.dtb
CURR_DIR=$PWD

if [ $1 ]
then
  echo "Start...."
  SDCARD_NAME=$1
else
  echo "The 1st parameter should be set obligatorily"
  exit 1
fi

#----- Artifacts copying ------------------------------------------------------
function copy {

echo "Create a Folder for deployingh - " ${ARTIFACTS_DIR}
mkdir -p ${ARTIFACTS_DIR}/
mkdir -p ${ARTIFACTS_DIR}/generated/

echo "Copying images"
cp ${OUT_TARGET_DIR}/*.img ${ARTIFACTS_DIR}/

echo "Copying u-boot files"
cp ${OUT_TARGET_DIR}/*.bin ${ARTIFACTS_DIR}/

echo "Copying kernel files"
cp ${OUT_TARGET_DIR}/obj/KERNEL_OBJ/arch/arm/boot/${KERNEL_IMAGE_NAME} ${ARTIFACTS_DIR}/
cp ${OUT_TARGET_DIR}/obj/KERNEL_OBJ/arch/arm/boot/dts/${DTB_NAME} ${ARTIFACTS_DIR}/

echo "Copying sdcard script"
cp device/allwinner/tools/gensdimg.sh ${ARTIFACTS_DIR}/

echo "Copying files for booting"
cp device/allwinner/${BOARD_NAME}/boot.txt ${ARTIFACTS_DIR}/
cp device/allwinner/${BOARD_NAME}/fstab-android-sdcard.dts ${ARTIFACTS_DIR}/

sync

}

#----- Generate SDCard image ---------------------------------------------------
function generate {

echo "Start image creation"
cd ${ARTIFACTS_DIR}
./gensdimg.sh ${DTB_NAME}
cd ${CURR_DIR}

}

#----- Deployng ---------------------------------------------------------------
function deploying {

echo "Start SDCard image is being deployed to /dev/"${SDCARD_NAME}
cd ${ARTIFACTS_DIR}
sudo dd if=generated/sdcard.img of=/dev/${SDCARD_NAME}
cd ${CURR_DIR}

}

#----- Main cycle -------------------------------------------------------------
copy
generate
deploying

#----- End --------------------------------------------------------------------
