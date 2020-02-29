
MOD_SRC := kernel/glodroid-modules/rtl8189ES_linux
MODULES_DIR := $(PRODUCT_OUT)/vendor/lib/modules/
INTERMEDIATE_DIR := $(PRODUCT_OUT)/obj/RTL8189FTV-MOD
MODULE := $(INTERMEDIATE_DIR)/8189fs.ko

$(MODULE): $(KERNEL_OUT)/.config $(sort $(shell find -L $(MOD_SRC))) $(PRODUCT_OUT)/kernel
	rm -rf $(INTERMEDIATE_DIR)
	mkdir -p $(INTERMEDIATE_DIR)
	cp -r $(MOD_SRC)/* $(INTERMEDIATE_DIR)
	$(MAKE_COMMON) KSRC=$$(readlink -f $(KERNEL_OUT)) -C $(INTERMEDIATE_DIR)

#-------------------------------------------------------------------------------
include $(CLEAR_VARS)

LOCAL_MODULE := 8189fs.ko

LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)/lib/modules/
LOCAL_PREBUILT_MODULE_FILE := $(MODULE)

include $(BUILD_EXECUTABLE)

#-------------------------------------------------------------------------------
