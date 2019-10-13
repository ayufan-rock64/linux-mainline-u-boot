export RELEASE ?= 1

SHELL := /bin/bash

all:

ifeq (,$(BOARD_TARGET))

all: $(addsuffix -board,$(notdir $(wildcard dev-ayufan/blobs/*)))
clean: $(addsuffix -clean,$(notdir $(wildcard dev-ayufan/blobs/*)))

list:
	@echo $(addsuffix -board,$(notdir $(wildcard dev-ayufan/blobs/*)))

%-board:
	./dev-make BOARD_TARGET=$(patsubst %-board,%,$@) &> >(ts "[$(patsubst %-board,%,$@)]")

%-menuconfig:
	./dev-make u-boot-menuconfig BOARD_TARGET=$(patsubst %-menuconfig,%,$@)

%-clean:
	./dev-make clean BOARD_TARGET=$(patsubst %-clean,%,$@) &> >(ts "[$(patsubst %-clean,%,$@)]")

else

include dev-ayufan/blobs/$(BOARD_TARGET)/board.mk
include dev-ayufan/build.mk
include dev-ayufan/deps.mk
include dev-ayufan/images.mk
include dev-ayufan/package.mk
include dev-ayufan/rockchip.mk

RELEASE_NAME ?= $(shell $(UBOOT_MAKE) -s ubootrelease)

.PHONY: .scmversion
.scmversion:
	@echo "-ayufan-$(RELEASE)-g$$(git rev-parse --short HEAD)" > .scmversion

version: .scmversion
	@echo $(RELEASE_NAME)

deploy: u-boot-package
	scp u-boot-$(BOARD_TARGET)-$(RELEASE_NAME).deb root@$(TARGET_HOST):
	ssh root@$(TARGET_HOST) apt install --reinstall ./u-boot-$(BOARD_TARGET)-$(RELEASE_NAME).deb
	ssh root@$(TARGET_HOST) rock64_upgrade_bootloader.sh

endif
