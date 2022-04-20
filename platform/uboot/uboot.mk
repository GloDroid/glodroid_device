#
# Copyright (C) 2011 The Android Open-Source Project
# Copyright (C) 2018 GlobalLogic
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
#-------------------------------------------------------------------------------
BSP_UBOOT_PATH := $(call my-dir)

UBOOT_SRC := external/u-boot
UBOOT_OUT := $(PRODUCT_OUT)/obj/UBOOT_OBJ

UBOOT_SRC_FILES := $(sort $(shell find -L $(UBOOT_SRC) -not -path '*/\.git/*'))

UBOOT_EMMC_DEV_INDEX := 1
UBOOT_SD_DEV_INDEX := 0

UBOOT_KCFLAGS = \
    -fgnu89-inline \
    $(TARGET_BOOTLOADER_CFLAGS)

ifeq ($(TARGET_ARCH),arm64)
BL31_SET := BL31=$(AOSP_TOP_ABS)/$(ATF_BINARY)
endif

ifeq ($(PRODUCT_BOARD_PLATFORM),sunxi)
ifneq ($(CRUST_FIRMWARE_DEFCONFIG),)
CRUST_FIRMWARE_SET := SCP=$(AOSP_TOP_ABS)/$(CRUST_FIRMWARE_BINARY)
endif
endif

UMAKE := \
    PATH=/usr/bin:/bin:$$PATH \
    ARCH=$(TARGET_ARCH) \
    CROSS_COMPILE=$(AOSP_TOP_ABS)/$(CROSS_COMPILE) \
    $(BL31_SET) \
    $(CRUST_FIRMWARE_SET) \
    $(MAKE) \
    -C $(UBOOT_SRC) \
    O=$(AOSP_TOP_ABS)/$(UBOOT_OUT)

UBOOT_FRAGMENTS	+= device/glodroid/platform/common/uboot.config
UBOOT_FRAGMENT_EMMC := $(UBOOT_OUT)/uboot-emmc.config
UBOOT_FRAGMENT_SD := $(UBOOT_OUT)/uboot-sd.config

#-------------------------------------------------------------------------------
ifeq ($(PRODUCT_BOARD_PLATFORM),sunxi)
SYSFS_MMC0_PATH ?= soc/1c0f000.mmc
SYSFS_MMC1_PATH ?= soc/1c11000.mmc
UBOOT_FRAGMENTS	+= device/glodroid/platform/common/sunxi/uboot.config
UBOOT_BINARY := $(UBOOT_OUT)/u-boot-sunxi-with-spl.bin
endif

ifeq ($(PRODUCT_BOARD_PLATFORM),broadcom)
UBOOT_FRAGMENTS	+= device/glodroid/platform/common/broadcom/uboot.config
UBOOT_BINARY := $(UBOOT_OUT)/u-boot.bin
RPI_FIRMWARE_DIR := vendor/raspberry/firmware
endif

ifeq ($(PRODUCT_BOARD_PLATFORM),rockchip)
UBOOT_FRAGMENTS += device/glodroid/platform/common/rockchip/uboot.config
UBOOT_FRAGMENT_ROCKCHIP_EMMC := device/glodroid/platform/common/rockchip/uboot-emmc.config
UBOOT_BINARY := $(UBOOT_OUT)/u-boot-dtb.bin
UBOOT_IDBLOADER := $(UBOOT_OUT)/idbloader_externel.img
UBOOT_TRUST := $(UBOOT_OUT)/trust.img
UBOOT_BINARY_SD_EMMC := $(UBOOT_BINARY).deploy-emmc
BOOTLOADER_SD_FOR_EMMC := $(PRODUCT_OUT)/bootloader-deploy-emmc.img
BOOTLOADER_EMMC := $(PRODUCT_OUT)/bootloader-emmc.img
ROCKCHIP_FIRMWARE_DIR := vendor/rockchip/rkbin
TRUST_MERGER := tools/trust_merger
RK_BIN_DIR := $(ROCKCHIP_FIRMWARE_DIR)/$(RK33_BIN)
RKTRUST_DIR := $(ROCKCHIP_FIRMWARE_DIR)/RKTRUST
UBOOT_EMMC_DEV_INDEX := 0
UBOOT_SD_DEV_INDEX := 1
SYSFS_MMC0_PATH ?= fe330000.sdhci
SYSFS_MMC1_PATH ?= fe320000.mmc
endif

$(UBOOT_FRAGMENT_EMMC):
	echo "CONFIG_FASTBOOT_FLASH_MMC_DEV=$(UBOOT_EMMC_DEV_INDEX)" > $@

$(UBOOT_FRAGMENT_SD):
	echo "CONFIG_FASTBOOT_FLASH_MMC_DEV=$(UBOOT_SD_DEV_INDEX)" > $@

