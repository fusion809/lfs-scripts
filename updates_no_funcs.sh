#!/bin/bash
source $HOME/.bashrc
LOG="$HOME/updates.log"
LOG_TMP="$HOME/updates.log.tmp"
DURATION_LOG="$HOME/updates_duration.log"
MAX_AGE=5 # Maximum age of updates.log in minutes

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
    local avg_duration_rnd=0
    if [[ -s "$DURATION_LOG" ]]; then
        avg_duration_rnd=$(R -q -e "durations <- scan(\"$DURATION_LOG\", quiet=TRUE); round(mean(durations))" 2>/dev/null | grep "^\[1\]" | cut -d ' ' -f 2 | tr -cd '0-9')
        avg_duration_rnd=${avg_duration_rnd:-0}
    fi
    local threshold=$(( 300 - avg_duration_rnd ))
    local log_age=$(( $(date +%s) - $(date +%s -r "$LOG") ))
    (( threshold >= log_age ))
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

progress_status() {
    in_progress=""
	if [[ -f $LOG_TMP ]]; then
		in_progress="󰦕 "
		local percent=$(awk '/Global/ { sub(/.*Global /, ""); sub(/%.*/, ""); value = $0 } END { print value }' ~/updates.log.tmp)
		if ! [[ -n $percent ]]; then
			percent="0"
		fi
		in_progress="󰦕 ${percent}% "
	fi
}

print_status() {
	echo "$in_progress $mod_time  $no_updates 󰂕 $no_missing_total  $no_failed"
}
