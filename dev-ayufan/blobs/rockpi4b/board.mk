UBOOT_DEFCONFIG ?= rock-pi-4-rk3399_defconfig
BL31 ?= tmp/rkbin/bin/rk33/rk3399_bl31_v1.36.elf
BOARD_CHIP ?= rk3399
LOADER_BIN ?= tmp/rkbin/loaders/rk3399_loader_v1.30.130.bin
IMAGES ?= flash-spi erase-spi
FLASH_LOADER ?= rksd_loader
LOADERS ?= rksd_loader rkspi_loader
