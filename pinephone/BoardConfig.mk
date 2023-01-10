# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2019 The Android Open-Source Project

include device/glodroid/common/board-common.mk

BOARD_VENDOR_SEPOLICY_DIRS += device/glodroid/pinephone/sepolicy/vendor

# Apply mesa3d patches to reduce CPU load during frame processing.
BOARD_MESA3D_PATCHES_DIRS += device/glodroid/patches/vendor/mesa3d_slowgpu
