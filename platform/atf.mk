# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)
#
# Makefile for ARM trusted firmware (ATF)

ifeq ($(TARGET_ARCH),arm64)

#-------------------------------------------------------------------------------
LOCAL_PATH := $(call my-dir)

#-------------------------------------------------------------------------------
ATF_SRC		?= external/arm-trusted-firmware

#-------------------------------------------------------------------------------
M0_TRIPLE := arm-eabi
M0_COMPILE := M0_CROSS_COMPILE=$$(readlink -f prebuilts/gcc/linux-x86/arm/gcc-linaro-$(M0_TRIPLE)/bin/$(M0_TRIPLE)-)

$(ATF_BINARY): $(sort $(shell find -L $(ATF_SRC)))
	$(M0_COMPILE) $(MAKE_COMMON) -C $(ATF_SRC) BUILD_BASE=$$(readlink -f $(ATF_OUT)) PLAT=$(ATF_PLAT) DEBUG=1 bl31

endif
