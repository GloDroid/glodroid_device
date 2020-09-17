# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base_telephony.mk)
$(call inherit-product, device/glodroid/common/device-common.mk)
$(call inherit-product, device/glodroid/common/device-common-sunxi.mk)
$(call inherit-product, device/glodroid/common/bluetooth/bluetooth.mk)

PRODUCT_PROPERTY_OVERRIDES += qemu.sf.lcd_density=269

# Phone
IS_PHONE := true
PRODUCT_PROPERTY_OVERRIDES += \
        qemu.sf.lcd_density=269 \
        hw.nophone=no \
        ro.boot.noril=no \
        ro.radio.noril=no \
        ro.telephony.default_network=10 \
        keyguard.no_require_sim=true \
        ril.function.dataonly=0 \
        persist.telephony.support.ipv6=1 \
        persists.telephony.support.ipv4=1 \
        telephony.lteOnGsmDevice=1 \
        telephony.lteOnCdmaDevice=0 \
        ro.telephony.call_ring.delay=0 \
        ro.ril.enable.amr.wideband=1 \
        ring.delay=0 \
        ro.config.vc_call_steps=20 \
        persist.cust.tel.eons=1 \
        ro.config.hw_fast_dormancy=1 \
        ro.radio.networkmode=enable \
        persist.audio.fluence.voicecall=false \
        ro.com.android.dataroaming=false
        ro.telephony.get_imsi_from_sim=true \
        ro.telephony.ril.config=simactivation

# Firmware
PRODUCT_COPY_FILES += \
    kernel/firmware/rtlbt/rtl8723cs_xx_fw:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8723cs_xx_fw.bin \
    kernel/firmware/rtlbt/rtl8723cs_xx_config:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8723cs_xx_config-pinephone.bin \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/wifi.pinephone.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/wifi.pinephone.rc \
    $(LOCAL_PATH)/lights.pinephone.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/lights.pinephone.rc \
    $(LOCAL_PATH)/vibrator.pinephone.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/vibrator.pinephone.rc \
    $(LOCAL_PATH)/sensors.pinephone.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/sensors.pinephone.rc \

# RIL
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/ril/chat:$(TARGET_COPY_OUT_SYSTEM)/bin/chat \
    $(LOCAL_PATH)/ril/ip-down:$(TARGET_COPY_OUT_SYSTEM)/etc/ppp/ip-down \
    $(LOCAL_PATH)/ril/ip-up:$(TARGET_COPY_OUT_SYSTEM)/etc/ppp/ip-up \
    $(LOCAL_PATH)/ril/libquectel-ril.so:$(TARGET_COPY_OUT_VENDOR)/lib64/libquectel-ril.so \
    $(LOCAL_PATH)/ril/ql-ril.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/ql-ril.conf \
    $(LOCAL_PATH)/ril/QAndroidLog:$(TARGET_COPY_OUT_SYSTEM)/bin/QAndroidLog \
    $(LOCAL_PATH)/ril/QFirehose:$(TARGET_COPY_OUT_SYSTEM)/bin/QFirehose \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    device/sample/etc/apns-full-conf.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/apns-conf.xml \

#GPS
PRODUCT_PACKAGES += \
        android.hardware.gnss@1.0-impl \
        android.hardware.gnss@1.0-service

PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/gps/gps.default.so:$(TARGET_COPY_OUT_VENDOR)/lib64/hw/gps.default.so \
        $(LOCAL_PATH)/gps/libstdc++.so:$(TARGET_COPY_OUT_VENDOR)/lib64/libstdc++.so \
        $(LOCAL_PATH)/gps/gps_cfg.inf:$(TARGET_COPY_OUT_SYSTEM)/etc/gps_cfg.inf \
        $(LOCAL_PATH)/gps/gps.cfg:$(TARGET_COPY_OUT_SYSTEM)etc/gps.cfg \
        frameworks/native/data/etc/android.hardware.location.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.xml \
        frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml

PRODUCT_PROPERTY_OVERRIDES += \
    ro.kernel.android.gps=ttyUSB1 \
    ro.kernel.android.gps.speed=115200 \
    ro.kernel.android.gps.max_rate=1

PRODUCT_COPY_FILES += \
    device/glodroid/pinephone/audio.pinephone.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio.pinephone.xml \

PRODUCT_PACKAGES += \
    lights.pinephone \
    android.hardware.light@2.0-impl:64 \
    android.hardware.light@2.0-service

PRODUCT_PACKAGES += \
    gpstest

PRODUCT_PACKAGES += \
    sensors.iio \
    android.hardware.sensors@1.0-impl:64 \
    android.hardware.sensors@1.0-service

PRODUCT_PACKAGES += \
    android.hardware.vibrator@1.0-service.pinephone

DEVICE_PACKAGE_OVERLAYS += \
    device/glodroid/pinephone/overlay

# SUNXI has broken drm/sun4i DE2 kernel driver.
# Disable scaling to avoid UI glitches.
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.hwc.drm.scale_with_gpu=1 \
