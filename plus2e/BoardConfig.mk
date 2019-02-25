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

# The generic product target doesn't have any hardware-specific pieces.
TARGET_NO_BOOTLOADER := true
TARGET_NO_KERNEL := false
TARGET_ARCH := arm

TARGET_ARCH_VARIANT := armv7-a
TARGET_CPU_VARIANT := allwinner
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi

TARGET_BOARD_INFO_FILE := board-info.txt

SMALLER_FONT_FOOTPRINT := true
MINIMAL_FONT_FOOTPRINT := true

# Kernel build rules
BOARD_KERNEL_CMDLINE := console=ttySC0,115200 init=/init androidboot.console=ttySC0 androidboot.hardware=orangepi_plus2e androidboot.selinux=permissive
TARGET_KERNEL_CONFIG := rcar3_android_defconfig

# Some framework code requires this to enable BT
BOARD_HAVE_BLUETOOTH := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/generic/common/bluetooth

BOARD_USES_GENERIC_AUDIO := true

USE_CAMERA_STUB := true

BUILD_EMULATOR_OPENGL := true
USE_OPENGL_RENDERER := true

BOARD_USE_LEGACY_UI := true

# Android images
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 576716800
BOARD_USERDATAIMAGE_PARTITION_SIZE := 576716800
BOARD_CACHEIMAGE_PARTITION_SIZE := 69206016
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_FLASH_BLOCK_SIZE := 512
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true

# SELinux support
BOARD_SEPOLICY_DIRS += build/target/board/generic/sepolicy
