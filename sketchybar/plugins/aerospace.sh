#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

CONFIG_DIR="$HOME/.config/sketchybar"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.drawing=on
else
    sketchybar --set $NAME background.drawing=off
fi

# Update all workspace icons when workspace changes
# This runs in background to avoid blocking the workspace switch
(
    for sid in $(aerospace list-workspaces --all); do
        apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

        if [ -n "$apps" ]; then
            sketchybar --set space.$sid drawing=on
            icon_strip=" "
            while read -r app; do
                icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
            done <<<"$apps"
        else
            icon_strip=""
            sketchybar --set space.$sid drawing=off
        fi
        sketchybar --set space.$sid label="$icon_strip"
    done
) &
