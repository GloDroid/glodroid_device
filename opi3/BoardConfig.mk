# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2019 The Android Open-Source Project
# Copyright (C) 2019-2023 GloDroid Project

BC_PATH := $(patsubst $(CURDIR)/%,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

include glodroid/configuration/common/board-common.mk

BOARD_MESA3D_GALLIUM_DRIVERS := panfrost

BOARD_KERNEL_CMDLINE += fw_devlink=permissive

BOARD_USES_TINYHAL_AUDIO := false

BOARD_KERNEL_PATCHES_DIRS := \
	$(BC_PATH)/patches-kernel/glodroid-clk-5.15  \
	$(BC_PATH)/patches-kernel/megi-opi3-5.15     \
	glodroid/configuration/patches/kernel/android13-5.15-2023-01/sun4i-drm \
