AC_DEFUN([AX_XEN_EXPAND_CONFIG], [
dnl expand these early so we can use this for substitutions
test "x$prefix" = "xNONE" && prefix=$ac_default_prefix
test "x$exec_prefix" = "xNONE" && exec_prefix=${prefix}

dnl Use /var instead of /usr/local/var because there can be only one
dnl xenstored active at a time. All tools have to share this dir, even
dnl if they come from a different --prefix=.
if test "$localstatedir" = '${prefix}/var' ; then
    localstatedir=/var
fi

dnl expand exec_prefix or it will end up in substituted variables
bindir=`eval echo $bindir`
sbindir=`eval echo $sbindir`
libdir=`eval echo $libdir`

dnl
if test "x$sysconfdir" = 'x${prefix}/etc' ; then
    case "$host_os" in
         *freebsd*)
         sysconfdir=$prefix/etc
         ;;
         *solaris*)
         if test "$prefix" = "/usr" ; then
             sysconfdir=/etc
         else
             sysconfdir=$prefix/etc
         fi
         ;;
         *)
         sysconfdir=/etc
         ;;
    esac
fi

dnl only Linux insists on this unnecessary subdirectory in /var
var_lib=''
case "$host_os" in
     *linux*)
     var_lib='lib/'
     ;;
esac

CONFIG_DIR=$sysconfdir
AC_SUBST(CONFIG_DIR)

XEN_CONFIG_DIR=$CONFIG_DIR/xen
AC_SUBST(XEN_CONFIG_DIR)
AC_DEFINE_UNQUOTED([XEN_CONFIG_DIR], ["$XEN_CONFIG_DIR"], [Xen's config dir])

dnl xxx the default should show the host-specific default
AC_ARG_WITH([initddir],
    AS_HELP_STRING([--with-initddir=DIR],
    [Path to directory with sysv runlevel scripts.
     [SYSCONFDIR/<system-specific-init-dir>]]),
    [initddir_path=$withval],
    [case "$host_os" in
         *linux*)
         if test -d $sysconfdir/rc.d/init.d ; then
             initddir_path=$sysconfdir/rc.d/init.d
         else
             initddir_path=$sysconfdir/init.d
         fi
         ;;
         *bsd*)
         initddir_path=$sysconfdir/rc.d
         ;;
         *)
         initddir_path=$sysconfdir/init.d
         ;;
     esac])

dnl CONFIG_LEAF_DIR is only used on GNU/Linux systems
AC_ARG_WITH([sysconfig-leaf-dir],
    AS_HELP_STRING([--with-sysconfig-leaf-dir=SUBDIR],
    [Name of subdirectory in /etc to store runtime options for runlevel
    scripts and daemons such as xenstored.
    This should be either "sysconfig" or "default". [sysconfig]]),
    [config_leaf_dir=$withval],
    [config_leaf_dir=sysconfig
    if test ! -d /etc/sysconfig ; then config_leaf_dir=default ; fi])
CONFIG_LEAF_DIR=$config_leaf_dir
AC_SUBST(CONFIG_LEAF_DIR)

dnl autoconf docs suggest to use a "package name" subdir. We make it
dnl configurable for the benefit of those who want e.g. xen-X.Y instead.
dnl this is unconventional in the BSD world, and generally not useful, but for
dnl consistency and historical practice it remains....
AC_ARG_WITH([libexec-leaf-dir],
    AS_HELP_STRING([--with-libexec-leaf-dir=SUBDIR],
    [Name of subdirectory in libexecdir to use.]),
    [libexec_subdir=$withval],
    [libexec_subdir=$PACKAGE_TARNAME])

AC_ARG_WITH([xen-scriptdir],
    AS_HELP_STRING([--with-xen-scriptdir=DIR],
    [Path to directory for dom0 hotplug scripts. [SYSCONFDIR/xen/scripts]]),
    [xen_scriptdir_path=$withval],
    [xen_scriptdir_path=$XEN_CONFIG_DIR/scripts])
