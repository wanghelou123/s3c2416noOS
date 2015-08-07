#!/bin/bash

DEV_NAME=sde
BLOCK_CNT=`cat /sys/block/${DEV_NAME}/size`

if [ ${BLOCK_CNT} -le 0 ]; then
	echo "Error: NO media found in card reader."
	exit 1
fi

if [ ${BLOCK_CNT} -gt 32000000 ]; then
	echo "Error: Block device size (${BLOCK_CNT}) is too large"
	exit 1
fi

let FIRMWARE1_POSITON=${BLOCK_CNT}-16-2-1024
let FIRMWARE2_POSITON=${BLOCK_CNT}-16-2-1024-256
set -x
umount /dev/sde1 2>/dev/null
umount /dev/sde2 2>/dev/null
umount /dev/sde3 2>/dev/null
umount /dev/sde4 2>/dev/null

dd if=./led_on.bin of=/dev/${DEV_NAME} bs=512 seek=${FIRMWARE1_POSITON}
dd if=./led_on.bin of=/dev/${DEV_NAME} bs=512 seek=${FIRMWARE2_POSITON}
sync

