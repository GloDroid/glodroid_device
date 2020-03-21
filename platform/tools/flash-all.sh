#!/bin/sh -xe

fastboot flash bootloader bootloader.img
fastboot flash env        env.img
fastboot flash misc       misc.img
fastboot flash boot_a     boot.img
fastboot flash dtbo_a     boot_dtbo.img
fastboot flash metadata   metadata.img
fastboot flash system     system.img
fastboot flash vendor     vendor.img
fastboot flash product    product.img
fastboot reboot
