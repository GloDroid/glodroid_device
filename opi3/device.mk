# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, device/glodroid/common/device-common.mk)
$(call inherit-product, device/glodroid/common/device-common-sunxi.mk)
$(call inherit-product, device/glodroid/common/bluetooth/bluetooth.mk)

# Firmware
PRODUCT_COPY_FILES += \
        kernel/firmware/brcm/BCM4345C5.hcd:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/BCM4345C5.hcd \
        kernel/firmware/brcm/brcmfmac43456-sdio.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43456-sdio.bin \
        kernel/firmware/brcm/brcmfmac43456-sdio.txt:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43456-sdio.txt \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/bluetooth.opi3.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/bluetooth.opi3.rc \

PRODUCT_COPY_FILES += \
    device/glodroid/opi3/audio.opi3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio.opi3.xml \

# Checked by android.opengl.cts.OpenGlEsVersionTest#testOpenGlEsVersion. Required to run correct set of dEQP tests.
# 196609 == 0x00030001 == GLES v3.1
PRODUCT_VENDOR_PROPERTIES += \
    ro.opengles.version=196609
