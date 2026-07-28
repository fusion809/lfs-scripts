#!/bin/bash
current="󰌽 $(< /etc/lfs-release),$(cat /etc/blfs-release | cut -d '-' -f 2)"

if [[ $(< ~/os_version.log) != "$current" ]]; then
	LFS_VERSION=$(cat /etc/lfs-release)
	BASE=$(echo $LFS_VERSION | cut -d '-' -f 1)
	LFS_REV=$(echo $LFS_VERSION | cut -d '-' -f 2)
	BLFS_VERSION=$(cat /etc/blfs-release)
	BLFS_REV=$(echo $BLFS_VERSION | cut -d '-' -f 2)
	echo "󰌽 $BASE-$LFS_REV,$BLFS_REV" > ~/os_version.log
fi