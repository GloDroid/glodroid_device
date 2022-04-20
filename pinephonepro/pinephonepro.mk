# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, device/glodroid/pinephonepro/device.mk)

PRODUCT_BOARD_PLATFORM := rockchip
PRODUCT_NAME := pinephonepro
PRODUCT_DEVICE := pinephonepro
PRODUCT_BRAND := Pine64
PRODUCT_MODEL := PinePhonePro
PRODUCT_MANUFACTURER := Pine64
PRODUCT_HAS_EMMC := true

# EMMC
SYSFS_MMC0_PATH ?= fe330000.mmc
# SDCARD
SYSFS_MMC1_PATH ?= fe320000.mmc

UBOOT_DEFCONFIG := pinephone-pro-rk3399_defconfig
ATF_PLAT        := rk3399

DDR_BLOB := rk33/rk3399_ddr_933MHz_v1.25.bin
MINILOADER_BLOB := rk33/rk3399_miniloader_v1.26.bin
RKTRUST_INI := RK3399TRUST.ini
RK33_BIN := bin/rk33

KERNEL_FRAGMENTS := $(LOCAL_PATH)/kernel.config

KERNEL_SRC       := kernel/glodroid-megous-edge
KERNEL_DEFCONFIG := $(KERNEL_SRC)/arch/arm64/configs/pinephone_pro_defconfig

KERNEL_DTB_FILE := rockchip/rk3399-pinephone-pro.dtb
