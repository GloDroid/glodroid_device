# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2019 The Android Open-Source Project

include device/glodroid/common/boardconfig-common.mk
include device/glodroid/common/bluetooth/boardconfig.mk

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a53

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a15

TARGET_BOARD_INFO_FILE := device/glodroid/pinephone/board-info.txt

BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive

DEVICE_MANIFEST_FILE += device/glodroid/pinephone/manifest.xml
BOARD_VENDOR_SEPOLICY_DIRS += device/glodroid/pinephone/sepolicy/vendor
