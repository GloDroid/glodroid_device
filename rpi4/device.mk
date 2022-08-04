# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_system.mk)
#PRODUCT_ENFORCE_ARTIFACT_PATH_REQUIREMENTS := relaxed

#
# All components inherited here go to system_ext image (same as GSI system_ext)
#
#$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_system_ext.mk)
#$(call inherit-product, $(SRC_TARGET_DIR)/product/telephony_system_ext.mk)

#
# All components inherited here go to product image (same as GSI product)
#
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_product.mk)

# Exclude features that are not available on AOSP devices.
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/aosp_excluded_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/aosp_excluded_hardware.xml

$(call inherit-product, device/glodroid/common/device-common.mk)
$(call inherit-product, device/glodroid/common/bluetooth/bluetooth.mk)

# Firmware
PRODUCT_COPY_FILES += \
        vendor/raspberry/firmware-nonfree/brcm/brcmfmac43455-sdio.clm_blob:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43455-sdio.clm_blob \
        vendor/raspberry/firmware-nonfree/brcm/brcmfmac43455-sdio.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43455-sdio.bin \
        vendor/raspberry/firmware-nonfree/brcm/brcmfmac43455-sdio.txt:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43455-sdio.txt \
        vendor/raspberry/firmware-nonfree/brcm/brcmfmac43456-sdio.clm_blob:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43456-sdio.clm_blob \
        vendor/raspberry/firmware-nonfree/brcm/brcmfmac43456-sdio.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43456-sdio.bin \
        vendor/raspberry/firmware-nonfree/brcm/brcmfmac43456-sdio.txt:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43456-sdio.txt \
        device/glodroid/rpi4/BCM4345C0.hcd:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/BCM4345C0.hcd \
        device/glodroid/rpi4/BCM4345C5.hcd:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/BCM4345C5.hcd \

PRODUCT_COPY_FILES += \
    device/glodroid/rpi4/audio.rpi4.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio.rpi4.xml \

# Disable suspend. During running some VTS device suspends, which sometimed causes kernel to crash in WIFI driver and reboot.
PRODUCT_COPY_FILES += \
    device/glodroid/common/no_suspend.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/no_suspend.rpi4.rc \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/power.rpi4.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/power.rpi4.rc \
    $(LOCAL_PATH)/snd.rpi4.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/snd.rpi4.rc     \

# Checked by android.opengl.cts.OpenGlEsVersionTest#testOpenGlEsVersion. Required to run correct set of dEQP tests.
# 196609 == 0x00030001 == GLES v3.1
PRODUCT_VENDOR_PROPERTIES += \
    ro.opengles.version=196609

# Camera
PRODUCT_PACKAGES += ipa_rpi ipa_rpi.so.sign

LIBCAMERA_CFGS := \
    imx219.json imx219_noir.json imx290.json imx378.json imx477.json imx477_noir.json \
    meson.build ov5647.json ov5647_noir.json ov9281.json se327m12.json uncalibrated.json

PRODUCT_COPY_FILES += $(foreach cfg,$(LIBCAMERA_CFGS),external/libcamera/src/ipa/raspberrypi/data/$(cfg):$(TARGET_COPY_OUT_VENDOR)/etc/libcamera/ipa/raspberrypi/$(cfg)$(space))

# Vulkan
PRODUCT_PACKAGES += \
    vulkan.broadcom

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vulkan.level-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_0_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2022-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml \

PRODUCT_VENDOR_PROPERTIES +=    \
    ro.hardware.vulkan=broadcom \

# It is the only way to set ro.hwui.use_vulkan=true
#TARGET_USES_VULKAN = true
