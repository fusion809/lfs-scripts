#!/bin/bash
# Source functions.sh
. $HOME/GitHub/mine/scripts/lfs-scripts/functions.sh

# Existing package versions
ACL_VERSION1="2.2.52"
ATTR_VERSION1="2.4.47"
AUTOCONF_VERSION1="2.69"
AUTOMAKE_VERSION1="1.15.1"
BASH_VERSION1="4.4"
BC_VERSION1="1.07.1"
BINUTILS_VERSION1="2.29"
BISON_VERSION1="3.0.4"
BLFS_VERSION1="20170731"

ACL_VERSION2=$(wget -c http://download.savannah.gnu.org/releases/acl/ -qO- | grep "sig" | cut -d '"' -f 4 | sed 's/\.src\.tar\.gz\.sig//g' | cut -d '-' -f 2 | tail -n 1)
ATTR_VERSION2=$(wget -c http://download.savannah.gnu.org/releases/attr/ -qO- | grep "sig" | cut -d '"' -f 4 | sed 's/\.src\.tar\.gz\.sig//g' | cut -d '-' -f 2 | tail -n 1)


AUTOCONF_VERSION2=$(gnuver autoconf)

# AUTOMAKE
AUTOMAKE_VERSION2=$(gnuver automake)

# BASH
BASH_VERSION2=$(gnuver bash)

# BC
BC_VERSION2=$(gnuver bc)

