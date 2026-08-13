#!/bin/zsh
source $HOME/.zshrc
while echo $boot_dur | grep -v "[0-9]"; do
	boot_dur=$(boot_time)
done
system_age=$(~/lfs-scripts/system-age.sh)
echo " $boot_dur $system_age"
