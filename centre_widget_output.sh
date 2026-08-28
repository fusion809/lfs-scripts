#!/bin/bash
wall=$(~/lfs-scripts/count-wallpapers.sh)
cpu=$(~/lfs-scripts/cpu.sh)
ram=$(~/lfs-scripts/ram.sh)
disk=$(df -h / | tail -n 1 | sed 's/.*G\s*//g' | cut -d ' ' -f 1)
echo " $cpu  $ram  $disk $wall"
