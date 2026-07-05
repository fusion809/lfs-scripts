#!/bin/bash
source $HOME/.bashrc
if ! find /tmp/updates.log -mmin -5 | grep -q . ; then
	updates 2>&1 | tee /tmp/updates.log > /dev/null
fi
no_updates=$(grep -cF "[UPDATE]" /tmp/updates.log)
no_missing=$(grep -cF "[MISSING]" /tmp/updates.log)
no_files_missing=$(grep -cF "[FILES MISSING]" /tmp/updates.log)
no_missing_total=$(($no_missing + $no_files_missing))
no_failed=$(grep -cF "[FAILED]" /tmp/updates.log)
echo " $no_updates 󰂕 $no_missing_total  $no_failed"
#echo "Up $no_updates M $no_missing_total F $no_failed"
