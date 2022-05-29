#!/system/bin/sh

first_run=$(getprop persist.glodroid.first_run)

ARCH=$(getprop ro.bionic.arch)
APK_PATH=/vendor/etc/preinstall

install_apk() {
   echo Installing $1
   [[ -f "$APK_PATH/$1_$ARCH" ]] && pm install -g "$APK_PATH/$1_$ARCH" && return
   [[ -f "$APK_PATH/$1_all" ]] && pm install -g "$APK_PATH/$1_all" && return
}

echo ${first_run}
if [ "${first_run}" != "false" ]; then

   install_apk fenix.apk
   install_apk skytube.apk
   install_apk fdroid.apk
   install_apk shade-launcher3.apk

   setprop persist.glodroid.first_run false
fi
