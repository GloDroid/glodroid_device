
PRODUCT_ENFORCE_ARTIFACT_PATH_REQUIREMENTS := false

#
# All components inherited here go to system image
#
$(call inherit-product, device/google/atv/products/atv_generic_system.mk)


#
# All components inherited here go to system_ext image
#
$(call inherit-product, device/google/atv/products/atv_system_ext.mk)

#
# All components inherited here go to product image
#
$(call inherit-product, device/google/atv/products/atv_product.mk)

#
# All components inherited here go to vendor image
#
$(call inherit-product, device/google/cuttlefish/shared/tv/device_vendor.mk)

# Fallback IME and Home apps
PRODUCT_PACKAGES += LeanbackIME TvSampleLeanbackLauncher TvProvision

$(call inherit-product, device/google/atv/products/atv_vendor.mk)

PRODUCT_COPY_FILES += \
    device/google/atv/products/bootanimations/bootanimation.zip:system/media/bootanimation.zip
