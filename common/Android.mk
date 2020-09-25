include device/linaro/hikey/libmemtrack/Android.mk

include $(CLEAR_VARS)
LOCAL_MODULE                         := remove-Bluetooth
EXECUTABLES.remove-Bluetooth.OVERRIDES := Bluetooth
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE                         := remove-android.hardware.configstore@1.1-service
EXECUTABLES.remove-android.hardware.configstore@1.1-service.OVERRIDES := \
					android.hardware.configstore@1.1-service
include $(BUILD_PHONY_PACKAGE)
