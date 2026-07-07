#!/bin/bash
INDEX=$(<~/.local/state/wallpaper_index)

find ~/wallpapers -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) |
sort |
nl -w3 -s'  ' |
awk -v idx="$INDEX" '
$1 == idx {
    printf "\033[1;32m%s\033[0m\n", $0
    next
}
{ print }
' |
less -R -j.5 +"$INDEX"
