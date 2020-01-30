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

	sgdisk --move-second-header $SDIMG

	sgdisk --new $pn:$(( PTR / 512 )):$(( ($PTR + $SIZE - 1) / 512 )) --change-name=$pn:"$2" ${SDIMG}

	dd if=$1 of=$SDIMG bs=4096 count=$(( SIZE/4096 )) seek=$(( $PTR / 4096 )) conv=notrunc && sync

	PTR=$(( $PTR + $SIZE ))
	pn=$(( $pn+1 ))
}

prepare_disk() {
    echo "===> Create raw disk image"
    rm -f $1
    dd if=/dev/zero of=$1 bs=4096 count=$(( (PART_START + GPT_SIZE * 2) / 4096 ))
    sgdisk --zap-all $1

    echo "===> Reduce GPT to have 56 partitions max (LBA 2-15, u-boot is located starting from LBA 16)"
    gdisk $1<<EOF
x
s
56
w
Y
EOF

    echo "===> Put u-boot with spl to image"
    dd if=u-boot-sunxi-with-spl.bin of=$1 bs=1024 seek=8 conv=notrunc
}

prepare_disk ${SDIMG}
prepare_disk sdcard_net.img

echo "===> Create env.img"
rm -f env.img
mkfs.vfat -n "orange-pi" -S 512 -C env.img $(( 256 ))
mcopy -i env.img -s boot.scr ::boot.scr

rm -f env_net.img
mkfs.vfat -n "orange-pi" -S 512 -C env_net.img $(( 256 ))
mcopy -i env_net.img -s boot_net.scr ::boot.scr

dd if=/dev/zero of=misc.img bs=4096 count=$(( (1024 * 512) / 4096 ))

dd if=/dev/zero of=metadata.img bs=4k count=$(( (1024 * 1024 * 16) / 4096 ))

echo "===> Add partitions"
add_part env.img env
add_part misc.img misc
add_part boot.img boot_a
add_part dtb.img dtb_a
add_part vendor.img vendor_a
add_part system.img system_a
add_part product.img product_a
#add_part vbmeta.img vbmeta
add_part userdata.img userdata
add_part metadata.img metadata

chmod a+w ${SDIMG} # nbd-server runs from root and needs write access
lz4c -f ${SDIMG} ${SDIMG}.lz4

echo "===> Add partition with bootscript for netboot sdcard image"
SDIMG=sdcard_net.img
PTR=$PART_START
pn=1
add_part env_net.img env
