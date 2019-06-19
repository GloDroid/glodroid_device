#!/bin/sh -e

SDIMG=sdcard.img

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

echo "===> Create raw disk image"
dd if=/dev/zero of=${SDIMG} bs=4096 count=$(( (PART_START + GPT_SIZE * 2) / 4096 ))
sgdisk -Z ${SDIMG}

echo "===> Reduce GPT to have 56 partitions max (LBA 2-15, u-boot is located starting from LBA 16)"
gdisk ${SDIMG}<<EOF
x
s
56
w
Y
EOF

echo "===> Create env.img"
rm -f env.img
sync
mkfs.vfat -n "orange-pi" -S 512 -C env.img $(( 1024 * 32 ))
mcopy -i env.img -s boot.scr ::boot.scr

echo "===> Add partitions"
add_part env.img env
add_part boot.img boot_a
add_part dtb.img dtb_a
add_part vendor.img vendor_a
add_part system.img system_a
#add_part vbmeta.img vbmeta
add_part userdata.img userdata

echo "===> Put u-boot with spl to image"
dd if=u-boot-sunxi-with-spl.bin of=${SDIMG} bs=1024 seek=8 conv=notrunc
