#!/bin/sh -e

SDIMG=sdcard.img

if [ -e "$SDIMG" ]; then
    SDSIZE=$(stat $SDIMG -c%s)
else
    SDSIZE=$(( 1024 * 1024 * 1024 * 8 ))
    echo "===> Create raw disk image"
    dd if=/dev/zero of=$SDIMG bs=4096 count=$(( $SDSIZE / 4096 ))
fi;

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

	if [ -z "$3" ]; then
	    SGCMD="--new $pn:$(( PTR / 512 )):$(( ($PTR + $SIZE - 1) / 512 ))"
	else
	    SGCMD="--largest-new=$pn"
	fi

	sgdisk $SGCMD --change-name=$pn:"$2" ${SDIMG}

	dd if=$1 of=$SDIMG bs=4k count=$(( SIZE/4096 )) seek=$(( $PTR / 4096 )) conv=notrunc && sync

	PTR=$(( $PTR + $SIZE ))
	pn=$(( $pn+1 ))
}

prepare_disk() {
    echo "===> Clean existing partition table"
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

echo "===> Create env.img"
rm -f env.img
mkfs.vfat -n "orange-pi" -S 512 -C env.img $(( 256 ))
mcopy -i env.img -s boot.scr ::boot.scr

dd if=/dev/zero of=misc.img bs=4096 count=$(( (1024 * 512) / 4096 ))

dd if=/dev/zero of=metadata.img bs=4k count=$(( (1024 * 1024 * 16) / 4096 ))

echo "===> Add partitions"
add_part env.img env
add_part misc.img misc
add_part boot.img boot_a
add_part boot_dtbo.img dtbo_a
add_part metadata.img metadata
add_part super.img super
#add_part vbmeta.img vbmeta
add_part metadata.img userdata fit

chmod a+w ${SDIMG} # nbd-server runs from root and needs write access
#lz4c -f ${SDIMG} ${SDIMG}.lz4
