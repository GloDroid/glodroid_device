// Android fstab file. cpp extension is used to pass C preprocessor
//<src>                                           <mnt_point> <type> <mnt_flags and options> <fs_mgr_flags>
// The filesystem that contains the filesystem checker binary (typically /system) cannot
// specify MF_CHECK, and must come before any filesystems that do specify MF_CHECK

// '<ALL>' will be replaced with '*' . '*' can't be used since it will be interpreted as a comment by C preprocessor

#ifdef platform_sunxi
#define __FILE_ENCRYPT__ fileencryption=adiantum,metadata_encryption=adiantum
#else
#define __FILE_ENCRYPT__ fileencryption=aes-256-xts:aes-256-cts
#endif

system                              /system         ext4    ro,barrier=1,discard                  wait,first_stage_mount,logical,slotselect
system_ext                          /system_ext     ext4    ro,barrier=1,discard                  wait,first_stage_mount,logical,slotselect
vendor                              /vendor         ext4    ro,barrier=1,discard                  wait,first_stage_mount,logical,slotselect
product                             /product        ext4    ro,barrier=1,discard                  wait,first_stage_mount,logical,slotselect
vendor_dlkm                         /vendor_dlkm    ext4    ro,noatime,errors=panic               wait,first_stage_mount,logical,slotselect

/dev/block/by-name/metadata         /metadata       ext4    noatime,nosuid,nodev,discard,sync     wait,check,formattable,first_stage_mount
/dev/block/by-name/misc             /misc           emmc    defaults                              defaults
/dev/block/by-name/pst              /persistent     emmc    defaults                              defaults
/dev/block/by-name/boot             /boot           emmc    defaults                              defaults,slotselect
/dev/block/by-name/userdata         /data           ext4    noatime,nosuid,nodev,barrier=1        wait,check,latemount,quota,formattable,__FILE_ENCRYPT__,keydirectory=/metadata/vold/metadata_encryption

// USB storage
#ifdef platform_broadcom
/devices/platform/scb/<ALL>.pcie/<ALL>/<ALL>/<ALL>/usb<ALL>    auto   auto    defaults            voldmanaged=usb:auto,encryptable=userdata
#else
/devices/platform/soc/<ALL>/usb<ALL>                  auto            auto    defaults            voldmanaged=usb:auto,encryptable=userdata
#endif
