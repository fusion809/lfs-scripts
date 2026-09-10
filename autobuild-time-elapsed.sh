#!/bin/bash
jobs=$(ps ax | grep "autobuild\.sh" | grep -v grep)
if echo $jobs &> /dev/null; then
	echo "autobuild job(s):"
fi
while IFS= read -r job; do
	start=$(ps -p "$(echo $job | awk '{print $1}')" -o lstart=)
	elapsed=$(( $(date +%s) - $(date -d "$start" +%s) ))
	pkg=$(echo $job | rev | cut -d ' ' -f -1 | rev)

	printf '%s time elapsed: %02d:%02d:%02d\n' \
    	$pkg \
    	$((elapsed / 3600)) \
    	$(((elapsed % 3600) / 60)) \
    	$((elapsed % 60))
done <<< $jobs
