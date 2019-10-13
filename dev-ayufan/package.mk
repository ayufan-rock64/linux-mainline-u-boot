ifneq (,$(UBOOT_LOADERS))
UBOOT_PACKAGE_NAME = u-boot-$(BOARD_TARGET)-$(RELEASE_NAME)

.PHONY: u-boot-package
u-boot-package: $(UBOOT_LOADERS)
	fpm -s dir -t deb -n $(UBOOT_PACKAGE_NAME) -v $(RELEASE_NAME) \
		-p $(UBOOT_PACKAGE_NAME).deb \
		--deb-priority optional --category admin \
		--force \
		--depends debsums \
		--depends mtd-utils \
		--deb-field "Multi-Arch: foreign" \
		--deb-field "Replaces: u-boot-virtual, u-boot-mainline, u-boot-rockchip, u-boot-$(BOARD_TARGET), u-boot-$(BOARD_TARGET)" \
		--deb-field "Conflicts: u-boot-virtual, u-boot-mainline, u-boot-rockchip, u-boot-$(BOARD_TARGET), u-boot-$(BOARD_TARGET)" \
		--deb-field "Provides: u-boot-virtual, u-boot-mainline, u-boot-rockchip, u-boot-$(BOARD_TARGET), u-boot-$(BOARD_TARGET)" \
		--after-install dev-ayufan/scripts/postinst.deb \
		--before-remove dev-ayufan/scripts/prerm.deb \
		--url https://gitlab.com/ayufan-rock64/linux-build \
		--description "Rock64 U-boot package" \
		-m "Kamil Trzciński <ayufan@ayufan.eu>" \
		--license "MIT" \
		--vendor "Kamil Trzciński" \
		-a all \
		dev-ayufan/root/=/ \
		$(addsuffix =/usr/lib/u-boot-$(BOARD_TARGET)/,$(UBOOT_LOADERS))

u-boot-package-clean:
	rm -f u-boot-$(BOARD_TARGET)-*.deb

all: u-boot-package
clean: u-boot-package-clean
endif
