# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2019 The Android Open-Source Project

include device/glodroid/common/board-common.mk

BOARD_MESA3D_GALLIUM_DRIVERS := panfrost

BOARD_KERNEL_CMDLINE += earlyprintk console=ttyS2,1500000n8 printk.devkmsg=on printk.time=1

BOARD_VENDOR_SEPOLICY_DIRS += device/glodroid/pinephone/sepolicy/vendor

BOARD_LIBCAMERA_IPAS := rkisp1
BOARD_LIBCAMERA_PIPELINES := rkisp1
