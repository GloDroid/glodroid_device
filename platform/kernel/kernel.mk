# Android makefile to build kernel as a part of Android build

#-------------------------------------------------------------------------------
LOCAL_PATH := $(call my-dir)
#-------------------------------------------------------------------------------
ifeq ($(TARGET_PREBUILT_KERNEL),)

#-------------------------------------------------------------------------------
KERNEL_SRC		:= kernel/glodroid
KERNEL_FRAGMENTS	+= \
    $(LOCAL_PATH)/android-base.config \
    $(LOCAL_PATH)/android-recommended.config \

KERNEL_OUT		:= $(PRODUCT_OUT)/obj/KERNEL_OBJ
KERNEL_MODULES_OUT 	:= $(PRODUCT_OUT)/obj/KERNEL_MODULES
KERNEL_BOOT_DIR		:= arch/$(TARGET_ARCH)/boot
ifeq ($(TARGET_ARCH),arm64)
KERNEL_TARGET		:= Image
else
KERNEL_TARGET		:= zImage
endif
KERNEL_BINARY		:= $(KERNEL_OUT)/$(KERNEL_BOOT_DIR)/$(KERNEL_TARGET)
KERNEL_COMPRESSED	:= $(KERNEL_OUT)/$(KERNEL_BOOT_DIR)/Image.lz4
ifeq ($(TARGET_ARCH),arm64)
KERNEL_IMAGE		:= $(KERNEL_COMPRESSED)
else
KERNEL_IMAGE		:= $(KERNEL_BINARY)
endif
KERNEL_DTS_DIR		:= $(KERNEL_BOOT_DIR)/dts
KERNEL_DTB_OUT		:= $(KERNEL_OUT)/$(KERNEL_DTS_DIR)
DTB_IMG_CONFIG		:= $(LOCAL_PATH)/dtbimg.cfg
ANDROID_DTS_OVERLAY	:= $(LOCAL_PATH)/fstab-android-sdcard.dts
ANDROID_DTBO		:= $(KERNEL_DTB_OUT)/fstab-android-sdcard.dtbo
BOARD_PREBUILT_DTBOIMAGE := $(KERNEL_DTB_OUT)/dtbo.img
MKDTBOIMG		:= $(HOST_OUT_EXECUTABLES)/mkdtboimg.py

KMAKE := \
    $(MAKE_COMMON) \
    -C $(KERNEL_SRC) O=$$(readlink -f $(KERNEL_OUT)) \

#-------------------------------------------------------------------------------
$(KERNEL_OUT)/.config: $(KERNEL_FRAGMENTS) $(sort $(shell find -L $(KERNEL_SRC)))
	$(KMAKE) $(KERNEL_DEFCONFIG)
	PATH=/usr/bin:/bin:$$PATH $(KERNEL_SRC)/scripts/kconfig/merge_config.sh -m -O $(KERNEL_OUT)/ $(KERNEL_OUT)/.config $(KERNEL_FRAGMENTS)
	$(KMAKE) olddefconfig

$(KERNEL_BINARY): $(sort $(shell find -L $(KERNEL_SRC))) $(KERNEL_OUT)/.config
	$(KMAKE) $(KERNEL_TARGET) dtbs modules

$(KERNEL_COMPRESSED): $(KERNEL_BINARY)
	rm -f $@
	prebuilts/misc/linux-x86/lz4/lz4c -c1 $< $@

$(KERNEL_MODULES_OUT): $(KERNEL_BINARY)
	rm -rf $(KERNEL_MODULES_OUT)
	$(KMAKE) INSTALL_MOD_PATH=$$(readlink -f $(KERNEL_MODULES_OUT)) modules_install
	find $(KERNEL_MODULES_OUT) -mindepth 2 -type f -name '*.ko' | xargs -I{} cp {} $(KERNEL_MODULES_OUT)

#-------------------------------------------------------------------------------
$(ANDROID_DTBO): $(ANDROID_DTS_OVERLAY)
	rm -f $@
	./prebuilts/misc/linux-x86/dtc/dtc -@ -I dts -O dtb -o $@ $<

$(BOARD_PREBUILT_DTBOIMAGE): $(DTB_IMG_CONFIG) $(KERNEL_BINARY) $(ANDROID_DTBO) $(MKDTBOIMG)
	$(call pretty,"Target dtb image: $@")
	$(MKDTBOIMG) cfg_create $@ $< --dtb-dir=$(KERNEL_DTB_OUT)

#-------------------------------------------------------------------------------
$(PRODUCT_OUT)/kernel: $(KERNEL_IMAGE) $(KERNEL_MODULES_OUT)
	cp -v $< $@

#-------------------------------------------------------------------------------

include $(LOCAL_PATH)/rtl8189ftv-mod.mk

endif # TARGET_PREBUILT_KERNEL
