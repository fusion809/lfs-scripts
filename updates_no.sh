#!/bin/bash

source "$HOME/.bashrc"

LOG="$HOME/updates.log"
LOG_TMP="$HOME/updates.log.tmp"
DURATION_LOG="$HOME/updates_duration.log"
MAX_AGE=4 # Maximum age of updates.log in minutes

silent_updates() {
    local start_time=$(date +%s)
    echo "$start_time" > "${LOG_TMP}.start"
    if updates 2>&1 | tee "$LOG_TMP" > /dev/null; then
        mv "$LOG_TMP" "$LOG"
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        echo "$duration" >> "$DURATION_LOG"
    fi
    rm -f "${LOG_TMP}.start"
}

log_is_recent() {
	find "$LOG" -mmin "-$MAX_AGE" | grep -q .
}

update_if_needed() {
    if [[ ! -f "$LOG" ]]; then
        # No log at all — refresh in background, print empty/zero stats now
        (
            flock -n 9 || exit
            [[ -f "$LOG" ]] || silent_updates
        ) >/dev/null 2>&1 9>"$LOG.lock" &
    elif ! log_is_recent; then
        # Log exists but stale — refresh in background, print stale data now
        (
            flock -n 9 || exit
            silent_updates
        ) >/dev/null 2>&1 9>"$LOG.lock" &
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
	in_progress=""
	if [[ -f $LOG_TMP ]]; then
		in_progress="󰦕 "
		if [[ -f "${LOG_TMP}.start" ]]; then
			local start_time=$(cat "${LOG_TMP}.start" 2>/dev/null)
			if [[ -n "$start_time" ]]; then
				local current_time=$(date +%s)
				local elapsed=$((current_time - start_time))
				local avg_duration=$(R -q -e "durations <- scan(\"$DURATION_LOG\", quiet=TRUE); mean(durations)" | grep "^\[1\]" | cut -d ' ' -f 2)
                local avg_duration_rnd=$(R -q -e "round($avg_duration)" | grep "^\[1\]" | cut -d ' ' -f 2)
				if (( avg_duration_rnd > 0 )); then
					local percent=$(R -q -e "round($elapsed*100/$avg_duration)" | grep "^\[1\]" | cut -d ' ' -f 2)
					if (( percent > 99 )); then
						percent=99
					fi
					in_progress="󰦕 ${percent}% "
				fi
			fi
		fi
	fi
	echo "$in_progress $mod_time  $no_updates 󰂕 $no_missing_total  $no_failed"
}

update_if_needed
read_log_stats
print_status
