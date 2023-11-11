UBOOT_DEFCONFIG ?= pinebook-pro-rk3399_defconfig
BL31 ?= tmp/rkbin/bin/rk33/rk3399_bl31_v1.36.elf
BOARD_CHIP ?= rk3399
LOADER_BIN ?= tmp/rkbin/loaders/rk3399_loader_v1.30.130.bin
LOADER_OFFSET ?= 64
LOADER_FLASH ?= rksd_loader
IMAGES ?= flash-spi erase-spi
LOADERS ?= rksd_loader rkspi_loader
