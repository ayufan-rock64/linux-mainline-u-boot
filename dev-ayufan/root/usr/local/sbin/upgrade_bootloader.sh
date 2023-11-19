#!/bin/bash

set -eo pipefail

source /usr/local/lib/u-boot-rockchip/loader-common

prompt() {
    cnt=1
    methods=()

    echo "############################"
    version2 "Latest version" "$SD_LOADER"

    while read MNT_DEV; do
        version2 "$MNT_DEV" "$MNT_DEV"

        echo "$cnt) Install u-boot on $MNT_DEV"
        methods[$cnt]="dd if=\"$SD_LOADER\" of=\"$MNT_DEV\" iflag=fullblock oflag=direct"
        cnt=$((cnt+1))
        echo "$cnt) Remove bootloader on $MNT_DEV"
        methods[$cnt]="dd if=/dev/zero of=\"$MNT_DEV\" bs=32768 iflag=fullblock oflag=direct || true"
        cnt=$((cnt+1))
        echo
    done < <(blkid /dev/disk/by-id/{ata,usb,mmc}-* -o device -t PARTLABEL="loader1")

    if find_mtd; then
        version2 "SPI Flash" "$MTD_DEV"

        echo "$cnt) Install u-boot on $MTD_DEV"
        methods[$cnt]="flash_erase \"$MTD_DEV\" \"$MTD_OFFSET\" 0 && nandwrite -s \"$MTD_OFFSET\" \"$MTD_DEV\" \"$SPI_LOADER\""
        cnt=$((cnt+1))
        echo "$cnt) Remove bootloader on $MTD_DEV"
        methods[$cnt]="flash_erase \"$MTD_DEV\" \"$MTD_OFFSET\" 0"
        cnt=$((cnt+1))
        echo
    fi
    echo "############################"

    while true; do
        echo "Select one of the options or Ctrl-C to abort:"
        read OPTION
        echo

        if [[ -z "${methods[$OPTION]}" ]]; then
            echo "The '$OPTION' is invalid option"
            continue
        fi

        echo "Executing '${methods[$OPTION]}'..."
        confirm
        eval "${methods[$OPTION]}"
        echo
        return
    done
}

while true; do
    prompt
done
