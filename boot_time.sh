#!/bin/zsh
source $HOME/.zshrc
LFS_VERSION=$(cat /etc/os-release | grep "^VERSION_ID" | cut -d '"' -f 2)

echo " $(boot_time)󰌽 $LFS_VERSION 󰏖 $(~/lfs-scripts/packages_no.sh | sed 's/,//g')"

