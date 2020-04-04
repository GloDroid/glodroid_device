# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, device/glodroid/common/lowram/device-common-1gb.mk)
$(call inherit-product, device/glodroid/common/bluetooth/bluetooth.mk)

# tools
PRODUCT_COPY_FILES += \
    device/glodroid/platform/tools/gensdimg.sh:$(TARGET_COPY_OUT)/gensdimg.sh

# Firmware
PRODUCT_COPY_FILES += \
        kernel/firmware/brcm/BCM4345C5.hcd:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/BCM4345C5.hcd \
        kernel/firmware/brcm/brcmfmac43456-sdio.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43456-sdio.bin \
        kernel/firmware/brcm/brcmfmac43456-sdio.txt:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43456-sdio.xunlong,orangepi-3.txt \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/bluetooth.opi3.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/bluetooth.opi3.rc \
