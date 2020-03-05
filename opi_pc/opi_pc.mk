# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, device/glodroid/opi_pc/device.mk)

PRODUCT_BOARD_PLATFORM ?= H3_Quad-core_Cortex-A7
PRODUCT_NAME := opi_pc
PRODUCT_DEVICE := opi_pc
PRODUCT_BRAND := OrangePI
PRODUCT_MODEL := opi_pc
PRODUCT_MANUFACTURER := xunlong

UBOOT_DEFCONFIG := orangepi_pc_defconfig
KERNEL_DEFCONFIG := sunxi_defconfig
KERNEL_FRAGMENTS := \
    device/glodroid/platform/kernel/android-sunxi.config \
    device/glodroid/platform/kernel/android-recommended-arm.config \

KERNEL_DTB_FILE := sun8i-h3-orangepi-pc.dts
