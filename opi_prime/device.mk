# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, device/glodroid/common/device-common.mk)
$(call inherit-product, device/glodroid/common/device-common-sunxi.mk)
$(call inherit-product, device/glodroid/common/bluetooth/no-bluetooth.mk)

# Firmware
PRODUCT_COPY_FILES += \
        kernel/firmware/rtlwifi/rtl8723bs_nic.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtlwifi/rtl8723bs_nic.bin \
        kernel/firmware/rtlwifi/rtl8723bs_wowlan.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtlwifi/rtl8723bs_wowlan.bin \
        kernel/firmware/rtlwifi/rtl8723bs_ap_wowlan.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtlwifi/rtl8723bs_ap_wowlan.bin \

PRODUCT_COPY_FILES += \
    device/glodroid/opi_plus2e/audio.opi_plus2e.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio.opi_prime.xml \
