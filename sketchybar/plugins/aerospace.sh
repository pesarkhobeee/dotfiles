#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

SID="$1"
CONFIG_DIR="$HOME/.config/sketchybar"

# Source icon_map function once instead of spawning subprocesses per app
source "$CONFIG_DIR/plugins/icon_map_fn.sh"

# Update app icons for this workspace
apps=$(aerospace list-windows --workspace "$SID" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

icon_strip=""
if [ -n "${apps}" ]; then
    icon_strip=" "
    while read -r app; do
        icon_map "$app"
        icon_strip+=" $icon_result"
    done <<<"${apps}"
fi

# Build a single batched sketchybar command
args=(--set space.$SID label="$icon_strip")

if [ -n "${apps}" ]; then
    args+=(--set $NAME background.drawing=off drawing=on)
else
    args+=(--set $NAME background.drawing=off drawing=off)
fi

sketchybar "${args[@]}"
