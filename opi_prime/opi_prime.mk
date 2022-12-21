# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, device/glodroid/opi_prime/device.mk)

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
PRODUCT_NAME := opi_prime
PRODUCT_DEVICE := opi_prime
PRODUCT_BRAND := OrangePI
PRODUCT_MODEL := opi_prime
PRODUCT_MANUFACTURER := xunlong

GD_LOWRAM_CONFIG := true
GD_NO_DEFAULT_BLUETOOTH := true

UBOOT_DEFCONFIG := orangepi_prime_defconfig

# ATF is not used
ATF_PLAT        := sun50i_a64

KERNEL_DEFCONFIG := device/glodroid/platform/common/sunxi/sunxi64_defconfig
KERNEL_FRAGMENTS += \
    device/glodroid/platform/common/sunxi/sunxi-common.config \
    device/glodroid/opi_prime/kernel.config \

KERNEL_DTB_FILE := allwinner/sun50i-h5-orangepi-prime.dtb
