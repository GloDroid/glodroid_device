# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, device/glodroid/common/device-common.mk)
$(call inherit-product, device/glodroid/common/device-common-sunxi.mk)
$(call inherit-product, device/glodroid/common/bluetooth/no-bluetooth.mk)

PRODUCT_CHARACTERISTICS := tablet
PRODUCT_PROPERTY_OVERRIDES += qemu.sf.lcd_density=151

# Firmware
PRODUCT_COPY_FILES += \
    kernel/firmware/rtlbt/rtl8723cs_xx_fw:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8723cs_xx_fw.bin \
    kernel/firmware/rtlbt/rtl8723cs_xx_config:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8723cs_xx_config-pinetab.bin \

PRODUCT_COPY_FILES += \
    device/glodroid/pinetab/audio.pinetab.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio.pinetab.xml \

PRODUCT_PACKAGES += \
    glodroid_pinetab_overlay_frameworks_base_core \

# Checked by android.opengl.cts.OpenGlEsVersionTest#testOpenGlEsVersion. Required to run correct set of dEQP tests.
# 131072 == 0x00020000 == GLES v2.0
PRODUCT_VENDOR_PROPERTIES += \
    ro.opengles.version=131072

# Disable suspend. Crust or device has some issues and get stuck at clock setup.
# ISSUE: https://gitlab.com/pine64-org/linux/-/issues/35
PRODUCT_COPY_FILES += \
    device/glodroid/common/no_suspend.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/no_suspend.pinetab.rc \
    device/glodroid/common/no_animation.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/no_animation.pinetab.rc \
