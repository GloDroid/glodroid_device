# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, device/glodroid/opi3/device.mk)

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

KERNEL_SRC       := kernel/glodroid-megous
KERNEL_DEFCONFIG := device/glodroid/platform/common/sunxi/sunxi64_defconfig
KERNEL_FRAGMENTS := \
    device/glodroid/platform/common/sunxi/sunxi-common.config \
    $(LOCAL_PATH)/kernel.config \

KERNEL_DTB_FILE := allwinner/sun50i-h6-orangepi-3.dtb

SYSFS_MMC0_PATH := soc/4020000.mmc
SYSFS_MMC1_PATH := soc/4022000.mmc

ANDROID_DTS_OVERLAY := $(LOCAL_PATH)/android.dts
