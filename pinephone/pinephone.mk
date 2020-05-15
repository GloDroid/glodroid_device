# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, device/glodroid/pinephone/device.mk)

PRODUCT_BOARD_PLATFORM := sunxi
PRODUCT_NAME := pinephone
PRODUCT_DEVICE := pinephone
PRODUCT_BRAND := Pine64
PRODUCT_MODEL := PinePhone
PRODUCT_MANUFACTURER := Pine64
PRODUCT_HAS_EMMC := true

UBOOT_DEFCONFIG := sopine_baseboard_defconfig
ATF_PLAT        := sun50i_a64

KERNEL_DEFCONFIG := device/glodroid/platform/common/sunxi/sunxi64_defconfig
KERNEL_FRAGMENTS := \
    device/glodroid/platform/common/sunxi/sunxi-common.config \
    device/glodroid/pinephone/kernel.config \

KERNEL_DTB_FILE := allwinner/sun50i-a64-pinephone.dtb

ANDROID_DTS_OVERLAY := $(LOCAL_PATH)/android.dts
