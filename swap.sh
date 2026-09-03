#!/bin/bash
function swap {
	cat /proc/meminfo | grep $1 | sed "s/$1:\s*//g" | sed 's/ kB//g'
}

SwapFree=$(swap SwapFree)
SwapTotal=$(swap SwapTotal)
perc=$(R -q -e "round(($SwapTotal-$SwapFree)/$SwapTotal * 100, 0)" | grep "^\[1\]" | cut -d ' ' -f 2)
echo "$perc%"
