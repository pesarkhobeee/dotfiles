#!/bin/bash
SELECTED_LINK=$(cat /Users/farid/flink-links.txt | choose | awk "{print $1}")
if [ "$SELECTED_LINK" != "" ] && [ "$SELECTED_LINK" == "#todo" ]; then
  aerospace focus --window-id 11046 && wezterm cli activate-pane --pane-id=0
elif [ "$SELECTED_LINK" != "" ] && [ "$SELECTED_LINK" == "#mute-toggle" ] ; then
  aerospace volume mute-toggle
else
  open "$SELECTED_LINK"
fi
# TODO
# - Open a Jira ticket
# - Open a new Google meet and copy the link to clipboard
# - Open a new terminal tab with curl wttr.in/berlin
