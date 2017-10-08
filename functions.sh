#!/bin/bash

# Version of Savannah packages
function gnuv {
    wget -cqO- http://ftp.gnu.org/gnu/$1/ | grep "$1" | grep "tar" | cut -d '"' -f 8 | cut -d '-' -f 2 | grep "[0-9]\.tar\.[a-z]*z*" | sed 's/\.tar\.[a-z]*z[0-9a-z.]*//g' | uniq | tail -n 2
}

# Version of Savannah packages
function savv {
    wget -cqO- http://download.savannah.gnu.org/releases/$1/ | grep "sig" | cut -d '"' -f 4 | sed 's/\.src\.tar\.gz\.sig//g' | cut -d '-' -f 2 | tail -n 2
}

# Ver func
# Determine the latest version of software that patch releases (z in x.y.z)
# Using this to determine gnuver and savver doesn't work
function ver {
    ATTEMPT_L1=$(echo $1 | sed 's/ /\n/g' | head -n 1)
    ATTEMPT_L2=$(echo $1 | sed 's/ /\n/g' | tail -n 1)

    if [[ $ATTEMPT_L1 == ${ATTEMPT_L2}.[0-9.pu]* ]]; then
         VERSION=${ATTEMPT_L1}
    else
         VERSION=${ATTEMPT_L2}
    fi

    printf "$VERSION\n"
}

# GNU ver func
# Determine latest version of GNU software
function gnuver {
    ATTEMPT_L1=$(gnuv $1 | head -n 1)
    ATTEMPT_L2=$(gnuv $1 | tail -n 1)

    if [[ $ATTEMPT_L1 == ${ATTEMPT_L2}.[0-9] ]]; then
         VERSION=${ATTEMPT_L1}
    else
         VERSION=${ATTEMPT_L2}
    fi

    printf "$VERSION\n"
}

# Sav ver func
function savver {
    ATTEMPT_L1=$(savv $1 | head -n 1)
    ATTEMPT_L2=$(savv $1 | tail -n 1)

    if [[ $ATTEMPT_L1 == ${ATTEMPT_L2}.[0-9] ]]; then
         VERSION=${ATTEMPT_L1}
    else
         VERSION=${ATTEMPT_L2}
    fi

    printf "$VERSION\n"
}

# Compare versions and tell us whether the package is up-to-date or outdated (with the latest version available)
function vercomp {
    NAME=$1
    VER1=$2
    VER2=$3

    if ! [[ $VER1 == $VER2 ]]; then
  #       printf "$NAME is up-to-date"
  #  else
         printf "$NAME $VER2 is available\n"
    fi
}

# Compare versions for GNU software
function gnuvercomp {
    NAME="$1"
    EXIST="$2"
    CURRENT=$(gnuver $NAME)

    vercomp $NAME $EXIST $CURRENT
}

function savvercomp {
    NAME="$1"
    EXIST="$2"
    CURRENT=$(savver $NAME)

    vercomp $NAME $EXIST $CURRENT
}

function blfsvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- http://anduin.linuxfromscratch.org/BLFS/blfs-bootscripts/ | grep "xz" | cut -d '"' -f 2 | cut -d '-' -f 3 | sed 's/\.tar\.xz//g' | tail -n 1)

    vercomp "blfs-bootscripts" $EXIST $CURRENT
}

function bzip2vercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- http://www.bzip.org/ | grep "current version" | cut -d ',' -f 1 | cut -d ' ' -f 5 | cut -d '>' -f 2 | cut -d '<' -f 1)

    vercomp "bzip2" $EXIST $CURRENT
}

function checkvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- https://github.com/libcheck/check/releases | grep "check\-[0-9.]*\.tar\.gz" | cut -d '>' -f 2 | cut -d '<' -f 1 | cut -d '-' -f 2 | grep "tar" | sed 's/\.tar\.gz//g' | head -n 1)

    vercomp "check" $EXIST $CURRENT
}

function dbusvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- https://dbus.freedesktop.org/releases/dbus/ | grep "10.[0-9][a-z0-9.]*asc" | cut -d '-' -f 2 | sed 's/\.tar[a-z.">]*//g' | tail -n 1)

    vercomp "dbus" $EXIST $CURRENT
}

function dhcpcdvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- https://roy.marples.name/downloads/dhcpcd/ | cut -d '"' -f 2 | grep -v "beta\|rc\|ui\|gtk\|dbus\|test\|initd\|dhcpcd\.xz\|<" | cut -d '-' -f 2 | sed 's/\.tar[a-z.]*//g' | tail -n 1)

    vercomp "dhcpcd" $EXIST $CURRENT
}

function e2fsprogsvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- https://sourceforge.net/projects/e2fsprogs/files/e2fsprogs/ | sed 's/,/\n/g' | grep "v[0-9]" | grep "a href" | head -n 1 | cut -d '"' -f 4 | cut -d '/' -f 3 | sed 's/v//g')

    vercomp "e2fsprogs" $EXIST $CURRENT
}

export -f gnuvercomp
export -f savvercomp
export -f blfsvercomp
export -f bzip2vercomp
export -f checkvercomp
export -f dbusvercomp
export -f dhcpcdvercomp
export -f e2fsprogsvercomp
