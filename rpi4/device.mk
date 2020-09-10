# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, device/glodroid/common/device-common.mk)
$(call inherit-product, device/glodroid/common/bluetooth/no-bluetooth.mk)

# Firmware
PRODUCT_COPY_FILES += \
        vendor/raspberry/firmware-nonfree/brcm/brcmfmac43455-sdio.clm_blob:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43455-sdio.clm_blob \
        vendor/raspberry/firmware-nonfree/brcm/brcmfmac43455-sdio.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43455-sdio.bin \
        vendor/raspberry/firmware-nonfree/brcm/brcmfmac43455-sdio.txt:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43455-sdio.raspberrypi,4-model-b.txt \

PRODUCT_COPY_FILES += \
    device/glodroid/rpi4/audio.rpi4.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio.rpi4.xml \
    device/glodroid/rpi4/snd-dummy.rpi4.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/snd-dummy.rpi4.rc \
