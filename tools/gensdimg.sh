#!/bin/sh -e

# It is possible to use the first parameter for setting a dtb-file name, eg:
# ./gensdimg.sh sun8i-h3-orangepi-one.dtb

DTB_NAME=sun8i-h3-orangepi-one.dtb

if [ $1 ]
then DTB_NAME=$1
fi

SDIMG=generated/sdcard.img

PART_START=$(( 2048 * 1024 ))
ALIGN=1048576

PTR=$PART_START
GPT_SIZE=$(( 512 * 34 ))
pn=1

add_part() {
	SIZE=$(stat $1 -c%s)
	# Align size
	SIZE="$(( ($SIZE / $ALIGN + 1) * $ALIGN))"
	echo $1: size=$SIZE
	echo $1: partition offset=$PTR

	dd if=/dev/null of=$SDIMG bs=1 count=1 seek=$(( $PTR + $SIZE + $GPT_SIZE ))

	sgdisk -e $SDIMG

	sgdisk -n $pn:$(( PTR / 512 )):$(( ($PTR + $SIZE - 1) / 512 )) -c=$pn:"$2" ${SDIMG}

	dd if=$1 of=$SDIMG bs=4096 count=$(( SIZE/4096 )) seek=$(( $PTR / 4096 )) conv=notrunc && sync

	PTR=$(( $PTR + $SIZE ))
	pn=$(( $pn+1 ))
}

# Create raw disk image
dd if=/dev/zero of=${SDIMG} bs=4096 count=$(( (PART_START + GPT_SIZE * 2) / 4096 ))
sgdisk -Z ${SDIMG}

# Reduce GPT to have 56 partitions max (LBA 2-15, u-boot is located starting from LBA 16)
gdisk ${SDIMG}<<EOF
x
s
56
w
Y
EOF

mkdir -p generated

# Compiling boot script
mkimage -A arm -O linux -T script -C none -a 0 -e 0 -d boot.txt generated/boot.scr

# Create boot.img
rm generated/boot.img
mkfs.vfat -n "orange-pi" -S 512 -C generated/boot.img $(( 1024 * 32 ))

dtc -@ -I dts -O dtb -o generated/fstab-android-sdcard.dtb fstab-android-sdcard.dts
mcopy -i generated/boot.img -s zImage ::zImage
mcopy -i generated/boot.img -s generated/fstab-android-sdcard.dtb ::fstab-android-sdcard.dtb
mcopy -i generated/boot.img -s generated/boot.scr ::boot.scr
mcopy -i generated/boot.img -s ${DTB_NAME} ::${DTB_NAME}

# Add partitions
add_part generated/boot.img boot
add_part vendor.img vendor
add_part system.img system
#add_part vbmeta.img vbmeta
add_part userdata.img userdata

# Put u-boot with spl to image
dd if=u-boot-sunxi-with-spl.bin of=${SDIMG} bs=1024 seek=8 conv=notrunc
