# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, device/glodroid/common/device-common.mk)

# tools
PRODUCT_COPY_FILES += \
    device/glodroid/platform/tools/gensdimg.sh:$(TARGET_COPY_OUT)/gensdimg.sh

PRODUCT_COPY_FILES += \
    device/glodroid/plus2e/audio.plus2e.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio.plus2e.xml \
