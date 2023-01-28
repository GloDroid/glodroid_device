/*
 * Copyright (C) 2019 The Android Open Source Project
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

#include <android-base/logging.h>
#include <android/binder_manager.h>
#include <android/binder_process.h>

#include "vibrator-impl/Vibrator.h"

using aidl::android::hardware::vibrator::FFDevice;
using aidl::android::hardware::vibrator::Vibrator;

static const char* INPUT_PATH = "/sys/devices/platform/vibrator/input";

int main() {
    ABinderProcess_setThreadPoolMaxThreadCount(0);
    auto device = FFDevice::create(INPUT_PATH);
    if (!device)
        return EXIT_FAILURE;
    std::shared_ptr<Vibrator> vib = ndk::SharedRefBase::make<Vibrator>(std::move(device));

    const std::string instance = std::string() + Vibrator::descriptor + "/default";
    binder_status_t status = AServiceManager_addService(vib->asBinder().get(), instance.c_str());
    CHECK(status == STATUS_OK);

    ABinderProcess_joinThreadPool();
    return EXIT_FAILURE;  // should not reach
}
