# Android makefile to build kernel as a part of Android build

#-------------------------------------------------------------------------------
LOCAL_PATH := $(call my-dir)
KERNEL_CROSS_COMPILE := prebuilts/gcc/linux-x86/arm/gcc-linaro_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-

#-------------------------------------------------------------------------------
ifeq ($(TARGET_PREBUILT_KERNEL),)

#-------------------------------------------------------------------------------
KERNEL_SRC		:= kernel/allwinner
KERNEL_DEFCONFIG	:= sunxi_defconfig android-base.config android-recommended.config
AOSP_CONFIGS		:= kernel/configs/p/android-4.14
KERNEL_FRAGMENTS	:= $(AOSP_CONFIGS)/android-base-arm.cfg \
			   $(LOCAL_PATH)/android-sunxi.config
KERNEL_OUT		:= $(PRODUCT_OUT)/obj/KERNEL_OBJ
KERNEL_MODULES_OUT 	:= $(PRODUCT_OUT)/obj/KERNEL_MODULES
KERNEL_BOOT_DIR		:= arch/$(TARGET_ARCH)/boot
KERNEL_TARGET		:= zImage
KERNEL_BINARY		:= $(KERNEL_OUT)/$(KERNEL_BOOT_DIR)/$(KERNEL_TARGET)
KERNEL_COMPRESSED	:= $(KERNEL_OUT)/$(KERNEL_BOOT_DIR)/Image.lz4
DTB_IMG			:= $(PRODUCT_OUT)/dtb.img
KERNEL_DTS_DIR		:= $(KERNEL_BOOT_DIR)/dts
KERNEL_DTB_OUT		:= $(KERNEL_OUT)/$(KERNEL_DTS_DIR)
DTB_IMG_CONFIG		:= $(LOCAL_PATH)/dtbimg.cfg
ANDROID_DTS_OVERLAY	:= $(LOCAL_PATH)/fstab-android-sdcard.dts
ANDROID_DTBO		:= $(KERNEL_DTB_OUT)/fstab-android-sdcard.dtbo

#-------------------------------------------------------------------------------
ifeq ($(KERNEL_CROSS_COMPILE),)
$(error KERNEL_CROSS_COMPILE is not defined)
endif

#DTB_BLOBS := \
#	$(KERNEL_DTS_DIR)/sun8i-h3-orangepi-plus2e.dtb --id=0x00779520

#-------------------------------------------------------------------------------
# Include only for Renesas ones.
ifeq ($(DTB_BLOBS),)
ifneq (,$(filter $(TARGET_PRODUCT), allwinner))
$(error "DTB_BLOBS is not set for target product $(TARGET_PRODUCT)")
endif
endif

ifeq ($(TARGET_KERNEL_EXT_MODULES),)
    TARGET_KERNEL_EXT_MODULES := no-external-modules
endif

#-------------------------------------------------------------------------------
$(KERNEL_OUT)/.config: $(KERNEL_FRAGMENTS) $(sort $(shell find -L -n "*config" $(KERNEL_SRC)))
	$(MAKE) -C $(KERNEL_SRC) O=$$(readlink -f $(KERNEL_OUT)) ARCH=$(TARGET_ARCH) $(KERNEL_DEFCONFIG)
	$(KERNEL_SRC)/scripts/kconfig/merge_config.sh -m -O $(KERNEL_OUT)/ $(KERNEL_OUT)/.config $(KERNEL_FRAGMENTS)
	$(MAKE) -C $(KERNEL_SRC) O=$$(readlink -f $(KERNEL_OUT)) ARCH=$(TARGET_ARCH) olddefconfig

$(KERNEL_BINARY): $(sort $(shell find -L $(KERNEL_SRC))) $(KERNEL_OUT)/.config
	$(MAKE) -C $(KERNEL_OUT) ARCH=$(TARGET_ARCH) CROSS_COMPILE=$$(readlink -f $(KERNEL_CROSS_COMPILE)) $(KERNEL_TARGET) dtbs modules

$(KERNEL_COMPRESSED): $(KERNEL_BINARY)
	rm -f $@
	lz4c -c1 $< $@

$(KERNEL_MODULES_OUT): $(KERNEL_BINARY)
	rm -rf $(KERNEL_MODULES_OUT)
	$(MAKE) -C $(KERNEL_OUT) ARCH=$(TARGET_ARCH) INSTALL_MOD_PATH=$$(readlink -f $(KERNEL_MODULES_OUT)) modules_install
	find $(KERNEL_MODULES_OUT) -mindepth 2 -type f -name '*.ko' | xargs -I{} cp {} $(KERNEL_MODULES_OUT)

#-------------------------------------------------------------------------------
$(ANDROID_DTBO): $(ANDROID_DTS_OVERLAY)
	rm -f $@
	dtc -@ -I dts -O dtb -o $@ $<

$(DTB_IMG): $(DTB_IMG_CONFIG) mkdtimg $(KERNEL_BINARY) $(ANDROID_DTBO)
	$(call pretty,"Target dtb image: $@")
	mkdtimg cfg_create $@ $< --dtb-dir=$(KERNEL_DTB_OUT)

#-------------------------------------------------------------------------------
$(PRODUCT_OUT)/kernel: $(KERNEL_BINARY)
	cp -v $< $@

#-------------------------------------------------------------------------------
endif # TARGET_PREBUILT_KERNEL
