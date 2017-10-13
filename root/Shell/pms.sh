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
