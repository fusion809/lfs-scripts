#!/bin/bash

duration_dir="$HOME/build_duration"
mkdir -p "$duration_dir"

while :; do
	pid=$(ps ax | grep "\.lfs_autobuild.sh" | grep -v grep | cut -d ' ' -f 1)
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
			if [[ $(grep -o ' ' <<< "$pkg" | wc -l) -eq 0 ]]; then
				echo "$diff" >> $duration_dir/$pkg.tmp
			fi
		done
		if [[ -f "$duration_dir/$pkg.tmp" ]]; then
			tail -n 1 "$duration_dir/$pkg.tmp" >> "$duration_dir/$pkg"
			rm "$duration_dir/$pkg.tmp"
		fi

	done <<< $pid
done
