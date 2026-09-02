#!/bin/bash
current="󰌽 $(< /etc/lfs-release),$(cat /etc/blfs-release | cut -d '-' -f 2)"

if [[ $(< ~/logs/os_version.log) != "$current" ]]; then
	LFS_VERSION=$(cat /etc/lfs-release)
	LFS_BASE=$(echo $LFS_VERSION | cut -d '-' -f 1)
	LFS_REV=$(echo $LFS_VERSION | cut -d '-' -f 2)
	if [[ $LFS_REV == $LFS_BASE ]]; then
		LFS_REV="0"
	fi
	BLFS_VERSION=$(cat /etc/blfs-release)
	BLFS_BASE=$(cat /etc/blfs-release | cut -d '-' -f 1)
	BLFS_REV=$(echo $BLFS_VERSION | cut -d '-' -f 2)
	if [[ $LFS_BASE == $BLFS_BASE ]]; then
		echo "󰌽 $LFS_BASE-$LFS_REV,$BLFS_REV" > ~/logs/os_version.log
	else
		echo "󰌽 $LFS_BASE-$LFS_REV, $BLFS_BASE-$BLFS_REV" > ~/logs/os_version.log
	fi
fi
