# Copyright (C) 2019 The Android Open Source Project
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

$(call inherit-product, device/allwinner/plus2e/modules.mk)

# default is nosdcard, S/W button enabled in resource
DEVICE_PACKAGE_OVERLAYS := device/generic/armv7-a-neon/overlay
PRODUCT_CHARACTERISTICS := nosdcard

# Build and run only ART
PRODUCT_RUNTIMES := runtime_libart_default

# bootloaders in srec format
PRODUCT_PACKAGES += \
    u-boot-sunxi-with-spl.bin

# Init RC files
PRODUCT_COPY_FILES += \
    device/allwinner/plus2e/init.plus2e.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.plus2e.rc \
    device/allwinner/plus2e/ueventd.plus2e.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc \

# Generic memtrack module
PRODUCT_PACKAGES += \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service

# Keymaster HAL
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service

# Gatekeeper HAL
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-impl \
    android.hardware.gatekeeper@1.0-service

# USB HAL
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service

# Configstore HAL
PRODUCT_PACKAGES += \
    android.hardware.configstore@1.1-service

