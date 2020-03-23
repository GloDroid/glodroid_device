
MODULES_DIR := $(PRODUCT_OUT)/vendor/lib/modules/
MODULE := $(PRODUCT_OUT)/obj/RTL8723CS-MOD/8723cs.ko
MOD_SRC := kernel/glodroid-modules/rtl8723cs

$(MODULE): $(MOD_SRC) $(KERNEL_OUT)/.config $(sort $(shell find -L $(MOD_SRC))) $(PRODUCT_OUT)/kernel
	rm -rf $(dir $@)
	mkdir -p $(dir $@)
	cp -r $</* $(dir $@)
	$(MAKE_COMMON) KSRC=$$(readlink -f $(KERNEL_OUT)) -C $(dir $@)

#-------------------------------------------------------------------------------
include $(CLEAR_VARS)

LOCAL_MODULE := 8723cs.ko

LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)/lib/modules/
LOCAL_PREBUILT_MODULE_FILE := $(MODULE)

include $(BUILD_EXECUTABLE)

#-------------------------------------------------------------------------------
