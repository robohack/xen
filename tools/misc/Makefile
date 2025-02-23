XEN_ROOT=$(CURDIR)/../..
include $(XEN_ROOT)/tools/Rules.mk

# Include configure output (config.h)
CFLAGS += -include $(XEN_ROOT)/tools/config.h
CFLAGS += $(CFLAGS_libxenevtchn)
CFLAGS += $(CFLAGS_libxenctrl)
CFLAGS += $(CFLAGS_libxenguest)
CFLAGS += $(CFLAGS_xeninclude)
CFLAGS += $(CFLAGS_libxenstore)

# Everything to be installed in regular bin/
INSTALL_BIN-$(CONFIG_X86)      += xen-cpuid
INSTALL_BIN-$(CONFIG_X86)      += xen-detect
INSTALL_BIN                    += xencov_split
INSTALL_BIN += $(INSTALL_BIN-y)

# Everything to be installed in regular sbin/
INSTALL_SBIN-$(CONFIG_MIGRATE) += xen-hptool
INSTALL_SBIN-$(CONFIG_X86)     += xen-hvmcrash
INSTALL_SBIN-$(CONFIG_X86)     += xen-hvmctx
INSTALL_SBIN-$(CONFIG_X86)     += xen-lowmemd
INSTALL_SBIN-$(CONFIG_X86)     += xen-mceinj
INSTALL_SBIN-$(CONFIG_X86)     += xen-memshare
INSTALL_SBIN-$(CONFIG_X86)     += xen-mfndump
INSTALL_SBIN-$(CONFIG_X86)     += xen-ucode
INSTALL_SBIN-$(CONFIG_X86)     += xen-vmtrace
INSTALL_SBIN                   += xencov
INSTALL_SBIN                   += xenhypfs
INSTALL_SBIN                   += xenlockprof
INSTALL_SBIN                   += xenperf
INSTALL_SBIN                   += xenpm
# XXX daemon programs are supposed to be installed in $(LIBEXEC_BIN)
INSTALL_SBIN                   += xenwatchdogd
INSTALL_SBIN                   += xen-access
INSTALL_SBIN                   += xen-livepatch
INSTALL_SBIN                   += xen-diag
INSTALL_SBIN += $(INSTALL_SBIN-y)

# Everything to be installed
TARGETS_ALL := $(INSTALL_BIN) $(INSTALL_SBIN)

# Everything which only needs copying to install
TARGETS_COPY += xencov_split

# Everything which needs to be built
TARGETS := $(filter-out $(TARGETS_COPY),$(TARGETS_ALL))

.PHONY: all
all: $(TARGETS)

.PHONY: install
install: all
	$(INSTALL_DIR) $(DESTDIR)$(bindir)
	$(INSTALL_DIR) $(DESTDIR)$(sbindir)
	$(INSTALL_DIR) $(DESTDIR)$(LIBEXEC_BIN)
	$(INSTALL_PYTHON_PROG) $(INSTALL_BIN) $(DESTDIR)$(bindir)
	$(INSTALL_PYTHON_PROG) $(INSTALL_SBIN) $(DESTDIR)$(sbindir)

.PHONY: uninstall
uninstall:
	rm -f $(addprefix $(DESTDIR)$(sbindir)/, $(INSTALL_SBIN))
	rm -f $(addprefix $(DESTDIR)$(bindir)/, $(INSTALL_BIN))

.PHONY: clean
clean:
	$(RM) *.o $(TARGETS) $(DEPS_RM)

.PHONY: distclean
distclean: clean

xen-access: xen-access.o
	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS_libxenctrl) $(LDLIBS_libxenguest) $(LDLIBS_libxenevtchn) $(APPEND_LDFLAGS)

xen-cpuid: xen-cpuid.o
	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS_libxenctrl) $(LDLIBS_libxenguest) $(APPEND_LDFLAGS)

xen-detect: xen-detect.o
	$(CC) $(LDFLAGS) -o $@ $< $(APPEND_LDFLAGS)

xen-hvmctx: xen-hvmctx.o
	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS_libxenctrl) $(APPEND_LDFLAGS)

xen-hvmcrash: xen-hvmcrash.o
	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS_libxenctrl) $(LDLIBS_libxendevicemodel) $(APPEND_LDFLAGS)

xen-memshare: xen-memshare.o
	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS_libxenctrl) $(APPEND_LDFLAGS)

xen-vmtrace: xen-vmtrace.o
	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS_libxenctrl) $(LDLIBS_libxenforeignmemory) $(APPEND_LDFLAGS)

xen-mceinj: xen-mceinj.o
	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS_libxenctrl) $(LDLIBS_libxenguest) $(LDLIBS_libxenstore) $(APPEND_LDFLAGS)

xenperf: xenperf.o
	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS_libxenctrl) $(APPEND_LDFLAGS)

xenpm: xenpm.o
	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS_libxenctrl) $(APPEND_LDFLAGS)

xenhypfs: xenhypfs.o
	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS_libxenhypfs) $(APPEND_LDFLAGS)

xenlockprof: xenlockprof.o
	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS_libxenctrl) $(APPEND_LDFLAGS)

xen-hptool: xen-hptool.o
	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS_libxenevtchn) $(LDLIBS_libxenctrl) $(LDLIBS_libxenguest) $(LDLIBS_libxenstore) $(APPEND_LDFLAGS)

xenhypfs.o: CFLAGS += $(CFLAGS_libxenhypfs)

xen-mfndump: xen-mfndump.o
	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS_libxenevtchn) $(LDLIBS_libxenctrl) $(LDLIBS_libxenguest) $(APPEND_LDFLAGS)

xenwatchdogd: xenwatchdogd.o
	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS_libxenctrl) $(APPEND_LDFLAGS)

xen-livepatch: xen-livepatch.o
	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS_libxenctrl) $(APPEND_LDFLAGS)

xen-diag: xen-diag.o
	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS_libxenctrl) $(APPEND_LDFLAGS)

xen-lowmemd: xen-lowmemd.o
	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS_libxenevtchn) $(LDLIBS_libxenctrl) $(LDLIBS_libxenstore) $(APPEND_LDFLAGS)

xencov: xencov.o
	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS_libxenctrl) $(APPEND_LDFLAGS)

xen-ucode: xen-ucode.o
	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS_libxenctrl) $(APPEND_LDFLAGS)

-include $(DEPS_INCLUDE)
