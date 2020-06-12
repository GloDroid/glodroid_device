/* SPDX-License-Identifier: Apache-2.0
 *
 * Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)
 *
 * This is GloDroid u-boot Bootscript macro file.
 * .cpp extension is used only to enable syntax highlighting.
 */

#include "bootscript.h"

#ifdef broadcom
setenv dtbaddr 0x1fa00000
setenv loadaddr 0x10008000
setenv dtboaddr 0x12008000
#endif

#ifdef sunxi
setenv dtbaddr 0x5fa00000
setenv loadaddr 0x50008000
setenv dtboaddr 0x52008000
#endif

/* EMMC cards have 512k erase block size. Align partitions accordingly to avoid issues with erasing. */

setenv partitions "uuid_disk=\${uuid_gpt_disk}"
EXTENV(partitions, ";name=bootloader,start=128K,size=130944K,uuid=\${uuid_gpt_bootloader}")
EXTENV(partitions, ";name=uboot-env,size=512K,uuid=\${uuid_gpt_reserved}")
EXTENV(partitions, ";name=recovery_boot,size=32M,uuid=\${uuid_gpt_boot_recovery}")
EXTENV(partitions, ";name=misc,size=512K,uuid=\${uuid_gpt_misc}")
EXTENV(partitions, ";name=boot_a,size=32M,uuid=\${uuid_gpt_boot_a}")
EXTENV(partitions, ";name=dtbo_a,size=8M,uuid=\${uuid_gpt_dtbo_a}")
EXTENV(partitions, ";name=vbmeta_a,size=512K,uuid=\${uuid_gpt_vbmeta_a}")
EXTENV(partitions, ";name=super,size=1200M,uuid=\${uuid_gpt_super}")
EXTENV(partitions, ";name=metadata,size=16M,uuid=\${uuid_gpt_metadata}")
EXTENV(partitions, ";name=userdata,size=-,uuid=\${uuid_gpt_userdata}")

setenv bootargs " init=/init rootwait ro androidboot.boottime=223.708 androidboot.selinux=permissive"
EXTENV(bootargs, " androidboot.revision=1.0 androidboot.board_id=0x1234567 androidboot.serialno=${serial#}")
EXTENV(bootargs, " androidboot.slot_suffix=_a firmware_class.path=/vendor/etc/firmware")
EXTENV(bootargs, " androidboot.verifiedbootstate=orange ${debug_bootargs}")

FUNC_BEGIN(enter_fastboot)
 setenv fastboot_fail 0
#ifdef sunxi
 /* OTG on sunxi require USB to be initialized */
 usb start ;
#endif
 fastboot 0 || setenv fastboot_fail 1;
 /* If for some reason uboot-fastboot fail for this board, fallback to fastbootd */
 if test STRESC(${fastboot_fail}) = STRESC(1);
 then
  /* If the sdcard image is deploy image - reformat the GPT to allow fastbootd to flash Android partitions */
  part start mmc \$mmc_bootdev misc misc_start || gpt write $partitions
  /* Boot into the fastbootd mode */
  bcb load $mmc_bootdev misc && bcb set command boot-fastboot && bcb store
 fi;
FUNC_END()

FUNC_BEGIN(bootcmd_bcb)
 /* ab_select is used as counter of failed boot attempts. After 14 failed boot attempt fallback to fastboot. */
 ab_select slot_name mmc \${mmc_bootdev}#misc || run enter_fastboot ;
 bcb load $mmc_bootdev misc ;
 /* Handle $ adb reboot bootloader */
 bcb test command = bootonce-bootloader && bcb clear command && bcb store && run enter_fastboot ;
 /* Handle $ adb reboot fastboot */
 bcb test command = boot-fastboot && setenv androidrecovery true ;
 /* Handle $ adb reboot recovery (Android 11+) */
 bcb test command = boot-recovery && setenv androidrecovery true ;
FUNC_END()

FUNC_BEGIN(bootcmd_prepare_env)
 setenv bootdevice_path STRESC(__SYSFS_MMC0_PATH__);
 if test STRESC(${mmc_bootdev}) = STRESC(1);
 then
  setenv bootdevice_path STRESC(__SYSFS_MMC1_PATH__);
 fi;
 FEXTENV(bootargs, " androidboot.boot_devices=\${bootdevice_path}") ;
FUNC_END()

FUNC_BEGIN(bootcmd_start)
 if test STRESC(\${androidrecovery}) != STRESC(true);
 then
  FEXTENV(bootargs, " androidboot.force_normal_boot=1") ;
 fi;
 abootimg addr \$loadaddr
 abootimg get recovery_dtbo dtbo_addr
 adtimg addr \${dtbo_addr}
#ifdef sunxi
 adtimg get dt --index=0 dtb_start dtb_size &&
 cp.b \$dtb_start \$dtbaddr \$dtb_size &&
 fdt addr \$dtbaddr &&
#endif
#ifdef broadcom
/* raspberrypi vc bootloader prepare fdt based on many factors. Use this fdt instead of dtb compiled by the kernel */
 fdt addr \${fdt_addr} &&
#endif
 adtimg get dt --index=1 dtb_start dtb_size &&
 cp.b \$dtb_start \$dtboaddr \$dtb_size &&
 fdt resize 8192 &&
 fdt apply \$dtboaddr &&
 FEXTENV(bootargs, " androidboot.dtbo_idx=0,1") ;
 /* START KERNEL */
 bootm \$loadaddr
 /* Should never get here */
FUNC_END()

FUNC_BEGIN(bootcmd_block)
 run bootcmd_bcb &&
 if test STRESC(${androidrecovery}) != STRESC(true);
 then
  part start mmc \$mmc_bootdev boot_a boot_start &&
  part size mmc \$mmc_bootdev boot_a boot_size
 else
  part start mmc \$mmc_bootdev recovery_boot boot_start &&
  part size mmc \$mmc_bootdev recovery_boot boot_size
 fi;
 mmc dev \$mmc_bootdev &&
 mmc read \$loadaddr \$boot_start \$boot_size
FUNC_END()

FUNC_BEGIN(bootcmd)
 run bootcmd_prepare_env ;
 run bootcmd_block ;
 run bootcmd_start ;
FUNC_END()

run bootcmd
