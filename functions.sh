#!/bin/bash

# Version of Savannah packages
function gnuv {
    if [[ $1 == "gcc" ]]; then
         wget -cqO- http://ftp.gnu.org/gnu/gcc/ | grep "gcc" | cut -d '"' -f 8 | cut -d '-' -f 2 | cut -d '/' -f 1 | grep -v "vms" | tail -n 1
    elif [[ $1 == "gettext" ]]; then
          wget -cqO- http://ftp.gnu.org/gnu/$1/ | grep "$1" | grep "tar" | cut -d '"' -f 8 | cut -d '-' -f 2 | grep "[0-9]\.tar\.[a-z]*z*" | sed 's/\.tar\.[a-z]*z[0-9a-z.]*//g' | uniq | tail -n 3 | head -n 2
    else
         wget -cqO- http://ftp.gnu.org/gnu/$1/ | grep "$1" | grep "tar" | cut -d '"' -f 8 | cut -d '-' -f 2 | grep "[0-9]\.tar\.[a-z]*z*" | sed 's/\.tar\.[a-z]*z[0-9a-z.]*//g' | uniq | tail -n 2
    fi
}

# Version of Savannah packages
function savv {
    if [[ $1 == "man-db" ]]; then
         wget -cqO- http://download.savannah.gnu.org/releases/$1/ | grep "\.tar\.xz\.sig" | cut -d '"' -f 4 | sed 's/[a-z.]*\.tar\.xz\.sig//g' | cut -d '-' -f 3 | tail -n 2
    else
         wget -cqO- http://download.savannah.gnu.org/releases/$1/ | grep "sig" | cut -d '"' -f 4 | sed 's/[a-z.]*\.tar\.gz\.sig//g' | sed 's/\.tar\.bz2\.sig//g' | cut -d '-' -f 2 | tail -n 2
    fi
}

# Ver func
# Determine the latest version of software that patch releases (z in x.y.z)
# Using this to determine gnuver and savver doesn't work
function ver {
    ATTEMPT_L1=$(echo $1 | sed 's/ /\n/g' | head -n 1)
    ATTEMPT_L2=$(echo $1 | sed 's/ /\n/g' | tail -n 1)

    if [[ $ATTEMPT_L1 == ${ATTEMPT_L2}.[0-9.]* ]]; then
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

    if [[ $ATTEMPT_L1 == ${ATTEMPT_L2}.[0-9]* ]]; then
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

    if [[ $ATTEMPT_L1 == ${ATTEMPT_L2}.[0-9]* ]]; then
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
function dilute {
    echo $1 | grep "a href" | head -n 1 | cut -d '"' -f 4 | cut -d '/' -f 3 | sed 's/v//g'
}

function sfvercomp {
    NAME="$1"
    EXIST="$2"
    CURRENT1=$(wget -cqO- https://sourceforge.net/projects/$NAME/files/$NAME/ | sed 's/,/\n/g' | grep "v[0-9]" | grep "a href" | head -n 1 | cut -d '"' -f 4 | cut -d '/' -f 3 | sed 's/v//g')

    if ! [[ $CURRENT1 == [0-9.]* ]]; then
         CURRENT=$(wget -cqO- https://sourceforge.net/projects/$NAME/files/$NAME/ | sed 's/,/\n/g' | grep "[0-9]" | grep "a href" | head -n 1 | cut -d '"' -f 4 | cut -d '/' -f 3 | sed 's/v//g')
    else
         CURRENT=$CURRENT1
    fi

    if [[ $NAME == "expat" ]]; then
         CURRENT=$(wget -cqO- https://sourceforge.net/projects/$NAME/files/$NAME/ | sed 's/,/\n/g' | grep "a href" | grep "[0-9]" | grep -v "h1\|p>" | head -n 1 | cut -d '"' -f 4 | cut -d '/' -f 4 | cut -d ':' -f 1 | cut -d '-' -f 2 | sed 's/\.tar[a-z0-9.]*//g')
    fi

    vercomp $NAME $EXIST $CURRENT
}

# EUDEV
function eudevver {
    eudevv=$(wget -cqO- https://dev.gentoo.org/~blueness/eudev/ | grep "eudev" | grep "tar" | cut -d '=' -f 3 | sed 's/\.tar[0-9a-zA-Z./><-]*//g' | sed 's/ALIGN//g' | cut -d '-' -f 2 | tail -n 2)
    ATTEMPT_L1=$(echo $eudevv | head -n 1)
    ATTEMPT_L2=$(echo $eudevv | tail -n 1)

    if [[ $ATTEMPT_L1 == ${ATTEMPT_L2}.[0-9] ]]; then
         VERSION=${ATTEMPT_L1}
    else
         VERSION=${ATTEMPT_L2}
    fi

    printf "$VERSION\n"
}

function eudevvercomp {
    EXIST="$1"
    CURRENT=$(eudevver)

    vercomp "eudev" $EXIST $CURRENT
}

function expectvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- https://sourceforge.net/projects/expect/files/Expect/ | sed 's/,/\n/g' | grep "[0-9]" | grep "a href" | grep -v "p>" | grep "download" | cut -d '"' -f 4 | cut -d ':' -f 1 | cut -d '/' -f 3)

    vercomp "Expect" $EXIST $CURRENT
}

function filevercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- ftp://ftp.astron.com/pub/file/ | grep "asc" | cut -d '/' -f 6 | cut -d '"' -f 1 | sed 's/\.tar[a-z.]*//g' | cut -d '-' -f 2 | tail -n 1)

    vercomp "file" $EXIST $CURRENT
}

function findutilsvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- http://ftp.gnu.org/gnu/findutils | grep "a href" | cut -d '"' -f 8 | tail -n 1 | sed 's/\.tar[a-z.]*//g' | cut -d '-' -f 2)

    vercomp "findutils" $EXIST $CURRENT
}

function flexvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- https://github.com/westes/flex/releases | grep "download\/" | head -n 1 | cut -d '"' -f 2 | cut -d '/' -f 6 | cut -d 'v' -f 2)

    vercomp "flex" $EXIST $CURRENT
}

function iata-etcvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- http://anduin.linuxfromscratch.org/LFS/ | grep "iana-etc" | cut -d '"' -f 2 | cut -d '-' -f 3 | sed 's/\.tar[a-z0-9.]*//g')

    vercomp "iata-etc" $EXIST $CURRENT
}

function intltoolvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- https://launchpad.net/intltool/ | grep "+download" | cut -d '"' -f 2 | cut -d '/' -f 6 | head -n 1)

    vercomp "intltool" $EXIST $CURRENT
}

function iproute2vercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- https://www.kernel.org/pub/linux/utils/net/iproute2/ | grep -v "2015" | grep -v "2016" | grep "tar\.xz" | cut -d '"' -f 2 | cut -d '-' -f 2 | sed 's/\.tar[a-z.]*//g' | tail -n 1)

    vercomp "iproute2" $EXIST $CURRENT
}

function kbdvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- https://www.kernel.org/pub/linux/utils/kbd/ | grep "tar\.xz" | cut -d '"' -f 2 | cut -d '-' -f 2 | sed 's/\.tar[a-z.]*//g' | tail -n 1)

    vercomp "kbd" $EXIST $CURRENT
}

function kmodvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- https://www.kernel.org/pub/linux/utils/kernel/kmod/ | grep "tar\.xz" | grep -v "2012" | cut -d '"' -f 2 | cut -d '-' -f 2 | sed 's/\.tar[a-z.]*//g' | tail -n 1)

    vercomp "kmod" $EXIST $CURRENT
}

function lessvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- http://www.greenwoodsoftware.com/less/ | grep "general" | grep "-" | cut -d '-' -f 2 | cut -d ' ' -f 1 | head -n 1)

    vercomp "less" $EXIST $CURRENT
}

function libcapvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/ | grep "libcap-[0-9.a-z]*.xz" | cut -d '"' -f 2 | cut -d '-' -f 2 | sed 's/\.tar[a-z.]*//g' | tail -n 1)

    vercomp "libcap" $EXIST $CURRENT
}

function libpipelinevercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- http://download.savannah.gnu.org/releases/libpipeline/ | grep "libpipeline-[0-9.a-z]*.gz" | cut -d '"' -f 4 | tail -n 1 | sed 's/\.tar[a-z.]*//g' | cut -d '-' -f 2)

    vercomp "libpipeline" $EXIST $CURRENT
}

function linuxvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- https://www.kernel.org/ | grep "\.tar\.xz" | head -n 1 | cut -d '"' -f 2 | tail -n 1 | cut -d '-' -f 2 | sed 's/\.tar\.xz//g')

    vercomp "linux" $EXIST $CURRENT
}

function manpagesvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- https://www.kernel.org/pub/linux/docs/man-pages | grep "man-pages-[0-9.a-z]*.xz" | cut -d '"' -f 2 | cut -d '-' -f 3 | sed 's/\.tar[a-z.]*//g' | tail -n 1)

    vercomp "man-page" $EXIST $CURRENT
}

function mpcvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- "http://www.multiprecision.org/index.php?prog=mpc&page=download" | grep "SHA1" | cut -d ' ' -f 2 | cut -d '-' -f 2 | sed 's/\.tar\.gz//g')

    vercomp "mpc" $EXIST $CURRENT
}

function mpfrvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- http://www.mpfr.org/mpfr-current/ | grep "mpfr-[0-9a-z.]*.xz" | cut -d '"' -f 2 | cut -d '-' -f 2 | sed 's/\.tar[a-z.]*//g' | head -n 1)

    vercomp "mpfr" $EXIST $CURRENT
}

function opensslvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- https://www.openssl.org/source/ | grep "\.tar\.gz" | cut -d '"' -f 2 | head -n 2 | tail -n 1 | cut -d '-' -f 2 | sed 's/\.tar\.gz//g')

    vercomp "OpenSSL" $EXIST $CURRENT
}

function pciutilsvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- https://www.kernel.org/pub/software/utils/pciutils/ | grep "[0-9.]*" | cut -d '"' -f 2 | grep "xz" | cut -d '-' -f 2 | sed 's/\.tar\.xz//g' | tail -n 1)

    vercomp "pciutils" $EXIST $CURRENT
}

function perlvercomp {
    EXIST="$1"
    CURRENT=$(perl --version | cut -d '(' -f 2 | cut -d ')' -f 1 | grep "v[0-9].[0-9][02468]" | head -n 1 | sed 's/v//g')

    vercomp "perl" $EXIST $CURRENT
}

function pkgconfigvercomp {
    EXIST="$1"
    CURRENT1=$(wget -cqO- https://pkg-config.freedesktop.org/releases/ | grep "pkg-config-[0-9.]*tar.[a-z]*" | cut -d '"' -f 8 | sed 's/\.tar[a-z.]*//g' | uniq | tail -n 2 | cut -d '-' -f 3)
 
    ATTEMPT_L1=$(echo $CURRENT1 | head -n 1)
    ATTEMPT_L2=$(echo $CURRENT1 | tail -n 1)

    if [[ $ATTEMPT_L1 == ${ATTEMPT_L2}.[0-9] ]]; then
         CURRENT=${ATTEMPT_L1}
    else
         CURRENT=${ATTEMPT_L2}
    fi

    vercomp "pkg-config" $EXIST $CURRENT
}

function procpsvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- http://sourceforge.net/projects/procps-ng/files/Production/ | grep "procps-ng-[a-z0-9.]*xz" | head -n 1 | cut -d '"' -f 4 | cut -d '-' -f 3 | cut -d ':' -f 1 | sed 's/\.tar[a-z.]*//g')

    vercomp "procps-ng" $EXIST $CURRENT
}

function psmiscvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- https://sourceforge.net/projects/psmisc/files/psmisc/ | grep "psmisc-[0-9.]*tar[a-z.]*" | head -n 1 | cut -d '"' -f 4 | cut -d '/' -f 3 | cut -d ':' -f 1 | cut -d '-' -f 2 | sed 's/\.tar[a-z.]*//g')

    vercomp "psmisc" $EXIST $CURRENT
}

function pythonvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- https://www.python.org/downloads/source/ | grep "ftp/python" | grep "/3" | grep "\.tar" | grep -v "[0-9]a[0-9]\.tar" | grep -v "[0-9]rc[0-9]\.tar" | cut -d '/' -f 6 | head -n 1)

    vercomp "Python" $EXIST $CURRENT
}

function shadowvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- https://github.com/shadow-maint/shadow/releases | grep "shadow\-[0-9.]*\.tar\.gz" | cut -d '>' -f 2 | cut -d '<' -f 1 | cut -d '-' -f 2 | grep "tar" | sed 's/\.tar\.gz//g' | head -n 1)

    vercomp "shadow" $EXIST $CURRENT
}

function sudovercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- https://www.sudo.ws/stable.html | grep "\.tar\.gz" | cut -d '/' -f 3 | cut -d '"' -f 1 | cut -d '-' -f 2 | sed 's/\.tar[a-z.]*//g')

    vercomp "sudo" $EXIST $CURRENT
}

