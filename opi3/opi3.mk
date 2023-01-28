# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, glodroid/configuration/opi3/device.mk)

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

PRODUCT_BOARD_PLATFORM := sunxi
PRODUCT_NAME := opi3
PRODUCT_DEVICE := opi3
PRODUCT_BRAND := OrangePI
PRODUCT_MODEL := opi3
PRODUCT_MANUFACTURER := xunlong
PRODUCT_HAS_EMMC := true

UBOOT_DEFCONFIG := orangepi_3_defconfig
ATF_PLAT        := sun50i_h6

CRUST_FIRMWARE_DEFCONFIG := orangepi_3_defconfig

KERNEL_SRC       := glodroid/kernel/megous
KERNEL_DEFCONFIG := glodroid/configuration/platform/common/sunxi/sunxi64_defconfig
KERNEL_FRAGMENTS := \
    glodroid/configuration/platform/common/sunxi/sunxi-common.config \
    $(LOCAL_PATH)/kernel.config \

KERNEL_DTB_FILE := allwinner/sun50i-h6-orangepi-3.dtb

SYSFS_MMC0_PATH := soc/4020000.mmc
SYSFS_MMC1_PATH := soc/4022000.mmc

ANDROID_DTS_OVERLAY := $(LOCAL_PATH)/android.dts