XEN_SCRIPT_DIR=$xen_scriptdir_path
AC_SUBST(XEN_SCRIPT_DIR)
AC_DEFINE_UNQUOTED([XEN_SCRIPT_DIR], ["$XEN_SCRIPT_DIR"], [Xen's script dir])

AC_ARG_WITH([xen-dumpdir],
    AS_HELP_STRING([--with-xen-dumpdir=DIR],
    [Path to directory for domU crash dumps. [LOCALSTATEDIR/[lib/]xen/dump]]),
    [xen_dumpdir_path=$withval],
    [xen_dumpdir_path=$localstatedir/${var_lib}xen/dump])

AC_ARG_WITH([rundir],
    AS_HELP_STRING([--with-rundir=DIR],
    [Path to directory for runtime data. [LOCALSTATEDIR/run]]),
    [rundir_path=$withval],
    [rundir_path=$localstatedir/run])

AC_ARG_WITH([debugdir],
    AS_HELP_STRING([--with-debugdir=DIR],
    [Path to directory for debug symbols. [PREFIX/lib/debug]]),
    [debugdir_path=$withval],
    [debugdir_path=$prefix/lib/debug])

dnl XXX Solaris would likely be different, if fully supported
if test "$libexecdir" = '${exec_prefix}/libexec' ; then
    case "$host_os" in
         *linux*)
         libexecdir='${exec_prefix}/lib'
         ;;
    esac
fi
dnl expand $libexecdir or it will end up in substituted variables
LIBEXEC=`eval echo $libexecdir/$libexec_subdir`
AC_SUBST(LIBEXEC)

dnl These variables will be substituted in various .in files
LIBEXEC_BIN=${LIBEXEC}/bin
AC_SUBST(LIBEXEC_BIN)
AC_DEFINE_UNQUOTED([LIBEXEC_BIN], ["$LIBEXEC_BIN"], [Xen's libexec path])
dnl LIBEXEC_LIB is only used with qemu configure
LIBEXEC_LIB=${LIBEXEC}/lib
AC_SUBST(LIBEXEC_LIB)
dnl LIBEXEC_INC is only used with qemu configure
LIBEXEC_INC=${LIBEXEC}/include
AC_SUBST(LIBEXEC_INC)
XENFIRMWAREDIR=${LIBEXEC}/boot
AC_SUBST(XENFIRMWAREDIR)
AC_DEFINE_UNQUOTED([XENFIRMWAREDIR], ["$XENFIRMWAREDIR"], [Xen's firmware dir])

XEN_RUN_DIR=$rundir_path/xen
AC_SUBST(XEN_RUN_DIR)
AC_DEFINE_UNQUOTED([XEN_RUN_DIR], ["$XEN_RUN_DIR"], [Xen's runstate path])

XEN_LOG_DIR=$localstatedir/log/xen
AC_SUBST(XEN_LOG_DIR)
AC_DEFINE_UNQUOTED([XEN_LOG_DIR], ["$XEN_LOG_DIR"], [Xen's log dir])

XEN_RUN_STORED=$rundir_path/xenstored
AC_SUBST(XEN_RUN_STORED)
AC_DEFINE_UNQUOTED([XEN_RUN_STORED], ["$XEN_RUN_STORED"], [Xenstore's runstate path])

XEN_LIB_DIR='${localstatedir}/${var_lib}xen'
AC_SUBST(XEN_LIB_DIR)
AC_DEFINE_UNQUOTED([XEN_LIB_DIR], ["$XEN_LIB_DIR"], [Xen's localstate dir])

SHAREDIR=$prefix/share
AC_SUBST(SHAREDIR)

INITD_DIR=$initddir_path
AC_SUBST(INITD_DIR)

case "$host_os" in
*linux*) XEN_LOCK_DIR=$localstatedir/lock ;;
*) XEN_LOCK_DIR=$rundir_path/xen ;;
esac
AC_SUBST(XEN_LOCK_DIR)
AC_DEFINE_UNQUOTED([XEN_LOCK_DIR], ["$XEN_LOCK_DIR"], [Xen's lock dir])

XEN_PAGING_DIR=$rundir_path/${var_lib}xen/xenpaging
AC_SUBST(XEN_PAGING_DIR)

XEN_DUMP_DIR=$xen_dumpdir_path
AC_SUBST(XEN_DUMP_DIR)
AC_DEFINE_UNQUOTED([XEN_DUMP_DIR], ["$XEN_DUMP_DIR"], [Xen's dump directory])

DEBUG_DIR=$debugdir_path
AC_SUBST(DEBUG_DIR)
])

dnl only used for default value in tools/ocaml/xenstored/oxenstored.conf
dnl xxx why can't .ml code also use equivalent of system ifdefs?   "system"???
case "$host_os" in
*freebsd*) XENSTORED_KVA=/dev/xen/xenstored ;;
*netbsd*) XENSTORED_KVA=/dev/xsd_kva ;;
*) XENSTORED_KVA=/proc/xen/xsd_kva ;;
esac
AC_SUBST(XENSTORED_KVA)

dnl only used for default value in tools/ocaml/xenstored/oxenstored.conf
dnl xxx why can't .ml code also use equivalent of system ifdefs?  "system"???
case "$host_os" in
*freebsd*) XENSTORED_PORT=/dev/xen/xenstored ;;
*netbsd*) XENSTORED_PORT=/kern/xen/xsd_port ;;
*) XENSTORED_PORT=/proc/xen/xsd_port ;;
esac
AC_SUBST(XENSTORED_PORT)
