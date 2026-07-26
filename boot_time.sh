#!/bin/bash
timestamp=$(uptime -s)
if [[ -f ~/plots/$timestamp.svg ]]
then
	filename=$HOME/plots/$timestamp.svg
elif [[ -f ~/plots/outliers/$timestamp.svg ]]; then
	filename=$HOME/plots/outliers/$timestamp.svg
else
	diff=1000000000
find ~/plots -type f -name '*.svg' -print0 |
while IFS= read -r -d '' filetmp; do
    i=${filetmp:t:r}       # basename without .svg

    plot_timestamp=$(date -d "$i" +%s)
    curr_time=$(date -d "$timestamp" +%s)

    diff_tmp=$(( plot_timestamp - curr_time ))
    diff_tmp=$(( diff_tmp < 0 ? -diff_tmp : diff_tmp ))

    if (( diff_tmp < diff )); then
        diff=$diff_tmp
        filename=$filetmp
    fi
done
fi
boot_time=$(cat "$filename" | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv} kernel | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv} user | sed 's/.*= //g')

echo " $boot_time"

