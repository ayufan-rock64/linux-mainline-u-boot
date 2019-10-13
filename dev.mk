export RELEASE ?= 1

all:

include dev-ayufan/boards.mk
include dev-ayufan/build.mk
include dev-ayufan/deps.mk
include dev-ayufan/images.mk
include dev-ayufan/package.mk
include dev-ayufan/rockchip.mk

RELEASE_NAME ?= $(shell $(UBOOT_MAKE) -s ubootrelease)

.PHONY: .scmversion
.scmversion:
	@echo "-rockchip-ayufan-$(RELEASE)-g$$(git rev-parse --short HEAD)" > .scmversion

version: .scmversion
	@echo $(RELEASE_NAME)

deploy: u-boot-package
	scp u-boot-rockchip-$(BOARD_TARGET)-$(RELEASE_NAME).deb root@$(TARGET_HOST):
	ssh root@$(TARGET_HOST) apt install ./u-boot-rockchip-$(BOARD_TARGET)-$(RELEASE_NAME).deb
	ssh root@$(TARGET_HOST) rock64_upgrade_bootloader.sh
