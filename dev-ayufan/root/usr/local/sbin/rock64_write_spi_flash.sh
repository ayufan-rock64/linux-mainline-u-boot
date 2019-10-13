#!/bin/bash

set -eo pipefail

source /usr/local/lib/u-boot-rockchip/loader-common

echo "Doing this will overwrite data stored on SPI Flash"
echo "  and it will require that you use eMMC or SD"
echo "  as your boot device."
echo ""

find_mtd
version "$MTD_DEV"
confirm

echo "Writing "$MTD_DEV" with content at $MTD_OFFSET"
flash_erase "$MTD_DEV" "$MTD_OFFSET" 0
nandwrite -s "$MTD_OFFSET" "$MTD_DEV" "$SPI_LOADER"

echo Done.
