#!/bin/bash
source $HOME/.bashrc
if ! find ~/updates.log -mmin -10 | grep -q . ; then
	updates 2>&1 | tee ~/updates.log > /dev/null
fi
no_updates=$(grep -cF "[UPDATE]" ~/updates.log)
no_missing=$(grep -cF "[MISSING]" ~/updates.log)
no_files_missing=$(grep -cF "[FILES MISSING]" ~/updates.log)
no_missing_total=$(($no_missing + $no_files_missing))
no_failed=$(grep -cF "[FAILED]" ~/updates.log)
echo " $no_updates 󰂕 $no_missing_total  $no_failed"
