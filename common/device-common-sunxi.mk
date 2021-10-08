
# tools
PRODUCT_COPY_FILES += \
    device/glodroid/platform/tools/gensdimg.sh:$(TARGET_COPY_OUT)/gensdimg.sh

UBOOT_FRAGMENTS += \
    device/glodroid/platform/common/sunxi/uboot.config

ATF_SRC         := external/crust-firmware/arm-trusted-firmware

# Sunxi has no hardware AES-XTS supportm which is required by FBE, adiantum is a fast software impl. from Google
PRODUCT_PROPERTY_OVERRIDES := \
    ro.crypto.volume.options=adiantum \
    ro.crypto.volume.metadata.encryption=adiantum \
