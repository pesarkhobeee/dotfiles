#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

SID="$1"
CONFIG_DIR="$HOME/.config/sketchybar"

# Determine focused workspace (passed via event or query aerospace)
CURRENT_WORKSPACE="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"

# Update app icons for this workspace
apps=$(aerospace list-windows --workspace "$SID" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

if [ -n "${apps}" ]; then
    icon_strip=" "
    while read -r app; do
        icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
    done <<<"${apps}"
    sketchybar --set space.$SID label="$icon_strip"
else
    sketchybar --set space.$SID label=""
fi

# Update visibility and highlight
if [ "$SID" = "$CURRENT_WORKSPACE" ]; then
    sketchybar --set $NAME background.drawing=on drawing=on
elif [ -n "${apps}" ]; then
    sketchybar --set $NAME background.drawing=off drawing=on
else
    sketchybar --set $NAME background.drawing=off drawing=off
fi
