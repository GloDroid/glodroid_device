# SPDX-License-Identifier: Apache-2.0
#
# GloDroid project (https://github.com/GloDroid)
#
# Copyright (C) 2022 Roman Stratiienko (r.stratiienko@gmail.com)

BOARD_BUILD_AOSPEXT_LIBCAMERA := true
BOARD_LIBCAMERA_SRC_DIR := glodroid/vendor/libcamera
BOARD_LIBCAMERA_PATCHES_DIRS := glodroid/configuration/patches/vendor/libcamera
BOARD_LIBCAMERA_IPAS := raspberrypi
BOARD_LIBCAMERA_PIPELINES := simple raspberrypi

DEVICE_MANIFEST_FILE += \
    glodroid/configuration/common/camera/android.hardware.camera.provider@2.5.xml \

BOARD_VENDOR_SEPOLICY_DIRS       += glodroid/configuration/common/camera/sepolicy/vendor
