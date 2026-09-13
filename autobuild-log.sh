#!/bin/bash

duration_dir="$HOME/build_duration"
mkdir -p "$duration_dir"

while :; do
	pid=$(ps ax | grep "\.lfs_autobuild.sh" | grep -v grep | sed 's/^\s*//g' | cut -d ' ' -f 1)
	if ! [[ -n $pid ]]; then
		continue;
	fi
	while read -r pid; do
		pkg=$(ps ax | grep $pid | grep -v "grep" | sed 's/.*lfs_autobuild.sh\s//g' | sed 's/ -f.*$//g')
		start_time=$(ps -p $pid -o lstart=)
		start_sec=$(date -d "$start_time" +"%s")
		while kill -0 "$pid" 2>/dev/null; do
			current_sec=$(date +"%s")
			diff=$(($current_sec-$start_sec))
		done
		if [[ "$diff" =~ ^[0-9]+$ ]] && [[ $(grep -o ' ' <<< "$pkg" | wc -l) -eq 0 ]]; then
			echo "$diff" >> $duration_dir/$pkg
		fi
	done <<< $pid
done
