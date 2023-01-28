/* SPDX-License-Identifier: Apache-2.0
 *
 * Copyright (C) 2019 The Android Open-Source Project
 * Copyright (C) 2021 GloDroid project
 */

#include "vibrator-impl/FFDevice.h"

#include <android-base/logging.h>
#include <dirent.h>
#include <fcntl.h>
#include <linux/input.h>
#include <sys/ioctl.h>
#include <unistd.h>

#include <cstdint>
#include <sstream>
#include <string>
#include <string_view>
#include <vector>

using observe_func = bool (*)(std::string_view path, std::string& param);
static bool recursive_dir_observer(const char* path, observe_func func, std::string& param);

namespace aidl {
namespace android {
namespace hardware {
namespace vibrator {

std::unique_ptr<FFDevice> FFDevice::create(const char* input_path) {
    auto observe_func = [](std::string_view path, std::string& event_path) -> bool {
        if (path.find("event") != std::string::npos) {
            event_path = path.data();
            return true;
        }
        return false;
    };
    std::string event_path;
    if (recursive_dir_observer(input_path, observe_func, event_path)) {
        event_path = "/dev/input/" + event_path;
        auto device = std::make_unique<FFDevice>();
        device->event_fd = open(event_path.c_str(), O_RDWR);
        if (device->event_fd == -1) {
            LOG(ERROR) << "FFDevice: error opening event file";
            return nullptr;
        }
        return device;
    }
    LOG(ERROR) << "FFDevice: event path not found";
    return nullptr;
}

FFDevice::~FFDevice() {
    if (event_fd >= 0) {
        close(event_fd);
    }
}

void FFDevice::vibrate(int duration_ms) {
    off();

    /* Prepare effect */
    ff_effect effect = {.type = FF_RUMBLE,
                        .u.rumble.strong_magnitude = UINT16_MAX,
                        .u.rumble.weak_magnitude = UINT16_MAX,
                        .replay.length = static_cast<uint16_t>(duration_ms),
                        .replay.delay = 0,
                        .id = -1 /* set to -1 for allocate new effect */};

    /* Send the effect to the driver */
    if (ioctl(event_fd, EVIOCSFF, &effect) < 0) {
        LOG(ERROR) << "FFDevice: send effect failed";
        return;
    }
    last_effect_id = effect.id;

    /* Prepare the play event */
    input_event play = {.type = EV_FF, .code = static_cast<uint16_t>(effect.id), .value = 1};

    /* Playing the effect in the driver */
    if (write(event_fd, &play, sizeof(play)) == -1) {
        LOG(ERROR) << "FFDevice: play effect failed";
    }
}

void FFDevice::off() {
    if (last_effect_id == -1) {
        return;
    }

    /* Cleanup */
    if (ioctl(event_fd, EVIOCRMFF, last_effect_id) == -1) {
        LOG(ERROR) << "FFDevice: remove effect failed";
    }
    last_effect_id = -1;
}

}  // namespace vibrator
}  // namespace hardware
}  // namespace android
}  // namespace aidl

/* Recursive traversal of the directory tree */
static bool recursive_dir_observer(const char* path, observe_func func, std::string& param) {
    DIR* d = opendir(path);
    if (d == nullptr) {
        return false;
    }

    struct dirent* dir; /* for the directory entries */
    bool found = false; /* to exit recursion */
    std::vector<std::string> paths;
    while ((dir = readdir(d)) != NULL) /* if we were able to read somehting from the directory */
    {
        if (dir->d_type == DT_DIR && strcmp(dir->d_name, ".") != 0 &&
            strcmp(dir->d_name, "..") != 0) /* if it is a directory */
        {
            if (func(std::string_view(dir->d_name), param)) {
                found = true;
                break;
            }
            /* save directory path for future observation */
            std::ostringstream dirpath;
            dirpath << path << "/" << dir->d_name;
            paths.push_back(dirpath.str());
        }
    }
    closedir(d);
    if (!found) {
        for (auto p : paths) {
            if (recursive_dir_observer(p.c_str(), func, param)) {
                found = true;
                break;
            }
        }
    }
    return found;
}
