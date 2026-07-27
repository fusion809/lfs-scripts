#!/bin/zsh
source $HOME/.zshrc
while echo $boot_dur | grep -v "[0-9]"; do
	boot_dur=$(boot_time)
done
echo " $boot_dur"
