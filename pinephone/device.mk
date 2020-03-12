# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, device/glodroid/common/device-common.mk)

PRODUCT_PROPERTY_OVERRIDES += qemu.sf.lcd_density=269

# Out-of-tree modules
PRODUCT_PACKAGES += \
    8723cs.ko

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/drm.pinephone.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/drm.pinephone.rc \
    $(LOCAL_PATH)/wifi.pinephone.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/wifi.pinephone.rc \
    $(LOCAL_PATH)/lights.pinephone.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/lights.pinephone.rc \

# tools
PRODUCT_COPY_FILES += \
    device/glodroid/platform/tools/gensdimg.sh:$(TARGET_COPY_OUT)/gensdimg.sh

PRODUCT_PACKAGES += \
    lights.pinephone \
    android.hardware.light@2.0-impl:64 \
    android.hardware.light@2.0-service
