# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, device/glodroid/opi3/device.mk)

PRODUCT_BOARD_PLATFORM ?= H6
PRODUCT_NAME := opi3
PRODUCT_DEVICE := opi3
PRODUCT_BRAND := OrangePI
PRODUCT_MODEL := opi3
PRODUCT_MANUFACTURER := xunlong

UBOOT_DEFCONFIG := orangepi_one_plus_defconfig
ATF_PLAT        := sun50i_h6

KERNEL_DEFCONFIG := device/glodroid/platform/common/sunxi/sunxi64_defconfig
KERNEL_FRAGMENTS := \
    device/glodroid/platform/common/sunxi/sunxi-common.config \

KERNEL_DTB_FILE := allwinner/sun50i-h6-orangepi-3.dtb

SYSFS_MMC0_PATH := soc/4020000.mmc
