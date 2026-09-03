#!/bin/bash
wall=$(~/lfs-scripts/count-wallpapers.sh)
cpu=$(~/lfs-scripts/cpu.sh)
ram=$(~/lfs-scripts/ram.sh)
swap=$(~/lfs-scripts/swap.sh)
disk=$(df -h / | tail -n 1 | sed 's/.*G\s*//g' | cut -d ' ' -f 1)
echo " $cpu  $ram 󰿡 $swap  $disk $wall"
