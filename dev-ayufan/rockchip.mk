.PHONY: loader-download-mode
loader-download-mode: $(LOADER_BIN)
	rkdeveloptool db $(LOADER_BIN)
	sleep 1s

.PHONY: loader-boot		# boot loader over USB
loader-boot: $(UBOOT_LOADERS) $(UBOOT_TPL) $(UBOOT_SPL)
	./dev-make loader-download-mode
	rkdeveloptool rid
	dd if=/dev/zero of=$(UBOOT_OUTPUT_DIR)/clear.img count=1
	rkdeveloptool wl 64 $(UBOOT_OUTPUT_DIR)/clear.img
	rkdeveloptool wl 512 $(UBOOT_OUTPUT_DIR)/u-boot.itb
	rkdeveloptool rd
	sleep 1s

ifneq (,$(UBOOT_TPL))
	cat $(UBOOT_TPL) | openssl rc4 -K 7c4e0304550509072d2c7b38170d1711 | rkflashtool l
endif
ifneq (,$(UBOOT_SPL))
	cat $(UBOOT_SPL) | openssl rc4 -K 7c4e0304550509072d2c7b38170d1711 | rkflashtool L
endif

.PHONY: loader-flash		# flash loader to the device
loader-flash: $(UBOOT_LOADERS)
	./dev-make loader-download-mode
	sleep 1s
	rkdeveloptool rid
	rkdeveloptool wl 64 $<
	rkdeveloptool rd

.PHONY: loader-wipe		# clear loader
loader-wipe:
	dd if=/dev/zero of=$(UBOOT_OUTPUT_DIR)/clear.img count=1
	./dev-make loader-download-mode
	sleep 1s
	rkdeveloptool rid
	rkdeveloptool wl 64 $(UBOOT_OUTPUT_DIR)/clear.img
	rkdeveloptool rd

.PHONY: loader-writesd		# write loader to SD
loader-writesd: $(UBOOT_OUTPUT_DIR)/rksd_loader.img
	blkid -t PARTLABEL=loader1
	dd if=$(UBOOT_OUTPUT_DIR)/rksd_loader.img of=$$(blkid -t PARTLABEL=loader1 -o device) bs=1M
	sync

.PHONY: loader-clearsd
loader-clearsd:
	blkid -t PARTLABEL=loader1
	dd if=/dev/zero of=$(UBOOT_OUTPUT_DIR)/clear.img count=1
	dd if=$(UBOOT_OUTPUT_DIR)/clear.img of=$$(blkid -t PARTLABEL=loader1 -o device) bs=1M
	sync
