# SPDX-License-Identifier: Apache-2.0
#
# GloDroid project (https://github.com/GloDroid)
#
# Copyright (C) 2022 Roman Stratiienko (r.stratiienko@gmail.com)

# OpenGL driver
PRODUCT_PACKAGES += \
    libEGL_mesa \
    libGLESv1_CM_mesa \
    libGLESv2_mesa \
    libgallium_dri \
    libglapi \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/android.hardware.graphics.allocator@4.0-service.minigbm_gd.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.graphics.allocator@4.0-service.minigbm_gd.rc

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.opengles.deqp.level-2021-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml

# Composer passthrough HAL
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.4-impl \
    android.hardware.graphics.composer@2.4-service \

## Composer HAL for gralloc4 + minigbm gralloc4
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@4.0-service.minigbm_gd \
    android.hardware.graphics.mapper@4.0-impl.minigbm_gd \
    libminigbm_gralloc_gd \
    libgbm_mesa_wrapper \
    hwcomposer.drm_gd \

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.hwcomposer=drm_gd \
##

GD_LCD_DENSITY ?= 160
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=$(GD_LCD_DENSITY) \
