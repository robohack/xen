XEN_ROOT = $(CURDIR)/../../..
include $(XEN_ROOT)/tools/Rules.mk

# Xen script dir and scripts to go there.
XEN_SCRIPTS :=
XEN_SCRIPTS += locking.sh
XEN_SCRIPTS += block
XEN_SCRIPTS += vif-bridge
XEN_SCRIPTS += vif-ip
XEN_SCRIPTS += qemu-ifup

XEN_SCRIPT_DATA :=
XEN_RCD_PROG := rc.d/xencommons rc.d/xendomains rc.d/xenwatchdog rc.d/xendriverdomain

# XXX this is wrong -- the config.status script should be used to regenerate any generated script!
.PHONY: all
all:

.PHONY: install
install: install-scripts install-rcd

.PHONY: uninstall
uninstall: uninstall-scripts uninstall-rcd

.PHONY: install-scripts
install-scripts:
	$(INSTALL_DIR) $(DESTDIR)$(XEN_SCRIPT_DIR)
	set -e; for i in $(XEN_SCRIPTS); \
	   do \
	   $(INSTALL_PROG) $$i $(DESTDIR)$(XEN_SCRIPT_DIR); \
	done
	set -e; for i in $(XEN_SCRIPT_DATA); \
	   do \
	   $(INSTALL_DATA) $$i $(DESTDIR)$(XEN_SCRIPT_DIR); \
	done

.PHONY: uninstall-scripts
uninstall-scripts:
	rm -f $(addprefix $(DESTDIR)$(XEN_SCRIPT_DIR)/, $(XEN_SCRIPTS))
	rm -f $(addprefix $(DESTDIR)$(XEN_SCRIPT_DIR)/, $(XEN_SCRIPT_DATA))

# XXX hotplugpath.sh should be sourced by the first non-comment line of each
# rc.d script's /etc/rc.conf.d/ file.  If the file already exists, and if the
# line exists, make sure it has the correct path to the script, else add the
# line and append the old contents; else if there's no file then create it with
# just the line.

.PHONY: install-rcd
install-rcd:
	$(INSTALL_DIR) $(DESTDIR)$(XEN_SCRIPT_DIR)
	$(INSTALL_DIR) $(DESTDIR)$(INITD_DIR)
	set -e; for i in $(XEN_RCD_PROG); \
	   do \
	   $(INSTALL_PROG) $$i $(DESTDIR)$(INITD_DIR); \
	   dest=$(DESTDIR)$(subst rc.d,rc.conf.d,$(INITD_DIR))/$$(basename $$i); \
	   if [ -f $$dest ]; \
	   then \
	      if [ grep '^\.[ 	].*/hotplugpath.sh' $$dest > /dev/null 2>&1 ]; \
	      then \
	         sed 's|^\.[ 	].*/hotplugpath.sh|. $(XEN_SCRIPT_DIR)/hotplugpath.sh|' $$dest > $$dest-new; \
	      else \
	         echo '. $(XEN_SCRIPT_DIR)/hotplugpath.sh' > $$dest-new; \
	         cat $$dest >> $$dest-new; \
	      fi \
	      mv $$dest-new $$dest; \
	   else \
	      echo ". $(XEN_SCRIPT_DIR)/hotplugpath.sh" > $$dest; \
	   fi \
	done

# xxx don't remove the rc.conf.d file!

.PHONY: uninstall-rcd
uninstall-rcd:
	rm -f $(subst rc.d,$(DESTDIR)$(INITD_DIR),$(XEN_RCD_PROG))

.PHONY: clean
clean:

.PHONY: distclean
distclean: clean
