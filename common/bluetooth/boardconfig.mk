# SPDX-License-Identifier: Apache-2.0

# Some framework code requires this to enable BT
BOARD_HAVE_BLUETOOTH := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/generic/common/bluetooth
DEVICE_MANIFEST_FILE += device/glodroid/common/bluetooth/manifest.xml
