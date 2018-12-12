
ifndef ROOTDIR
ROOTDIR=../..
endif

ROMFS_DIR = $(ROOTDIR)/romfs

THISDIR = $(shell pwd)

all:

clean:

romfs:
	echo "use $(ROMFSINST) install xunlei..."
#	$(ROMFSINST) /usr/bin/xunlei.sh
#	$(ROMFSINST) /etc_ro/xware.tgz
#	$(ROMFSINST) /www/Advanced_xunlei.asp
	$(ROMFSINST) $(THISDIR)/xunlei.sh /usr/bin/xunlei.sh
	$(ROMFSINST) $(THISDIR)/xware.tgz /etc_ro/xware.tgz
#	$(ROMFSINST) $(THISDIR)/xunlei_mips_le_mips32-v2.207.3.310.tar.gz /etc_ro/xware.tgz
	$(ROMFSINST) $(THISDIR)/Advanced_xunlei.asp /www/Advanced_xunlei.asp
	rm -f $(ROMFS_DIR)/www/Advanced_AiDisk_xunlei.asp
