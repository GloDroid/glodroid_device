# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)
PLATFORM_PATH := $(call my-dir)

AOSP_TOP_ABS := $(realpath .)

ifeq ($(TARGET_ARCH),arm)
TRIPLE=arm-linux-gnueabihf
CROSS_COMPILE := prebuilts/gcc/linux-x86/arm/gcc-linaro-$(TRIPLE)/bin/$(TRIPLE)-
else
TRIPLE=aarch64-linux-gnu
CROSS_COMPILE := prebuilts/gcc/linux-x86/aarch64/gcc-linaro-$(TRIPLE)/bin/$(TRIPLE)-
# Common for ATF and u-boot
ATF_OUT		:= $(PRODUCT_OUT)/obj/ATF_OBJ

ifeq ($(PRODUCT_BOARD_PLATFORM),rockchip)
ATF_BINARY  := $(ATF_OUT)/$(ATF_PLAT)/debug/bl31/bl31.elf
else
ATF_BINARY	:= $(ATF_OUT)/$(ATF_PLAT)/debug/bl31.bin
endif

endif
CLANG_ABS := $(AOSP_TOP_ABS)/$(CLANG)

MAKE_COMMON := \
    PATH=/usr/bin:/bin:/sbin:$$PATH \
    ARCH=$(TARGET_ARCH) \
    CROSS_COMPILE=$(AOSP_TOP_ABS)/$(CROSS_COMPILE) \
    $(MAKE)

include $(PLATFORM_PATH)/kernel/kernel.mk
include $(PLATFORM_PATH)/uboot/uboot.mk
include $(PLATFORM_PATH)/tools/tools.mk
include $(PLATFORM_PATH)/atf.mk
