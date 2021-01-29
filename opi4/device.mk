# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Daniil Petrov (daniil.petrov@globallogic.com)

$(call inherit-product, device/glodroid/common/device-common.mk)
$(call inherit-product, device/glodroid/common/bluetooth/no-bluetooth.mk)

PRODUCT_COPY_FILES += \
	vendor/raspberry/firmware-nonfree/brcm/brcmfmac43456-sdio.clm_blob:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43456-sdio.clm_blob \
	vendor/raspberry/firmware-nonfree/brcm/brcmfmac43456-sdio.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43456-sdio.bin \
	vendor/raspberry/firmware-nonfree/brcm/brcmfmac43456-sdio.txt:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43456-sdio.rockchip,rk3399-orangepi.txt \
