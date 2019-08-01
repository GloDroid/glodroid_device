

MALI_SRC := external/sunxi-mali
MODULES_DIR := $(PRODUCT_OUT)/vendor/lib/modules/
INTERMEDIATE_DIR := $(PRODUCT_OUT)/obj/SUNXI-MALI
MODULE := $(INTERMEDIATE_DIR)/mali.ko

$(MODULE): $(KERNEL_OUT)/.config $(sort $(shell find -L $(MALI_SRC)))
	rm -rf $(INTERMEDIATE_DIR)
	mkdir -p $(INTERMEDIATE_DIR)
	cp -r $(MALI_SRC)/* $(INTERMEDIATE_DIR)
	$(KMAKEENV) PATH=/usr/bin:$$PATH KDIR=$$(readlink -f $(KERNEL_OUT)) bash -c 'cd $(INTERMEDIATE_DIR) && ./build.sh -r r6p0 -b'

#-------------------------------------------------------------------------------
include $(CLEAR_VARS)

LOCAL_MODULE := mali.ko

LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)/lib/modules/
LOCAL_PREBUILT_MODULE_FILE := $(MODULE)

include $(BUILD_EXECUTABLE)

#-------------------------------------------------------------------------------
