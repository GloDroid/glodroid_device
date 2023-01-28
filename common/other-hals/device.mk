#
# Copyright (C) 2011 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

ifeq ($(GD_NO_DEFAULT_DRM),)
PRODUCT_PACKAGES += android.hardware.drm@1.3-service.clearkey
endif

ifeq ($(GD_NO_DEFAULT_FASTBOOTD),)
PRODUCT_PACKAGES += fastbootd android.hardware.fastboot@1.1-impl-mock
endif

ifeq ($(GD_NO_DEFAULT_BOOTCTL),)
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-impl \
    android.hardware.boot@1.2-impl.recovery \
    android.hardware.boot@1.2-service \

endif

ifeq ($(GD_NO_DEFAULT_THERMAL),)
PRODUCT_PACKAGES += android.hardware.thermal@2.0-service.mock
endif

ifeq ($(GD_NO_DEFAULT_USB),)
PRODUCT_PACKAGES += \
    android.hardware.usb-service.glodroid \
    android.hardware.usb.gadget@1.2-glodroid-service \

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \

endif

ifeq ($(GD_NO_DEFAULT_GATEKEEPER),)
PRODUCT_PACKAGES += android.hardware.gatekeeper@1.0-service.software
endif

ifeq ($(GD_NO_DEFAULT_KEYMINT),)
PRODUCT_PACKAGES += android.hardware.security.keymint-service
endif

ifeq ($(GD_NO_DEFAULT_IDENTITY),)
PRODUCT_PACKAGES += android.hardware.identity-service.example
endif

ifeq ($(GD_NO_DEFAULT_POWER),)
PRODUCT_PACKAGES += android.hardware.power-service.glodroid
endif

ifeq ($(GD_NO_DEFAULT_VIBRATOR),)
PRODUCT_PACKAGES += android.hardware.vibrator-service.glodroid
endif

ifeq ($(GD_NO_DEFAULT_HEALTH),)
PRODUCT_PACKAGES += \
    android.hardware.health-service.example \
    android.hardware.health-service.example_recovery \

endif
