#!/bin/bash

set -eo pipefail

source /usr/local/lib/u-boot-rockchip/loader-common

echo "Doing this will overwrite data stored on SPI Flash"
echo "  and it will require that you use eMMC or SD"
echo "  as your boot device."
echo ""

if ! MTD=$(grep \"loader\" /proc/mtd | cut -d: -f1); then
    echo "loader partition on MTD is not found"
    exit 1
fi

version "/dev/${MTD}"
confirm

flash_erase "/dev/$MTD" 0 0

echo Done.
