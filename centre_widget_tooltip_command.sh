#!/bin/bash

INDEX=$(<~/.local/state/wallpaper_index)
WINDOW=25

find ~/wallpapers -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) |
sort |
nl -w3 -s'  ' |
awk -v idx="$INDEX" -v window="$WINDOW" '
{
    lines[NR] = $0
}

END {
    max = NR

    lower = idx - window
    upper = idx + window

    if (lower < 1) {
        upper += 1 - lower
        lower = 1
    }

    if (upper > max) {
        lower -= upper - max
        upper = max
        if (lower < 1)
            lower = 1
    }

    for (i = lower; i <= upper; i++) {
        line = lines[i]
        sub(/^[[:space:]]*[0-9]+[[:space:]]+/, "", line)

        if (i == idx)
            printf ">%3d  %s\n", i, line
        else
            printf " %3d  %s\n", i, line
    }
}
'
