#!/bin/bash
wall=$(~/lfs-scripts/count-wallpapers.sh)
cpu=$(~/lfs-scripts/cpu.sh)
ram=$(~/lfs-scripts/ram.sh)
echo " $cpu  $ram $wall"
