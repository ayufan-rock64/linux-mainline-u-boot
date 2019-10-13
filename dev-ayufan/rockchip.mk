.PHONY: loader-download-mode
loader-download-mode: $(LOADER_BIN)
	rkdeveloptool db $(LOADER_BIN)
	sleep 1s

.PHONY: loader-write-clear
loader-write-clear:
	rkdeveloptool rid
	dd if=/dev/zero of=$(UBOOT_OUTPUT_DIR)/clear.img count=1
	rkdeveloptool wl $(LOADER_OFFSET) $(UBOOT_OUTPUT_DIR)/clear.img
ifneq (,$(FULL_WIPE))
	rkdeveloptool wl 512 $(UBOOT_OUTPUT_DIR)/clear.img
	rkdeveloptool wl 1024 $(UBOOT_OUTPUT_DIR)/clear.img
endif

.PHONY: loader-write-flash
loader-write-flash:
	rkdeveloptool rid
	rkdeveloptool wl $(LOADER_OFFSET) $(UBOOT_OUTPUT_DIR)/$(LOADER_FLASH).img

.PHONY: loader-boot		# boot loader over USB
loader-boot: $(UBOOT_OUTPUT_DIR)/$(LOADER_FLASH).img
	./dev-make loader-download-mode
	./dev-make loader-write-flash
	./dev-make loader-write-clear
	rkdeveloptool rd
	sleep 1s

ifneq (,$(UBOOT_TPL))
	cat $(UBOOT_TPL) | openssl rc4 -K 7c4e0304550509072d2c7b38170d1711 | rkflashtool l
endif
ifneq (,$(UBOOT_SPL))
	cat $(UBOOT_SPL) | openssl rc4 -K 7c4e0304550509072d2c7b38170d1711 | rkflashtool L
endif

.PHONY: loader-flash		# flash loader to the device
loader-flash:
	./dev-make loader-download-mode
	./dev-make loader-write-flash
	rkdeveloptool rd

.PHONY: loader-wipe		# clear loader
loader-wipe:
	./dev-make loader-download-mode
	./dev-make loader-write-clear FULL_WIPE=1
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
