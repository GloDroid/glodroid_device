# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, device/glodroid/common/device-common.mk)
$(call inherit-product, device/glodroid/common/device-common-sunxi.mk)
$(call inherit-product, device/glodroid/common/bluetooth/no-bluetooth.mk)

PRODUCT_CHARACTERISTICS := tablet
PRODUCT_PROPERTY_OVERRIDES += ro.sf.lcd_density=151

# Firmware
PRODUCT_COPY_FILES += \
    kernel/firmware/rtlbt/rtl8723cs_xx_fw:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8723cs_xx_fw.bin \
    kernel/firmware/rtlbt/rtl8723cs_xx_config:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8723cs_xx_config-pinetab.bin \

DEVICE_PACKAGE_OVERLAYS += \
    device/glodroid/pinetab/overlay
