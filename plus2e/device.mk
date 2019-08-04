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

# bootloaders in srec format
PRODUCT_PACKAGES += \
    boot.scr \
    boot_net.scr \
    u-boot-sunxi-with-spl.bin

# Init RC files
PRODUCT_COPY_FILES += \
    device/allwinner/plus2e/init.plus2e.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.plus2e.rc \
    device/allwinner/plus2e/ueventd.plus2e.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc \

# fstab
PRODUCT_COPY_FILES += \
    device/allwinner/plus2e/fstab:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.$(TARGET_PRODUCT)

# tools
PRODUCT_COPY_FILES += \
    device/allwinner/tools/gensdimg.sh:$(TARGET_COPY_OUT)/gensdimg.sh

# Keymaster HAL
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service

# Set custom settings
DEVICE_PACKAGE_OVERLAYS += device/linaro/hikey/overlay

# Add openssh support for remote debugging and job submission
PRODUCT_PACKAGES += ssh sftp scp sshd ssh-keygen sshd_config start-ssh

# Add wifi-related packages
PRODUCT_PACKAGES += libwpa_client wpa_supplicant hostapd wificond wifilogd
PRODUCT_PROPERTY_OVERRIDES += wifi.interface=wlan0 \
                              wifi.supplicant_scan_interval=15

# Build and run only ART
PRODUCT_RUNTIMES := runtime_libart_default

# Build default bluetooth a2dp and usb audio HALs
PRODUCT_PACKAGES += audio.a2dp.default \
		    audio.usb.default \
		    audio.r_submix.default \
		    tinyplay

PRODUCT_PACKAGES += \
    android.hardware.audio@2.0-impl \
    android.hardware.audio.effect@2.0-impl \
    android.hardware.broadcastradio@1.0-impl \
    android.hardware.soundtrigger@2.0-impl

PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-impl \

# Graphics HAL
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.mapper@2.0-impl

# Memtrack
PRODUCT_PACKAGES += \
    memtrack.default \
    android.hardware.memtrack@1.0-service \
    android.hardware.memtrack@1.0-impl

PRODUCT_PACKAGES += android.hardware.bluetooth@1.0-service.btlinux

# PowerHAL
PRODUCT_PACKAGES += android.hardware.power@1.0-impl

#GNSS HAL
PRODUCT_PACKAGES += \
    android.hardware.gnss@1.0-impl

# Audio HAL
PRODUCT_PACKAGES += \
    android.hardware.audio@4.0-impl \
    android.hardware.audio@2.0-service \
    android.hardware.audio.effect@2.0-impl \
    android.hardware.audio.common@4.0-util \
    android.hardware.audio.effect@4.0-impl \
    android.hardware.audio.effect@all-versions-impl \
    android.hardware.bluetooth.a2dp@1.0-impl

PRODUCT_PACKAGES += \
    hwcomposer.drm \
    hwcomposer.drm_minigbm \
    gralloc.minigbm \
    gralloc.gbm \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.allocator@2.0-impl

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/drm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/drm.rc
