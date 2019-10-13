UBOOT_TMP_DIR ?= $(CURDIR)/tmp/u-boot-$(BOARD_TARGET)-build
UBOOT_OUTPUT_DIR ?= $(CURDIR)/tmp/u-boot-$(BOARD_TARGET)
UBOOT_MAKE ?= make KBUILD_OUTPUT=$(UBOOT_OUTPUT_DIR) BL31=$(realpath $(BL31)) ROCKCHIP_TPL=$(realpath $(ROCKCHIP_TPL)) \
	CROSS_COMPILE="ccache aarch64-linux-gnu-"

UBOOT_LOADERS ?= $(addprefix $(UBOOT_OUTPUT_DIR)/, $(addsuffix .img, $(LOADERS)))
UBOOT_TPL ?= $(UBOOT_OUTPUT_DIR)/tpl/u-boot-tpl.bin
UBOOT_SPL ?= $(UBOOT_OUTPUT_DIR)/spl/u-boot-spl.bin

tmp/u-boot-$(BOARD_TARGET)/.config: configs/$(UBOOT_DEFCONFIG)
	$(UBOOT_MAKE) $(UBOOT_DEFCONFIG)

$(UBOOT_OUTPUT_DIR):
	mkdir -p $@

$(UBOOT_OUTPUT_DIR)/u-boot.bin: .scmversion $(UBOOT_OUTPUT_DIR) tmp/u-boot-$(BOARD_TARGET)/.config $(BL31) $(ROCKCHIP_TPL)
	$(UBOOT_MAKE) -j $$(nproc)

$(UBOOT_OUTPUT_DIR)/u-boot.itb: $(UBOOT_OUTPUT_DIR)/u-boot.bin
	#grep CONFIG_LED=y $(UBOOT_OUTPUT_DIR)/.config
	#grep CONFIG_CMD_USB_MASS_STORAGE=y $(UBOOT_OUTPUT_DIR)/.config
	$(UBOOT_MAKE) -j $$(nproc) u-boot.itb

$(UBOOT_TPL) $(UBOOT_SPL): $(UBOOT_OUTPUT_DIR)/u-boot.itb

$(UBOOT_OUTPUT_DIR)/rksd_loader.img: $(UBOOT_OUTPUT_DIR)/u-boot.itb $(UBOOT_TPL) $(UBOOT_SPL)
	grep CONFIG_SYS_MMCSD_RAW_MODE_U_BOOT_SECTOR= $(UBOOT_OUTPUT_DIR)/.config
	dev-ayufan/scripts/build_loader $@ $(UBOOT_OUTPUT_DIR)/idbloader.img $(IDBLOADER_OFFSET) $(UBOOT_OUTPUT_DIR) CONFIG_SYS_MMCSD_RAW_MODE_U_BOOT_SECTOR 512

$(UBOOT_OUTPUT_DIR)/rkspi_loader.img: $(UBOOT_OUTPUT_DIR)/u-boot.itb $(UBOOT_TPL) $(UBOOT_SPL)
	grep CONFIG_SPL_SPI_LOAD=y $(UBOOT_OUTPUT_DIR)/.config
	grep CONFIG_SYS_SPI_U_BOOT_OFFS= $(UBOOT_OUTPUT_DIR)/.config
	grep CONFIG_ROCKCHIP_SPI_IMAGE=y $(UBOOT_OUTPUT_DIR)/.config
	dev-ayufan/scripts/build_loader $@ $(UBOOT_OUTPUT_DIR)/idbloader-spi.img $$(($(IDBLOADER_SPI_OFFSET)*512)) $(UBOOT_OUTPUT_DIR) CONFIG_SYS_SPI_U_BOOT_OFFS 1

.PHONY: u-boot-menuconfig		# edit u-boot config and save as defconfig
u-boot-menuconfig:
	$(UBOOT_MAKE) ARCH=arm64 $(UBOOT_DEFCONFIG)
	$(UBOOT_MAKE) ARCH=arm64 menuconfig
	$(UBOOT_MAKE) ARCH=arm64 savedefconfig
	mv $(UBOOT_OUTPUT_DIR)/defconfig configs/$(UBOOT_DEFCONFIG)

.PHONY: u-boot-build		# compile u-boot
u-boot-build: $(UBOOT_LOADERS)

.PHONY: u-boot-bin
u-boot-bin: $(UBOOT_OUTPUT_DIR)/u-boot.bin

.PHONY: u-boot-clean
u-boot-clean:
	rm -rf $(UBOOT_OUTPUT_DIR)
	rm -rf $(UBOOT_TMP_DIR)

all: u-boot-bin u-boot-build
clean: u-boot-clean
