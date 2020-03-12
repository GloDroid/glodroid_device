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

$(call inherit-product, device/glodroid/common/device-common.mk)

# tools
PRODUCT_COPY_FILES += \
    device/glodroid/platform/tools/gensdimg.sh:$(TARGET_COPY_OUT)/gensdimg.sh

# Out-of-tree modules
PRODUCT_PACKAGES += \
    8189fs.ko \

PRODUCT_COPY_FILES += \
    device/glodroid/plus2e/audio.plus2e.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio.plus2e.xml \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.opi_plus2e.aux.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.opi_plus2e.aux.rc \
