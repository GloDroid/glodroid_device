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

#include <array>

#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <linux/i2c-dev.h>
#include <sys/ioctl.h>
#include <sys/types.h>

#include <aidl/android/hardware/light/BnLights.h>
#include <android-base/logging.h>
#include <android/binder_manager.h>
#include <android/binder_process.h>

using ::aidl::android::hardware::light::BnLights;
using ::aidl::android::hardware::light::HwLight;
using ::aidl::android::hardware::light::HwLightState;
using ::aidl::android::hardware::light::ILights;
using ::aidl::android::hardware::light::LightType;
using ::ndk::ScopedAStatus;
using ::ndk::SharedRefBase;

static pthread_once_t g_init = PTHREAD_ONCE_INIT;
static pthread_mutex_t g_lock = PTHREAD_MUTEX_INITIALIZER;

struct LightAddress {
    uint8_t red;
    uint8_t green;
    uint8_t blue;
};

char const* const RED_LED_FILE = "/sys/class/leds/sei610:red:power/brightness";

char const* const BLUE_LED_FILE = "/sys/class/leds/sei610:blue:bt/brightness";

std::array<LightAddress, 4> const lightAddrs = {
        LightAddress{0x20, 0x21, 0x22}, LightAddress{0x23, 0x24, 0x25},
        LightAddress{0x26, 0x27, 0x28}, LightAddress{0x29, 0x2A, 0x2B}};

#define LA_P0_ENABLE 0x12
#define LA_P1_ENABLE 0x13
#define LA_RESET_ADDR 0x7F
char const* const ARRAY_LED_DEVICE = "/dev/i2c-0";
const int i2c_dev_addr = (0xB6 >> 1); /* 0x5B */

static int sys_write_int(int fd, int value) {
    char buffer[16];
    size_t bytes;
    ssize_t amount;

    bytes = snprintf(buffer, sizeof(buffer), "%d\n", value);
    if (bytes >= sizeof(buffer)) return -EINVAL;
    amount = write(fd, buffer, bytes);
    return amount == -1 ? -errno : 0;
}

static int write8reg8(int fd, uint8_t regaddr, uint8_t cmd) {
    uint8_t buf[2];

    buf[0] = regaddr;
    buf[1] = cmd;
    if (write(fd, buf, 2) != 2) return -1;
    return 0;
}

class Lights : public BnLights {
  private:
    std::vector<HwLight> availableLights;

    void addLight(LightType const type, int const ordinal) {
        HwLight light{};
        light.id = availableLights.size();
        light.type = type;
        light.ordinal = ordinal;
        availableLights.emplace_back(light);
    }

    int rgbToBrightness(int color) {
        int const r = ((color >> 16) & 0xFF) * 77 / 255;
        int const g = ((color >> 8) & 0xFF) * 150 / 255;
        int const b = (color & 0xFF) * 29 / 255;
        return (r << 16) | (g << 8) | b;
    }

    int writeLedArray(const char* path, LightAddress const& addr, int color) {
        int const fd = open(path, O_RDWR);
        if (fd < 0) {
            LOG(ERROR) << "COULD NOT OPEN ARRAY_LED_DEVICE " << path;
            return fd;
        }
        if (ioctl(fd, I2C_SLAVE, i2c_dev_addr) < 0) {
            LOG(ERROR) << "Error setting slave addr";
            close(fd);
            return -errno;
        }

        write8reg8(fd, addr.red, ((color >> 16) & 0xFF));
        write8reg8(fd, addr.green, ((color >> 8) & 0xFF));
        write8reg8(fd, addr.blue, (color)&0xFF);

        write8reg8(fd, LA_P0_ENABLE, 0x00);
        write8reg8(fd, LA_P1_ENABLE, 0x00);

        close(fd);
        return 0;
    }

    void writeLed(const char* path, int color) {
        int fd = open(path, O_WRONLY);
        if (fd < 0) {
            LOG(ERROR) << "COULD NOT OPEN LED_DEVICE " << path;
            return;
        }

        sys_write_int(fd, color);
        close(fd);
    }

  public:
    Lights() : BnLights() {
        pthread_mutex_init(&g_lock, NULL);

        addLight(LightType::BACKLIGHT, 0);
        addLight(LightType::KEYBOARD, 0);
        addLight(LightType::BUTTONS, 0);
        addLight(LightType::BATTERY, 0);
        addLight(LightType::NOTIFICATIONS, 0);
        addLight(LightType::ATTENTION, 0);
        addLight(LightType::BLUETOOTH, 0);
        addLight(LightType::WIFI, 0);

        for (int i = 0; i < 4; i++) {
            addLight(LightType::MICROPHONE, i);
        }

        writeLed(RED_LED_FILE, rgbToBrightness(0x00000000));
        writeLed(BLUE_LED_FILE, rgbToBrightness(0xFFFFFFFF));
    }

    ScopedAStatus setLightState(int id, const HwLightState& state) override {
        if (!(0 <= id && id < availableLights.size())) {
            LOG(ERROR) << "Light id " << (int32_t)id << " does not exist.";
            return ScopedAStatus::fromExceptionCode(EX_UNSUPPORTED_OPERATION);
        }

        int const color = rgbToBrightness(state.color);
        HwLight const& light = availableLights[id];

        int ret = 0;

        switch (light.type) {
            case LightType::MICROPHONE:
                ret = writeLedArray(ARRAY_LED_DEVICE, lightAddrs[light.ordinal], color);
                break;
            case LightType::BATTERY:
                writeLed(RED_LED_FILE, color);
                break;
            case LightType::BLUETOOTH:
                writeLed(BLUE_LED_FILE, color);
                break;
        }

        if (ret == 0) {
            return ScopedAStatus::ok();
        } else {
            return ScopedAStatus::fromServiceSpecificError(ret);
        }
    }

    ScopedAStatus getLights(std::vector<HwLight>* lights) override {
        for (auto i = availableLights.begin(); i != availableLights.end(); i++) {
            lights->push_back(*i);
        }
        return ScopedAStatus::ok();
    }
};

int main() {
    ABinderProcess_setThreadPoolMaxThreadCount(0);

    std::shared_ptr<Lights> light = SharedRefBase::make<Lights>();

    const std::string instance = std::string() + ILights::descriptor + "/default";
    binder_status_t status = AServiceManager_addService(light->asBinder().get(), instance.c_str());

    if (status != STATUS_OK) {
        LOG(ERROR) << "Could not register" << instance;
        // should abort, but don't want crash loop for local testing
    }

    ABinderProcess_joinThreadPool();

    return 1;  // should not reach
}
