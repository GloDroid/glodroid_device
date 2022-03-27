#!/system/bin/sh

first_run=$(getprop persist.glodroid.first_run)
echo ${first_run}
if [ "${first_run}" != "false" ]; then

   pm install -g "/vendor/etc/preinstall/fenix.apk_"

   pm install -g "/vendor/etc/preinstall/skytube.apk_"

   pm install -g "/vendor/etc/preinstall/fdroid.apk_"

   pm install -g "/vendor/etc/preinstall/shade-launcher3.apk_"

   setprop persist.glodroid.first_run false
fi
