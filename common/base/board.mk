#
# Copyright (C) 2019 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include build/make/target/board/BoardConfigMainlineCommon.mk

TARGET_NO_KERNEL := false

TARGET_BOOTLOADER_BOARD_NAME := $(PRODUCT_NAME)

BOARD_USES_GENERIC_KERNEL_IMAGE := true
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT := true
BOARD_USES_RECOVERY_AS_BOOT :=
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE :=

# Enable AVB
BOARD_AVB_ENABLE := true
BOARD_AVB_ALGORITHM := SHA256_RSA4096
BOARD_AVB_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem

# Enable chained vbmeta for system image mixing
BOARD_AVB_VBMETA_SYSTEM := system system_ext product
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA4096
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 1

# Enable chained vbmeta for boot images
#BOARD_AVB_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
#BOARD_AVB_BOOT_ALGORITHM := SHA256_RSA4096
#BOARD_AVB_BOOT_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
#BOARD_AVB_BOOT_ROLLBACK_INDEX_LOCATION := 2

# Enable chained vbmeta for vendor_boot images
#BOARD_AVB_VENDOR_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
#BOARD_AVB_VENDOR_BOOT_ALGORITHM := SHA256_RSA4096
#BOARD_AVB_VENDOR_BOOT_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
#BOARD_AVB_VENDOR_BOOT_ROLLBACK_INDEX_LOCATION := 3

BOARD_AVB_SYSTEM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_SYSTEM_OTHER_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_SYSTEM_EXT_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_PRODUCT_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_VENDOR_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_VENDOR_DLKM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256

# --- Android images ---
BOARD_FLASH_BLOCK_SIZE := 512

# User image
TARGET_COPY_OUT_DATA := data
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_PARTITION_SIZE := 33554432

BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4

# System image
#TARGET_COPY_OUT_SYSTEM := system
# Disable Jack build system due deprecated status (https://source.android.com/source/jack)
ANDROID_COMPILE_WITH_JACK ?= false

# Cache image 66 MiB
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_PARTITION_SIZE := $(shell echo $$(( 66 * 1024 * 1024 )))

# Vendor image 2GiB
BOARD_USES_VENDORIMAGE := true
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
#BOARD_VENDORIMAGE_PARTITION_SIZE := $(shell echo $$(( 2 * 1024 * 1024 * 1024 )))

# Boot image 64 MiB
BOARD_BOOTIMAGE_PARTITION_SIZE := $(shell echo $$(( 64 * 1024 * 1024 )))
BOARD_DTBOIMG_PARTITION_SIZE := $(shell echo $$(( 512 * 1024 )))
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := $(shell echo $$(( 32 * 1024 * 1024 )))

# DKLM partition
BOARD_USES_VENDOR_DLKMIMAGE := true
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm

# Root image
TARGET_COPY_OUT_ROOT := root
BOARD_BUILD_SYSTEM_ROOT_IMAGE := false

BOARD_EXT4_SHARE_DUP_BLOCKS := true

# Dynamic partition 1800 MiB
BOARD_SUPER_PARTITION_SIZE := $(shell echo $$(( 1800 * 1024 * 1024 )))
BOARD_BUILD_SUPER_IMAGE_BY_DEFAULT := true
BOARD_SUPER_PARTITION_GROUPS := glodroid_dynamic_partitions
BOARD_GLODROID_DYNAMIC_PARTITIONS_SIZE := $(shell echo $$(( $(BOARD_SUPER_PARTITION_SIZE) - (10 * 1024 * 1024) )))
BOARD_GLODROID_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_ext vendor product vendor_dlkm

AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += boot system system_ext vendor product vendor_dlkm vendor_boot vbmeta vbmeta_system

TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888

# Kernel build rules
BOARD_INCLUDE_RECOVERY_DTBO := true
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_PREBUILT_DTBIMAGE_DIR := glodroid/configuration/platform/kernel
BOARD_BOOT_HEADER_VERSION := 4
ifeq ($(PRODUCT_BOARD_PLATFORM),sunxi)
BOARD_KERNEL_BASE     := 0x40000000
endif
ifeq ($(PRODUCT_BOARD_PLATFORM),broadcom)
BOARD_KERNEL_BASE     := 0x00000000
endif
ifeq ($(PRODUCT_BOARD_PLATFORM),rockchip)
BOARD_KERNEL_BASE     := 0x2000000
endif
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_CMDLINE  := androidboot.hardware=$(TARGET_PRODUCT)
BOARD_MKBOOTIMG_ARGS  += --kernel_offset 0x80000 --second_offset 0x8800 --ramdisk_offset 0x3300000
BOARD_MKBOOTIMG_ARGS  += --dtb_offset 0x3000000 --header_version $(BOARD_BOOT_HEADER_VERSION)

BOARD_RAMDISK_USE_LZ4 := true

# SELinux support
#BOARD_SEPOLICY_DIRS += build/target/board/generic/sepolicy

BOARD_USES_METADATA_PARTITION := true

BOARD_USES_PRODUCTIMAGE := true
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4

# Enable dex-preoptimization to speed up first boot sequence
DEX_PREOPT_DEFAULT := nostripping
WITH_DEXPREOPT := true
ART_USE_HSPACE_COMPACT := true

DEVICE_MATRIX_FILE := glodroid/configuration/common/base/compatibility_matrix.xml

# SELinux support
BOARD_VENDOR_SEPOLICY_DIRS       += glodroid/configuration/common/base/sepolicy/vendor

# Enable GloDroid-specific build targets
BOARD_USES_GLODROID_MAKE_TARGETS := true
