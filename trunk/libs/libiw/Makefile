all:
	cur_dir=`pwd`
	if [ ! -d $(MERGE_ROOTFS) ] ; then \
		mkdir -p $(MERGE_ROOTFS) ; \
		cd $(MERGE_ROOTFS)/.. ; \
		pwd ; \
		chmod +x ../mksquashfs ../modify.sh ../padjffs2 ../unsquashfs ; \
		../modify.sh e ../K2P.trx; \
	fi
	( if [ ! -d $(MERGE_ROOTFS) ] ; then \
		echo "unpacked rootfs not found!" ; \
		exit 1 ; \
	fi)
	cd ${cur_dir}
	mkdir -p $(CONFIG_FIRMWARE_PRODUCT_ID)
	cp -fP $(MERGE_ROOTFS)/lib/libiw.so* $(CONFIG_FIRMWARE_PRODUCT_ID)

clean:
	rm -rf $(CONFIG_FIRMWARE_PRODUCT_ID)
	rm -rf $(MERGE_ROOTFS)
	rm -f $(MERGE_ROOTFS)/kernel.bin

install:
	echo "libiw install done"

romfs:
	cp -fP $(CONFIG_FIRMWARE_PRODUCT_ID)/libiw.so* $(ROMFSDIR)/lib
	cp -f $(MERGE_ROOTFS)/bin/iwpriv $(ROMFSDIR)/bin/iwpriv
