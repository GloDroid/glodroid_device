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
TARGET_ARCH_VARIANT := armv7-a-neon
#TARGET_CPU_VARIANT := cortex-a7
TARGET_CPU_VARIANT := generic
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi

# Binder interface should be 64bit even on 32bit SoC
TARGET_USES_64_BIT_BINDER := true

TARGET_SUPPORTS_32_BIT_APPS := true
TARGET_SUPPORTS_64_BIT_APPS := false

TARGET_BOARD_INFO_FILE := device/glodroid/plus2e/board-info.txt

# generic wifi
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_HOSTAPD_DRIVER := NL80211

# --- Android images ---
BOARD_FLASH_BLOCK_SIZE := 512

# User image
TARGET_COPY_OUT_DATA := data
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_PARTITION_SIZE := 300000000

# System image
#TARGET_COPY_OUT_SYSTEM := system
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 900000000
# Disable Jack build system due deprecated status (https://source.android.com/source/jack)
ANDROID_COMPILE_WITH_JACK ?= false

# Cache image
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_PARTITION_SIZE := 69206016 # 66MB

# Vendor image
TARGET_COPY_OUT_VENDOR := vendor
BOARD_USES_VENDORIMAGE := true
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_PARTITION_SIZE := 268435456 # 256MB
#BOARD_VENDORIMAGE_PARTITION_SIZE := 2147483648 # 2GB

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
BOARD_KERNEL_BASE     := 0x40008000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_MKBOOTIMG_ARGS  := --second_offset 0x800 --kernel_offset 0x80000 --ramdisk_offset 0x2180000
TARGET_KERNEL_SOURCE  := kernel/glodroid

# SELinux support
#BOARD_SEPOLICY_DIRS += build/target/board/generic/sepolicy

BOARD_VNDK_VERSION := current

# Some framework code requires this to enable BT
BOARD_HAVE_BLUETOOTH := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/generic/common/bluetooth

BOARD_USES_TINYHAL_AUDIO := true
TINYCOMPRESS_TSTAMP_IS_LONG := true
TINYALSA_NO_ADD_NEW_CTRLS := true
TINYALSA_NO_CTL_GET_ID := true
#USE_CAMERA_STUB := true
BUILD_EMULATOR_OPENGL := true
USE_OPENGL_RENDERER := true
BOARD_USE_LEGACY_UI := true

BOARD_GPU_DRIVERS := lima kmsro

# Enable dex-preoptimization to speed up first boot sequence
DEX_PREOPT_DEFAULT := nostripping
WITH_DEXPREOPT := true
ART_USE_HSPACE_COMPACT := true

DEVICE_MANIFEST_FILE := device/glodroid/common/manifest.xml

# SELinux support
BOARD_PLAT_PUBLIC_SEPOLICY_DIR   += device/glodroid/plus2e/sepolicy/public
BOARD_PLAT_PRIVATE_SEPOLICY_DIR  += device/glodroid/plus2e/sepolicy/private
BOARD_VENDOR_SEPOLICY_DIRS       += device/glodroid/plus2e/sepolicy/vendor
