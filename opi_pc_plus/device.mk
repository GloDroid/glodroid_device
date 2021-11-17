# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2021 GloDroid project

$(call inherit-product, device/glodroid/common/lowram/device-common-1gb.mk)
$(call inherit-product, device/glodroid/common/device-common-sunxi.mk)
$(call inherit-product, device/glodroid/common/bluetooth/no-bluetooth.mk)

# Out-of-tree modules
PRODUCT_PACKAGES += \
    8189fs.ko \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio.opi_pc_plus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio.opi_pc_plus.xml \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/wifi.opi_pc_plus.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/wifi.opi_pc_plus.rc \

# Checked by android.opengl.cts.OpenGlEsVersionTest#testOpenGlEsVersion. Required to run correct set of dEQP tests.
# 131072 == 0x00020000 == GLES v2.0
PRODUCT_VENDOR_PROPERTIES += \
    ro.opengles.version=131072
