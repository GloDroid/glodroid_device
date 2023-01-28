# SPDX-License-Identifier: Apache-2.0
#
# GloDroid project (https://github.com/GloDroid)
#
# Copyright (C) 2022 Roman Stratiienko (r.stratiienko@gmail.com)

# AOSPEXT configuration
BOARD_BUILD_AOSPEXT_MESA3D := true
BOARD_MESA3D_SRC_DIR := glodroid/vendor/mesa3d
BOARD_MESA3D_GALLIUM_DRIVERS := lima
BOARD_MESA3D_BUILD_LIBGBM := true

BOARD_BUILD_AOSPEXT_DRMHWCOMPOSER := true
BOARD_DRMHWCOMPOSER_SRC_DIR := glodroid/vendor/drm_hwcomposer
BOARD_DRMHWCOMPOSER_PATCHES_DIRS += glodroid/configuration/patches/vendor/drm_hwcomposer

BOARD_BUILD_AOSPEXT_MINIGBM := true
BOARD_MINIGBM_SRC_DIR := glodroid/vendor/minigbm
BOARD_MINIGBM_PATCHES_DIRS += glodroid/configuration/patches/vendor/minigbm

DEVICE_MANIFEST_FILE += \
    glodroid/configuration/common/graphics/android.hardware.graphics.allocator@4.0.xml \
    glodroid/configuration/common/graphics/android.hardware.graphics.mapper@4.0.xml \
    glodroid/configuration/common/graphics/android.hardware.graphics.composer@2.4.xml \

BOARD_VENDOR_SEPOLICY_DIRS       += glodroid/configuration/common/graphics/sepolicy/vendor
