#!/bin/bash

# Version of Savannah packages
function gnuv {
    wget -cqO- http://ftp.gnu.org/gnu/$1/ | grep "$1" | grep "sig" | cut -d '"' -f 8 | cut -d '-' -f 2 | grep "[0-9]\.tar\.gz\.sig" | sed 's/\.tar\.gz\.sig//g' | tail -n 2
}

# Version of Savannah packages
function savv {
    wget -c http://download.savannah.gnu.org/releases/$1/ -qO- | grep "sig" | cut -d '"' -f 4 | sed 's/\.src\.tar\.gz\.sig//g' | cut -d '-' -f 2 | tail -n 2
}

# Ver func
# Determine the latest version of software that patch releases (z in x.y.z)
function ver {
    ATTEMPT=$1
    ATTEMPT_L1=$(echo $ATTEMPT | head -n 1)
    ATTEMPT_L2=$(echo $ATTEMPT | head -n 1)

    if [[ $ATTEMPT_L1 == ${ATTEMPT_L2}.[0-9] ]]; then
         VERSION=${ATTEMPT_L1}
    else
         VERSION=${ATTEMPT_L2}
    fi

    printf $VERSION
}

# GNU ver func
# Determine latest version of GNU software
function gnuver {
    ver $(gnuv $1)
}

# Compare versions and tell us whether the package is up-to-date or outdated (with the latest version available)
function vercomp {
    NAME=$1
    VER1=$2
    VER2=$3

    if [[ $VER1 == $VER2 ]]; then
         printf "$NAME is up-to-date"
    else
         printf "$NAME $VER2 is available"
    fi
}

# Compare versions for GNU software
function gnuvercomp {
    NAME="$1"
    EXIST_VER="$2"
    CURRENT_VER=$(gnuver $NAME)

    vercomp $NAME $EXIST_VER $CURRENT_VER
}
