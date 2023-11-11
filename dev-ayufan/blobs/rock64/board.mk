UBOOT_DEFCONFIG ?= rock64-rk3328_defconfig
BL31 ?= tmp/rkbin/bin/rk33/rk322xh_bl31_v1.49.elf
BOARD_CHIP ?= rk3328
ifneq (,$(FLASH_SPI))
LOADER_BIN ?= tmp/rkbin/loaders/rk3328_loader_v1.08.244_for_spi_nor_build_Aug_7_2017.bin
else
LOADER_BIN ?= tmp/rkbin/loaders/rk3328_loader_v1.19.250.bin
endif
LOADER_OFFSET ?= 64
LOADER_FLASH ?= rksd_loader
IMAGES ?= flash-spi erase-spi
FLASH_LOADER ?= rksd_loader
LOADERS ?= rksd_loader
