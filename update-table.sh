#!/bin/bash
grep -E '\[(UPDATE|FILES MISSING|FAILED)\]' ~/updates.log |
awk -F'[[:space:]]*\\|[[:space:]]*' '
{
    for (i = 1; i <= NF; i++) {
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", $i)
        gsub(/[[:space:]]+/, " ", $i)
    }

    match($3, /^(.*) (\[[^]]+\])$/, a)

    rows[NR][1] = $1
    rows[NR][2] = $2
    rows[NR][3] = a[1]
    rows[NR][4] = a[2]

    if (length($1) > maxw1) maxw1 = length($1)
    if (length($2) > maxw2) maxw2 = length($2)
    if (length(a[1]) > maxw3) maxw3 = length(a[1])
}
END {
    fmt = "%-" maxw1 "s | %-" maxw2 "s | %-" maxw3 "s %s\n"
    for (i = 1; i <= NR; i++)
        printf fmt, rows[i][1], rows[i][2], rows[i][3], rows[i][4]
}'
