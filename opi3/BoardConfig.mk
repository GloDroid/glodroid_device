# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2019 The Android Open-Source Project

include glodroid/configuration/common/board-common.mk

BOARD_MESA3D_GALLIUM_DRIVERS := panfrost

BOARD_KERNEL_CMDLINE += fw_devlink=permissive

BOARD_USES_TINYHAL_AUDIO := false
