#
# Copyright (C) 2019 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

TARGET_NO_BOOTLOADER := true
TARGET_NO_RECOVERY := true
TARGET_NO_KERNEL := false

# Architecture
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a
#TARGET_CPU_VARIANT := cortex-a7
TARGET_CPU_VARIANT := generic
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi

TARGET_BOARD_INFO_FILE := device/allwinner/plus2e/board-info.txt

# --- Android images ---
BOARD_FLASH_BLOCK_SIZE := 512

# User image
TARGET_COPY_OUT_DATA := data
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_PARTITION_SIZE := 576716800

# System image
TARGET_COPY_OUT_SYSTEM := system
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 576716800

# Cache image
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_PARTITION_SIZE := 69206016

# Vendor image
TARGET_COPY_OUT_VENDOR := vendor
BOARD_USES_VENDORIMAGE := true
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_PARTITION_SIZE := 268435456
#BOARD_VENDOR_SEPOLICY_DIRS       += device/renesas/common/sepolicy/vendor
#BOARD_VENDOR_SEPOLICY_DIRS       += device/renesas/$(TARGET_PRODUCT)/sepolicy/vendor

# Boot image
#BOARD_BOOTIMAGE_PARTITION_SIZE := 16777216
#BOARD_DTBIMAGE_PARTITION_SIZE := 1048576
#BOARD_DTBOIMG_PARTITION_SIZE := 524288

# Root image
TARGET_COPY_OUT_ROOT := root
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true

# Recovery image
TARGET_COPY_OUT_RECOVERY := recovery

# Kernel build rules
KERNEL_CONFIGS_DIR:= ../configs/p/android-4.14
BOARD_KERNEL_BASE     := 0x40008000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_MKBOOTIMG_ARGS  := --second_offset 0x800 --kernel_offset 0x80000 --ramdisk_offset 0x2180000
BOARD_KERNEL_CMDLINE  := console=ttySC0,115200 init=/init androidboot.console=ttySC0 androidboot.hardware=orangepi_plus2e androidboot.selinux=permissive
TARGET_KERNEL_SOURCE  := kernel/allwinner
#TARGET_KERNEL_CONFIG  := orangepi_plus2e_defconfig ${KERNEL_CONFIGS_DIR}/android-base.cfg ${KERNEL_CONFIGS_DIR}/android-base-arm.cfg ${KERNEL_CONFIGS_DIR}/android-recommended.cfg
TARGET_KERNEL_CONFIG  := orangepi_plus2e_defconfig android-base.config android-recommended.config

# SELinux support
#BOARD_SEPOLICY_DIRS += build/target/board/generic/sepolicy

BOARD_VNDK_VERSION := current

SMALLER_FONT_FOOTPRINT := true
MINIMAL_FONT_FOOTPRINT := true

# Some framework code requires this to enable BT
#BOARD_HAVE_BLUETOOTH := true
#BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/generic/common/bluetooth

BOARD_USES_GENERIC_AUDIO := true
#USE_CAMERA_STUB := true
BUILD_EMULATOR_OPENGL := true
USE_OPENGL_RENDERER := true
BOARD_USE_LEGACY_UI := true
