
# tools
PRODUCT_COPY_FILES += \
    device/glodroid/platform/tools/gensdimg.sh:$(TARGET_COPY_OUT)/gensdimg.sh

UBOOT_FRAGMENTS += \
    device/glodroid/platform/common/sunxi/uboot.config

ATF_SRC         := external/crust-firmware/arm-trusted-firmware
