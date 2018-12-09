THISDIR = $(shell pwd)

all:

clean:

romfs:
	$(ROMFSINST) -x $(THISDIR)/koolshare-aliddns/aliddns/scripts/aliddns_config.sh /usr/bin/aliddns_config.sh
	$(ROMFSINST) -x $(THISDIR)/koolshare-aliddns/aliddns/scripts/aliddns_update.sh /usr/bin/aliddns_update.sh
	$(ROMFSINST) $(THISDIR)/koolshare-aliddns/aliddns/webs/Module_aliddns.asp /www/Module_aliddns.asp
