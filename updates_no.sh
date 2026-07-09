#!/bin/bash

source "$HOME/.bashrc"

LOG="$HOME/updates.log"
LOG_TMP="$HOME/updates.log.tmp"
MIN_MAX=4

silent_updates() {
	updates 2>&1 | tee "$LOG_TMP" > /dev/null
	mv $LOG_TMP $LOG
}

log_is_recent() {
	find "$LOG" -mmin -$MIN_MAX | grep -q .
}

ensure_log() {
	if [[ ! -f "$LOG" ]] || ! log_is_recent; then
		silent_updates
	fi
}

read_log_stats() {
	no_updates=$(grep -cF "[UPDATE]" "$LOG")
	no_missing=$(grep -cF "[MISSING]" "$LOG")
	no_files_missing=$(grep -cF "[FILES MISSING]" "$LOG")
	no_missing_total=$((no_missing + no_files_missing))
	no_failed=$(grep -cF "[FAILED]" "$LOG")
	mod_time=$(date -d "$(stat -c %y "$LOG")" "+%I:%M:%S %p")
}

print_status() {
	echo " $mod_time  $no_updates 󰂕 $no_missing_total  $no_failed"
}

ensure_log
read_log_stats
print_status

if ! log_is_recent; then
	silent_updates
	read_log_stats
	print_status
fi
