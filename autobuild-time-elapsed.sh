#!/bin/bash
jobs=$(ps ax | grep "autobuild\.sh" | grep -v grep)
if [[ -n "$jobs" ]]; then
	echo "autobuild job(s):"
else
	exit 1
fi
while IFS= read -r job; do
	start=$(ps -p "$(echo $job | awk '{print $1}')" -o lstart=)
	elapsed=$(( $(date +%s) - $(date -d "$start" +%s) ))
	pkg=$(echo $job | sed 's/.*.sh //g' | sed 's/-f//g')

	printf '%s time elapsed: %02d:%02d:%02d\n' \
    	$pkg \
    	$((elapsed / 3600)) \
    	$(((elapsed % 3600) / 60)) \
    	$((elapsed % 60))
done <<< $jobs
