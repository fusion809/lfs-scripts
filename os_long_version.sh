#!/bin/bash
LFS_VERSION=$(cat /etc/lfs-release)
BASE=$(echo $LFS_VERSION | cut -d '-' -f 1)
LFS_REV=$(echo $LFS_VERSION | cut -d '-' -f 2)
BLFS_VERSION=$(cat /etc/blfs-release)
BLFS_REV=$(echo $BLFS_VERSION | cut -d '-' -f 2)
echo -e "(Beyond) Linux From Scratch $BASE-$LFS_REV,$BLFS_REV"