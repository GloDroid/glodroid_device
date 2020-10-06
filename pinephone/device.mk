# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, device/glodroid/common/device-common.mk)
$(call inherit-product, device/glodroid/common/device-common-sunxi.mk)
$(call inherit-product, device/glodroid/common/bluetooth/bluetooth.mk)

PRODUCT_PROPERTY_OVERRIDES += qemu.sf.lcd_density=269

# Firmware
PRODUCT_COPY_FILES += \
    kernel/firmware/rtlbt/rtl8723cs_xx_fw:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8723cs_xx_fw.bin \
    kernel/firmware/rtlbt/rtl8723cs_xx_config:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8723cs_xx_config-pinephone.bin \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/wifi.pinephone.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/wifi.pinephone.rc \
    $(LOCAL_PATH)/sensors.pinephone.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/sensors.pinephone.rc \

PRODUCT_COPY_FILES += \
    device/glodroid/pinephone/audio.pinephone.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio.pinephone.xml \

# Lights HAL
PRODUCT_PACKAGES += \
    android.hardware.lights-service.pinephone \

# Vibrator HAL
PRODUCT_PACKAGES += \
    android.hardware.vibrator-service.pinephone \

PRODUCT_PACKAGES += \
    sensors.iio \
    android.hardware.sensors@1.0-impl:64 \
    android.hardware.sensors@1.0-service

DEVICE_PACKAGE_OVERLAYS += \
    device/glodroid/pinephone/overlay

# SUNXI has broken drm/sun4i DE2 kernel driver.
# Disable scaling to avoid UI glitches.
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.hwc.drm.scale_with_gpu=1 \