function sysklogdvercomp {
    EXIST="$1"
    CURRENT1=$(wget -cqO- http://www.infodrom.org/projects/sysklogd/download/ | grep "\.tar\.gz" | cut -d '"' -f 8 | sed 's/\.tar\.gz[a-z.]*//g' | uniq | tail -n 2 | cut -d '-' -f 2)

    ATTEMPT_L1=$(echo $CURRENT1 | sed 's/ /\n/g' | head -n 1)
    ATTEMPT_L2=$(echo $CURRENT1 | sed 's/ /\n/g' | tail -n 1)

    if [[ $ATTEMPT_L1 == ${ATTEMPT_L2}.[0-9.]* ]]; then
         CURRENT=${ATTEMPT_L1}
    else
         CURRENT=${ATTEMPT_L2}
    fi

    vercomp "sysklogd" $EXIST $CURRENT
}

function tclvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- http://sourceforge.net/projects/tcl/files/Tcl/ | grep "[0-9]\.[0-9]\.[0-9]" | grep "stats\/timeline" | head -n 1 | cut -d '/' -f 6)

    vercomp "tcl-core" $EXIST $CURRENT
}

function tzdatavercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- http://www.iana.org/time-zones/ | grep "tzdata[0-9a-z.]*" | cut -d '/' -f 5 | cut -d '"' -f 1 | sed 's/\.tar\.gz//g' | sed 's/tzdata//g')

    vercomp "tzdata" $EXIST $CURRENT
}

function udevlfsvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- http://anduin.linuxfromscratch.org/LFS | grep "udev-lfs" | cut -d '"' -f 2 | cut -d '-' -f 3 | sed 's/\.tar\.bz2//g')

    vercomp "udev-lfs" $EXIST $CURRENT
}

function utillinuxvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- https://www.kernel.org/pub/linux/utils/util-linux/ | grep "v[0-9.]*" | cut -d '"' -f 2 | sed 's/\///g' | sed 's/v//g' | tail -n 1)

    vercomp "util-linux" $EXIST $CURRENT
}

function vimvercomp {
    EXIST="$1"
    CURRENT=$(wget -q https://github.com/vim/vim/releases -O - | grep "tar\.gz" | head -n 1 | cut -d '/' -f 5 | cut -d '"' -f 1 | sed 's/v//g' | sed 's/\.tar\.gz//g')

    vercomp "vim" $EXIST $CURRENT
}

function xmlparservercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- http://cpan.metacpan.org/authors/id/T/TO/TODDR | grep "XML" | cut -d '"' -f 2 | tail -n 1 | cut -d '-' -f 3 | sed 's/\.tar\.gz//g' | sed 's/_0[0-9]//g' )

    vercomp "XML-PARSER" $EXIST $CURRENT
}

function xzvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- http://tukaani.org/xz/ | grep "xz\-[0-9.]*tar[a-z.]*" | cut -d '"' -f 2 | sed 's/\.tar\.xz\.sig//g' | sed 's/xz-//g' | tail -n 1)

    vercomp "xz" $EXIST $CURRENT
}

function zlibvercomp {
    EXIST="$1"
    CURRENT=$(wget -cqO- http://zlib.net/ | grep "\.tar\.xz" | cut -d '"' -f 2 | head -n 1 | cut -d '-' -f 2 | sed 's/\.tar\.xz//g')

    vercomp "zlib" $EXIST $CURRENT
}

# Export functions
export -f gnuvercomp
export -f savvercomp
export -f blfsvercomp
export -f bzip2vercomp
export -f checkvercomp
export -f dbusvercomp
export -f dhcpcdvercomp
export -f eudevvercomp
export -f sfvercomp
export -f expectvercomp
export -f filevercomp
export -f findutilsvercomp
export -f flexvercomp
export -f iata-etcvercomp
export -f intltoolvercomp
export -f iproute2vercomp
export -f kbdvercomp
export -f kmodvercomp
export -f lessvercomp
export -f libcapvercomp
export -f libpipelinevercomp
export -f linuxvercomp
export -f manpagesvercomp
export -f mpcvercomp
export -f mpfrvercomp
export -f opensslvercomp
export -f pciutilsvercomp
export -f perlvercomp
export -f pkgconfigvercomp
export -f procpsvercomp
export -f psmiscvercomp
export -f pythonvercomp
export -f shadowvercomp
export -f sysklogdvercomp
export -f tclvercomp
export -f tzdatavercomp
export -f udevlfsvercomp
export -f utillinuxvercomp
export -f vimvercomp
export -f xmlparservercomp
export -f xzvercomp
export -f zlibvercomp
