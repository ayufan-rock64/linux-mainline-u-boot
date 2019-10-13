#!/bin/bash

set -eo pipefail

source /usr/local/lib/u-boot-rockchip/loader-common

echo "Doing this will erase bootloader stored on your boot device"
echo "  and it might break your system."
echo "Use this only if you prefer to boot from SPI ('rock64_write_spi_flash.sh')."
echo "To bring back bootloader run 'rock64_upgrade_bootloader.sh'."
echo ""

MNT_DEV=$(findmnt /boot/efi -n -o SOURCE)

version "$MNT_DEV"
confirm

write_sd() {
    local DEVICE="$(boot_device "$1")"
    dd if="$2" of="${DEVICE}"
}

write_sd "$MNT_DEV" "/dev/zero"

sync

echo Done.
