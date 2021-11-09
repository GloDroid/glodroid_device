# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, device/glodroid/rpi4/device.mk)

PRODUCT_BOARD_PLATFORM := broadcom
PRODUCT_NAME := rpi4
PRODUCT_DEVICE := rpi4
PRODUCT_BRAND := RaspberryPI
PRODUCT_MODEL := rpi4
PRODUCT_MANUFACTURER := RaspberryPiFoundation

UBOOT_DEFCONFIG := rpi_4_defconfig
ATF_PLAT        := rpi4

KERNEL_DEFCONFIG := kernel/glodroid-broadcom/arch/arm64/configs/bcm2711_defconfig

KERNEL_FRAGMENTS := \
    $(LOCAL_PATH)/kernel.config \

KERNEL_DTB_FILE := broadcom/bcm2711-rpi-4-b.dtb

SYSFS_MMC0_PATH := emmc2bus/fe340000.mmc

RPI_CONFIG := $(LOCAL_PATH)/config.txt