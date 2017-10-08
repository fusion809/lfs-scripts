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
