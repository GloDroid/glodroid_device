# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Daniil Petrov (daniil.petrov@globallogic.com)

$(call inherit-product, glodroid/configuration/common/device-common.mk)

PRODUCT_COPY_FILES += \
    glodroid/kernel-firmware/rpi/brcm/brcmfmac43456-sdio.clm_blob:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43456-sdio.clm_blob \
    glodroid/kernel-firmware/rpi/brcm/brcmfmac43456-sdio.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43456-sdio.bin \
    glodroid/kernel-firmware/rpi/brcm/brcmfmac43456-sdio.txt:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43456-sdio.txt \

# 196609 == 0x00030001 == GLES v3.1
PRODUCT_VENDOR_PROPERTIES += \
    ro.opengles.version=196609
