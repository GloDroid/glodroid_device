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

echo "Copying sdcard script"
cp device/allwinner/tools/gensdimg.sh ${OUT_TARGET_DIR}/

sync

}

#----- Generate SDCard image ---------------------------------------------------
function generate {

echo "Start image creation"
cd ${OUT_TARGET_DIR}
./gensdimg.sh
cd ${CURR_DIR}

}

#----- Deployng ---------------------------------------------------------------
function deploying {

echo "Start SDCard image is being deployed to /dev/"${SDCARD_NAME}
cd ${OUT_TARGET_DIR}
sudo dd if=sdcard.img of=/dev/${SDCARD_NAME}
cd ${CURR_DIR}

}

#----- Main cycle -------------------------------------------------------------
copy
generate
deploying

#----- End --------------------------------------------------------------------
