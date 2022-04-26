# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

LOCAL_PATH := $(call my-dir)

FSTAB_RAW := $(LOCAL_PATH)/fstab.cpp
RECOVERY_FSTAB := $(TARGET_VENDOR_RAMDISK_OUT)/first_stage_ramdisk/fstab.$(TARGET_PRODUCT)
VENDOR_FSTAB := $(TARGET_OUT_VENDOR)/etc/fstab.$(TARGET_PRODUCT)

TARGET_RECOVERY_FSTAB := $(RECOVERY_FSTAB)

$(VENDOR_FSTAB) $(RECOVERY_FSTAB): $(FSTAB_RAW)
	$(CLANG) -E -P -Wno-invalid-pp-token $< -o $@ \
	    -Dplatform_$(PRODUCT_BOARD_PLATFORM) \
	    -Ddevice_$(PRODUCT_DEVICE)
	sed -i 's/<ALL>/*/g' $@


include $(CLEAR_VARS)

# ---------------------------------------------------------------------------

LOCAL_MODULE := fstab

LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)/etc/
LOCAL_PREBUILT_MODULE_FILE := $(VENDOR_FSTAB) $(RECOVERY_FSTAB)

include $(BUILD_EXECUTABLE)
