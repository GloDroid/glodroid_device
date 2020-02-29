# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)
PLATFORM_PATH := $(call my-dir)

ifeq ($(TARGET_ARCH),arm)
TRIPLE=arm-linux-gnueabihf
CROSS_COMPILE := prebuilts/gcc/linux-x86/arm/gcc-linaro_$(TRIPLE)/bin/$(TRIPLE)-
else
TRIPLE=aarch64-linux-gnu
CROSS_COMPILE := prebuilts/gcc/linux-x86/aarch64/gcc-linaro-$(TRIPLE)/bin/$(TRIPLE)-
endif

CLANG_ABS := $$(readlink -f $(CLANG))

MAKE_COMMON := \
    PATH=/usr/bin:/bin:$$PATH \
    ARCH=$(TARGET_ARCH) \
    CROSS_COMPILE=$$(readlink -f $(CROSS_COMPILE)) \
    $(MAKE) CC=$(CLANG_ABS) HOSTCC=$(CLANG_ABS) \

include $(PLATFORM_PATH)/kernel/kernel.mk
include $(PLATFORM_PATH)/uboot/uboot.mk
include $(PLATFORM_PATH)/tools/tools.mk
