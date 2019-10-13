BL31 ?= tmp/rkbin/bin/rk33/rk322xh_bl31_v1.49.elf
BOARD_CHIP ?= rk3328
ifneq (,$(FLASH_SPI))
RKDEV_LOADER_BIN ?= tmp/rkbin/loaders/rk3328_loader_v1.08.244_for_spi_nor_build_Aug_7_2017.bin
else
RKDEV_LOADER_BIN ?= tmp/rkbin/loaders/rk3328_loader_v1.19.250.bin
endif
IMAGES ?= flash-spi erase-spi
LOADERS ?= rksd_loader rkspi_loader
IDBLOADER_OFFSET ?= 64
IDBLOADER_SPI_OFFSET ?= 64
