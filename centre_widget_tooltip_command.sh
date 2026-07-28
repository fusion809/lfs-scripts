#!/bin/bash

INDEX=$(<~/.local/state/wallpaper_index)
WINDOW=10

find ~/wallpapers -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) |
sort |
nl -w3 -s'  ' |
awk -v idx="$INDEX" -v window="$WINDOW" '
$1 >= idx - window && $1 <= idx + window {
    line = $1
    sub(/^[[:space:]]*[0-9]+[[:space:]]+/, "", $0)

    if (line == idx)
        printf ">%3d  %s\n", line, $0
    else
        printf " %3d  %s\n", line, $0
}
'
