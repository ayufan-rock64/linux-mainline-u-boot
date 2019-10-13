BOARD_CHIP ?= rk3399
BL31 ?= tmp/rkbin/bin/rk33/rk3399_bl31_v1.36.elf
RKDEV_LOADER_BIN ?= tmp/rkbin/loaders/rk3399_loader_v1.30.130.bin
IMAGES ?= flash-spi erase-spi
LOADERS ?= rksd_loader rkspi_loader
IDBLOADER_OFFSET ?= 64
IDBLOADER_SPI_OFFSET ?= 0
