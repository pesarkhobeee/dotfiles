#!/bin/bash
# Thanks to https://github.com/prasmussen/chrome-cli
PATH=/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
MEET_ID=$(/opt/homebrew/bin/vivaldi-cli open "https://meet.google.com/new" | grep Id | awk -F'[[:space:]]+' '{print $2}')
sleep 4
/opt/homebrew/bin/vivaldi-cli info -t "$MEET_ID" | grep Url | awk -F'[[:space:]]+' '{print $2}' | pbcopy
