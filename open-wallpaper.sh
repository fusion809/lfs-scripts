#!/bin/bash
set -x

WALLPAPER_DIR="$HOME/wallpapers"
STATE_FILE="$HOME/.local/state/wallpaper_index"

INDEX=$(<"$STATE_FILE")

mapfile -t WALLPAPERS < <(
    find "$WALLPAPER_DIR" -maxdepth 1 -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" \
        -o -iname "*.png" -o -iname "*.webp" \) |
    sort
)

exec eog "${WALLPAPERS[$((INDEX-1))]}"
