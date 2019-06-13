#
# Copyright (C) 2011 The Android Open-Source Project
# Copyright (C) 2018 GlobalLogic
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#-------------------------------------------------------------------------------
LOCAL_PATH := $(call my-dir)
UBOOT_CROSS_COMPILE := prebuilts/gcc/linux-x86/arm/gcc-linaro_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-

UBOOT_CLEAN_BUILD ?=

ifeq ($(UBOOT_CROSS_COMPILE),)
$(error UBOOT_CROSS_COMPILE is not set)
endif

UBOOT_SRC_PATH := $(LOCAL_PATH)
UBOOT_OUT_PATH := $(PRODUCT_OUT)/obj/UBOOT_OBJ

UBOOT_KCFLAGS = \
    -fgnu89-inline \
    $(TARGET_BOOTLOADER_CFLAGS)

UBOOT_DEFCONFIG := $(TARGET_PRODUCT)_defconfig

#-------------------------------------------------------------------------------
$(UBOOT_OUT):
	$(hide) mkdir -p $(UBOOT_OUT_PATH)

uboot: $(UBOOT_OUT)
	@echo "Building U-Boot"
	@echo "TARGET_PRODUCT = " $(TARGET_PRODUCT)
	$(hide) CROSS_COMPILE=$$(readlink -f $(UBOOT_CROSS_COMPILE)) ARCH=$(TARGET_ARCH) make -C $(UBOOT_SRC_PATH) O=$$(readlink -f $(UBOOT_OUT_PATH)) $(UBOOT_DEFCONFIG)
	$(hide) CROSS_COMPILE=$$(readlink -f $(UBOOT_CROSS_COMPILE)) ARCH=$(TARGET_ARCH) make -C $(UBOOT_SRC_PATH) O=$$(readlink -f $(UBOOT_OUT_PATH)) KCFLAGS="$(UBOOT_KCFLAGS)"

clean-uboot: $(UBOOT_OUT)
	@echo "Cleaning U-Boot"
	$(hide) CROSS_COMPILE=$$(readlink -f $(UBOOT_CROSS_COMPILE)) ARCH=$(TARGET_ARCH) make -C $(UBOOT_SRC_PATH) O=$$(readlink -f $(UBOOT_OUT_PATH)) mrproper

.PHONY: uboot clean-uboot

ifneq (,$(UBOOT_CLEAN_BUILD))
uboot: clean-uboot
endif

#-------------------------------------------------------------------------------
include $(CLEAR_VARS)

LOCAL_MODULE := u-boot.bin

LOCAL_MODULE_PATH := $(PRODUCT_OUT)
LOCAL_PREBUILT_MODULE_FILE:= $(UBOOT_OUT_PATH)/$(LOCAL_MODULE)
$(LOCAL_PREBUILT_MODULE_FILE): uboot

include $(BUILD_EXECUTABLE)

#-------------------------------------------------------------------------------
include $(CLEAR_VARS)

LOCAL_MODULE := u-boot-sunxi-with-spl.bin

LOCAL_MODULE_PATH := $(PRODUCT_OUT)
LOCAL_PREBUILT_MODULE_FILE:= $(UBOOT_OUT_PATH)/$(LOCAL_MODULE)
$(LOCAL_PREBUILT_MODULE_FILE): uboot

include $(BUILD_EXECUTABLE)

#-------------------------------------------------------------------------------