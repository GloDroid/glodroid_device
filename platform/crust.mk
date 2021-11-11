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

SCP_MAKE := PATH=/usr/bin:/usr/sbin:/bin:/sbin $(OR1K_COMPILE) $(MAKE) -C $(CRUST_FIRMWARE_OUT)

CRUST_FIRMWARE_SRC_FILES := $(sort $(shell find -L $(CRUST_FIRMWARE_SRC) -not -path '*/\.git/*'))

$(CRUST_FIRMWARE_BINARY): $(CRUST_FIRMWARE_SRC_FILES)
	rm -rf $(CRUST_FIRMWARE_OUT)
	mkdir -p $(CRUST_FIRMWARE_OUT)
	cp -r $(CRUST_FIRMWARE_SRC)/* $(CRUST_FIRMWARE_OUT)
	$(SCP_MAKE) $(CRUST_FIRMWARE_DEFCONFIG)
	$(SCP_MAKE) scp
