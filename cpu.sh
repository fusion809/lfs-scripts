#!/bin/bash
read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat

idle1=$((idle+iowait))
total1=$((user+nice+system+idle+iowait+irq+softirq+steal))

sleep 1

read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat

idle2=$((idle+iowait))
total2=$((user+nice+system+idle+iowait+irq+softirq+steal))

idle_delta=$((idle2-idle1))
total_delta=$((total2-total1))

awk -v idle="$idle_delta" -v total="$total_delta" \
    'BEGIN { printf "%.0f%%\n", 100*(1-idle/total) }'
