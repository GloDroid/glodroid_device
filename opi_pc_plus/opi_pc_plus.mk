# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2021 GloDroid project

$(call inherit-product, device/glodroid/opi_pc_plus/device.mk)

PRODUCT_BOARD_PLATFORM := sunxi
PRODUCT_NAME := opi_pc_plus
PRODUCT_DEVICE := opi_pc_plus
PRODUCT_BRAND := OrangePI
PRODUCT_MODEL := opi_pc_plus
PRODUCT_MANUFACTURER := xunlong
PRODUCT_HAS_EMMC := true

UBOOT_DEFCONFIG := orangepi_pc_plus_defconfig
KERNEL_SRC       := kernel/glodroid-stable
KERNEL_DEFCONFIG := $(KERNEL_SRC)/arch/arm/configs/sunxi_defconfig
KERNEL_FRAGMENTS += \
    device/glodroid/platform/common/sunxi/sunxi-common.config \

KERNEL_DTB_FILE := sun8i-h3-orangepi-pc-plus.dtb