$(UBOOT_BINARY): $(UBOOT_FRAGMENTS) $(UBOOT_FRAGMENT_SD) $(UBOOT_FRAGMENT_EMMC) $(UBOOT_SRC_FILES) $(ATF_BINARY) $(CRUST_FIRMWARE_BINARY)
	@echo "Building U-Boot: "
	@echo "TARGET_PRODUCT = " $(TARGET_PRODUCT):
	mkdir -p $(UBOOT_OUT)
	$(UMAKE) $(UBOOT_DEFCONFIG)
	PATH=/usr/bin:/bin $(UBOOT_SRC)/scripts/kconfig/merge_config.sh -m -O $(UBOOT_OUT)/ $(UBOOT_OUT)/.config $(UBOOT_FRAGMENTS) $(UBOOT_FRAGMENT_SD)
	$(UMAKE) olddefconfig
	$(UMAKE) KCFLAGS="$(UBOOT_KCFLAGS)"
	cp $@ $@.sd
ifneq ($(PRODUCT_HAS_EMMC),)
	$(UMAKE) $(UBOOT_DEFCONFIG)
ifeq ($(PRODUCT_BOARD_PLATFORM),rockchip)
	PATH=/usr/bin:/bin $(UBOOT_SRC)/scripts/kconfig/merge_config.sh -m -O $(UBOOT_OUT)/ $(UBOOT_OUT)/.config $(UBOOT_FRAGMENTS) $(UBOOT_FRAGMENT_ROCKCHIP_EMMC) $(UBOOT_FRAGMENT_EMMC)
else
	PATH=/usr/bin:/bin $(UBOOT_SRC)/scripts/kconfig/merge_config.sh -m -O $(UBOOT_OUT)/ $(UBOOT_OUT)/.config $(UBOOT_FRAGMENTS) $(UBOOT_FRAGMENT_EMMC)
endif
	$(UMAKE) olddefconfig
	$(UMAKE) KCFLAGS="$(UBOOT_KCFLAGS)"
	cp $@ $@.emmc
endif

BOOTSCRIPT_GEN := $(PRODUCT_OUT)/gen/BOOTSCRIPT/boot.txt

$(BOOTSCRIPT_GEN): $(BSP_UBOOT_PATH)/bootscript.cpp $(BSP_UBOOT_PATH)/bootscript.h
	mkdir -p $(dir $@)
	$(CLANG) -E -P -Wno-invalid-pp-token $< -o $@ \
	    -Dplatform_$(PRODUCT_BOARD_PLATFORM) \
	    -Ddevice_$(PRODUCT_DEVICE) \
	    -D__SYSFS_MMC0_PATH__=$(SYSFS_MMC0_PATH) \
	    -D__SYSFS_MMC1_PATH__=$(SYSFS_MMC1_PATH) \

$(UBOOT_OUT)/boot.scr: $(BOOTSCRIPT_GEN) $(UBOOT_BINARY)
	$(UBOOT_OUT)/tools/mkimage -A arm -O linux -T script -C none -a 0 -e 0 -d $< $@

$(PRODUCT_OUT)/env.img: $(UBOOT_OUT)/boot.scr
	rm -f $@
	/sbin/mkfs.vfat -n "uboot-scr" -S 512 -C $@ 256
	/usr/bin/mcopy -i $@ -s $< ::$(notdir $<)

$(UBOOT_OUT)/bootloader.img: $(UBOOT_BINARY)
	cp -f $< $@
	dd if=/dev/null of=$@ bs=1 count=1 seek=$$(( 2048 * 1024 - 256 * 512 ))


ifeq ($(PRODUCT_BOARD_PLATFORM),sunxi)
$(PRODUCT_OUT)/bootloader-sd.img: $(UBOOT_BINARY)
	cp -f $<.sd $@
	dd if=/dev/null of=$@ bs=1 count=1 seek=$$(( 2048 * 1024 - 256 * 512 ))
endif

ifeq ($(PRODUCT_BOARD_PLATFORM),rockchip)
$(UBOOT_BINARY_SD_EMMC): $(UBOOT_BINARY)
	mkdir -p $(UBOOT_OUT)
	$(UMAKE) $(UBOOT_DEFCONFIG)
	PATH=/usr/bin:/bin $(UBOOT_SRC)/scripts/kconfig/merge_config.sh -m -O $(UBOOT_OUT)/ $(UBOOT_OUT)/.config $(UBOOT_FRAGMENTS) $(UBOOT_FRAGMENT_EMMC)
	$(UMAKE) olddefconfig
	$(UMAKE) KCFLAGS="$(UBOOT_KCFLAGS)"
	cp $(UBOOT_BINARY) $@

$(UBOOT_IDBLOADER): $(UBOOT_BINARY)
	$(ROCKCHIP_FIRMWARE_DIR)/tools/mkimage -n rk3399 -T rksd -d $(ROCKCHIP_FIRMWARE_DIR)/bin/$(DDR_BLOB) $@
	cat $(ROCKCHIP_FIRMWARE_DIR)/bin/$(MINILOADER_BLOB) >> $@

