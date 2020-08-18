
# tools
PRODUCT_COPY_FILES += \
    device/glodroid/platform/tools/gensdimg.sh:$(TARGET_COPY_OUT)/gensdimg.sh

UBOOT_FRAGMENTS += \
    device/glodroid/platform/common/sunxi/uboot.config

# SUNXI has broken drm/sun4i DE2 kernel driver.
# Disable scaling to acoid UI glitches.
PRODUCT_PROPERTY_OVERRIDES += \
    hwc.drm.scale_with_gpu=1 \
