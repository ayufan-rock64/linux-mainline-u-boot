$(filter tmp/rkbin/%, $(BL31) $(UBOOT_TPL) $(UBOOT_SPL) $(LOADER_BIN)):
	mkdir -p $$(dirname "$@")
	curl --fail -L https://github.com/ayufan-rock64/rkbin/raw/master/$(subst tmp/rkbin/,,$@) > $@.tmp
	mv $@.tmp $@

$(filter tmp/atf/%, $(BL31)):
	rm -rf $$(dirname "$@")/$$(basename "$@" .elf)/src
	git clone https://github.com/ARM-software/arm-trusted-firmware.git $$(dirname "$@")/$$(basename "$@" .elf)/src
	git -C $$(dirname "$@")/$$(basename "$@" .elf)/src checkout $$(basename "$@" .elf)
	make -C $$(dirname "$@")/$$(basename "$@" .elf)/src PLAT=$(BOARD_CHIP) CROSS_COMPILE="ccache aarch64-linux-gnu-" M0_CROSS_COMPILE="ccache arm-linux-gnueabi-" bl31
	cp $$(dirname "$@")/$$(basename "$@" .elf)/src/build/$(BOARD_CHIP)/release/bl31/bl31.elf $@
