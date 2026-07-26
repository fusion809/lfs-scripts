#!/bin/bash
timestamp=$(uptime -s)
if [[ -f ~/plots/$timestamp.svg ]]
then
	filename=$HOME/plots/$timestamp.svg
else
	filename=$HOME/plots/outliers/$timestamp.svg
fi
cat "$filename" | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv} kernel | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv} user | sed 's/.*= //g'

