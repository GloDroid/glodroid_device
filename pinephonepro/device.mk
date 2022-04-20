# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_system.mk)
#PRODUCT_ENFORCE_ARTIFACT_PATH_REQUIREMENTS := relaxed

#
# All components inherited here go to system_ext image (same as GSI system_ext)
#
$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_system_ext.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/telephony_system_ext.mk)

#
# All components inherited here go to product image (same as GSI product)
#
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_product.mk)

# Exclude features that are not available on AOSP devices.
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/aosp_excluded_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/aosp_excluded_hardware.xml

$(call inherit-product, device/glodroid/common/device-common.mk)
$(call inherit-product, device/glodroid/common/bluetooth/bluetooth.mk)

PRODUCT_PROPERTY_OVERRIDES += qemu.sf.lcd_density=269

# Firmware
PRODUCT_COPY_FILES += \
    kernel/firmware/rockchip/dptx.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rockchip/dptx.bin \
    vendor/megous/firmware/regulatory.db:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/regulatory.db \
    vendor/megous/firmware/regulatory.db.p7s:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/regulatory.db.p7s \
    vendor/megous/firmware/brcm/brcmfmac43455-sdio.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43455-sdio.bin \
    vendor/megous/firmware/brcm/brcmfmac43455-sdio.txt:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43455-sdio.txt \
    vendor/megous/firmware/brcm/brcmfmac43455-sdio.clm_blob:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/brcmfmac43455-sdio.clm_blob \
    vendor/megous/firmware/brcm/BCM4345C0.hcd:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/brcm/BCM4345C0.hcd \

# Checked by android.opengl.cts.OpenGlEsVersionTest#testOpenGlEsVersion. Required to run correct set of dEQP tests.
# 196609 == 0x00030001 == GLES v3.1
PRODUCT_VENDOR_PROPERTIES += \
    ro.opengles.version=196609 \

# Lights HAL
PRODUCT_PACKAGES += \
    android.hardware.lights-service.pinephone \

# Vibrator HAL
PRODUCT_PACKAGES += \
    android.hardware.vibrator-service.pinephone \

# Sensors HAL
PRODUCT_PACKAGES += \
    sensors.iio \
    android.hardware.sensors@1.0-impl:64 \
    android.hardware.sensors@1.0-service \

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.sensors=iio                            \
    ro.iio.accel.mpu6500.name=MPU6500_Accelerometer    \
    ro.iio.accel.quirks=no-trig,no-event               \
    ro.iio.anglvel.mpu6500.name=MPU6500_Gyroscope      \
    ro.iio.anglvel.quirks=no-trig,no-event             \
    ro.iio.magn.af8133j.name=AF8133J_Magnetometer      \
    ro.iio.magn.quirks=no-trig,no-event                \

PRODUCT_COPY_FILES += \
    device/glodroid/pinephone/modem.pinephone.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/modem.pinephonepro.rc \

# Modem packages and configuration
PRODUCT_PACKAGES += \
    libpinephone-ril-2 \
    libpinephone-rild \

PRODUCT_PROPERTY_OVERRIDES += \
    ro.boot.modem_simulator_ports=-1 \
    vendor.rild.libargs=-d/dev/ttyUSB2 \

PRODUCT_COPY_FILES += \
    device/glodroid/pinephonepro/audio.pinephonepro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio.pinephonepro.xml \

# Camera IPAs
PRODUCT_PACKAGES += ipa_rkisp1 ipa_rkisp1.so.sign
