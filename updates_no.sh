#!/bin/bash

source "$HOME/.bashrc"

LOG="$HOME/updates.log"
LOG_TMP="$HOME/updates.log.tmp"
MAX_AGE=4 # Maximum age of updates.log in minutes

silent_updates() {
    updates 2>&1 | tee "$LOG_TMP" > /dev/null &&
    mv "$LOG_TMP" "$LOG"
}

log_is_recent() {
	find "$LOG" -mmin "-$MAX_AGE" | grep -q .
}

update_if_needed() {
    if [[ ! -f "$LOG" ]]; then
        # No log at all — block until one is created
        (
            flock 9
            [[ -f "$LOG" ]] || silent_updates
        ) 9>"$LOG.lock"
    elif ! log_is_recent; then
        # Log exists but stale — refresh in background, print stale data now
        (
            flock -n 9 || exit
            silent_updates
        ) 9>"$LOG.lock" &
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

update_if_needed
read_log_stats
print_status
