
ifneq (,$(filter %_tv,$(TARGET_PRODUCT)))
    GD_NO_DEFAULT_MODEM := true
    $(call inherit-product, $(LOCAL_PATH)/device-tv.mk)
else ifneq (,$(filter %_auto,$(TARGET_PRODUCT)))
# TODO: Implement
    $(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
else
    $(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
endif


$(call inherit-product, $(LOCAL_PATH)/base/device.mk)

$(call inherit-product, $(LOCAL_PATH)/other-hals/device.mk)

ifeq ($(GD_NO_DEFAULT_BLUETOOTH),)
    $(call inherit-product, $(LOCAL_PATH)/bluetooth/device.mk)
endif

ifeq ($(GD_NO_DEFAULT_GRAPHICS),)
    $(call inherit-product, $(LOCAL_PATH)/graphics/device.mk)
endif

ifeq ($(GD_NO_DEFAULT_CODECS),)
    $(call inherit-product, $(LOCAL_PATH)/codecs/device.mk)
endif

ifeq ($(GD_NO_DEFAULT_CAMERA),)
    $(call inherit-product, $(LOCAL_PATH)/camera/device.mk)
endif

ifeq ($(GD_NO_DEFAULT_MODEM),)
    $(call inherit-product, $(LOCAL_PATH)/modem/device.mk)
endif

ifeq ($(GD_NO_DEFAULT_AUDIO),)
    $(call inherit-product, $(LOCAL_PATH)/audio/device.mk)
endif

ifeq ($(GD_NO_DEFAULT_WIFI),)
    $(call inherit-product, $(LOCAL_PATH)/wifi/device.mk)
endif

ifeq ($(GD_NO_DEFAULT_APPS),)
    $(call inherit-product, glodroid/apks/glodroid-apks.mk)
endif

ifneq ($(GD_LOWRAM_CONFIG),)
    $(call inherit-product, $(LOCAL_PATH)/lowram/device.mk)
endif

ifeq ($(PRODUCT_BOARD_PLATFORM),sunxi)
    $(call inherit-product, $(LOCAL_PATH)/device-common-sunxi.mk)
endif

PRODUCT_SOONG_NAMESPACES += glodroid/configuration
