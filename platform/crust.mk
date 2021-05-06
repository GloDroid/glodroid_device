# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)
#
# Makefile for ARM trusted firmware (ATF)

#-------------------------------------------------------------------------------
LOCAL_PATH := $(call my-dir)

CRUST_FIRMWARE_SRC    ?= external/crust-firmware/crust
OR1K_TOOLCHAIN_PREFIX := prebuilts/gcc/linux-x86/or1k/gcc-linux-or1k/bin/or1k-linux-
OR1K_COMPILE          := CROSS_COMPILE=$(AOSP_TOP_ABS)/$(OR1K_TOOLCHAIN_PREFIX)

SCP_MAKE := PATH=/usr/bin:/bin:/sbin:$$PATH $(OR1K_COMPILE) $(MAKE) -C $(CRUST_FIRMWARE_SRC) OBJ=$(AOSP_TOP_ABS)/$(CRUST_FIRMWARE_OUT)

$(CRUST_FIRMWARE_BINARY): $(sort $(shell find -L $(CRUST_FIRMWARE_SRC)))
	$(SCP_MAKE) $(CRUST_FIRMWARE_DEFCONFIG)
	$(SCP_MAKE) scp