$(UBOOT_TRUST): $(UBOOT_BINARY)
	mkdir -p $(UBOOT_OUT)/bin
	(cp -r $(RK_BIN_DIR) $(UBOOT_OUT)/bin && \
	cp $(RKTRUST_DIR)/$(RKTRUST_INI) $(UBOOT_OUT) && \
	cp $(ROCKCHIP_FIRMWARE_DIR)/$(TRUST_MERGER) $(UBOOT_OUT)/$(TRUST_MERGER) && \
	cd $(UBOOT_OUT) && \
	$(TRUST_MERGER) $(RKTRUST_INI))

$(PRODUCT_OUT)/bootloader-deploy-emmc.img $(PRODUCT_OUT)/bootloader-sd.img $(PRODUCT_OUT)/bootloader-emmc.img: $(UBOOT_BINARY) $(UBOOT_BINARY_SD_EMMC) $(UBOOT_IDBLOADER) $(UBOOT_TRUST)
	#Script for build uboot: https://github.com/armbian/build/blob/19a963189510a541a0486933eb8eaa1d7bc7f695/config/sources/families/include/rockchip64_common.inc#L180
	$(ROCKCHIP_FIRMWARE_DIR)/tools/loaderimage --pack --uboot $(UBOOT_BINARY).$(subst .img,,$(subst $(PRODUCT_OUT)/bootloader-,,$@)) $(UBOOT_OUT)/uboot.img.$(subst .img,,$(subst $(PRODUCT_OUT)/bootloader-,,$@)) 0x200000
	dd if=$(UBOOT_IDBLOADER) of=$@ seek=$$(( 64 - 64 ))
	dd if=$(UBOOT_OUT)/uboot.img.$(subst .img,,$(subst $(PRODUCT_OUT)/bootloader-,,$@)) of=$@ seek=$$(( 16384 - 64 ))
	dd if=$(UBOOT_TRUST) of=$@ seek=$$(( 24576 - 64 ))
	dd if=/dev/null of=$@ bs=1 count=1 seek=$$(( 16384 * 1024 - 64 * 512 ))
endif

ifeq ($(PRODUCT_BOARD_PLATFORM),broadcom)
BOOT_FILES := \
    $(RPI_FIRMWARE_DIR)/boot/bootcode.bin \
    $(RPI_FIRMWARE_DIR)/boot/start_x.elf \
    $(RPI_FIRMWARE_DIR)/boot/start4x.elf \
    $(RPI_FIRMWARE_DIR)/boot/fixup_x.dat \
    $(RPI_FIRMWARE_DIR)/boot/fixup4x.dat \
    $(PRODUCT_OUT)/obj/KERNEL_OBJ/arch/$(TARGET_ARCH)/boot/dts/broadcom/bcm2711-rpi-4-b.dtb \
    $(PRODUCT_OUT)/obj/KERNEL_OBJ/arch/$(TARGET_ARCH)/boot/dts/broadcom/bcm2711-rpi-400.dtb \
    $(PRODUCT_OUT)/obj/KERNEL_OBJ/arch/$(TARGET_ARCH)/boot/dts/broadcom/bcm2711-rpi-cm4.dtb \

OVERLAY_FILES := $(sort $(shell find -L $(RPI_FIRMWARE_DIR)/boot/overlays))

$(PRODUCT_OUT)/bootloader-sd.img: $(UBOOT_BINARY) $(OVERLAY_FILES) $(ATF_BINARY) $(RPI_CONFIG) $(KERNEL_BINARY)
	dd if=/dev/null of=$@ bs=1 count=1 seek=$$(( 128 * 1024 * 1024 - 256 * 512 ))
	/sbin/mkfs.vfat -F 32 -n boot $@
	/usr/bin/mcopy -i $@ $(UBOOT_BINARY) ::$(notdir $(UBOOT_BINARY))
	/usr/bin/mcopy -i $@ $(ATF_BINARY) ::$(notdir $(ATF_BINARY))
	/usr/bin/mcopy -i $@ $(RPI_CONFIG) ::$(notdir $(RPI_CONFIG))
	/usr/bin/mcopy -i $@ $(BOOT_FILES) ::
	/usr/bin/mmd -i $@ ::overlays
	/usr/bin/mcopy -i $@ $(OVERLAY_FILES) ::overlays/
endif

ifneq ($(PRODUCT_HAS_EMMC),)
ifeq ($(PRODUCT_BOARD_PLATFORM),sunxi)
$(PRODUCT_OUT)/bootloader-emmc.img: $(UBOOT_BINARY)
	cp -f $<.emmc $@
	dd if=/dev/null of=$@ bs=1 count=1 seek=$$(( 2048 * 1024 - 256 * 512 ))
endif
endif
