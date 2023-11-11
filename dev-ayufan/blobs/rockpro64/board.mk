UBOOT_DEFCONFIG ?= rockpro64-rk3399_defconfig
BL31 ?= tmp/rkbin/bin/rk33/rk3399_bl31_v1.36.elf
BOARD_CHIP ?= rk3399
ifneq (,$(FLASH_SPI))
LOADER_BIN ?= tmp/rkbin/loaders/rk3399_loader_spinor_v1.30.114.bin
LOADER_OFFSET ?= 0
LOADER_FLASH ?= rkspi_loader
else
LOADER_BIN ?= tmp/rkbin/loaders/rk3399_loader_v1.30.130.bin
LOADER_OFFSET ?= 64
LOADER_FLASH ?= rksd_loader
endif
IMAGES ?= flash-spi erase-spi
LOADERS ?= rksd_loader rkspi_loader
