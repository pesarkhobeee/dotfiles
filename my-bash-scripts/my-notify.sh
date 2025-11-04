#!/bin/bash

MESSAGE="$1"
DURATION="${2:-5}"

sketchybar --add item temp_notification center \
           --set temp_notification label="$MESSAGE"

sleep "$DURATION"

sketchybar --remove temp_notification
