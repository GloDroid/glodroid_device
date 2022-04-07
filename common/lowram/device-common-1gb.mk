
GLODROID_LOWRAM := true

PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapstartsize=1m \
    dalvik.vm.heapgrowthlimit=48m \
    dalvik.vm.heapsize=128m \
    dalvik.vm.heaptargetutilization=0.75 \
    dalvik.vm.heapminfree=512k \
    dalvik.vm.heapmaxfree=2m \
    dalvik.vm.usejit=false \

PRODUCT_PROPERTY_OVERRIDES += ro.config.low_ram=true

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.lowram.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.lowram.rc \
    device/glodroid/common/no_animation.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/no_animation.rc \

LOCAL_PATH := device/glodroid/common
include $(LOCAL_PATH)/device-common.mk
