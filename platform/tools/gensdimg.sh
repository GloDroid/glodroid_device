#!/bin/bash -e

PLATFORM=sunxi

# Old Allwinner boot ROM looks for the SPL binary starting from 16th LBA of SDCARD and EMMC.
# Newer Alwinner SOCs including H3, A64, and later is looking for SPL at both 16th LBA and 256th LBA.
# Align first partition to 256th LBA to allow update bootloader binaries using fastboot.
PART_START=$(( 256 * 512 ))

# 1 MiB alignment is relevant for USB flash devices. Follow that rules to improve
# read performance when using SDCARD with USB card reader.
ALIGN=$(( 2048 * 512 ))

PTR=$PART_START
pn=1

add_part() {
	SIZE=$(stat $1 -c%s)
	# Align size
	echo $1: size=$SIZE
	echo $1: partition offset=$PTR

	if [ -z "$3" ]; then
	    SGCMD="--new $pn:$(( PTR / 512 )):$(( ($PTR + $SIZE - 1) / 512 ))"
	else
	    SGCMD="--largest-new=$pn"
	fi

	sgdisk --set-alignment=1 $SGCMD --change-name=$pn:"$2" ${SDIMG}

	dd if=$1 of=$SDIMG bs=4k count=$(( SIZE/4096 )) seek=$(( $PTR / 4096 )) conv=notrunc && sync

	PTR=$(( ($PTR + $SIZE + $ALIGN - 1) / $ALIGN * $ALIGN ))
	pn=$(( $pn+1 ))
}

prepare_disk() {
    if [ -e "$SDIMG" ]; then
        SDSIZE=$(stat $SDIMG -c%s)
    else
        SDSIZE=$(( 1024 * 1024 * $1 ))
        echo "===> Create raw disk image"
        dd if=/dev/zero of=$SDIMG bs=4096 count=$(( $SDSIZE / 4096 ))
    fi;

    echo "===> Clean existing partition table"
    sgdisk --zap-all $SDIMG
}

modify_for_rpi() {
    echo "===> Transforming GPT to hybrid partition table"
    gdisk $SDIMG <<EOF
r
h
1
n
04
y
n
m
w
y
EOF
}

gen_sd() {
    prepare_disk $(( 1024 * 8 )) # Default size - 8 GB

    dd if=/dev/zero of=misc.img bs=4096 count=$(( (1024 * 512) / 4096 ))

    dd if=/dev/zero of=metadata.img bs=4k count=$(( (1024 * 1024 * 16) / 4096 ))

    echo "===> Add partitions"
    add_part bootloader-sd.img bootloader
    add_part env.img uboot-env
    add_part boot.img recovery_boot
    add_part misc.img misc
    add_part boot.img boot
    add_part boot_dtbo.img dtbo_a
    add_part metadata.img metadata
    add_part super.img super
    add_part vbmeta.img vbmeta
    add_part metadata.img userdata fit

    if [ "$PLATFORM" = "broadcom" ]; then
        modify_for_rpi
    fi
}

gen_deploy() {
    local SUFFIX=$1
    prepare_disk $(( 256 )) # Default size - 256 MB

    echo "===> Add partitions"
    if [ "$PLATFORM" = "rockchip" ] && [ "$SUFFIX" == "emmc" ]; then
        add_part bootloader-deploy-emmc.img bootloader
    else
        add_part bootloader-$SUFFIX.img bootloader
    fi
    add_part env.img uboot-env
    add_part boot.img recovery_boot

    if [ "$PLATFORM" = "broadcom" ]; then
        modify_for_rpi
    fi
}

for i in "$@"
do
case $i in
    -C=*|--directory=*)
    cd "${i#*=}"
    shift
    ;;
    -T=*|--type=*)
    TYPE="${i#*=}"
    shift
    ;;
    -P=*|--platform=*)
    PLATFORM="${i#*=}"
    shift
    ;;
    *)
    ;;
esac
done

if [ "$PLATFORM" = "rockchip" ]; then
    PART_START=$(( 64 * 512 ))
    PTR=$PART_START
fi

if [[ -n $1 ]]; then
    SDIMG=$1
else
    SDIMG=sdcard.img
fi

case $TYPE in
    DEPLOY-SD)
    gen_deploy "sd"
    ;;
    DEPLOY-SD-FOR-EMMC)
    gen_deploy "emmc"
    ;;
    SD|*)
    gen_sd
    ;;
esac
