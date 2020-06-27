
# tools
PRODUCT_COPY_FILES += \
    device/glodroid/platform/tools/gensdimg.sh:$(TARGET_COPY_OUT)/gensdimg.sh

UBOOT_FRAGMENTS += \
    device/glodroid/platform/common/sunxi/uboot.config

# SUNXI has broken drm/sun4i DE2 kernel driver.
# Disable drm_hwcomposer for layer composition.
PRODUCT_PROPERTY_OVERRIDES += \
    setprop hwc.drm.exclude_non_hwfb_imports=1
