#!/bin/bash
grep -E '\[(UPDATES|MISSING|FAILED)\]' ~/updates.log | awk -F'[[:space:]]*\\|[[:space:]]*' '
{
    for (i = 1; i <= NF; i++) {
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", $i)  # trim
        gsub(/[[:space:]]+/, " ", $i)                # collapse internal whitespace
    }
    printf "%-16s |   %-7s | %s\n", $1, $2, $3
}'
