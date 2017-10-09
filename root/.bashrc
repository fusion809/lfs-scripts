function kern-build {
	VERSION=$(echo $PWD | cut -d '-' -f 2)
	make -j4 && make modules_install && cp -v arch/x86/boot/bzImage /boot/vmlinuz-${VERSION}-lfs-8.1 && cp -v System.map /boot/System.map-${VERSION} && cp -v .config /boot/config-${VERSION} && install -d /usr/share/doc/linux-${VERSION} && cp -r Documentation/* /usr/share/doc/linux-${VERSION}
}
