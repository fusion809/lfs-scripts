#!/bin/zsh
source $HOME/.zshrc
echo " $(boot_time)$(~/lfs-scripts/os_version.sh) 󰏖 $(~/lfs-scripts/packages_no.sh | sed 's/,//g')"
