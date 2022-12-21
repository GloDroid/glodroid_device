# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2019 The Android Open-Source Project
# Copyright (C) 2021 GloDroid project

include device/glodroid/common/board-common.mk

# Unfortunately WIFI out-of-tree module has an issue when building using CLANG.
BUILD_KERNEL_USING_GCC := true
