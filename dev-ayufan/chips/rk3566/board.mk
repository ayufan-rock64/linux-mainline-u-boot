BL31 ?= tmp/rkbin/bin/rk35/rk3568_bl31_v1.43.elf
BOARD_CHIP ?= rk3566
UBOOT_TPL =
ROCKCHIP_TPL ?= tmp/rkbin/bin/rk35/rk3566_ddr_1056MHz_v1.18.bin
IMAGES ?= flash-spi erase-spi
LOADERS ?= rksd_loader rkspi_loader
IDBLOADER_OFFSET ?= 64
IDBLOADER_SPI_OFFSET ?= 64
