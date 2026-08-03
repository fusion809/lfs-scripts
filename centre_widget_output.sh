#!/bin/bash
wall=$(~/lfs-scripts/count-wallpapers.sh)
cpu=$(~/lfs-scripts/cpu.sh)
totalMem=$(grep -E '^MemTotal:' /proc/meminfo | sed 's/MemTotal:.\s*//g' | sed 's/ kB//g')
freeMem=$(grep -E '^MemFree:' /proc/meminfo | sed 's/MemFree:.\s*//g' | sed 's/ kB//g')
usedMem=$(R -q -e "$totalMem-$freeMem" | grep "^\[1\]" | cut -d ' ' -f 2)
ram=$(R -q -e "round(100*$usedMem/$totalMem,2)" | grep "^\[1\]" | cut -d ' ' -f 2)
echo " $cpu  $ram% $wall"
