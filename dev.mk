export RELEASE ?= 1

all:

ifeq (,$(BOARD_TARGET))

all:
	@echo $(addsuffix -board,$(notdir $(wildcard dev-ayufan/blobs/*)))

all-boards: $(addsuffix -board,$(notdir $(wildcard dev-ayufan/blobs/*)))

%-board:
	./dev-make BOARD_TARGET=$(patsubst %-board,%,$@)

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
