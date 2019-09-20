
MOD_SRC := kernel/allwinner-modules/rtl8189ES_linux
MODULES_DIR := $(PRODUCT_OUT)/vendor/lib/modules/
INTERMEDIATE_DIR := $(PRODUCT_OUT)/obj/RTL8189FTV-MOD
MODULE := $(INTERMEDIATE_DIR)/8189fs.ko

$(MODULE): $(KERNEL_OUT)/.config $(sort $(shell find -L $(MOD_SRC)))
	rm -rf $(INTERMEDIATE_DIR)
	mkdir -p $(INTERMEDIATE_DIR)
	cp -r $(MOD_SRC)/* $(INTERMEDIATE_DIR)
	$(KMAKEENV) PATH=/usr/bin:$$PATH KSRC=$$(readlink -f $(KERNEL_OUT)) bash -c 'cd $(INTERMEDIATE_DIR) && make -j4'

#-------------------------------------------------------------------------------
include $(CLEAR_VARS)

LOCAL_MODULE := 8189fs.ko

LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)/lib/modules/
LOCAL_PREBUILT_MODULE_FILE := $(MODULE)

include $(BUILD_EXECUTABLE)

#-------------------------------------------------------------------------------
