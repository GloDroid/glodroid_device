#!/bin/bash

# It is necessary to install tools for deploying before script usage:
# sudo apt install u-boot-tools


#----- Parameters initialization ----------------------------------------------
BOARD_NAME=plus2e
OUT_DIR=out
OUT_TARGET_DIR=${OUT_DIR}/target/product/${BOARD_NAME}
ARTIFACTS_DIR=${OUT_DIR}/deploying
KERNEL_IMAGE_NAME=zImage
DTB_NAME=sun8i-h3-orangepi-plus2e.dtb

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
cp vendor/tools/gensdimg.sh ${ARTIFACTS_DIR}/

echo "Copying files for booting"
cp device/allwinner/${BOARD_NAME}/boot.txt ${ARTIFACTS_DIR}/
cp device/allwinner/${BOARD_NAME}/fstab-android-sdcard.dts ${ARTIFACTS_DIR}/

sync

}

#----- Deployng ---------------------------------------------------------------
function deploying {
echo "Start deploying"
cd ${ARTIFACTS_DIR}
./gensdimg.sh ${DTB_NAME}

}

#----- Main cycle -------------------------------------------------------------
#copy
deploying

#----- End --------------------------------------------------------------------
