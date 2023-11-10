ifeq (rock64,$(BOARD_TARGET))

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

else ifeq (rockpro64,$(BOARD_TARGET))

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

else ifeq (rockpi4b,$(BOARD_TARGET))

UBOOT_DEFCONFIG ?= rock-pi-4-rk3399_defconfig
BL31 ?= tmp/rkbin/bin/rk33/rk3399_bl31_v1.36.elf
BOARD_CHIP ?= rk3399
LOADER_BIN ?= tmp/rkbin/loaders/rk3399_loader_v1.30.130.bin
IMAGES ?= flash-spi erase-spi
FLASH_LOADER ?= rksd_loader
LOADERS ?= rksd_loader rkspi_loader

else ifeq (pinebookpro,$(BOARD_TARGET))

UBOOT_DEFCONFIG ?= pinebook-pro-rk3399_defconfig
BL31 ?= tmp/rkbin/bin/rk33/rk3399_bl31_v1.36.elf
BOARD_CHIP ?= rk3399
LOADER_BIN ?= tmp/rkbin/loaders/rk3399_loader_v1.30.130.bin
LOADER_OFFSET ?= 64
LOADER_FLASH ?= rksd_loader
IMAGES ?= flash-spi erase-spi
LOADERS ?= rksd_loader rkspi_loader

else ifeq (rockpi5b,$(BOARD_TARGET))

UBOOT_DEFCONFIG ?= rock5b-rk3588_defconfig
BL31 ?= tmp/rkbin/bin/rk35/rk3588_bl31_v1.40.elf
BOARD_CHIP ?= rk3588
UBOOT_TPL =
ROCKCHIP_TPL ?= tmp/rkbin/bin/rk35/rk3588_ddr_lp4_2112MHz_lp5_2736MHz_v1.12.bin
LOADER_BIN ?= tmp/rkbin/loaders/rk3588_spl_loader_v1.12.112.bin
LOADER_OFFSET ?= 64
LOADER_FLASH ?= rksd_loader
IMAGES ?= flash-spi erase-spi
LOADERS ?= rksd_loader rkspi_loader
RKSD_LOADER ?= idbloader.img
RKSPI_LOADER ?= idbloader-spi.img

else ifeq (qemu-arm64,$(BOARD_TARGET))

UBOOT_DEFCONFIG ?= qemu_arm64_defconfig

else
$(error Unsupported BOARD_TARGET)
endif
