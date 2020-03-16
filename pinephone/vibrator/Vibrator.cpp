/*
 * Copyright (C) 2017 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "VibratorService"

#include <log/log.h>

#include <hardware/hardware.h>
#include <hardware/vibrator.h>

#include "Vibrator.h"

#include <cinttypes>
#include <cmath>
#include <iostream>
#include <fstream>


namespace android {
namespace hardware {
namespace vibrator {
namespace V1_0 {
namespace implementation {

static constexpr uint32_t CLICK_TIMING_MS = 100;

Vibrator::Vibrator(std::ofstream&& state, std::ofstream&& duration, std::ofstream&& activate) :
        mState(std::move(state)),
        mDuration(std::move(duration)),
        mActivate(std::move(activate)) {}

// Methods from ::android::hardware::vibrator::V1_0::IVibrator follow.
Return<Status> Vibrator::on(uint32_t timeout_ms) {
    mState << 1 << std::endl;
    if (!mState) {
        ALOGE("Failed to turn vibrator on (%d): %s", errno, strerror(errno));
        return Status::UNKNOWN_ERROR;
    }
    mDuration << timeout_ms << std::endl;
    if (!mDuration) {
        ALOGE("Failed to turn vibrator on (%d): %s", errno, strerror(errno));
        return Status::UNKNOWN_ERROR;
    }
    mActivate << 1 << std::endl;
    if (!mActivate) {
        ALOGE("Failed to turn vibrator on (%d): %s", errno, strerror(errno));
        return Status::UNKNOWN_ERROR;
    }
    return Status::OK;
}

Return<Status> Vibrator::off()  {
    mActivate << 0 << std::endl;
    if (!mActivate) {
        ALOGE("Failed to turn vibrator off (%d): %s", errno, strerror(errno));
        return Status::UNKNOWN_ERROR;
    }
    return Status::OK;
}

Return<bool> Vibrator::supportsAmplitudeControl()  {
    return false;
}

Return<Status> Vibrator::setAmplitude(uint8_t amplitude) {
    (void) amplitude;
    return Status::BAD_VALUE;
}

Return<void> Vibrator::perform(Effect effect, EffectStrength strength, perform_cb _hidl_cb) {
    ALOGD("Vibrator::perform()");
    (void) strength;
    if (effect == Effect::CLICK) {
        on(CLICK_TIMING_MS);
        _hidl_cb(Status::OK, CLICK_TIMING_MS);
    } else {
        _hidl_cb(Status::UNSUPPORTED_OPERATION, 0);
    }
    return Void();
}

} // namespace implementation
}  // namespace V1_0
}  // namespace vibrator
}  // namespace hardware
}  // namespace android
