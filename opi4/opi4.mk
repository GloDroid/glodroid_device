# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Daniil Petrov (daniil.petrov@globallogic.com)

$(call inherit-product, glodroid/configuration/opi4/device.mk)

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

BOARD_MESA3D_GALLIUM_DRIVERS := panfrost
ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
BOARD_KERNEL_CMDLINE += earlyprintk console=ttyS2,1500000n8
endif

PRODUCT_BOARD_PLATFORM := rockchip
PRODUCT_NAME := opi4
PRODUCT_DEVICE := opi4
PRODUCT_BRAND := OrangePI
PRODUCT_MODEL := opi4
PRODUCT_MANUFACTURER := xunlong
PRODUCT_HAS_EMMC := true

UBOOT_DEFCONFIG := orangepi-rk3399_defconfig
ATF_PLAT        := rk3399

# Variable for uboot: https://github.com/armbian/build/blob/19a963189510a541a0486933eb8eaa1d7bc7f695/config/sources/families/rk3399.conf#L36
DDR_BLOB := rk33/rk3399_ddr_933MHz_v1.25.bin
MINILOADER_BLOB := rk33/rk3399_miniloader_v1.26.bin
RKTRUST_INI := RK3399TRUST.ini
RK33_BIN := bin/rk33

KERNEL_DEFCONFIG := $(LOCAL_PATH)/rockchip_defconfig
KERNEL_FRAGMENTS := $(LOCAL_PATH)/kernel.config

KERNEL_DTB_FILE := rockchip/rk3399-orangepi.dtb
