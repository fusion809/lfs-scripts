#!/bin/bash
# Source functions.sh
. $HOME/GitHub/mine/scripts/lfs-scripts/functions.sh

# Existing package versions
ACL="2.2.52"
ATTR="2.4.47"
AUTOCONF="2.69"
AUTOMAKE="1.15.1"
BASH="4.4"
BC="1.07.1"
BINUTILS="2.29"
BISON="3.0.4"
BLFS="20170731"
BZIP2="1.0.6"
CHECK="0.11.0"
COREUTILS="8.27"
DBUS="1.10.22"
DEJAGNU="1.6"
DHCPCD="6.11.5"
DIFFUTILS="3.6"
E2FSPROGS="1.43.5"
EUDEV="3.2.2"
EXPAT="2.2.3"
EXPECT="5.45"
FILE="5.31"
FINDUTILS="4.6.0"
FLEX="2.6.4"
GDBM="1.13"
GETTEXT="0.19.8.1"
GLIBC="2.26"
GMP="6.1.2"
GPERF="3.1"
GREP="3.1"
GROFF="1.22.3"
GRUB="2.02"
GZIP="1.8"
IATA_ETC="2.30"
INETUTILS="1.9.4"
INTLTOOL="0.51.0"
IPROUTE2="4.12.0"
KBD="2.0.4"
KMOD="24"
LESS="487"
LFS_BOOTSCRIPTS="20170626"
LIBCAP="2.25"
LIBFFI="3.2.1"
LIBPIPELINE="1.4.2"
LIBTOOL="2.4.6"
LINUX="4.13.5" # 4.12.7 was the default!
LYNX="2.8.8rel.2" # Wasn't included by default
M4="1.4.18"
MAKE="4.2.1"
MAN_DB="2.7.6.1"
MAN_PAGES="4.12"
MPC="1.0.3"
MPFR="3.1.5"
NCURSES="6.0"
PATCH="2.7.5"
PERL="5.26.1" # 5.26.0 was original
PKG_CONFIG="0.29.2"
PROCPS_NG="3.3.12"
PSMISC="23.1"
READLINE="7.0"
SED="4.4"
SHADOW="4.5"
SYSKLOGD="1.5.1"
SYSVINIT="2.88dsf"
TAR="1.29"
TCL_CORE="8.6.7"
TEXINFO="6.4"
TZDATA="2017b"
UDEV_LFS="20140408"
UTIL_LINUX="2.30.1"
VIM="8.0.1176" # 8.0.0586 was default
XML_PARSER="2.44"
XZ="5.2.3"
ZLIB="1.2.11"

# Check
savvercomp acl $ACL
savvercomp attr $ATTR
gnuvercomp autoconf $AUTOCONF
gnuvercomp bash $BASH
gnuvercomp bc $BC
gnuvercomp binutils $BINUTILS
gnuvercomp bison $BISON
blfsvercomp $BLFS
bzip2vercomp $BZIP2
checkvercomp $CHECK
gnuvercomp coreutils $COREUTILS
dbusvercomp $DBUS
gnuvercomp $DEJAGNU
dhcpcdvercomp $DHCPCD
gnuvercomp $DIFFUTILS
sfvercomp e2fsprogs $E2FSPROGS
eudevvercomp $EUDEV
sfvercomp expat $EXPAT
expectvercomp $EXPECT
filevercomp $FILE
findutilsvercomp $FINDUTILS
flexvercomp $FLEX
gnuvercomp gawk $GAWK
gnuvercomp gdbm $GDBM
gnuvercomp gettext $GETTEXT
gnuvercomp glibc $GLIBC
gnuvercomp gmp $GMP
gnuvercomp gperf $GPERF
gnuvercomp grep $GREP
gnuvercomp groff $GROFF
gnuvercomp grub $GRUB
gnuvercomp gzip $GZIP
iata-etcvercomp $IATA_ETC
gnuvercomp inetutils $INETUTILS
intltoolvercomp $INTLTOOL
iproute2vercomp $IPROUTE2
kbdvercomp $KBD
kmodvercomp $KMOD
lessvercomp $LESS
# LFS Bootscripts
libcapvercomp $LIBCAP
libpipelinevercomp $LIBPIPELINE
gnuvercomp libtool $LIBTOOL
linuxvercomp $LINUX
gnuvercomp m4 $M4
gnuvercomp make $MAKE
savvercomp man-db $MAN_DB
manpagesvercomp $MAN_PAGES
mpcvercomp $MPC
mpfrvercomp $MPFR
gnuvercomp ncurses $NCURSES
gnuvercomp patch $PATCH
# Perl is complicated; 5.27.x is out but 5.26.1 seems like the latest as it's the one used by Arch Linux
perlvercomp $PERL
procpsvercomp $PROCPS_NG
gnuvercomp readline $READLINE
gnuvercomp sed $SED
gnuvercomp tar $TAR
gnuvercomp texinfo $TEXINFO
