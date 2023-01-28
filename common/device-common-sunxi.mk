
UBOOT_FRAGMENTS += \
    glodroid/configuration/platform/common/sunxi/uboot.config

ATF_SRC         := glodroid/bootloader/crust-atf

# Sunxi has no hardware AES-XTS supportm which is required by FBE, adiantum is a fast software impl. from Google
PRODUCT_PROPERTY_OVERRIDES := \
    ro.crypto.volume.options=adiantum \
    ro.crypto.volume.metadata.encryption=adiantum \

PRODUCT_PACKAGES += \
    glodroid_overlay_frameworks_base_core_slow_gpu \
