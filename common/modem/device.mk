# SPDX-License-Identifier: Apache-2.0
#
# GloDroid project (https://github.com/GloDroid)
#
# Copyright (C) 2022 Roman Stratiienko (r.stratiienko@gmail.com)

#
# All components inherited here go to system_ext image (same as GSI system_ext)
#
$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_system_ext.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base_telephony.mk)

# dbus-1
PRODUCT_PACKAGES += \
    dbus-cleanup-sockets dbus-daemon dbus-daemon-launch-helper dbus-launch dbus-monitor dbus-run-session dbus-send dbus-test-tool dbus-update-activation-environment dbus-uuidgen \
    libdbus-1 system.conf dbus-daemon \

# glib-2.0
PRODUCT_PACKAGES += \
    libintl libglib-2.0 libgthread-2.0 libgmodule-2.0 libgobject-2.0 libgio-2.0 \

# libqmi
PRODUCT_PACKAGES += \
    qmicli qmi-firmware-update qmi-network qmi-proxy \
    libqmi-glib \

# ModemManager
PRODUCT_PACKAGES += \
    ModemManager mmcli libmm-glib org.freedesktop.ModemManager1.conf

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/modem_manager.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/modem_manager.rc \

# Radio HAL
PRODUCT_PACKAGES += \
    android.hardware.mm-radio-service \
    android.hardware.mmradio.rc \
    android.hardware.mmradio.xml \

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.xml \
