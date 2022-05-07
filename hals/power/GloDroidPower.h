/*
 * Copyright (C) 2022 Roman Stratiienko and GloDroid Project
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

#pragma once

#include <android-base/unique_fd.h>
#include <dirent.h>
#include <log/log.h>
#include <sys/types.h>
#include <thread>

using android::base::unique_fd;

namespace aidl {
namespace android {

class SysfsIntFile {
  public:
    explicit SysfsIntFile(std::string file_name) : file_name_(file_name) {
        auto fd = unique_fd(open(file_name.c_str(), O_RDONLY));
        if (fd.get() == -1) {
            ALOGV("Unable to open sysfs file: %s, errno: %i", file_name.c_str(), errno);
            return;
        }
        char buf[32];
        int n = read(fd, &buf, sizeof(buf) - 1);
        if (n < 0) {
            ALOGV("Unable to read from sysfs file: %s", file_name.c_str());
            return;
        }
        buf[n] = '\0';
        if (sscanf(buf, "%d", &initial_value_) != 1) {
            ALOGE("Unable to parse integer from sysfs file: %s", file_name.c_str());
            return;
        }

        valid_ = true;
    }

    operator bool() { return valid_; }

    bool Write(int value) {
        if (!valid_) return false;

        auto fd = unique_fd(open(file_name_.c_str(), O_WRONLY));
        if (fd.get() == -1) {
            ALOGI("Unable to open %s for writing", file_name_.c_str());
            return false;
        }

        int n = dprintf(fd, "%i", value);

        if (n < 0) {
            ALOGE("Unable to write %i into %s", value, file_name_.c_str());
            return false;
        }
        last_value_ = value;

        return true;
    }

    int GetLastValue() { return last_value_; }

    int GetInitialValue() { return initial_value_; }

  private:
    std::string file_name_;
    int initial_value_{-1};
    int last_value_{-1};
    bool valid_{};
};

class DevFreq {
  public:
    DevFreq(std::string scaling_prefix)
        : min_freq_(scaling_prefix + "min_freq"), max_freq_(scaling_prefix + "max_freq") {
        valid_ = min_freq_ && max_freq_ && min_freq_.Write(min_freq_.GetInitialValue());
    }

    operator bool() { return valid_; }

    void Boost(bool en) {
        min_freq_.Write(en ? max_freq_.GetInitialValue() : min_freq_.GetInitialValue());
    }

  private:
    bool valid_{};
    SysfsIntFile min_freq_, max_freq_;
};

class GloDroidPower {
  public:
    GloDroidPower() {
        std::string suffix = "min_freq";
        auto fn = [&](std::string file_name) {
            auto dvfs = std::make_unique<DevFreq>(
                    file_name.substr(0, file_name.size() - suffix.size()));

            if (*dvfs) {
                booster_list_.emplace_back(std::move(dvfs));
                ALOGI("(%s) Successfully added as DVFS booster", file_name.c_str());
            } else {
                ALOGW("(%s) Unable to use as DVFS booster", file_name.c_str());
            }
        };

        ALOGI("Searching for platform DVFS:");
        SearchSysfs("/sys/devices/platform", suffix, fn);

        ALOGI("Searching for system DVFS:");
        SearchSysfs("/sys/devices/system", suffix, fn);

        if (booster_list_.empty()) {
            ALOGW("No usable DVFS boosters found");
            return;
        }

        thread_ = std::thread(&GloDroidPower::ThreadFn, this);
    }

    ~GloDroidPower() {
        {
            auto lock = std::unique_lock(mut_);
            exit_ = true;
        }
        Notify();
        thread_.join();
    }

    void SearchSysfs(std::string path, std::string match_suffix,
                     std::function<void(std::string)> match_fn) {
        DIR* dir;
        struct dirent* entry;

        if (!(dir = opendir(path.c_str()))) return;

        while ((entry = readdir(dir)) != NULL) {
            if (entry->d_type == DT_DIR) {
                if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) continue;
                SearchSysfs(path + "/" + entry->d_name, match_suffix, match_fn);
            } else {
                std::string f_name(entry->d_name);
                if (f_name.size() < match_suffix.size()) continue;
                if (f_name.substr(f_name.size() - match_suffix.size(), match_suffix.size()) ==
                    match_suffix) {
                    match_fn(path + "/" + f_name);
                }
            }
        }
        closedir(dir);
    }

    void BoostFor(int timeout_ms) {
        using namespace std::chrono;
        constexpr int kDefaultTimeout = 100;
        if (timeout_ms <= 0) timeout_ms = kDefaultTimeout;

        ALOGV("Boost for %i", timeout_ms);

        {
            auto lock = std::unique_lock(mut_);
            auto boost_end = steady_clock::now() + milliseconds(timeout_ms);
            if (boost_end_ < boost_end) {
                boost_end_ = boost_end;
                Notify();
            }
        }
    }

    void BoostEn(bool en) {
        ALOGV("Boost en: %i", en ? 1 : 0);

        {
            auto lock = std::unique_lock(mut_);
            boost_en_ = en;
            Notify();
        }
    }

  private:
    void Notify() { cv_.notify_all(); }

    bool exit_{};

    std::vector<std::unique_ptr<DevFreq>> booster_list_;

    std::condition_variable cv_;
    std::mutex mut_;

    std::chrono::time_point<std::chrono::steady_clock> boost_end_;
    bool boost_en_{};

    std::thread thread_;

    void BoostAll(bool en) {
        for (auto& df : booster_list_) {
            df->Boost(en);
        }
    }

    void ThreadFn() {
        using namespace std::chrono;
        bool boosted = false;
        auto wakeup_pt = time_point<steady_clock>::max();

        ALOGV("Started");

        for (;;) {
            auto lock = std::unique_lock(mut_);
            cv_.wait_until(lock, wakeup_pt);
            if (exit_) return;

            bool boost_active = boost_end_ > steady_clock::now() || boost_en_;

            ALOGV("Process Boost active: %i", (int)boost_active);

            if (boost_active) {
                if (!boosted) {
                    ALOGV("Boost");
                    boosted = true;
                    BoostAll(boosted);
                }
            }

            if (!boost_active) {
                if (boosted) {
                    ALOGV("Cancel boost");
                    boosted = false;
                    BoostAll(boosted);
                }
            }

            if (boost_active && !boost_en_) {
                wakeup_pt = boost_end_;
            } else {
                wakeup_pt = time_point<steady_clock>::max();
            }
        }
    }
};

}  // namespace android
}  // namespace aidl
