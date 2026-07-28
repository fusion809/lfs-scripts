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

function print_line(i, line) {
    line = lines[i]
    sub(/^[[:space:]]*[0-9]+[[:space:]]+/, "", line)

    if (i == idx)
        printf ">%3d  %s\n", i, line
    else
        printf " %3d  %s\n", i, line
}

END {
    max = NR
    size = 2 * window + 1

    # If there are fewer wallpapers than requested, show them all.
    if (max <= size) {
        for (i = 1; i <= max; i++)
            print_line(i)
        exit
    }

    lower = idx - window
    upper = idx + window

    if (lower < 1) {
        # Wrap to the end.
        for (i = max + lower; i <= max; i++)
            print_line(i)
        for (i = 1; i <= upper; i++)
            print_line(i)
    }
    else if (upper > max) {
        # Wrap to the beginning.
        for (i = lower; i <= max; i++)
            print_line(i)
        for (i = 1; i <= upper - max; i++)
            print_line(i)
    }
    else {
        # Normal case.
        for (i = lower; i <= upper; i++)
            print_line(i)
    }
}
'
