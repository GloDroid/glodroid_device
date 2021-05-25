/* SPDX-License-Identifier: Apache-2.0
 *
 * Copyright (C) 2019 The Android Open-Source Project
 * Copyright (C) 2021 GloDroid project
 */

#pragma once

#include <memory>

namespace aidl {
namespace android {
namespace hardware {
namespace vibrator {

class FFDevice {
    int last_effect_id = -1;
    int event_fd;

  public:
    static std::unique_ptr<FFDevice> create(const char* input_path);

    ~FFDevice();
    void vibrate(int duration_ms);
    void off();
};

}  // namespace vibrator
}  // namespace hardware
}  // namespace android
}  // namespace aidl
