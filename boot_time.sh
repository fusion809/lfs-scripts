#!/bin/zsh
source $HOME/.zshrc
LFS_VERSION=$(cat /etc/os-release | grep "^VERSION_ID" | cut -d '"' -f 2)

echo "󰌽 $LFS_VERSION  $(boot_time)"

