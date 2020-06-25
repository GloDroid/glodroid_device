# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, device/glodroid/opi_pc2/device.mk)

PRODUCT_BOARD_PLATFORM := sunxi
PRODUCT_NAME := opi_pc2
PRODUCT_DEVICE := opi_pc2
PRODUCT_BRAND := OrangePI
PRODUCT_MODEL := opi_pc2
PRODUCT_MANUFACTURER := xunlong

UBOOT_DEFCONFIG := orangepi_pc2_defconfig

# ATF is not used
ATF_PLAT        := sun50i_a64

KERNEL_DEFCONFIG := device/glodroid/platform/common/sunxi/sunxi64_defconfig
KERNEL_FRAGMENTS += \
    device/glodroid/platform/common/sunxi/sunxi-common.config \

KERNEL_DTB_FILE := allwinner/sun50i-h5-orangepi-pc2.dtb
