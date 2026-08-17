source $HOME/.lfs_scripts/21-lfs.sh

function instLfp {
	if [[ -d $HOME/lfs_packaging/$1 ]]; then
		cdlp "$1"
		./build.sh
	fi
}

function rm_lfp_src {
	cdlfp
	for tarball in $(find . -name '*.tar*'); do
    		dir=${tarball%.tar.*}   # removes .tar.xz, .tar.gz, .tar.bz2, etc.
    		if [[ -d "$dir" ]]; then
			sudo rm -rf "$dir"
			sudo rm -rf "$tarball"
		else
			sudo rm -rf "$tarball"
    		fi
	done
	cd -
}

function download {
	unset DOWNLOAD_x86_64
	source *.info
	if [[ -n $DOWNLOAD_x86_64 ]]; then
		echo "x86_64!"
		URL=$(cat *.info | grep DOWNLOAD_x86_64 | cut -d '"' -f 2)
	else
		echo "Not x86_64!"
		URL=$(cat *.info | grep DOWNLOAD | cut -d '"' -f 2)
	fi
	echo "URL=$URL"
	wget -c $URL
}

function pkgver {
	find /var/lib/{book,custom}-packages -type f -name "*$1*" -exec sh -c '
    for file; do
        head -n1 "$file"
    done
' sh {} +
}

function rmSrc {
	cdlfp
	find . -mindepth 2 -maxdepth 2 -type d \
    ! -exec test -d '{}/.git' ';' -print
	find . -name "*.tar*" -delete
}

function strip_system {
	sudo su -c 'save_usrlib="$(cd /usr/lib; ls ld-linux*[^g])
             libc.so.6
             libthread_db.so.1
             libquadmath.so.0.0.0
             libstdc++.so.6.0.34
             libitm.so.1.0.0
             libatomic.so.1.2.0"

cd /usr/lib

for LIB in $save_usrlib; do
    objcopy --only-keep-debug --compress-debug-sections=zstd $LIB $LIB.dbg
    cp $LIB /tmp/$LIB
    strip --strip-debug /tmp/$LIB
    objcopy --add-gnu-debuglink=$LIB.dbg /tmp/$LIB
    install -vm755 /tmp/$LIB /usr/lib
    rm /tmp/$LIB
done

online_usrbin="bash find strip"
online_usrlib="libbfd-2.45.1.so
               libsframe.so.2.0.0
               libhistory.so.8.3
               libncursesw.so.6.6
               libm.so.6
               libreadline.so.8.3
               libz.so.1.3.1
               libzstd.so.1.5.7
               $(cd /usr/lib; find libnss*.so* -type f)"

for BIN in $online_usrbin; do
    cp /usr/bin/$BIN /tmp/$BIN
    strip --strip-debug /tmp/$BIN
    install -vm755 /tmp/$BIN /usr/bin
    rm /tmp/$BIN
done

for LIB in $online_usrlib; do
    cp /usr/lib/$LIB /tmp/$LIB
    strip --strip-debug /tmp/$LIB
    install -vm755 /tmp/$LIB /usr/lib
    rm /tmp/$LIB
done

for i in $(find /usr/lib -type f -name \*.so* ! -name \*dbg) \
         $(find /usr/lib -type f -name \*.a)                 \
         $(find /usr/{bin,sbin,libexec} -type f); do
    case "$online_usrbin $online_usrlib $save_usrlib" in
        *$(basename $i)* )
            ;;
        * ) strip --strip-debug $i
            ;;
    esac
done

unset BIN LIB save_usrlib online_usrbin online_usrlib'
}

# lfs_autobuild: run the host's latest lfs-autobuild.sh (synced to ~/.lfs_autobuild.sh by the host)
autobuild() {
    bash ~/.lfs_autobuild.sh "$@"
}

missing_search() {
    local pattern="${1:-not found}"

    for i in /usr/lib/* /usr/bin/*; do
        [[ -e "$i" ]] || continue

        if file -L "$i" | grep -q 'ELF'; then
            if ldd "$i" 2>/dev/null | grep -q "$pattern"; then
                echo "$i"
            fi
        fi
    done
}

missing_search_fast() {
    local pattern="${1:-not found}"
    find /usr/lib /usr/bin /opt/qt6/bin /opt/qt6/lib /opt/rustc/bin /opt/rustc/lib /opt/texlive/2025/bin /opt/texlive/2025/lib -type f -print0 |
    while IFS= read -r -d '' f; do
        ldd "$f" 2>/dev/null | grep -q "$pattern" && printf '%s\n' "$f"
    done
}

function version {
	if [[ -n "$1" ]]; then
		pushd $LFS/"$1"
	fi
	eval "$(grep '^version=' build.sh)"
	echo "$version"
	if [[ -n "$1" ]]; then
		popd
	fi
}

function check_version {
	if [[ -n "$1" ]]; then
		name="$1"
		pushd $LFS/"$1"
	else
		name=$(pwd | sed 's|.*/||g')
	fi
	eval "$(grep '^version=' build.sh)"
	inst_version="$(cat /var/lib/lfs-custom-packages/$name)"
	if [[ "$inst_version" != "$version" ]]; then
		echo "Installed version = $inst_version"
		echo "Upstream version  = $version"
	fi
	if [[ -n "$1" ]]; then
		popd
	fi
}

source ~/.lfs_scripts/lfs-vm-bootstrap.sh 2>/dev/null

alias preserved-rebuild=rm_old_libs_gpt
alias preserved_rebuild=rm_old_libs_gpt
function rm_old_kerns {
	current=$(uname -r)
	echo "Deleting kernels older than $current..."
	find /lib/modules -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort -V |
	while read -r ver; do
	    if [[ "$ver" == "$current" ]]; then
        	break
	    fi
	    sudo rm -rf "/lib/modules/$ver"
	    echo "/lib/modules/$ver was deleted"
	done
	find /boot -maxdepth 1 -type f \
    \( -name "vmlinuz-*" -o \
       -name "initramfs-*" -o \
       -name "System.map-*" -o \
       -name "config-*" \) |
	while read -r file; do
		if echo $file | grep "vmlinuz" &> /dev/null; then
			ver=${file##*/vmlinuz-}
		else
			ver=${file##*-}
			ver=${ver%.img}
		fi

	    if [[ "$(printf '%s\n%s\n' "$ver" "$current" | sort -V | head -n1)" == *"$ver"* &&
	          "$ver" != "$current" ]]; then
	        sudo rm -f "$file"
	        echo "$file was deleted."
		source ~/lfs-scripts/Shell/10-miscellaneous.sh
		update-grub
	    fi
	done
}

function rm_book_src {
	sudo rm -rf /sources/*
	mkdir /sources/archives -p
}

function rm_src {
	rm_book_src
	rm_lfp_src
}

function updc {
	update "$@"
	local broken_pkgs=$(find /var/lib/book-packages /var/lib/custom-packages -maxdepth 1 -type f ! -name ".*" 2>/dev/null | grep -vE "/(COMMIT_EDITMSG|HEAD|config|description|ORIG_HEAD)$" | while read -r f; do (head -n 1 "$f" | grep -q "^BUILD_FAILED$" || [ $(wc -l < "$f") -le 1 ]) && basename "$f"; done | tr -d '\r')
	if [ -z "$broken_pkgs" ]; then
		rm_old_docs
		rm_old_kerns
		rm_old_libs
		rm_old_share
		rm_src
		lfs_commit
	else
		echo "Build failures or missing inventories detected. Skipping cleanup."
	fi
}

alias updatec=updc
