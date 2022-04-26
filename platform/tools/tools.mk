GENSDIMG := $(PLATFORM_PATH)/tools/gensdimg.sh

NATIVE_PATH := PATH=/sbin:/bin:/usr/bin:$$PATH

DEPLOY_TOOLS := \
	$(HOST_OUT_EXECUTABLES)/adb \
	$(HOST_OUT_EXECUTABLES)/fastboot \
	$(HOST_OUT_EXECUTABLES)/mke2fs \

DEPLOY_BOOTLOADER := \
	$(PRODUCT_OUT)/bootloader-sd.img \
	$(PRODUCT_OUT)/env.img \

ifneq ($(PRODUCT_HAS_EMMC),)
ifeq ($(PRODUCT_BOARD_PLATFORM),rockchip)
DEPLOY_BOOTLOADER += $(PRODUCT_OUT)/bootloader-deploy-emmc.img
endif
DEPLOY_BOOTLOADER += $(PRODUCT_OUT)/bootloader-emmc.img
endif

DEPLOY_FILES := \
	$(DEPLOY_TOOLS) \
	$(DEPLOY_BOOTLOADER) \
	$(PRODUCT_OUT)/flash-sd.sh \
	$(PRODUCT_OUT)/deploy-sd.img \
	$(PRODUCT_OUT)/boot.img \
	$(PRODUCT_OUT)/boot_dtbo.img \
	$(PRODUCT_OUT)/vendor_boot.img \
	$(PRODUCT_OUT)/super.img \
	$(PRODUCT_OUT)/deploy-gpt.img \

ifneq ($(PRODUCT_HAS_EMMC),)
DEPLOY_FILES += \
	$(PRODUCT_OUT)/flash-emmc.sh \
	$(PRODUCT_OUT)/deploy-sd-for-emmc.img \

endif

$(PRODUCT_OUT)/flash-sd.sh: $(PLATFORM_PATH)/tools/flash-all.sh
	cp $< $@
	sed -i "s/__SUFFIX__/-sd/g" $@

$(PRODUCT_OUT)/flash-emmc.sh: $(PLATFORM_PATH)/tools/flash-all.sh
	cp $< $@
	sed -i "s/__SUFFIX__/-emmc/g" $@

$(PRODUCT_OUT)/deploy-sd.img: $(GENSDIMG) $(DEPLOY_BOOTLOADER) $(PRODUCT_OUT)/boot.img
	$(NATIVE_PATH) $< -C=$(PRODUCT_OUT) -T=DEPLOY-SD -P=$(PRODUCT_BOARD_PLATFORM) $(notdir $@)

$(PRODUCT_OUT)/deploy-sd-for-emmc.img: $(GENSDIMG) $(DEPLOY_BOOTLOADER) $(PRODUCT_OUT)/boot.img
	$(NATIVE_PATH) $< -C=$(PRODUCT_OUT) -T=DEPLOY-SD-FOR-EMMC -P=$(PRODUCT_BOARD_PLATFORM) $(notdir $@)

$(PRODUCT_OUT)/deploy-gpt.img: $(PRODUCT_OUT)/deploy-sd.img $(GENSDIMG)
	dd if=$< of=$@ bs=1k count=128

$(PRODUCT_OUT)/sdcard.img: $(GENSDIMG)
	$(call pretty,"Creating sdcard image...")
	$(NATIVE_PATH) $< -C=$(PRODUCT_OUT) -T=SD -P=$(PRODUCT_BOARD_PLATFORM) $@

sdcard: droid $(PRODUCT_OUT)/sdcard.img

$(PRODUCT_OUT)/images.tar.gz: $(DEPLOY_FILES)
	cp $(DEPLOY_TOOLS) $(PRODUCT_OUT)
	tar -C$(PRODUCT_OUT) -czvf $@ $(notdir $^)

.PHONY: images
images: $(PRODUCT_OUT)/images.tar.gz
