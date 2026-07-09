#!/bin/bash
grep -E '\[(UPDATE|MISSING|FAILED)\]' ~/updates.log |
awk -F'[[:space:]]*\\|[[:space:]]*' '
{
    for (i = 1; i <= NF; i++) {
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", $i)
        gsub(/[[:space:]]+/, " ", $i)
    }

    match($3, /^(.*) (\[[^]]+\])$/, a)

    printf "%-16s |   %-7s | %-8s %s\n", $1, $2, a[1], a[2]
}'
