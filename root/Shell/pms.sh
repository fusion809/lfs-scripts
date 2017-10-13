function vimup {
    pkgver=$(wget -q https://github.com/vim/vim/releases -O - | grep "tar\.gz" | head -n 1 | cut -d '/' -f 5 | cut -d '"' -f 1 | sed 's/v//g' | sed 's/\.tar\.gz//g')
    pkgvere=$(vim --version | head -n 1 | cut -d ' ' -f 5).$(vim --version | head -n 2 | tail -n 1 | cut -d ' ' -f 3 | cut -d '-' -f 2)
    if [[ $pkgver == $pkgvere ]]; then
         printf "Vim is up-to-date!"
    else
         pushd /sources
              wget -cqO- https://github.com/vim/vim/archive/v${pkgver}.tar.gz | tar xz
              pushd vim*
                   echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
                   ./configure --prefix=/usr
                   make -j4
                   make install
                   rm /usr/share/doc/vim-${pkgvere}
                   ln -sv ../vim/vim80/doc /usr/share/doc/vim-${pkgver}
              popd

              rm -rf vim*
         popd
    fi
}

function linup {
    pkgver=$(wget -cqO- https://www.kernel.org/ | grep "\.tar\.xz" | head -n 1 | cut -d '"' -f 2 | tail -n 1 | cut -d '-' -f 2 | sed 's/\.tar\.xz//g')
    pkgvere=$(ls /lib/modules/* -ld | tail -n 1 | cut -d ' ' -f 10 | cut -d '/' -f 4)

    if [[ $pkgver == $pkgvere ]]; then
         printf "The Linux kernel is up-to-date!"
    else
         pushd /sources
              pkgverf=$(echo $pkgver | grep -o -E '[0-9]+' | head -1 | sed -e 's/^0\+//')
              if ! [[ -d linux-${pkgver} ]]; then
                 wget -cqO- https://cdn.kernel.org/pub/linux/kernel/v${pkgverf}.x/linux-${pkgver}.tar.xz | tar xJ
              fi
              pushd linux*
                   make mrproper
                   make INSTALL_HDR_PATH=dest headers_install
                   find dest/include \( -name .install -o -name ..install.cmd \) -delete
                   cp -rv dest/include/* /usr/include
                   make mrproper
                   cp /boot/config-${pkgvere} .config
                   make -j4
                   make modules_install
                   cp -v arch/x86/boot/bzImage /boot/vmlinuz-${pkgver}-lfs
                   cp -v System.map /boot/System.map-${pkgver}
                   cp -v .config /boot/config-${pkgver}
                   install -d /usr/share/doc/linux-${pkgver}
                   cp -r Documentation/* /usr/share/doc/linux-${pkgver}
              popd
         popd
    fi
}
