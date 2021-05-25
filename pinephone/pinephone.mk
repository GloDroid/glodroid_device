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

UBOOT_DEFCONFIG := pinephone_defconfig
ATF_PLAT        := sun50i_a64

CRUST_FIRMWARE_DEFCONFIG := pinephone_defconfig

KERNEL_SRC       := kernel/glodroid-megous
KERNEL_DEFCONFIG := $(KERNEL_SRC)/arch/arm64/configs/pinephone_defconfig
KERNEL_FRAGMENTS := \
    device/glodroid/platform/common/sunxi/a64_overlay.config \

KERNEL_DTB_FILE_PP11 := allwinner/sun50i-a64-pinephone-1.1.dtb
KERNEL_DTB_FILE_PP12 := allwinner/sun50i-a64-pinephone-1.2.dtb
